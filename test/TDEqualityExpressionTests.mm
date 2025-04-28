//
//  TDEqualityExpressionTests.m
//  TDTemplateEngineTests
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDBaseExpressionTests.h"

@interface TDEqualityExpressionTests : TDBaseExpressionTests
@end

@implementation TDEqualityExpressionTests

- (void)setUp {
    [super setUp];

}

- (void)tearDown {
    
    [super tearDown];
}

- (void)test1Eq1 {
    NSString *input = @"1 eq 1";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    TDExpression *expr = [self.eng expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDTrue([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)test0EqSignNeg0 {
    NSString *input = @"0 = -0";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    TDExpression *expr = [self.eng expressionFromTokens:toks error:&err];
    TDNotNil(err);
    TDNil(expr);
}

- (void)test0EqEqSignNeg0 {
    NSString *input = @"0 == -0";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    TDExpression *expr = [self.eng expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDTrue([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)testNeg0EqEqSign0 {
    NSString *input = @"-0 == 0";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    TDExpression *expr = [self.eng expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDTrue([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)testNeg0EqEqSignNeg0 {
    NSString *input = @"-0==-0";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    TDExpression *expr = [self.eng expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDTrue([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)test1EqSign1 {
    NSString *input = @"1 = 1";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    TDExpression *expr = [self.eng expressionFromTokens:toks error:&err];
    TDNotNil(err);
    TDNil(expr);
}

- (void)test1EqEqSign1 {
    NSString *input = @"1 == 1";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    TDExpression *expr = [self.eng expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDTrue([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)test1Eq2 {
    NSString *input = @"1 eq 2";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    TDExpression *expr = [self.eng expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDFalse([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)test1EqSign2 {
    NSString *input = @"1 = 2";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    TDExpression *expr = [self.eng expressionFromTokens:toks error:&err];
    TDNotNil(err);
    TDNil(expr);
}

- (void)test1EqEqSign2 {
    NSString *input = @"1 == 2";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    TDExpression *expr = [self.eng expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDFalse([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)test1Ne1 {
    NSString *input = @"1 ne 1";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    TDExpression *expr = [self.eng expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDFalse([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)test1NeSign1 {
    NSString *input = @"1 != 1";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    TDExpression *expr = [self.eng expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDFalse([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)test1Ne2 {
    NSString *input = @"1 ne 2";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    TDExpression *expr = [self.eng expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDTrue([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)test1NeSign2 {
    NSString *input = @"1 != 2";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    TDExpression *expr = [self.eng expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDTrue([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)test0EqNeg0 {
    NSString *input = @"0 == -0";
    NSArray *toks = [self tokenize:input];
    
    TDEquals(0, -0);
    
    NSError *err = nil;
    TDExpression *expr = [self.eng expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDTrue([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)test0NeNeg0 {
    NSString *input = @"0 != -0";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    TDExpression *expr = [self.eng expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDFalse([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)test00EqNeg00 {
    NSString *input = @"0.0 == -0.0";
    NSArray *toks = [self tokenize:input];
    
    TDEquals(0.0, -0.0);
    
    NSError *err = nil;
    TDExpression *expr = [self.eng expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDTrue([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)test00NeNeg00 {
    NSString *input = @"0.0 != -0.0";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    TDExpression *expr = [self.eng expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDFalse([[expr simplify] evaluateAsBooleanInContext:nil]);
}

@end
