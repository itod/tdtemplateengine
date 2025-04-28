//
//  TemplateParser.m
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 4/28/25.
//  Copyright © 2025 Todd Ditchendorf. All rights reserved.
//

#import "TemplateParser.hpp"
#import <ParseKitCPP/ParseException.hpp>
#import <TDTemplateEngine/TDRootNode.h>

using namespace parsekit;

namespace templateengine {

TemplateParser::TemplateParser(TDTemplateEngine *engine, TDTemplateContext *staticContext) :
_engine(engine),
_staticContext([staticContext retain])
{}

TemplateParser::~TemplateParser() {
    [_staticContext release];
    _staticContext = nil;
    
    [_currentParent release];
    _currentParent = nil;
    
    [_root release];
    _root = nil;
}

TDNode *TemplateParser::parse(TokenListPtr frags) {
    
    TokenListTokenizer tokenizer(frags);
    TokenList token_stack;
    TokenList consumed;
    
    Assembly assembly(&tokenizer, &token_stack, &consumed);
    _assembly = &assembly;
    
    TDNode *node = nil;
    try {
        _template();
        _eof();
        
        node = nil; // TODO
    } catch (ParseException& ex) {
        node = nil;
    }
    
    _assembly = nullptr;
    return node;
}

void TemplateParser::_template() {
    assert(_staticContext);
    
    TDNode *root = [TDRootNode rootNodeWithStaticContext:_staticContext];
    setRoot(root);
    setCurrentParent(root);
    
    do {
        _content();
    } while (predicts(TokenType_ANY, 0));
}

void TemplateParser::_content() {
    if (predicts(TemplateTokenType_PRINT, 0)) {
//        _print();
    } else if (predicts(TemplateTokenType_EMPTY_TAG, 0)) {
//        _empty_tag();
    } else if (predicts(TemplateTokenType_BLOCK_START_TAG, 0)) {
//        _block_tag();
    } else if (predicts(TemplateTokenType_TEXT, 0)) {
//        _text();
    } else {
//        raise(@"No viable alternative found in rule 'content'.");
    }
}
//
//- (void)print_ {
//
//    [self match:TDTEMPLATE_TOKEN_KIND_PRINT discard:NO];
//    [self execute:^{
//
//    PKToken *tok = POP();
//    ASSERT(_engine);
//    TDNode *printNode = [_engine printNodeFromFragment:tok withParent:_currentParent];
//    ASSERT(printNode);
//    [_currentParent addChild:printNode];
//
//    }];
//
//}
//
//- (void)empty_tag_ {
//
//    [self match:TDTEMPLATE_TOKEN_KIND_EMPTY_TAG discard:NO];
//    [self execute:^{
//
//    PKToken *tok = POP();
//    ASSERT(_engine);
//    TDTag *startTagNode = nil;
//    @try {
//        startTagNode = [_engine tagFromFragment:tok withParent:_currentParent];
//    } @catch (NSException *ex) {
//        [self raise:[ex reason]];
//    }
//    ASSERT(startTagNode);
//    [_currentParent addChild:startTagNode];
//    //self.currentParent = startTagNode;
//
//    }];
//
//}
//
//- (void)block_tag_ {
//
//    [self execute:^{
//     PUSH(_currentParent);
//    }];
//    [self block_start_tag_];
//    while (!predicts(TDTEMPLATE_TOKEN_KIND_BLOCK_END_TAG, 0)) {
//        [self content_];
//    }
//    [self block_end_tag_];
//    [self execute:^{
//     self.currentParent = POP();
//    }];
//
//}
//
//- (void)block_start_tag_ {
//
//    [self match:TDTEMPLATE_TOKEN_KIND_BLOCK_START_TAG discard:NO];
//    [self execute:^{
//
//    PKToken *tok = POP();
//    ASSERT(_engine);
//    TDTag *startTagNode = nil;
//    @try {
//        startTagNode = [_engine tagFromFragment:tok withParent:_currentParent];
//    } @catch (NSException *ex) {
//        [self raise:[ex reason]];
//    }
//    ASSERT(startTagNode);
//    [_currentParent addChild:startTagNode];
//    self.currentParent = startTagNode;
//
//    }];
//
//}
//
//- (void)block_end_tag_ {
//
//    [self match:TDTEMPLATE_TOKEN_KIND_BLOCK_END_TAG discard:NO];
//    [self execute:^{
//
//    PKToken *tok = POP();
//    NSString *tagName = [tok.stringValue substringFromIndex:[TDTemplateEngineTagEndPrefix length]];
//    while (_currentParent && ![_currentParent.tagName isEqualToString:tagName])
//        self.currentParent = POP();
//
//    if (!_currentParent || ![_currentParent.tagName isEqualToString:tagName]) {
//        [self raise:[NSString stringWithFormat:@"Could not find block start tag named: `%@`", tagName]];
//    }
//    ASSERT([_currentParent isKindOfClass:[TDTag class]]);
//    TDTag *startNode = (id)_currentParent;
//    startNode.endTagToken = tok;
//
//    }];
//
//}
//
//- (void)text_ {
//
//    [self match:TDTEMPLATE_TOKEN_KIND_TEXT discard:NO];
//    [self execute:^{
//
//    PKToken *tok = POP();
//    TDNode *txtNode = [TDTextNode nodeWithToken:tok parent:_currentParent];
//    [_currentParent addChild:txtNode];
//
//    }];
//
//}

void TemplateParser::setRoot(TDNode *n) {
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
