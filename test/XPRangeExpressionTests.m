//
//  XPRangeExpressionTests.m
//  TDTemplateEngineTests
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDTestScaffold.h"
#import "XPLoopExpression.h"
#import "XPRangeExpression.h"
#import "XPPathExpression.h"
#import "XPParser.h"
#import <TDTemplateEngine/TDTemplateContext.h>

@interface XPRangeExpressionTests : XCTestCase
@property (nonatomic, retain) XPExpression *expr;
@property (nonatomic, retain) PKTokenizer *t;
@end

@implementation XPRangeExpressionTests

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

- (void)testIIn0To4 {
    NSString *input = @"i in 0 to 4";
    NSArray *toks = [self tokenize:input];
    
    id foo = @[@(0), @(1), @(2), @(3)];
    id vars = @{@"foo": foo};
    TDTemplateContext *ctx = [[[TDTemplateContext alloc] initWithVariables:vars output:nil] autorelease];
    
    NSError *err = nil;
    XPExpression *expr = [[XPExpression loopExpressionFromTokens:toks error:&err] simplify];
    TDNil(err);
    TDNotNil(expr);
    TDTrue([expr isKindOfClass:[XPLoopExpression class]]);
    
    for (id obj in foo) {
        id res = [expr evaluateInContext:ctx];
        TDEqualObjects(obj, res);
    }
}

- (void)testIIn5To2 {
    NSString *input = @"i in 5 to 2";
    NSArray *toks = [self tokenize:input];
    
    id foo = @[@(5), @(4), @(3), @(2)];
    id vars = @{@"foo": foo};
    TDTemplateContext *ctx = [[[TDTemplateContext alloc] initWithVariables:vars output:nil] autorelease];
    
    NSError *err = nil;
    XPExpression *expr = [[XPExpression loopExpressionFromTokens:toks error:&err] simplify];
    TDNil(err);
    TDNotNil(expr);
    TDTrue([expr isKindOfClass:[XPLoopExpression class]]);
    
    for (id obj in foo) {
        id res = [expr evaluateInContext:ctx];
        TDEqualObjects(obj, res);
    }
}

- (void)testIIn0To10By2 {
    NSString *input = @"i in 0 to 10 by 2";
    NSArray *toks = [self tokenize:input];
    
    id foo = @[@(0), @(2), @(4), @(6), @(8), @(10)];
    id vars = @{@"foo": foo};
    TDTemplateContext *ctx = [[[TDTemplateContext alloc] initWithVariables:vars output:nil] autorelease];
    
    NSError *err = nil;
    XPExpression *expr = [[XPExpression loopExpressionFromTokens:toks error:&err] simplify];
    TDNil(err);
    TDNotNil(expr);
    TDTrue([expr isKindOfClass:[XPLoopExpression class]]);
    
    for (id obj in foo) {
        id res = [expr evaluateInContext:ctx];
        TDEqualObjects(obj, res);
    }
}

- (void)testIIn10To0ByNeg2 {
    NSString *input = @"i in 10 to 0 by -2";
    NSArray *toks = [self tokenize:input];
    
    id foo = @[@(10), @(8), @(6), @(4), @(2), @(0)];
    id vars = @{@"foo": foo};
    TDTemplateContext *ctx = [[[TDTemplateContext alloc] initWithVariables:vars output:nil] autorelease];
    
    NSError *err = nil;
    XPExpression *expr = [[XPExpression loopExpressionFromTokens:toks error:&err] simplify];
    TDNil(err);
    TDNotNil(expr);
    TDTrue([expr isKindOfClass:[XPLoopExpression class]]);
    
    for (id obj in foo) {
        id res = [expr evaluateInContext:ctx];
        TDEqualObjects(obj, res);
    }
}

@end
