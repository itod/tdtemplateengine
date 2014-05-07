//
//  TDPathExpressionTests.m
//  TDTemplateEngineTests
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDBaseExpressionTests.h"

@interface TDPathExpressionTests : TDBaseExpressionTests
@end

@implementation TDPathExpressionTests

- (void)setUp {
    [super setUp];
    
}

- (void)tearDown {
    
    [super tearDown];
}

- (void)testPathFooBar8 {
    NSString *input = @"foo.bar";
    NSArray *toks = [self tokenize:input];
    
    id vars = @{@"foo": @{@"bar": @(8)}};
    id ctx = [[[TDTemplateContext alloc] initWithVariables:vars output:nil] autorelease];
    
    NSError *err = nil;
    TDExpression *expr = [self.eng expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDEquals(8.0, [[expr simplify] evaluateAsNumberInContext:ctx]);
}

@end
