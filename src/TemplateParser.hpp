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
    
    TemplateAssembly *_assembly;
    
    TDNode *_root;
    void setRoot(TDNode *n);
    
    TDNode *_currentParent;
    void setCurrentParent(TDNode *n);
    
    void _template();
    void _content();
    void _print();
    void _empty_tag();
    void _block_tag();
    void _block_start_tag();
    void _block_end_tag();
    void _text();

    void raise(std::string reason);
    
public:
    explicit TemplateParser(TDTemplateEngine *, TDTemplateContext *);
    ~TemplateParser();
    
    virtual parsekit::Assembly *assembly() const override { return _assembly; }
    
    TDNode *parse(parsekit::TokenListPtr);
};

}
