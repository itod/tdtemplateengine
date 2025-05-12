//
//  TDCPPTests.m
//  TDTemplateEngineTests
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDBaseExpressionTests.h"
#import "ExpressionParser.hpp"

using namespace parsekit;
using namespace templateengine;

@interface TDCPPTests : TDBaseExpressionTests
@end

@implementation TDCPPTests

- (void)setUp {
    [super setUp];
    
}

- (void)tearDown {
    
    [super tearDown];
}

- (void)test1 {
    std::string input = "1";
    
    ExpressionParser p;
    Reader r(input);
    TDExpression *expr = p.parse(&r);
    XCTAssertNotNil(expr);
    XCTAssertTrue([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)test0 {
    std::string input = "0";
    
    ExpressionParser p;
    Reader r(input);
    TDExpression *expr = p.parse(&r);
    XCTAssertNotNil(expr);
    XCTAssertFalse([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)testYES {
    std::string input = "YES";
    
    ExpressionParser p;
    Reader r(input);
    TDExpression *expr = p.parse(&r);
    XCTAssertNotNil(expr);
    XCTAssertTrue([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)testNO {
    std::string input = "NO";
    
    ExpressionParser p;
    Reader r(input);
    TDExpression *expr = p.parse(&r);
    XCTAssertNotNil(expr);
    XCTAssertFalse([[expr simplify] evaluateAsBooleanInContext:nil]);
}
//
//- (void)testTrue {
//    NSString *input = @"true";
//    NSArray *toks = [self tokenize:input];
//    
//    NSError *err = nil;
//    TDExpression *expr = [self.eng expressionFromTokens:toks error:&err];
//    TDNil(err);
//    TDNotNil(expr);
//    TDTrue([[expr simplify] evaluateAsBooleanInContext:nil]);
//}
//
//- (void)testFalse {
//    NSString *input = @"false";
//    NSArray *toks = [self tokenize:input];
//    
//    NSError *err = nil;
//    TDExpression *expr = [self.eng expressionFromTokens:toks error:&err];
//    TDNil(err);
//    TDNotNil(expr);
//    TDFalse([[expr simplify] evaluateAsBooleanInContext:nil]);
//}
//
//- (void)testOpenTrueClose {
//    NSString *input = @"(true)";
//    NSArray *toks = [self tokenize:input];
//    
//    NSError *err = nil;
//    TDExpression *expr = [self.eng expressionFromTokens:toks error:&err];
//    TDNil(err);
//    TDNotNil(expr);
//    TDTrue([[expr simplify] evaluateAsBooleanInContext:nil]);
//}
//
//- (void)testOpenFalseClose {
//    NSString *input = @"(false)";
//    NSArray *toks = [self tokenize:input];
//    
//    NSError *err = nil;
//    TDExpression *expr = [self.eng expressionFromTokens:toks error:&err];
//    TDNil(err);
//    TDNotNil(expr);
//    TDFalse([[expr simplify] evaluateAsBooleanInContext:nil]);
//}
//
//- (void)testSQString {
//    NSString *input = @"'hello'";
//    NSArray *toks = [self tokenize:input];
//    
//    NSError *err = nil;
//    TDExpression *expr = [self.eng expressionFromTokens:toks error:&err];
//    TDNil(err);
//    TDNotNil(expr);
//    TDTrue([[expr simplify] evaluateAsBooleanInContext:nil]);
//}
//
//- (void)testEmptySQString {
//    NSString *input = @"''";
//    NSArray *toks = [self tokenize:input];
//    
//    NSError *err = nil;
//    TDExpression *expr = [self.eng expressionFromTokens:toks error:&err];
//    TDNil(err);
//    TDNotNil(expr);
//    TDFalse([[expr simplify] evaluateAsBooleanInContext:nil]);
//}
//
//- (void)test1And0 {
//    NSString *input = @"1 and 0";
//    NSArray *toks = [self tokenize:input];
//    
//    NSError *err = nil;
//    TDExpression *expr = [self.eng expressionFromTokens:toks error:&err];
//    TDNil(err);
//    TDNotNil(expr);
//    TDFalse([[expr simplify] evaluateAsBooleanInContext:nil]);
//}
//
//- (void)test1AmpAmp0 {
//    NSString *input = @"1 && 0";
//    NSArray *toks = [self tokenize:input];
//    
//    NSError *err = nil;
//    TDExpression *expr = [self.eng expressionFromTokens:toks error:&err];
//    TDNil(err);
//    TDNotNil(expr);
//    TDFalse([[expr simplify] evaluateAsBooleanInContext:nil]);
//}
//
//- (void)test0And1 {
//    NSString *input = @"0 and 1";
//    NSArray *toks = [self tokenize:input];
//    
//    NSError *err = nil;
//    TDExpression *expr = [self.eng expressionFromTokens:toks error:&err];
//    TDNil(err);
//    TDNotNil(expr);
//    TDFalse([[expr simplify] evaluateAsBooleanInContext:nil]);
//}
//
//- (void)test1And1 {
//    NSString *input = @"1 and 1";
//    NSArray *toks = [self tokenize:input];
//    
//    NSError *err = nil;
//    TDExpression *expr = [self.eng expressionFromTokens:toks error:&err];
//    TDNil(err);
//    TDNotNil(expr);
//    TDTrue([[expr simplify] evaluateAsBooleanInContext:nil]);
//}
//
//- (void)test1AmpAmp1 {
//    NSString *input = @"1 && 1";
//    NSArray *toks = [self tokenize:input];
//    
//    NSError *err = nil;
//    TDExpression *expr = [self.eng expressionFromTokens:toks error:&err];
//    TDNil(err);
//    TDNotNil(expr);
//    TDTrue([[expr simplify] evaluateAsBooleanInContext:nil]);
//}
//
//- (void)test1Or0 {
//    NSString *input = @"1 or 0";
//    NSArray *toks = [self tokenize:input];
//    
//    NSError *err = nil;
//    TDExpression *expr = [self.eng expressionFromTokens:toks error:&err];
//    TDNil(err);
//    TDNotNil(expr);
//    TDTrue([[expr simplify] evaluateAsBooleanInContext:nil]);
//}
//
//- (void)test1PipePipe0 {
//    NSString *input = @"1 || 0";
//    NSArray *toks = [self tokenize:input];
//    
//    NSError *err = nil;
//    TDExpression *expr = [self.eng expressionFromTokens:toks error:&err];
//    TDNil(err);
//    TDNotNil(expr);
//    TDTrue([[expr simplify] evaluateAsBooleanInContext:nil]);
//}
//
//- (void)test0Or1 {
//    NSString *input = @"0 or 1";
//    NSArray *toks = [self tokenize:input];
//    
//    NSError *err = nil;
//    TDExpression *expr = [self.eng expressionFromTokens:toks error:&err];
//    TDNil(err);
//    TDNotNil(expr);
//    TDTrue([[expr simplify] evaluateAsBooleanInContext:nil]);
//}
//
//- (void)test0PipePipe1 {
//    NSString *input = @"0 || 1";
//    NSArray *toks = [self tokenize:input];
//    
//    NSError *err = nil;
//    TDExpression *expr = [self.eng expressionFromTokens:toks error:&err];
//    TDNil(err);
//    TDNotNil(expr);
//    TDTrue([[expr simplify] evaluateAsBooleanInContext:nil]);
//}
//
//- (void)test1Or1 {
//    NSString *input = @"1 or 1";
//    NSArray *toks = [self tokenize:input];
//    
//    NSError *err = nil;
//    TDExpression *expr = [self.eng expressionFromTokens:toks error:&err];
//    TDNil(err);
//    TDNotNil(expr);
//    TDTrue([[expr simplify] evaluateAsBooleanInContext:nil]);
//}

@end
