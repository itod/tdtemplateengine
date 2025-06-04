//
//  CPPArithmeticExpressionTests.m
//  TDTemplateEngineTests
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDBaseExpressionTests.h"
#import "TagParser.hpp"

using namespace parsekit;
using namespace templateengine;

@interface CPPArithmeticExpressionTests : TDBaseExpressionTests
@end

@implementation CPPArithmeticExpressionTests

- (void)setUp {
    [super setUp];
    
}

- (void)tearDown {
    
    [super tearDown];
}

- (void)test1SpacePlusSpace2 {
    std::string input = "1 + 2";

    TagParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parseExpression(&r);
    XCTAssertNotNil(expr);
    XCTAssertEqual(3.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)test1Plus2 {
    std::string input = "1+2";

    TagParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parseExpression(&r);
    XCTAssertNotNil(expr);
    XCTAssertEqual(3.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)test1SpaceMinusSpace1 {
    std::string input = "1 - 1";

    TagParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parseExpression(&r);
    XCTAssertNotNil(expr);
    XCTAssertEqual(0.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)testTruePlus1 {
    std::string input = "True + 1";

    TagParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parseExpression(&r);
    XCTAssertNotNil(expr);
    XCTAssertEqual(2.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)testFalsePlus1 {
    std::string input = "False + 1";

    TagParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parseExpression(&r);
    XCTAssertNotNil(expr);
    XCTAssertEqual(1.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)test2Times2 {
    std::string input = "2*2";

    TagParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parseExpression(&r);
    XCTAssertNotNil(expr);
    XCTAssertEqual(4.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)test2Div2 {
    std::string input = "2/2";

    TagParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parseExpression(&r);
    XCTAssertNotNil(expr);
    XCTAssertEqual(1.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)test3Plus2Times2 {
    std::string input = "3+2*2";

    TagParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parseExpression(&r);
    XCTAssertNotNil(expr);
    XCTAssertEqual(7.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)testOpen3Plus2CloseTimes2 {
    std::string input = "(3+2)*2";

    TagParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parseExpression(&r);
    XCTAssertNotNil(expr);
    XCTAssertEqual(10.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)testNeg2Mod2 {
    std::string input = "-2%2";

    TagParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parseExpression(&r);
    XCTAssertNotNil(expr);
    XCTAssertEqual(-0.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)testNeg1Mod2 {
    std::string input = "-1%2";

    TagParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parseExpression(&r);
    XCTAssertNotNil(expr);
    XCTAssertEqual(-1.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)test0Mod2 {
    std::string input = "0%2";

    TagParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parseExpression(&r);
    XCTAssertNotNil(expr);
    XCTAssertEqual(0.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)test1Mod2 {
    std::string input = "1%2";

    TagParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parseExpression(&r);
    XCTAssertNotNil(expr);
    XCTAssertEqual(1.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)test2Mod2 {
    std::string input = "2%2";

    TagParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parseExpression(&r);
    XCTAssertNotNil(expr);
    XCTAssertEqual(0.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)test3Mod2 {
    std::string input = "3%2";

    TagParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parseExpression(&r);
    XCTAssertNotNil(expr);
    XCTAssertEqual(1.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)test4Mod2 {
    std::string input = "4%2";

    TagParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parseExpression(&r);
    XCTAssertNotNil(expr);
    XCTAssertEqual(0.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)testMinus1 {
    std::string input = "-1";

    TagParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parseExpression(&r);
    XCTAssertNotNil(expr);
    XCTAssertEqual(-1.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)testMinusMinus1 {
    std::string input = "--1";

    TagParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parseExpression(&r);
    XCTAssertNotNil(expr);
    XCTAssertEqual(1.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)test1PlusMinusMinus1 {
    std::string input = "1 + --1";

    TagParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parseExpression(&r);
    XCTAssertNotNil(expr);
    XCTAssertEqual(2.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)test1MinusMinusMinus1 {
    std::string input = "1 - --1";

    TagParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parseExpression(&r);
    XCTAssertNotNil(expr);
    XCTAssertEqual(0.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)testMinusMinus1Plus1 {
    std::string input = "--1 + 1";

    TagParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parseExpression(&r);
    XCTAssertNotNil(expr);
    XCTAssertEqual(2.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)testMinusMinus1Minus1 {
    std::string input = "--1 - 1";

    TagParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parseExpression(&r);
    XCTAssertNotNil(expr);
    XCTAssertEqual(0.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)testMinusMinusMinus1 {
    std::string input = "---1";

    TagParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parseExpression(&r);
    XCTAssertNotNil(expr);
    XCTAssertEqual(-1.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)testMinusMinusMinusMinus4 {
    std::string input = "----4";

    TagParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parseExpression(&r);
    XCTAssertNotNil(expr);
    XCTAssertEqual(4.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)testPathFooBar8Plus2 {
    std::string input = "foo.bar+2";
    ReaderCPP r(input);
    
    id vars = @{@"foo": @{@"bar": @(8)}};
    id ctx = [[[TDTemplateContext alloc] initWithVariables:vars output:nil] autorelease];
    
    NSError *err = nil;
    TDExpression *expr = [self expressionFromReader:&r error:&err];
    XCTAssertNil(err);
    XCTAssertNotNil(expr);
    XCTAssertEqual(10.0, [[expr simplify] evaluateAsNumberInContext:ctx]);
}

@end
