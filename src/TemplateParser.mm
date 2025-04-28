//
//  TemplateParser.m
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 4/28/25.
//  Copyright © 2025 Todd Ditchendorf. All rights reserved.
//

#import "TemplateParser.hpp"

using namespace parsekit;

namespace templateengine {

TemplateParser::TemplateParser(TDTemplateEngine *engine, TDTemplateContext *staticContext) :
    _engine(engine),
    _staticContext([staticContext retain])
{}

TemplateParser::~TemplateParser() {
    [_staticContext release];
    _staticContext = nil;
}

TDNode *TemplateParser::parse(TokenListPtr frags) {
    
    TokenListTokenizer tokenizer(frags);
    TokenList token_stack;
    TokenList consumed;

    Assembly assembly(&tokenizer, &token_stack, &consumed);
    _assembly = &assembly;
    
    
    
    _assembly = nullptr;
    return nil;
}

}
