//
//  TemplateParser.h
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 4/28/25.
//  Copyright © 2025 Todd Ditchendorf. All rights reserved.
//

#import <ParseKitCPP/BaseParser.hpp>
#import "TemplateAssembly.hpp"

@class TDTemplateEngine;
@class TDTemplateContext;
@class TDNode;
@class TDRootNode;

namespace templateengine {

typedef int TemplateTokenType;

const TemplateTokenType TemplateTokenType_TEXT = 2;
const TemplateTokenType TemplateTokenType_PRINT = 3;
const TemplateTokenType TemplateTokenType_BLOCK_START_TAG = 4;
const TemplateTokenType TemplateTokenType_BLOCK_END_TAG = 5;
const TemplateTokenType TemplateTokenType_EMPTY_TAG = 6;
const TemplateTokenType TemplateTokenType_TAG = 7;

class TemplateParser : public parsekit::BaseParser {
private:
    TDTemplateEngine *_engine; // weakref, aka delegate
    TDTemplateContext *_context;
    
    TemplateAssembly *_assembly;
    
    TDRootNode *_root;
    void setRoot(TDRootNode *n);
    
    TDNode *_currentParent;
    void setCurrentParent(TDNode *n);
    void reThrowOrRaiseWithToken(ParseException& ex, Token token);
    
    void _template(NSString *filePath);
    void _content();
    void _print();
    void _empty_tag();
    void _block_tag();
    void _block_start_tag();
    void _block_end_tag();
    void _text();

    void raise(NSString *reason, Token tok);
    
public:
    explicit TemplateParser(TDTemplateEngine *, TDTemplateContext *);
    ~TemplateParser();
    
    virtual parsekit::Assembly *assembly() const override { return _assembly; }
    
    TDRootNode *parse(parsekit::TokenListPtr, NSString *filePath);
};

}
