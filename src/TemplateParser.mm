//
//  TemplateParser.m
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 4/28/25.
//  Copyright © 2025 Todd Ditchendorf. All rights reserved.
//

#import "TemplateParser.hpp"
#import "TDTemplateEngine+ParserSupport.h"
#import <ParseKitCPP/ParseException.hpp>
#import <TDTemplateEngine/TDTemplateEngine.h>
#import <TDTemplateEngine/TDTemplateException.h>
#import <TDTemplateEngine/TDRootNode.h>
#import <TDTemplateEngine/TDPrintNode.h>
#import <TDTemplateEngine/TDTextNode.h>
#import <TDTemplateEngine/TDTag.h>
#import <TDTemplateEngine/TDVerbatimTag.h>

using namespace parsekit;

@interface TDNode ()
- (void)setToken:(Token)token;
@end

namespace templateengine {

TemplateParser::TemplateParser(TDTemplateEngine *engine, TDTemplateContext *context, NSString *filePath) :
    _engine(engine),
    _context([context retain]),
    _filePath([filePath retain]),
    _root(nil),
    _currentParent(nil)
{}

TemplateParser::~TemplateParser() {
    [_context release];
    _context = nil;
    
    [_currentParent release];
    _currentParent = nil;
    
    [_filePath release];
    _filePath = nil;
    
    [_root release];
    _root = nil;
}

TDRootNode *TemplateParser::parse(TokenListPtr frags) {
    TokenListTokenizer tokenizer(frags);
    _tokenizer = &tokenizer;

    TokenList lookahead;
    _lookahead = &lookahead;
    
    _p = 0;
    
    TokenList token_stack;
    TokenList consumed;
    
    NSMutableArray *node_stack = [NSMutableArray array];
    TemplateAssembly assembly(&token_stack, &consumed, node_stack);
    _assembly = &assembly;
    
    TDRootNode *node = nil;
    @try {
        try {
            _template();
            _eof();
            
            node = [[_root retain] autorelease];
        } catch (ParseException& ex) {
            Token token = lt(1);
            NSString *sample = [_context templateSubstringForToken:token];
            NSString *reason = [NSString stringWithUTF8String:ex.message().c_str()];
            [TDTemplateException raiseWithReason:reason token:token sample:sample filePath:_filePath];
        }
    } @finally {
        _assembly = nullptr;
        setRoot(nil);
        setCurrentParent(nil);
    }
    
    return node;
}

void TemplateParser::reThrowOrRaiseWithToken(TDTemplateException *ex, Token token) {
    // if it is being recursively thrown, retain the existing token and re-throw.
    // if this exception is first thrown here, it needs a token to display error location context
    TokenType tt = ex.token.token_type();
    if (tt != -1 && tt != 0) {
        [ex raise];
    } else {
        raise(ex.reason, token);
    }
}

void TemplateParser::_template() {
    assert([_context peekTemplateString]);
    
    TDRootNode *root = [TDRootNode rootNode];
    root.templateFilePath = _filePath;
    root.templateString = [_context peekTemplateString];
    
    setRoot(root);
    setCurrentParent(root);
    
    do {
        _content();
    } while (predicts(TokenType_ANY, 0));
}

void TemplateParser::_content() {
    if (predicts(TemplateTokenType_PRINT, 0)) {
        _print();
    } else if (predicts(TemplateTokenType_EMPTY_TAG, 0)) {
        _empty_tag();
    } else if (predicts(TemplateTokenType_BLOCK_START_TAG, 0)) {
        _block_tag();
    } else if (predicts(TemplateTokenType_TEXT, 0)) {
        _text();
    } else {
        raise(@"No viable alternative found in rule `content`.", lt(1));
    }
}

void TemplateParser::_print() {
    match(TemplateTokenType_PRINT, false);

    Token tok = _assembly->pop_token();
    assert(_engine);
    
    TDNode *printNode = [_engine printNodeFromFragment:tok withParent:_currentParent inContext:_context];
    assert(printNode);
    
    [_currentParent addChild:printNode];
}

void TemplateParser::_empty_tag() {
    match(TemplateTokenType_EMPTY_TAG, false);
    
    Token tok = assembly()->pop_token();
    assert(_engine);
    TDTag *startTagNode = nil;
    @try {
        startTagNode = [_engine tagFromFragment:tok withParent:_currentParent inContext:_context];
    } @catch (TDTemplateException *ex) {
        reThrowOrRaiseWithToken(ex, tok);
    }
    assert(startTagNode);
    [_currentParent addChild:startTagNode];
}

void TemplateParser::_block_tag() {
    _assembly->push_node(_currentParent);
    
    _block_start_tag();

    Token beg_tok = lt(1);
    match(TemplateTokenType_TAG, true);
    
    while (!predicts(TemplateTokenType_BLOCK_END_TAG, 0)) {
        _content();
    }
    
    _block_end_tag();

    Token end_tok = lt(1);
    match(TemplateTokenType_TAG, true);

    if (_currentParent.isVerbatim) {
        TokenRange beg_range = beg_tok.range();
        size_t beg_offset = beg_range.location + beg_range.length;
        
        TokenRange end_range = end_tok.range();
        size_t end_offset = end_range.location;// + end_range.length;
        
        size_t length = end_offset - beg_offset;
        Token tok = Token(TemplateTokenType_BLOCK_START_TAG, beg_offset, length, _currentParent.token.line_number());
        _currentParent.token = tok;
    }

    setCurrentParent(_assembly->pop_node());
}

void TemplateParser::_block_start_tag() {
    match(TemplateTokenType_BLOCK_START_TAG, false);
    
    Token tok = _assembly->pop_token();
    assert(_engine);
    TDTag *startTagNode = nil;
    @try {
        startTagNode = [_engine tagFromFragment:tok withParent:_currentParent inContext:_context];
    } @catch (TDTemplateException *ex) {
        reThrowOrRaiseWithToken(ex, tok);
    }
    assert(startTagNode);
    [_currentParent addChild:startTagNode];
    setCurrentParent(startTagNode);
}

void TemplateParser::_block_end_tag() {
    match(TemplateTokenType_BLOCK_END_TAG, false);
    
    Token tok = _assembly->pop_token();
    NSString *tagName = [[_context templateSubstringForToken:tok] substringFromIndex:TDTemplateEngineTagEndPrefix.length];
    
    while (_currentParent && ![_currentParent.tagName isEqualToString:tagName]) {
        setCurrentParent(_assembly->pop_node());
    }
    
    if (!_currentParent || ![_currentParent.tagName isEqualToString:tagName]) {
        raise([NSString stringWithFormat:@"Could not find block start tag named: `%@`", tagName], tok);
    }
    assert([_currentParent isKindOfClass:[TDTag class]]);
}

void TemplateParser::_text() {
    match(TemplateTokenType_TEXT, false);

    Token tok = _assembly->pop_token();
    TDNode *txtNode = [TDTextNode nodeWithToken:tok parent:_currentParent];
    [_currentParent addChild:txtNode];

}

void TemplateParser::raise(NSString *msg, Token tok) {
    NSString *sample = [_context templateSubstringForToken:tok];
    [TDTemplateException raiseWithReason:msg token:tok sample:sample filePath:_filePath];
}

void TemplateParser::setRoot(TDRootNode *n) {
    if (_root != n) {
        [_root autorelease];
        _root = [n retain];
    }
}

void TemplateParser::setCurrentParent(TDNode *n) {
    if (_currentParent != n) {
        [_currentParent autorelease];
        _currentParent = [n retain];
    }
}

}
