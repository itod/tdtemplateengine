//
//  TDRelationalExpressionTests.m
//  TDTemplateEngineTests
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDBaseExpressionTests.h"

@interface TDRelationalExpressionTests : TDBaseExpressionTests

@end

@implementation TDRelationalExpressionTests

- (void)setUp {
    [super setUp];
    
}

- (void)tearDown {
    
    [super tearDown];
}

- (void)test1Lt1 {
    NSString *input = @"1 < 1";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    TDExpression *expr = [self.eng expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDFalse([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)test1LtEq1 {
    NSString *input = @"1 <= 1";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    TDExpression *expr = [self.eng expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDTrue([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)test1Lt2 {
    NSString *input = @"1 < 2";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    TDExpression *expr = [self.eng expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDTrue([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)test1LtEq2 {
    NSString *input = @"1 <= 2";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    TDExpression *expr = [self.eng expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDTrue([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)test1Gt1 {
    NSString *input = @"1 > 1";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    TDExpression *expr = [self.eng expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDFalse([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)test1GtEq1 {
    NSString *input = @"1 >= 1";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    TDExpression *expr = [self.eng expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDTrue([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)test1Gt2 {
    NSString *input = @"1 > 2";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    TDExpression *expr = [self.eng expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDFalse([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)test1GtEq2 {
    NSString *input = @"1 >= 2";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    TDExpression *expr = [self.eng expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDFalse([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)testNeg0Lt0 {
    NSString *input = @"-0 < 0";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    TDExpression *expr = [self.eng expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDFalse([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)testNeg0Gt0 {
    NSString *input = @"-0.0 > 0.0";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    TDExpression *expr = [self.eng expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDFalse([[expr simplify] evaluateAsBooleanInContext:nil]);
}

@end
