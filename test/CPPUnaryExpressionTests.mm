//
//  CPPUnaryExpressionTests.m
//  TDTemplateEngineTests
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDBaseExpressionTests.h"
#import "TagParser.hpp"

using namespace parsekit;
using namespace templateengine;

@interface CPPUnaryExpressionTests : TDBaseExpressionTests

@end

@implementation CPPUnaryExpressionTests

- (void)testNeg1 {
    std::string input = "-1";
    
    TagParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parseExpression(&r);
    XCTAssertNotNil(expr);
    XCTAssertEqual(-1, [[expr simplify] evaluateAsNumberInContext:nil]);

}

- (void)testNegNeg1 {
    std::string input = "--1";
    
    TagParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parseExpression(&r);
    XCTAssertNotNil(expr);
    XCTAssertEqual(1, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)testNegNegNeg1 {
    std::string input = "---1";
    
    TagParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parseExpression(&r);
    XCTAssertNotNil(expr);
    XCTAssertEqual(-1, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)testNegNegNegNeg1 {
    std::string input = "----1";
    
    TagParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parseExpression(&r);
    XCTAssertNotNil(expr);
    XCTAssertEqual(1, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)testNegVar {
    NSString *input = @"{{-foo}}";
    id vars = @{@"foo": @1};
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@"-1", res);
}

- (void)testNegNegVar {
    NSString *input = @"{{--foo}}";
    id vars = @{@"foo": @1};
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@"1", res);
}

- (void)testNegNegNegVar {
    NSString *input = @"{{---foo}}";
    id vars = @{@"foo": @1};
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@"-1", res);
}

- (void)testNegNegNegNegVar {
    NSString *input = @"{{----foo}}";
    id vars = @{@"foo": @1};
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@"1", res);
}

@end
