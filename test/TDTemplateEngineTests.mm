//
//  TDTemplateEngineTests.m
//  TDTemplateEngineTests
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDBaseTestCase.h"
#import <ParseKitCPP/Token.hpp>
#import "TemplateParser.hpp"

using namespace parsekit;
using namespace templateengine;

@interface TDTemplateEngine ()
- (TokenListPtr)fragmentsFromString:(NSString *)inStr;
@end

@interface TDTemplateEngineTests : TDBaseTestCase

@end

@implementation TDTemplateEngineTests

- (void)testFragmentGathering {
    NSString *input = @"{% if test %}{{a}}{% else %} foo bar { baz } {% endif %}";
    
    TokenListPtr toks = [self.engine fragmentsFromString:input];
    
    Token tok = toks->at(0);
    XCTAssertEqual(tok.token_type(), TemplateTokenType_BLOCK_START_TAG);
    XCTAssertEqualObjects([input substringWithRange:NSMakeRange(tok.range().location, tok.range().length)], @" if test ");

    tok = toks->at(1);
    XCTAssertEqual(tok.token_type(), TemplateTokenType_TAG);
    XCTAssertEqualObjects([input substringWithRange:NSMakeRange(tok.range().location, tok.range().length)], @"{% if test %}");
    
    tok = toks->at(2);
    XCTAssertEqual(tok.token_type(), TemplateTokenType_PRINT);
    XCTAssertEqualObjects([input substringWithRange:NSMakeRange(tok.range().location, tok.range().length)], @"a");
    
    tok = toks->at(3);
    XCTAssertEqual(tok.token_type(), TemplateTokenType_EMPTY_TAG);
    XCTAssertEqualObjects([input substringWithRange:NSMakeRange(tok.range().location, tok.range().length)], @" else ");

    tok = toks->at(4);
    XCTAssertEqual(tok.token_type(), TemplateTokenType_TEXT);
    XCTAssertEqualObjects([input substringWithRange:NSMakeRange(tok.range().location, tok.range().length)], @" foo bar { baz } ");
    
    tok = toks->at(5);
    XCTAssertEqual(tok.token_type(), TemplateTokenType_BLOCK_END_TAG);
    XCTAssertEqualObjects([input substringWithRange:NSMakeRange(tok.range().location, tok.range().length)], @"endif");

    tok = toks->at(6);
    XCTAssertEqual(tok.token_type(), TemplateTokenType_TAG);
    XCTAssertEqualObjects([input substringWithRange:NSMakeRange(tok.range().location, tok.range().length)], @"{% endif %}");
}

@end
