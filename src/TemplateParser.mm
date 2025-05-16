//
//  TemplateParser.m
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 4/28/25.
//  Copyright © 2025 Todd Ditchendorf. All rights reserved.
//

#import "TemplateParser.hpp"
#import <ParseKitCPP/ParseException.hpp>
#import <TDTemplateEngine/TDTemplateEngine.h>
#import <TDTemplateEngine/TDRootNode.h>
#import <TDTemplateEngine/TDPrintNode.h>
#import <TDTemplateEngine/TDTextNode.h>
#import <TDTemplateEngine/TDTag.h>
#import <TDTemplateEngine/TDVerbatimTag.h>

using namespace parsekit;

@interface TDNode ()
- (void)setToken:(Token)token;
@end

@interface TDTemplateEngine ()
- (TDPrintNode *)printNodeFromFragment:(Token)frag withParent:(TDNode *)parent inContext:(TDTemplateContext *)staticContext;
- (TDTag *)tagFromFragment:(Token)tok withParent:(TDNode *)parent inContext:(TDTemplateContext *)staticContext;
@end

namespace templateengine {

TemplateParser::TemplateParser(TDTemplateEngine *engine, TDTemplateContext *staticContext) :
    _engine(engine),
    _staticContext([staticContext retain]),
    _root(nil),
    _currentParent(nil)
{}

TemplateParser::~TemplateParser() {
    [_staticContext release];
    _staticContext = nil;
    
    [_currentParent release];
    _currentParent = nil;
    
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
    //try {
        _template();
        _eof();
        
        node = [[_root retain] autorelease];
//    } catch (ParseException& ex) {
//        node = nil;
//    }
    
    _assembly = nullptr;
    
    setRoot(nil);
    setCurrentParent(nil);
    
    return node;
}

void TemplateParser::_template() {
    assert([_staticContext peekTemplateString]);
    
    TDRootNode *root = [TDRootNode rootNode];
    root.templateString = [_staticContext peekTemplateString];
    
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
        raise("No viable alternative found in rule `content`.");
    }
}

void TemplateParser::_print() {
    match(TemplateTokenType_PRINT, false);

    Token tok = _assembly->pop_token();
    assert(_engine);
    
    TDNode *printNode = [_engine printNodeFromFragment:tok withParent:_currentParent inContext:_staticContext];
    assert(printNode);
    
    [_currentParent addChild:printNode];
}

void TemplateParser::_empty_tag() {
    match(TemplateTokenType_EMPTY_TAG, false);
    
    Token tok = assembly()->pop_token();
    assert(_engine);
    TDTag *startTagNode = nil;
    @try {
        startTagNode = [_engine tagFromFragment:tok withParent:_currentParent inContext:_staticContext];
    } @catch (NSException *ex) {
        raise(std::string([[ex reason] UTF8String]));
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

    if ([_currentParent isKindOfClass:[TDVerbatimTag class]]) {
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
        startTagNode = [_engine tagFromFragment:tok withParent:_currentParent inContext:_staticContext];
    } @catch (NSException *ex) {
        raise(std::string([[ex reason] UTF8String]));
    }
    assert(startTagNode);
    [_currentParent addChild:startTagNode];
    setCurrentParent(startTagNode);
}

void TemplateParser::_block_end_tag() {
    match(TemplateTokenType_BLOCK_END_TAG, false);
    
    Token tok = _assembly->pop_token();
    NSString *tagName = [[_staticContext templateSubstringForToken:tok] substringFromIndex:TDTemplateEngineTagEndPrefix.length];
    
    while (_currentParent && ![_currentParent.tagName isEqualToString:tagName]) {
        setCurrentParent(_assembly->pop_node());
    }
    
    if (!_currentParent || ![_currentParent.tagName isEqualToString:tagName]) {
        raise(std::string([[NSString stringWithFormat:@"Could not find block start tag named: `%@`", tagName] UTF8String]));
    }
    assert([_currentParent isKindOfClass:[TDTag class]]);
    
}

void TemplateParser::_text() {
    match(TemplateTokenType_TEXT, false);

    Token tok = _assembly->pop_token();
    TDNode *txtNode = [TDTextNode nodeWithToken:tok parent:_currentParent];
    [_currentParent addChild:txtNode];

}

void TemplateParser::raise(std::string reason) {
    throw ParseException(reason);
    //[NSException raise:@"FIXME" format:@"%@", reason];
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
