//
//  TDUnaryExpressionTests.m
//  TDTemplateEngineTests
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDBaseExpressionTests.h"

@interface TDUnaryExpressionTests : TDBaseExpressionTests
@property (nonatomic, retain) NSOutputStream *output;
@end

@implementation TDUnaryExpressionTests

- (void)setUp {
    [super setUp];
    
    self.output = [NSOutputStream outputStreamToMemory];
}

- (void)tearDown {
    self.output = nil;
    
    [super tearDown];
}

- (NSString *)outputString {
    NSString *str = [[[NSString alloc] initWithData:[_output propertyForKey:NSStreamDataWrittenToMemoryStreamKey] encoding:NSUTF8StringEncoding] autorelease];
    return str;
}

- (void)testNeg1 {
    NSString *input = @"-1";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    TDExpression *expr = [self.eng expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDEquals(-1, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)testNegNeg1 {
    NSString *input = @"--1";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    TDExpression *expr = [self.eng expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDEquals(1, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)testNegNegNeg1 {
    NSString *input = @"---1";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    TDExpression *expr = [self.eng expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDEquals(-1, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)testNegNegNegNeg1 {
    NSString *input = @"----1";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    TDExpression *expr = [self.eng expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDEquals(1, [[expr simplify] evaluateAsNumberInContext:nil]);
}


- (void)testNegVar {
    NSString *input = @"{{-foo}}";
    id vars = @{@"foo": @1};
    
    NSError *err = nil;
    BOOL success = [self.eng processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"-1", res);
}

- (void)testNegNegVar {
    NSString *input = @"{{--foo}}";
    id vars = @{@"foo": @1};
    
    NSError *err = nil;
    BOOL success = [self.eng processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"1", res);
}

- (void)testNegNegNegVar {
    NSString *input = @"{{---foo}}";
    id vars = @{@"foo": @1};
    
    NSError *err = nil;
    BOOL success = [self.eng processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"-1", res);
}

- (void)testNegNegNegNegVar {
    NSString *input = @"{{----foo}}";
    id vars = @{@"foo": @1};
    
    NSError *err = nil;
    BOOL success = [self.eng processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"1", res);
}

@end
