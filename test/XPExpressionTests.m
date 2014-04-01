//
//  XPExpressionTests.m
//  TDTemplateEngineTests
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDTestScaffold.h"
#import "XPExpression.h"
#import "XPParser.h"
#import <TDTemplateEngine/TDTemplateContext.h>

@interface XPExpressionTests : XCTestCase
@property (nonatomic, retain) XPExpression *expr;
@property (nonatomic, retain) PKTokenizer *t;
@end

@implementation XPExpressionTests

- (void)setUp {
    [super setUp];
    
    self.expr = nil;
}

- (void)tearDown {
    self.expr = nil;
    
    [super tearDown];
}

- (NSArray *)tokenize:(NSString *)input {
    PKTokenizer *t = [XPParser tokenizer];
    t.string = input;
    
    PKToken *tok = nil;
    PKToken *eof = [PKToken EOFToken];
    
    NSMutableArray *toks = [NSMutableArray array];
    
    while (eof != (tok = [t nextToken])) {
        [toks addObject:tok];
    }
    return toks;
}

- (void)test1 {
    NSString *input = @"1";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDTrue([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)test0 {
    NSString *input = @"0";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDFalse([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)testYES {
    NSString *input = @"YES";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDTrue([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)testNO {
    NSString *input = @"NO";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDFalse([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)testTrue {
    NSString *input = @"true";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDTrue([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)testFalse {
    NSString *input = @"false";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDFalse([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)testOpenTrueClose {
    NSString *input = @"(true)";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDTrue([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)testOpenFalseClose {
    NSString *input = @"(false)";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDFalse([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)testSQString {
    NSString *input = @"'hello'";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDTrue([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)testEmptySQString {
    NSString *input = @"''";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDFalse([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)test1Eq1 {
    NSString *input = @"1 eq 1";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDTrue([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)test1EqSign1 {
    NSString *input = @"1 = 1";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDTrue([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)test1EqEqSign1 {
    NSString *input = @"1 == 1";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDTrue([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)test1Eq2 {
    NSString *input = @"1 eq 2";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDFalse([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)test1EqSign2 {
    NSString *input = @"1 = 2";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDFalse([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)test1EqEqSign2 {
    NSString *input = @"1 == 2";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDFalse([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)test1Ne1 {
    NSString *input = @"1 ne 1";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDFalse([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)test1NeSign1 {
    NSString *input = @"1 != 1";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDFalse([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)test1Ne2 {
    NSString *input = @"1 ne 2";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDTrue([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)test1NeSign2 {
    NSString *input = @"1 != 2";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDTrue([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)test1Lt1 {
    NSString *input = @"1 < 1";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDFalse([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)test1LtEq1 {
    NSString *input = @"1 <= 1";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDTrue([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)test1Lt2 {
    NSString *input = @"1 < 2";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDTrue([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)test1LtEq2 {
    NSString *input = @"1 <= 2";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDTrue([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)test1Gt1 {
    NSString *input = @"1 > 1";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDFalse([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)test1GtEq1 {
    NSString *input = @"1 >= 1";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDTrue([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)test1Gt2 {
    NSString *input = @"1 > 2";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDFalse([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)test1GtEq2 {
    NSString *input = @"1 >= 2";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDFalse([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)test1And0 {
    NSString *input = @"1 and 0";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDFalse([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)test1AmpAmp0 {
    NSString *input = @"1 && 0";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDFalse([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)test0And1 {
    NSString *input = @"0 and 1";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDFalse([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)test1And1 {
    NSString *input = @"1 and 1";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDTrue([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)test1AmpAmp1 {
    NSString *input = @"1 && 1";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDTrue([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)test1Or0 {
    NSString *input = @"1 or 0";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDTrue([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)test1PipePipe0 {
    NSString *input = @"1 || 0";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDTrue([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)test0Or1 {
    NSString *input = @"0 or 1";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDTrue([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)test0PipePipe1 {
    NSString *input = @"0 || 1";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDTrue([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)test1Or1 {
    NSString *input = @"1 or 1";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDTrue([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)test1SpacePlusSpace2 {
    NSString *input = @"1 + 2";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDEquals(3.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)test1Plus2 {
    NSString *input = @"1+2";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDEquals(3.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)test1SpaceMinusSpace1 {
    NSString *input = @"1 - 1";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDEquals(0.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)testTruePlus1 {
    NSString *input = @"true + 1";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDEquals(2.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)testYesPlus1 {
    NSString *input = @"YES + 1";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDEquals(2.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)testFalsePlus1 {
    NSString *input = @"false + 1";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDEquals(1.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)testNoPlus1 {
    NSString *input = @"NO + 1";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDEquals(1.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)test2Times2 {
    NSString *input = @"2*2";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDEquals(4.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)test2Div2 {
    NSString *input = @"2/2";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDEquals(1.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)test3Plus2Times2 {
    NSString *input = @"3+2*2";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDEquals(7.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)testOpen3Plus2CloseTimes2 {
    NSString *input = @"(3+2)*2";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDEquals(10.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)testMinus1 {
    NSString *input = @"-1";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDEquals(-1.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)testMinusMinus1 {
    NSString *input = @"--1";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDEquals(1.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)test1PlusMinusMinus1 {
    NSString *input = @"1 + --1";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDEquals(2.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)test1MinusMinusMinus1 {
    NSString *input = @"1 - --1";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDEquals(0.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)testMinusMinus1Plus1 {
    NSString *input = @"--1 + 1";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDEquals(2.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)testMinusMinus1Minus1 {
    NSString *input = @"--1 - 1";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDEquals(0.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)testMinusMinusMinus1 {
    NSString *input = @"---1";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDEquals(-1.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)testMinusMinusMinusMinus4 {
    NSString *input = @"----4";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDEquals(4.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)testPathFooBar8 {
    NSString *input = @"foo.bar";
    NSArray *toks = [self tokenize:input];
    
    id vars = @{@"foo": @{@"bar": @(8)}};
    id ctx = [[[TDTemplateContext alloc] initWithVariables:vars] autorelease];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDEquals(8.0, [[expr simplify] evaluateAsNumberInContext:ctx]);
}

- (void)testPathFooBar8Plus2 {
    NSString *input = @"foo.bar+2";
    NSArray *toks = [self tokenize:input];
    
    id vars = @{@"foo": @{@"bar": @(8)}};
    id ctx = [[[TDTemplateContext alloc] initWithVariables:vars] autorelease];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDEquals(10.0, [[expr simplify] evaluateAsNumberInContext:ctx]);
}

@end
