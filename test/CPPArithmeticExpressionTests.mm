//
//  CPPArithmeticExpressionTests.m
//  TDTemplateEngineTests
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDBaseExpressionTests.h"
#import "ExpressionParser.hpp"

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

    ExpressionParser p;
    Reader r(input);
    TDExpression *expr = p.parse(&r);
    XCTAssertNotNil(expr);
    TDEquals(3.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)test1Plus2 {
    std::string input = "1+2";

    ExpressionParser p;
    Reader r(input);
    TDExpression *expr = p.parse(&r);
    XCTAssertNotNil(expr);
    TDEquals(3.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)test1SpaceMinusSpace1 {
    std::string input = "1 - 1";

    ExpressionParser p;
    Reader r(input);
    TDExpression *expr = p.parse(&r);
    XCTAssertNotNil(expr);
    TDEquals(0.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)testTruePlus1 {
    std::string input = "true + 1";

    ExpressionParser p;
    Reader r(input);
    TDExpression *expr = p.parse(&r);
    XCTAssertNotNil(expr);
    TDEquals(2.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)testYesPlus1 {
    std::string input = "YES + 1";

    ExpressionParser p;
    Reader r(input);
    TDExpression *expr = p.parse(&r);
    XCTAssertNotNil(expr);
    TDEquals(2.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)testFalsePlus1 {
    std::string input = "false + 1";

    ExpressionParser p;
    Reader r(input);
    TDExpression *expr = p.parse(&r);
    XCTAssertNotNil(expr);
    TDEquals(1.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)testNoPlus1 {
    std::string input = "NO + 1";

    ExpressionParser p;
    Reader r(input);
    TDExpression *expr = p.parse(&r);
    XCTAssertNotNil(expr);
    TDEquals(1.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)test2Times2 {
    std::string input = "2*2";

    ExpressionParser p;
    Reader r(input);
    TDExpression *expr = p.parse(&r);
    XCTAssertNotNil(expr);
    TDEquals(4.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)test2Div2 {
    std::string input = "2/2";

    ExpressionParser p;
    Reader r(input);
    TDExpression *expr = p.parse(&r);
    XCTAssertNotNil(expr);
    TDEquals(1.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)test3Plus2Times2 {
    std::string input = "3+2*2";

    ExpressionParser p;
    Reader r(input);
    TDExpression *expr = p.parse(&r);
    XCTAssertNotNil(expr);
    TDEquals(7.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)testOpen3Plus2CloseTimes2 {
    std::string input = "(3+2)*2";

    ExpressionParser p;
    Reader r(input);
    TDExpression *expr = p.parse(&r);
    XCTAssertNotNil(expr);
    TDEquals(10.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)testNeg2Mod2 {
    std::string input = "-2%2";

    ExpressionParser p;
    Reader r(input);
    TDExpression *expr = p.parse(&r);
    XCTAssertNotNil(expr);
    TDEquals(-0.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)testNeg1Mod2 {
    std::string input = "-1%2";

    ExpressionParser p;
    Reader r(input);
    TDExpression *expr = p.parse(&r);
    XCTAssertNotNil(expr);
    TDEquals(-1.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)test0Mod2 {
    std::string input = "0%2";

    ExpressionParser p;
    Reader r(input);
    TDExpression *expr = p.parse(&r);
    XCTAssertNotNil(expr);
    TDEquals(0.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)test1Mod2 {
    std::string input = "1%2";

    ExpressionParser p;
    Reader r(input);
    TDExpression *expr = p.parse(&r);
    XCTAssertNotNil(expr);
    TDEquals(1.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)test2Mod2 {
    std::string input = "2%2";

    ExpressionParser p;
    Reader r(input);
    TDExpression *expr = p.parse(&r);
    XCTAssertNotNil(expr);
    TDEquals(0.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)test3Mod2 {
    std::string input = "3%2";

    ExpressionParser p;
    Reader r(input);
    TDExpression *expr = p.parse(&r);
    XCTAssertNotNil(expr);
    TDEquals(1.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)test4Mod2 {
    std::string input = "4%2";

    ExpressionParser p;
    Reader r(input);
    TDExpression *expr = p.parse(&r);
    XCTAssertNotNil(expr);
    TDEquals(0.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)testMinus1 {
    std::string input = "-1";

    ExpressionParser p;
    Reader r(input);
    TDExpression *expr = p.parse(&r);
    XCTAssertNotNil(expr);
    TDEquals(-1.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)testMinusMinus1 {
    std::string input = "--1";

    ExpressionParser p;
    Reader r(input);
    TDExpression *expr = p.parse(&r);
    XCTAssertNotNil(expr);
    TDEquals(1.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)test1PlusMinusMinus1 {
    std::string input = "1 + --1";

    ExpressionParser p;
    Reader r(input);
    TDExpression *expr = p.parse(&r);
    XCTAssertNotNil(expr);
    TDEquals(2.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)test1MinusMinusMinus1 {
    std::string input = "1 - --1";

    ExpressionParser p;
    Reader r(input);
    TDExpression *expr = p.parse(&r);
    XCTAssertNotNil(expr);
    TDEquals(0.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)testMinusMinus1Plus1 {
    std::string input = "--1 + 1";

    ExpressionParser p;
    Reader r(input);
    TDExpression *expr = p.parse(&r);
    XCTAssertNotNil(expr);
    TDEquals(2.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)testMinusMinus1Minus1 {
    std::string input = "--1 - 1";

    ExpressionParser p;
    Reader r(input);
    TDExpression *expr = p.parse(&r);
    XCTAssertNotNil(expr);
    TDEquals(0.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)testMinusMinusMinus1 {
    std::string input = "---1";

    ExpressionParser p;
    Reader r(input);
    TDExpression *expr = p.parse(&r);
    XCTAssertNotNil(expr);
    TDEquals(-1.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)testMinusMinusMinusMinus4 {
    std::string input = "----4";

    ExpressionParser p;
    Reader r(input);
    TDExpression *expr = p.parse(&r);
    XCTAssertNotNil(expr);
    TDEquals(4.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)testPathFooBar8Plus2 {
    std::string input = "foo.bar+2";
    Reader r(input);
    
    id vars = @{@"foo": @{@"bar": @(8)}};
    id ctx = [[[TDTemplateContext alloc] initWithVariables:vars output:nil] autorelease];
    
    NSError *err = nil;
    TDExpression *expr = [self.eng expressionFromReader:&r error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDEquals(10.0, [[expr simplify] evaluateAsNumberInContext:ctx]);
}

@end
