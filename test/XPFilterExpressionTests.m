//
//  XPFilterExpressionTests.m
//  TDTemplateEngineTests
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDTestScaffold.h"
#import "XPExpression.h"
#import "XPParser.h"
#import <TDTemplateEngine/TDTemplateContext.h>

@interface XPFilterExpressionTests : XCTestCase
@property (nonatomic, retain) XPExpression *expr;
@property (nonatomic, retain) PKTokenizer *t;
@end

@implementation XPFilterExpressionTests

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

- (void)testFooVarCapitalized {
    NSString *input = @"foo|capitalize";
    NSArray *toks = [self tokenize:input];
    
    id vars = @{@"foo": @"bar"};
    id ctx = [[[TDTemplateContext alloc] initWithVariables:vars output:nil] autorelease];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDEqualObjects(@"Bar", [expr evaluateAsStringInContext:ctx]);
}

- (void)testFooLiteralCapitalized {
    NSString *input = @"'foo'|capitalize";
    NSArray *toks = [self tokenize:input];
    
    id vars = nil;
    id ctx = [[[TDTemplateContext alloc] initWithVariables:vars output:nil] autorelease];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDEqualObjects(@"Foo", [expr evaluateAsStringInContext:ctx]);
}

- (void)testFooVarLowercase {
    NSString *input = @"foo|lowercase";
    NSArray *toks = [self tokenize:input];
    
    id vars = @{@"foo": @"BAR"};
    id ctx = [[[TDTemplateContext alloc] initWithVariables:vars output:nil] autorelease];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDEqualObjects(@"bar", [expr evaluateAsStringInContext:ctx]);
}

- (void)testFooLiteralLowercase {
    NSString *input = @"'fOO'|lowercase";
    NSArray *toks = [self tokenize:input];
    
    id vars = nil;
    id ctx = [[[TDTemplateContext alloc] initWithVariables:vars output:nil] autorelease];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDEqualObjects(@"foo", [expr evaluateAsStringInContext:ctx]);
}

- (void)testFooVarUppercase {
    NSString *input = @"foo|uppercase";
    NSArray *toks = [self tokenize:input];
    
    id vars = @{@"foo": @"bAr"};
    id ctx = [[[TDTemplateContext alloc] initWithVariables:vars output:nil] autorelease];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDEqualObjects(@"BAR", [expr evaluateAsStringInContext:ctx]);
}

- (void)testFooLiteralUppercase {
    NSString *input = @"'fOO'|uppercase";
    NSArray *toks = [self tokenize:input];
    
    id vars = nil;
    id ctx = [[[TDTemplateContext alloc] initWithVariables:vars output:nil] autorelease];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDEqualObjects(@"FOO", [expr evaluateAsStringInContext:ctx]);
}

- (void)testmonteSerenoLiteralUppercase {
    NSString *input = @"'monteSereno'|capitalize";
    NSArray *toks = [self tokenize:input];
    
    id vars = nil;
    id ctx = [[[TDTemplateContext alloc] initWithVariables:vars output:nil] autorelease];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDEqualObjects(@"MonteSereno", [expr evaluateAsStringInContext:ctx]);
}

@end
