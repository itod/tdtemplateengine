//
//  CPPNegationExpressionTests.m
//  TDTemplateEngineTests
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDBaseExpressionTests.h"
#import "ExpressionParser.hpp"

using namespace parsekit;
using namespace templateengine;

@interface CPPNegationExpressionTests : TDBaseExpressionTests
@end

@implementation CPPNegationExpressionTests

- (void)setUp {
    [super setUp];
    
}

- (void)tearDown {
    
    [super tearDown];
}

- (void)testNot1 {
    std::string input = "not 1";

    ExpressionParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parseExpression(&r);
    XCTAssertNotNil(expr);
    XCTAssertFalse([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)testBangSpace1 {
    std::string input = "! 1";

    ExpressionParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parseExpression(&r);
    XCTAssertNotNil(expr);
    XCTAssertFalse([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)testBang1 {
    std::string input = "!1";

    ExpressionParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parseExpression(&r);
    XCTAssertNotNil(expr);
    XCTAssertFalse([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)testNot0 {
    std::string input = "not 0";

    ExpressionParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parseExpression(&r);
    XCTAssertNotNil(expr);
    XCTAssertTrue([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)testBangSpace0 {
    std::string input = "! 0";

    ExpressionParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parseExpression(&r);
    XCTAssertNotNil(expr);
    XCTAssertTrue([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)testBang0 {
    std::string input = "!0";

    ExpressionParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parseExpression(&r);
    XCTAssertNotNil(expr);
    XCTAssertTrue([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)testNotYES {
    std::string input = "not YES";

    ExpressionParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parseExpression(&r);
    XCTAssertNotNil(expr);
    XCTAssertFalse([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)testBangSpaceYES {
    std::string input = "! YES";

    ExpressionParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parseExpression(&r);
    XCTAssertNotNil(expr);
    XCTAssertFalse([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)testBangYES {
    std::string input = "!YES";

    ExpressionParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parseExpression(&r);
    XCTAssertNotNil(expr);
    XCTAssertFalse([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)testNotNO {
    std::string input = "not NO";

    ExpressionParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parseExpression(&r);
    XCTAssertNotNil(expr);
    XCTAssertTrue([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)testBangSpaceNO {
    std::string input = "! NO";

    ExpressionParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parseExpression(&r);
    XCTAssertNotNil(expr);
    XCTAssertTrue([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)testBangNO {
    std::string input = "!NO";

    ExpressionParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parseExpression(&r);
    XCTAssertNotNil(expr);
    XCTAssertTrue([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)testNotTrue {
    std::string input = "not true";

    ExpressionParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parseExpression(&r);
    XCTAssertNotNil(expr);
    XCTAssertFalse([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)testBangSpaceTrue {
    std::string input = "! true";

    ExpressionParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parseExpression(&r);
    XCTAssertNotNil(expr);
    XCTAssertFalse([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)testBangTrue {
    std::string input = "!true";

    ExpressionParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parseExpression(&r);
    XCTAssertNotNil(expr);
    XCTAssertFalse([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)testNotFalse {
    std::string input = "not false";

    ExpressionParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parseExpression(&r);
    XCTAssertNotNil(expr);
    XCTAssertTrue([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)testBangSpaceFalse {
    std::string input = "! false";

    ExpressionParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parseExpression(&r);
    XCTAssertNotNil(expr);
    XCTAssertTrue([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)testBangFalse {
    std::string input = "!false";

    ExpressionParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parseExpression(&r);
    XCTAssertNotNil(expr);
    XCTAssertTrue([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)testNotOpenTrueClose {
    std::string input = "not(true)";

    ExpressionParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parseExpression(&r);
    XCTAssertNotNil(expr);
    XCTAssertFalse([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)testNotSpaceOpenTrueClose {
    std::string input = "not(true)";

    ExpressionParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parseExpression(&r);
    XCTAssertNotNil(expr);
    XCTAssertFalse([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)testBangSpaceOpenTrueClose {
    std::string input = "! (true)";

    ExpressionParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parseExpression(&r);
    XCTAssertNotNil(expr);
    XCTAssertFalse([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)testBangOpenTrueClose {
    std::string input = "!(true)";

    ExpressionParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parseExpression(&r);
    XCTAssertNotNil(expr);
    XCTAssertFalse([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)testNotOpenFalseClose {
    std::string input = "not(false)";

    ExpressionParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parseExpression(&r);
    XCTAssertNotNil(expr);
    XCTAssertTrue([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)testNotSpaceOpenFalseClose {
    std::string input = "not (false)";

    ExpressionParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parseExpression(&r);
    XCTAssertNotNil(expr);
    XCTAssertTrue([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)testBangOpenFalseClose {
    std::string input = "!(false)";

    ExpressionParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parseExpression(&r);
    XCTAssertNotNil(expr);
    XCTAssertTrue([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)testBangSpaceOpenFalseClose {
    std::string input = "! (false)";

    ExpressionParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parseExpression(&r);
    XCTAssertNotNil(expr);
    XCTAssertTrue([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)testNotSpaceSQString {
    std::string input = "not 'hello'";

    ExpressionParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parseExpression(&r);
    XCTAssertNotNil(expr);
    XCTAssertFalse([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)testNotSQString {
    std::string input = "not'hello'";

    ExpressionParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parseExpression(&r);
    XCTAssertNotNil(expr);
    XCTAssertFalse([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)testBangSpaceSQString {
    std::string input = "! 'hello'";

    ExpressionParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parseExpression(&r);
    XCTAssertNotNil(expr);
    XCTAssertFalse([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)testBangSQString {
    std::string input = "!'hello'";

    ExpressionParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parseExpression(&r);
    XCTAssertNotNil(expr);
    XCTAssertFalse([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)testNotSpaceEmptySQString {
    std::string input = "not ''";

    ExpressionParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parseExpression(&r);
    XCTAssertNotNil(expr);
    XCTAssertTrue([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)testNotEmptySQString {
    std::string input = "not''";

    ExpressionParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parseExpression(&r);
    XCTAssertNotNil(expr);
    XCTAssertTrue([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)testNotOpen1Eq1Close {
    std::string input = "not(1 eq 1)";

    ExpressionParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parseExpression(&r);
    XCTAssertNotNil(expr);
    XCTAssertFalse([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)testBangOpen1EqSign1Close {
    std::string input = "!(1 = 1)";
    
    ExpressionParser p;
    ReaderCPP r(input);
    
    TDExpression *expr = nil;
    try {
        expr = p.parseExpression(&r);
        XCTAssertTrue(0);
    } catch (ParseException& ex) {}
    XCTAssertNil(expr);
}

- (void)testBang1EqEqSign1 {
    std::string input = "!1 == 1";

    ExpressionParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parseExpression(&r);
    XCTAssertNotNil(expr);
    XCTAssertFalse([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)test1EqNot1 {
    std::string input = "1 eq not 1";

    ExpressionParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parseExpression(&r);
    XCTAssertNotNil(expr);
    XCTAssertFalse([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)test1EqBangSpace1 {
    std::string input = "1 eq ! 1";

    ExpressionParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parseExpression(&r);
    XCTAssertNotNil(expr);
    XCTAssertFalse([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)test1EqSpace1 {
    std::string input = "1 eq !1";

    ExpressionParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parseExpression(&r);
    XCTAssertNotNil(expr);
    XCTAssertFalse([[expr simplify] evaluateAsBooleanInContext:nil]);
}

@end
