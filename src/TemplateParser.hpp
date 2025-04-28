//
//  TemplateParser.h
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 4/28/25.
//  Copyright © 2025 Todd Ditchendorf. All rights reserved.
//

#import <ParseKitCPP/BaseParser.hpp>

@class TDTemplateEngine;
@class TDTemplateContext;
@class TDNode;

namespace templateengine {

typedef int TemplateTokenType;

const TemplateTokenType TemplateTokenType_TEXT = 2;
const TemplateTokenType TemplateTokenType_PRINT = 3;
const TemplateTokenType TemplateTokenType_BLOCK_START_TAG = 4;
const TemplateTokenType TemplateTokenType_BLOCK_END_TAG = 5;
const TemplateTokenType TemplateTokenType_EMPTY_TAG = 6;

class TemplateParser : public parsekit::BaseParser {
private:
    TDTemplateEngine *_engine; // weakref, aka delegate
    TDTemplateContext *_staticContext;
    
    parsekit::Assembly *_assembly;
    
public:
    explicit TemplateParser(TDTemplateEngine *, TDTemplateContext *);
    ~TemplateParser();
    
    virtual parsekit::Assembly *assembly() override { return _assembly; }
    
    TDNode *parse(parsekit::TokenListPtr);
};

}
