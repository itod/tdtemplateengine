//
//  CPPFilterExpressionTests.m
//  TDTemplateEngineTests
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDBaseExpressionTests.h"
#import <ParseKitCPP/Reader.hpp>

using namespace parsekit;

@interface CPPFilterExpressionTests : TDBaseExpressionTests
@end

@implementation CPPFilterExpressionTests

- (void)setUp {
    [super setUp];
    
}

- (void)tearDown {
    
    [super tearDown];
}

- (void)testFooVarTrim {
    std::string input = "foo|trim";
    Reader reader(input);
    
    id vars = @{@"foo": @"\n  bar   "};
    id ctx = [[[TDTemplateContext alloc] initWithVariables:vars output:nil] autorelease];
    
    NSError *err = nil;
    TDExpression *expr = [self.eng expressionFromReader:&reader error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDEqualObjects(@"bar", [expr evaluateAsStringInContext:ctx]);
}

//- (void)testReplaceLiteral {
//    std::string input = "'Hello World!'|replace:'hello', farewell, 'i'";
//    Reader reader(input);
//    
//    id vars = @{@"farewell": @"Goodbye, Cruel"};
//    id ctx = [[[TDTemplateContext alloc] initWithVariables:vars output:nil] autorelease];
//    
//    NSError *err = nil;
//    TDExpression *expr = [self.eng expressionFromReader:&reader error:&err];
//    TDNil(err);
//    TDNotNil(expr);
//    
//    NSString *res = [expr evaluateAsStringInContext:ctx];
//    TDEqualObjects(@"Goodbye, Cruel World!", res);
//}

- (void)testFooVarTrimUppercase {
    std::string input = "foo|trim|uppercase";
    Reader reader(input);
    
    id vars = @{@"foo": @"  \nbar   "};
    id ctx = [[[TDTemplateContext alloc] initWithVariables:vars output:nil] autorelease];
    
    NSError *err = nil;
    TDExpression *expr = [self.eng expressionFromReader:&reader error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDEqualObjects(@"BAR", [expr evaluateAsStringInContext:ctx]);
}

//- (void)testFooVarReplace {
//    std::string input = "foo|replace:'r', 'z'";
//    Reader reader(input);
//    
//    id vars = @{@"foo": @"bar"};
//    id ctx = [[[TDTemplateContext alloc] initWithVariables:vars output:nil] autorelease];
//    
//    NSError *err = nil;
//    TDExpression *expr = [self.eng expressionFromReader:&reader error:&err];
//    TDNil(err);
//    TDNotNil(expr);
//    TDEqualObjects(@"baz", [expr evaluateAsStringInContext:ctx]);
//}
//
//- (void)testFooVarReplaceNotCaseInsensitive {
//    std::string input = "foo|replace:'R', 'z'";
//    Reader reader(input);
//    
//    id vars = @{@"foo": @"bar"};
//    id ctx = [[[TDTemplateContext alloc] initWithVariables:vars output:nil] autorelease];
//    
//    NSError *err = nil;
//    TDExpression *expr = [self.eng expressionFromReader:&reader error:&err];
//    TDNil(err);
//    TDNotNil(expr);
//    TDEqualObjects(@"bar", [expr evaluateAsStringInContext:ctx]);
//}
//
//- (void)testFooVarReplaceCaseInsensitive {
//    std::string input = "foo|replace:'R', 'z', 'i'";
//    Reader reader(input);
//    
//    id vars = @{@"foo": @"bar"};
//    id ctx = [[[TDTemplateContext alloc] initWithVariables:vars output:nil] autorelease];
//    
//    NSError *err = nil;
//    TDExpression *expr = [self.eng expressionFromReader:&reader error:&err];
//    TDNil(err);
//    TDNotNil(expr);
//    TDEqualObjects(@"baz", [expr evaluateAsStringInContext:ctx]);
//}
//
- (void)testFooVarCapitalized {
    std::string input = "foo|capitalize";
    Reader reader(input);
    
    id vars = @{@"foo": @"bar"};
    id ctx = [[[TDTemplateContext alloc] initWithVariables:vars output:nil] autorelease];
    
    NSError *err = nil;
    TDExpression *expr = [self.eng expressionFromReader:&reader error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDEqualObjects(@"Bar", [expr evaluateAsStringInContext:ctx]);
}

- (void)testFooLiteralCapitalized {
    std::string input = "'foo'|capitalize";
    Reader reader(input);
    
    id vars = nil;
    id ctx = [[[TDTemplateContext alloc] initWithVariables:vars output:nil] autorelease];
    
    NSError *err = nil;
    TDExpression *expr = [self.eng expressionFromReader:&reader error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDEqualObjects(@"Foo", [expr evaluateAsStringInContext:ctx]);
}

- (void)testFooVarLowercase {
    std::string input = "foo|lowercase";
    Reader reader(input);
    
    id vars = @{@"foo": @"BAR"};
    id ctx = [[[TDTemplateContext alloc] initWithVariables:vars output:nil] autorelease];
    
    NSError *err = nil;
    TDExpression *expr = [self.eng expressionFromReader:&reader error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDEqualObjects(@"bar", [expr evaluateAsStringInContext:ctx]);
}

- (void)testFooLiteralLowercase {
    std::string input = "'fOO'|lowercase";
    Reader reader(input);
    
    id vars = nil;
    id ctx = [[[TDTemplateContext alloc] initWithVariables:vars output:nil] autorelease];
    
    NSError *err = nil;
    TDExpression *expr = [self.eng expressionFromReader:&reader error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDEqualObjects(@"foo", [expr evaluateAsStringInContext:ctx]);
}

- (void)testFooVarUppercase {
    std::string input = "foo|uppercase";
    Reader reader(input);
    
    id vars = @{@"foo": @"bAr"};
    id ctx = [[[TDTemplateContext alloc] initWithVariables:vars output:nil] autorelease];
    
    NSError *err = nil;
    TDExpression *expr = [self.eng expressionFromReader:&reader error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDEqualObjects(@"BAR", [expr evaluateAsStringInContext:ctx]);
}

- (void)testFooLiteralUppercase {
    std::string input = "'fOO'|uppercase";
    Reader reader(input);
    
    id vars = nil;
    id ctx = [[[TDTemplateContext alloc] initWithVariables:vars output:nil] autorelease];
    
    NSError *err = nil;
    TDExpression *expr = [self.eng expressionFromReader:&reader error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDEqualObjects(@"FOO", [expr evaluateAsStringInContext:ctx]);
}

- (void)testmonteSerenoLiteralUppercase {
    std::string input = "'monteSereno'|capitalize";
    Reader reader(input);
    
    id vars = nil;
    id ctx = [[[TDTemplateContext alloc] initWithVariables:vars output:nil] autorelease];
    
    NSError *err = nil;
    TDExpression *expr = [self.eng expressionFromReader:&reader error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDEqualObjects(@"MonteSereno", [expr evaluateAsStringInContext:ctx]);
}

//- (void)testDateFormatToday {
//    NSString *fmtStr = @"EEE, MMM d, yy";
//    NSString *input = [NSString stringWithFormat:@"'today'|fmtDate:'%@'", fmtStr];
//    Reader reader([input UTF8String]);
//    
//    id vars = nil;
//    id ctx = [[[TDTemplateContext alloc] initWithVariables:vars output:nil] autorelease];
//    
//    NSError *err = nil;
//    TDExpression *expr = [self.eng expressionFromReader:&reader error:&err];
//    TDNil(err);
//    TDNotNil(expr);
//    
//    NSDate *now = [NSDate date];
//    NSDateFormatter *fmt = [[[NSDateFormatter alloc] init] autorelease];
//    [fmt setDateFormat:fmtStr];
//    NSString *expected = [fmt stringFromDate:now];
//    NSString *actual = [expr evaluateAsStringInContext:ctx];
//    TDEqualObjects(expected, actual);
//    TDTrue([actual length]);
//    TDTrue([actual rangeOfString:@","].length);
//}
//
//- (void)testDateFormatNow {
//    NSString *fmtStr = @"EEE, MMM d, yy";
//    NSString *input = [NSString stringWithFormat:@"'now'|fmtDate:'%@'", fmtStr];
//    Reader reader([input UTF8String]);
//
//    id vars = nil;
//    id ctx = [[[TDTemplateContext alloc] initWithVariables:vars output:nil] autorelease];
//    
//    NSError *err = nil;
//    TDExpression *expr = [self.eng expressionFromReader:&reader error:&err];
//    TDNil(err);
//    TDNotNil(expr);
//    
//    NSDate *now = [NSDate date];
//    NSDateFormatter *fmt = [[[NSDateFormatter alloc] init] autorelease];
//    [fmt setDateFormat:fmtStr];
//    NSString *expected = [fmt stringFromDate:now];
//    NSString *actual = [expr evaluateAsStringInContext:ctx];
//    TDEqualObjects(expected, actual);
//    TDTrue([actual length]);
//    TDTrue([actual rangeOfString:@","].length);
//}
//
//- (void)testDateFormatOct26Literal {
//    NSString *fmtStr = @"EEE, MMM d, yy";
//    NSString *input = [NSString stringWithFormat:@"'Oct 26, 1977'|fmtDate:'%@'", fmtStr];
//    Reader reader([input UTF8String]);
//
//    id vars = nil;
//    id ctx = [[[TDTemplateContext alloc] initWithVariables:vars output:nil] autorelease];
//    
//    NSError *err = nil;
//    TDExpression *expr = [self.eng expressionFromReader:&reader error:&err];
//    TDNil(err);
//    TDNotNil(expr);
//    
//    NSString *expected = @"Wed, Oct 26, 77";
//    NSString *actual = [expr evaluateAsStringInContext:ctx];
//    TDEqualObjects(expected, actual);
//}
//
//
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Wdeprecated"
//
//- (void)testDateFormatApril25Var {
//    NSString *fmtStr = @"EEE, MMM d, yy";
//    NSString *input = [NSString stringWithFormat:@"mydate|fmtDate:'%@'", fmtStr];
//    Reader reader([input UTF8String]);
//
//    NSDate *date = [NSDate dateWithNaturalLanguageString:@"April 25 1996"];
//    id vars = @{@"mydate": date};
//    id ctx = [[[TDTemplateContext alloc] initWithVariables:vars output:nil] autorelease];
//    
//    NSError *err = nil;
//    TDExpression *expr = [self.eng expressionFromReader:&reader error:&err];
//    TDNil(err);
//    TDNotNil(expr);
//    
//    NSString *expected = @"Thu, Apr 25, 96";
//    NSString *actual = [expr evaluateAsStringInContext:ctx];
//    TDEqualObjects(expected, actual);
//}
//
//- (void)testDateFormatApril25Var2 {
//    NSString *fmtStr = @"yyyyy.MMMM.dd GGG hh:mm aaa";
//    NSString *input = [NSString stringWithFormat:@"mydate|fmtDate:'%@'", fmtStr];
//    Reader reader([input UTF8String]);
//
//    NSDate *date = [NSDate dateWithNaturalLanguageString:@"April 25 1996"];
//    id vars = @{@"mydate": date};
//    id ctx = [[[TDTemplateContext alloc] initWithVariables:vars output:nil] autorelease];
//    
//    NSError *err = nil;
//    TDExpression *expr = [self.eng expressionFromReader:&reader error:&err];
//    TDNil(err);
//    TDNotNil(expr);
//    
////    NSString *expected = @"01996.April.25 AD 12:00 PM";
//    NSString *expected = @"01996.April.25 AD 12:00";
//    NSString *actual = [expr evaluateAsStringInContext:ctx];
//    TDEqualObjects(expected, actual);
//}
//
//- (void)testDateFormatApril25Arg {
//    NSString *fmtStr = @"EEE, MMM d, yy";
//    std::string input = "mydate|fmtDate:fmt";
//    Reader reader(input);
//    
//    NSDate *date = [NSDate dateWithNaturalLanguageString:@"April 25 1996"];
//    id vars = @{@"mydate": date, @"fmt": fmtStr};
//    id ctx = [[[TDTemplateContext alloc] initWithVariables:vars output:nil] autorelease];
//    
//    NSError *err = nil;
//    TDExpression *expr = [self.eng expressionFromReader:&reader error:&err];
//    TDNil(err);
//    TDNotNil(expr);
//    
//    NSString *expected = @"Thu, Apr 25, 96";
//    NSString *actual = [expr evaluateAsStringInContext:ctx];
//    TDEqualObjects(expected, actual);
//}

#pragma clang diagnostic pop

@end
