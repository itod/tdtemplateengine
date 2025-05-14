//
//  CPPEqualityExpressionTests.m
//  TDTemplateEngineTests
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDBaseExpressionTests.h"
#import "ExpressionParser.hpp"

using namespace parsekit;
using namespace templateengine;


@interface CPPEqualityExpressionTests : TDBaseExpressionTests
@end

@implementation CPPEqualityExpressionTests

- (void)setUp {
    [super setUp];

}

- (void)tearDown {
    
    [super tearDown];
}

- (void)test1Eq1 {
    std::string input = "1 eq 1";

    ExpressionParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parse(&r);
    XCTAssertNotNil(expr);
    XCTAssertTrue([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)test0EqSignNeg0 {
    std::string input = "0 = -0";
    
    ExpressionParser p;
    ReaderCPP r(input);
    TDExpression *expr = nil;
    try {
        expr = p.parse(&r);
        XCTAssert(0);
    } catch (ParseException& ex) {}
    XCTAssertNil(expr);
}

- (void)test0EqEqSignNeg0 {
    std::string input = "0 == -0";

    ExpressionParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parse(&r);
    XCTAssertNotNil(expr);
    XCTAssertTrue([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)testNeg0EqEqSign0 {
    std::string input = "-0 == 0";

    ExpressionParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parse(&r);
    XCTAssertNotNil(expr);
    XCTAssertTrue([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)testNeg0EqEqSignNeg0 {
    std::string input = "-0==-0";

    ExpressionParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parse(&r);
    XCTAssertNotNil(expr);
    XCTAssertTrue([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)test1EqSign1 {
    std::string input = "1 = 1";
    
    ExpressionParser p;
    ReaderCPP r(input);
    TDExpression *expr = nil;
    try {
        expr = p.parse(&r);
        XCTAssert(0);
    } catch (ParseException& ex) {}
    XCTAssertNil(expr);
}

- (void)test1EqEqSign1 {
    std::string input = "1 == 1";

    ExpressionParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parse(&r);
    XCTAssertNotNil(expr);
    XCTAssertTrue([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)test1Eq2 {
    std::string input = "1 eq 2";

    ExpressionParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parse(&r);
    XCTAssertNotNil(expr);
    XCTAssertFalse([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)test1EqSign2 {
    std::string input = "1 = 2";
    
    ExpressionParser p;
    ReaderCPP r(input);
    TDExpression *expr = nil;
    try {
        expr = p.parse(&r);
        XCTAssert(0);
    } catch (ParseException& ex) {}
    XCTAssertNil(expr);
}

- (void)test1EqEqSign2 {
    std::string input = "1 == 2";

    ExpressionParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parse(&r);
    XCTAssertNotNil(expr);
    XCTAssertFalse([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)test1Ne1 {
    std::string input = "1 ne 1";

    ExpressionParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parse(&r);
    XCTAssertNotNil(expr);
    XCTAssertFalse([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)test1NeSign1 {
    std::string input = "1 != 1";

    ExpressionParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parse(&r);
    XCTAssertNotNil(expr);
    XCTAssertFalse([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)test1Ne2 {
    std::string input = "1 ne 2";

    ExpressionParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parse(&r);
    XCTAssertNotNil(expr);
    XCTAssertTrue([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)test1NeSign2 {
    std::string input = "1 != 2";

    ExpressionParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parse(&r);
    XCTAssertNotNil(expr);
    XCTAssertTrue([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)test0EqNeg0 {
    std::string input = "0 == -0";
    
    XCTAssertEqual(0, -0);
    
    ExpressionParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parse(&r);
    XCTAssertNotNil(expr);
    XCTAssertTrue([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)test0NeNeg0 {
    std::string input = "0 != -0";

    ExpressionParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parse(&r);
    XCTAssertNotNil(expr);
    XCTAssertFalse([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)test00EqNeg00 {
    std::string input = "0.0 == -0.0";
    
    XCTAssertEqual(0.0, -0.0);
    
    ExpressionParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parse(&r);
    XCTAssertNotNil(expr);
    XCTAssertTrue([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)test00NeNeg00 {
    std::string input = "0.0 != -0.0";

    ExpressionParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parse(&r);
    XCTAssertNotNil(expr);
    XCTAssertFalse([[expr simplify] evaluateAsBooleanInContext:nil]);
}

@end
