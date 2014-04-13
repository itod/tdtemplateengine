//
//  XPFilterExpressionTests.m
//  TDTemplateEngineTests
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "XPBaseExpressionTests.h"

@interface XPFilterExpressionTests : XPBaseExpressionTests
@end

@implementation XPFilterExpressionTests

- (void)setUp {
    [super setUp];
    
}

- (void)tearDown {
    
    [super tearDown];
}

- (void)testFooVarCapitalized {
    NSString *input = @"foo|capitalize";
    NSArray *toks = [self tokenize:input];
    
    id vars = @{@"foo": @"bar"};
    id ctx = [[[TDTemplateContext alloc] initWithVariables:vars output:nil] autorelease];
    
    NSError *err = nil;
    XPExpression *expr = [self.eng expressionFromTokens:toks error:&err];
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
    XPExpression *expr = [self.eng expressionFromTokens:toks error:&err];
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
    XPExpression *expr = [self.eng expressionFromTokens:toks error:&err];
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
    XPExpression *expr = [self.eng expressionFromTokens:toks error:&err];
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
    XPExpression *expr = [self.eng expressionFromTokens:toks error:&err];
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
    XPExpression *expr = [self.eng expressionFromTokens:toks error:&err];
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
    XPExpression *expr = [self.eng expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDEqualObjects(@"MonteSereno", [expr evaluateAsStringInContext:ctx]);
}

- (void)testDateFormatToday {
    NSString *fmtStr = @"EEE, MMM d, yy";
    NSString *input = [NSString stringWithFormat:@"'today'|dateFormat:'%@'", fmtStr];
    NSArray *toks = [self tokenize:input];
    
    id vars = nil;
    id ctx = [[[TDTemplateContext alloc] initWithVariables:vars output:nil] autorelease];
    
    NSError *err = nil;
    XPExpression *expr = [self.eng expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    
    NSDate *now = [NSDate date];
    NSDateFormatter *fmt = [[[NSDateFormatter alloc] init] autorelease];
    [fmt setDateFormat:fmtStr];
    NSString *expected = [fmt stringFromDate:now];
    NSString *actual = [expr evaluateAsStringInContext:ctx];
    TDEqualObjects(expected, actual);
    TDTrue([actual length]);
    TDTrue([actual rangeOfString:@","].length);
}

- (void)testDateFormatNow {
    NSString *fmtStr = @"EEE, MMM d, yy";
    NSString *input = [NSString stringWithFormat:@"'now'|dateFormat:'%@'", fmtStr];
    NSArray *toks = [self tokenize:input];
    
    id vars = nil;
    id ctx = [[[TDTemplateContext alloc] initWithVariables:vars output:nil] autorelease];
    
    NSError *err = nil;
    XPExpression *expr = [self.eng expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    
    NSDate *now = [NSDate date];
    NSDateFormatter *fmt = [[[NSDateFormatter alloc] init] autorelease];
    [fmt setDateFormat:fmtStr];
    NSString *expected = [fmt stringFromDate:now];
    NSString *actual = [expr evaluateAsStringInContext:ctx];
    TDEqualObjects(expected, actual);
    TDTrue([actual length]);
    TDTrue([actual rangeOfString:@","].length);
}

- (void)testDateFormatOct26Literal {
    NSString *fmtStr = @"EEE, MMM d, yy";
    NSString *input = [NSString stringWithFormat:@"'Oct 26, 1977'|dateFormat:'%@'", fmtStr];
    NSArray *toks = [self tokenize:input];
    
    id vars = nil;
    id ctx = [[[TDTemplateContext alloc] initWithVariables:vars output:nil] autorelease];
    
    NSError *err = nil;
    XPExpression *expr = [self.eng expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    
    NSString *expected = @"Wed, Oct 26, 77";
    NSString *actual = [expr evaluateAsStringInContext:ctx];
    TDEqualObjects(expected, actual);
}

- (void)testDateFormatApril25Var {
    NSString *fmtStr = @"EEE, MMM d, yy";
    NSString *input = [NSString stringWithFormat:@"mydate|dateFormat:'%@'", fmtStr];
    NSArray *toks = [self tokenize:input];
    
    NSDate *date = [NSDate dateWithNaturalLanguageString:@"April 25 1996"];
    id vars = @{@"mydate": date};
    id ctx = [[[TDTemplateContext alloc] initWithVariables:vars output:nil] autorelease];
    
    NSError *err = nil;
    XPExpression *expr = [self.eng expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    
    NSString *expected = @"Thu, Apr 25, 96";
    NSString *actual = [expr evaluateAsStringInContext:ctx];
    TDEqualObjects(expected, actual);
}

- (void)testDateFormatApril25Var2 {
    NSString *fmtStr = @"yyyyy.MMMM.dd GGG hh:mm aaa";
    NSString *input = [NSString stringWithFormat:@"mydate|dateFormat:'%@'", fmtStr];
    NSArray *toks = [self tokenize:input];
    
    NSDate *date = [NSDate dateWithNaturalLanguageString:@"April 25 1996"];
    id vars = @{@"mydate": date};
    id ctx = [[[TDTemplateContext alloc] initWithVariables:vars output:nil] autorelease];
    
    NSError *err = nil;
    XPExpression *expr = [self.eng expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    
    NSString *expected = @"01996.April.25 AD 12:00 PM";
    NSString *actual = [expr evaluateAsStringInContext:ctx];
    TDEqualObjects(expected, actual);
}

@end
