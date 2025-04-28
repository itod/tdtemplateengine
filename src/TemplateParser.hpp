//
//  TemplateParser.h
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 4/28/25.
//  Copyright © 2025 Todd Ditchendorf. All rights reserved.
//

#import <ParseKitCPP/BaseParser.hpp>

namespace templateengine {

typedef int TemplateTokenType;

const TemplateTokenType TemplateTokenType_TEXT = 2;
const TemplateTokenType TemplateTokenType_PRINT = 3;
const TemplateTokenType TemplateTokenType_BLOCK_START_TAG = 4;
const TemplateTokenType TemplateTokenType_BLOCK_END_TAG = 5;
const TemplateTokenType TemplateTokenType_EMPTY_TAG = 6;

class TemplateParser : public parsekit::BaseParser {

};

}
