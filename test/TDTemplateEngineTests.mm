//
//  TDTemplateEngineTests.m
//  TDTemplateEngineTests
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDTestScaffold.h"
#import <ParseKitCPP/Token.hpp>
#import "TemplateParser.hpp"

using namespace parsekit;
using namespace templateengine;

@interface TDTemplateEngine ()
- (TokenListPtr)fragmentsFromString_:(NSString *)inStr;
@end

@interface TDTemplateEngineTests : XCTestCase
@property (nonatomic, retain) TDTemplateEngine *engine;
@property (nonatomic, retain) NSOutputStream *output;
@end

@implementation TDTemplateEngineTests

- (void)setUp {
    [super setUp];
    
    self.engine = [TDTemplateEngine templateEngine];
    self.output = [NSOutputStream outputStreamToMemory];
}

- (void)tearDown {
    self.engine = nil;
    self.output = nil;
    
    [super tearDown];
}

- (NSString *)outputString {
    NSString *str = [[[NSString alloc] initWithData:[_output propertyForKey:NSStreamDataWrittenToMemoryStreamKey] encoding:NSUTF8StringEncoding] autorelease];
    return str;
}

- (void)testFragmentGathering {
    NSString *input = @"{% if test %}{{a}}{% else %} foo bar { baz } {% endif %}";
    
    TokenListPtr toks = [_engine fragmentsFromString_:input];
    
    Token tok = toks->at(0);
    XCTAssertEqual(tok.token_type(), TemplateTokenType_BLOCK_START_TAG);
    XCTAssertEqualObjects([input substringWithRange:NSMakeRange(tok.range().location, tok.range().length)], @"if");
    
    tok = toks->at(1);
    XCTAssertEqual(tok.token_type(), TemplateTokenType_PRINT);
    XCTAssertEqualObjects([input substringWithRange:NSMakeRange(tok.range().location, tok.range().length)], @"a");
    
    tok = toks->at(2);
    XCTAssertEqual(tok.token_type(), TemplateTokenType_EMPTY_TAG);
    XCTAssertEqualObjects([input substringWithRange:NSMakeRange(tok.range().location, tok.range().length)], @"else");
    
    tok = toks->at(3);
    XCTAssertEqual(tok.token_type(), TemplateTokenType_TEXT);
    XCTAssertEqualObjects([input substringWithRange:NSMakeRange(tok.range().location, tok.range().length)], @" foo bar { baz } ");
    
    tok = toks->at(4);
    XCTAssertEqual(tok.token_type(), TemplateTokenType_BLOCK_END_TAG);
    XCTAssertEqualObjects([input substringWithRange:NSMakeRange(tok.range().location, tok.range().length)], @"endif");
}

@end
