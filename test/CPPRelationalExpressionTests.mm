//
//  CPPRelationalExpressionTests.m
//  TDTemplateEngineTests
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDBaseExpressionTests.h"
#import "TagParser.hpp"

using namespace parsekit;
using namespace templateengine;

@interface CPPRelationalExpressionTests : TDBaseExpressionTests

@end

@implementation CPPRelationalExpressionTests

- (void)setUp {
    [super setUp];
    
}

- (void)tearDown {
    
    [super tearDown];
}

- (void)test1Lt1 {
    std::string input = "1 < 1";

    TagParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parseExpression(&r);
    XCTAssertNotNil(expr);
    XCTAssertFalse([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)test1LtEq1 {
    std::string input = "1 <= 1";

    TagParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parseExpression(&r);
    XCTAssertNotNil(expr);
    XCTAssertTrue([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)test1Lt2 {
    std::string input = "1 < 2";

    TagParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parseExpression(&r);
    XCTAssertNotNil(expr);
    XCTAssertTrue([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)test1LtEq2 {
    std::string input = "1 <= 2";

    TagParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parseExpression(&r);
    XCTAssertNotNil(expr);
    XCTAssertTrue([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)test1Gt1 {
    std::string input = "1 > 1";

    TagParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parseExpression(&r);
    XCTAssertNotNil(expr);
    XCTAssertFalse([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)test1GtEq1 {
    std::string input = "1 >= 1";

    TagParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parseExpression(&r);
    XCTAssertNotNil(expr);
    XCTAssertTrue([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)test1Gt2 {
    std::string input = "1 > 2";

    TagParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parseExpression(&r);
    XCTAssertNotNil(expr);
    XCTAssertFalse([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)test1GtEq2 {
    std::string input = "1 >= 2";

    TagParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parseExpression(&r);
    XCTAssertNotNil(expr);
    XCTAssertFalse([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)testNeg0Lt0 {
    std::string input = "-0 < 0";

    TagParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parseExpression(&r);
    XCTAssertNotNil(expr);
    XCTAssertFalse([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)testNeg0Gt0 {
    std::string input = "-0.0 > 0.0";

    TagParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parseExpression(&r);
    XCTAssertNotNil(expr);
    XCTAssertFalse([[expr simplify] evaluateAsBooleanInContext:nil]);
}

@end
