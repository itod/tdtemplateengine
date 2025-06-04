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
    ReaderCPP reader(input);
    
    id vars = @{@"foo": @"\n  bar   "};
    id ctx = [[[TDTemplateContext alloc] initWithVariables:vars output:nil] autorelease];
    
    NSError *err = nil;
    TDExpression *expr = [self.engine expressionFromReader:&reader error:&err];
    XCTAssertNil(err);
    XCTAssertNotNil(expr);
    XCTAssertEqualObjects(@"bar", [expr evaluateAsStringInContext:ctx]);
}

- (void)testReplaceLiteral {
    std::string input = "'Hello World!'|replace:'hello', farewell, 'i'";
    ReaderCPP reader(input);
    
    id vars = @{@"farewell": @"Goodbye, Cruel"};
    id ctx = [[[TDTemplateContext alloc] initWithVariables:vars output:nil] autorelease];
    
    NSError *err = nil;
    TDExpression *expr = [self.engine expressionFromReader:&reader error:&err];
    XCTAssertNil(err);
    XCTAssertNotNil(expr);
    
    NSString *res = [expr evaluateAsStringInContext:ctx];
    XCTAssertEqualObjects(@"Goodbye, Cruel World!", res);
}

- (void)testFooVarTrimUppercase {
    std::string input = "foo|trim|upper";
    ReaderCPP reader(input);
    
    id vars = @{@"foo": @"  \nbar   "};
    id ctx = [[[TDTemplateContext alloc] initWithVariables:vars output:nil] autorelease];
    
    NSError *err = nil;
    TDExpression *expr = [self.engine expressionFromReader:&reader error:&err];
    XCTAssertNil(err);
    XCTAssertNotNil(expr);
    XCTAssertEqualObjects(@"BAR", [expr evaluateAsStringInContext:ctx]);
}

- (void)testFooVarReplace {
    std::string input = "foo|replace:'r', 'z'";
    ReaderCPP reader(input);
    
    id vars = @{@"foo": @"bar"};
    id ctx = [[[TDTemplateContext alloc] initWithVariables:vars output:nil] autorelease];
    
    NSError *err = nil;
    TDExpression *expr = [self.engine expressionFromReader:&reader error:&err];
    XCTAssertNil(err);
    XCTAssertNotNil(expr);
    XCTAssertEqualObjects(@"baz", [expr evaluateAsStringInContext:ctx]);
}

- (void)testFooVarReplaceNotCaseInsensitive {
    std::string input = "foo|replace:'R', 'z'";
    ReaderCPP reader(input);
    
    id vars = @{@"foo": @"bar"};
    id ctx = [[[TDTemplateContext alloc] initWithVariables:vars output:nil] autorelease];
    
    NSError *err = nil;
    TDExpression *expr = [self.engine expressionFromReader:&reader error:&err];
    XCTAssertNil(err);
    XCTAssertNotNil(expr);
    XCTAssertEqualObjects(@"bar", [expr evaluateAsStringInContext:ctx]);
}

- (void)testFooVarReplaceCaseInsensitive {
    std::string input = "foo|replace:'R', 'z', 'i'";
    ReaderCPP reader(input);
    
    id vars = @{@"foo": @"bar"};
    id ctx = [[[TDTemplateContext alloc] initWithVariables:vars output:nil] autorelease];
    
    NSError *err = nil;
    TDExpression *expr = [self.engine expressionFromReader:&reader error:&err];
    XCTAssertNil(err);
    XCTAssertNotNil(expr);
    XCTAssertEqualObjects(@"baz", [expr evaluateAsStringInContext:ctx]);
}

- (void)testFooVarCapitalized {
    std::string input = "foo|title";
    ReaderCPP reader(input);
    
    id vars = @{@"foo": @"bar"};
    id ctx = [[[TDTemplateContext alloc] initWithVariables:vars output:nil] autorelease];
    
    NSError *err = nil;
    TDExpression *expr = [self.engine expressionFromReader:&reader error:&err];
    XCTAssertNil(err);
    XCTAssertNotNil(expr);
    XCTAssertEqualObjects(@"Bar", [expr evaluateAsStringInContext:ctx]);
}

- (void)testFooLiteralCapitalized {
    std::string input = "'foo'|title";
    ReaderCPP reader(input);
    
    id vars = nil;
    id ctx = [[[TDTemplateContext alloc] initWithVariables:vars output:nil] autorelease];
    
    NSError *err = nil;
    TDExpression *expr = [self.engine expressionFromReader:&reader error:&err];
    XCTAssertNil(err);
    XCTAssertNotNil(expr);
    XCTAssertEqualObjects(@"Foo", [expr evaluateAsStringInContext:ctx]);
}

- (void)testFooVarLowercase {
    std::string input = "foo|lower";
    ReaderCPP reader(input);
    
    id vars = @{@"foo": @"BAR"};
    id ctx = [[[TDTemplateContext alloc] initWithVariables:vars output:nil] autorelease];
    
    NSError *err = nil;
    TDExpression *expr = [self.engine expressionFromReader:&reader error:&err];
    XCTAssertNil(err);
    XCTAssertNotNil(expr);
    XCTAssertEqualObjects(@"bar", [expr evaluateAsStringInContext:ctx]);
}

- (void)testFooLiteralLowercase {
    std::string input = "'fOO'|lower";
    ReaderCPP reader(input);
    
    id vars = nil;
    id ctx = [[[TDTemplateContext alloc] initWithVariables:vars output:nil] autorelease];
    
    NSError *err = nil;
    TDExpression *expr = [self.engine expressionFromReader:&reader error:&err];
    XCTAssertNil(err);
    XCTAssertNotNil(expr);
    XCTAssertEqualObjects(@"foo", [expr evaluateAsStringInContext:ctx]);
}

- (void)testFooVarUppercase {
    std::string input = "foo|upper";
    ReaderCPP reader(input);
    
    id vars = @{@"foo": @"bAr"};
    id ctx = [[[TDTemplateContext alloc] initWithVariables:vars output:nil] autorelease];
    
    NSError *err = nil;
    TDExpression *expr = [self.engine expressionFromReader:&reader error:&err];
    XCTAssertNil(err);
    XCTAssertNotNil(expr);
    XCTAssertEqualObjects(@"BAR", [expr evaluateAsStringInContext:ctx]);
}

- (void)testFooLiteralUppercase {
    std::string input = "'fOO'|upper";
    ReaderCPP reader(input);
    
    id vars = nil;
    id ctx = [[[TDTemplateContext alloc] initWithVariables:vars output:nil] autorelease];
    
    NSError *err = nil;
    TDExpression *expr = [self.engine expressionFromReader:&reader error:&err];
    XCTAssertNil(err);
    XCTAssertNotNil(expr);
    XCTAssertEqualObjects(@"FOO", [expr evaluateAsStringInContext:ctx]);
}

- (void)testmonteSerenoLiteralUppercase {
    std::string input = "'monteSereno'|title";
    ReaderCPP reader(input);
    
    id vars = nil;
    id ctx = [[[TDTemplateContext alloc] initWithVariables:vars output:nil] autorelease];
    
    NSError *err = nil;
    TDExpression *expr = [self.engine expressionFromReader:&reader error:&err];
    XCTAssertNil(err);
    XCTAssertNotNil(expr);
    XCTAssertEqualObjects(@"MonteSereno", [expr evaluateAsStringInContext:ctx]);
}

- (void)testDateFormatToday {
    NSString *fmtStr = @"EEE, MMM d, yy";
    NSString *input = [NSString stringWithFormat:@"'today'|date:'%@'", fmtStr];
    ReaderObjC reader(input);
    
    id vars = nil;
    id ctx = [[[TDTemplateContext alloc] initWithVariables:vars output:nil] autorelease];
    
    NSError *err = nil;
    TDExpression *expr = [self.engine expressionFromReader:&reader error:&err];
    XCTAssertNil(err);
    XCTAssertNotNil(expr);
    
    NSDate *now = [NSDate date];
    NSDateFormatter *fmt = [[[NSDateFormatter alloc] init] autorelease];
    [fmt setDateFormat:fmtStr];
    NSString *expected = [fmt stringFromDate:now];
    NSString *actual = [expr evaluateAsStringInContext:ctx];
    XCTAssertEqualObjects(expected, actual);
    XCTAssertTrue([actual length]);
    XCTAssertTrue([actual rangeOfString:@","].length);
}

- (void)testDateFormatNow {
    NSString *fmtStr = @"EEE, MMM d, yy";
    NSString *input = [NSString stringWithFormat:@"'now'|date:'%@'", fmtStr];
    ReaderObjC reader(input);

    id vars = nil;
    id ctx = [[[TDTemplateContext alloc] initWithVariables:vars output:nil] autorelease];
    
    NSError *err = nil;
    TDExpression *expr = [self.engine expressionFromReader:&reader error:&err];
    XCTAssertNil(err);
    XCTAssertNotNil(expr);
    
    NSDate *now = [NSDate date];
    NSDateFormatter *fmt = [[[NSDateFormatter alloc] init] autorelease];
    [fmt setDateFormat:fmtStr];
    NSString *expected = [fmt stringFromDate:now];
    NSString *actual = [expr evaluateAsStringInContext:ctx];
    XCTAssertEqualObjects(expected, actual);
    XCTAssertTrue([actual length]);
    XCTAssertTrue([actual rangeOfString:@","].length);
}

- (void)testDateFormatOct26Literal {
    NSString *fmtStr = @"EEE, MMM d, yy";
    NSString *input = [NSString stringWithFormat:@"'Oct 26, 1977'|date:'%@'", fmtStr];
    ReaderObjC reader(input);

    id vars = nil;
    id ctx = [[[TDTemplateContext alloc] initWithVariables:vars output:nil] autorelease];
    
    NSError *err = nil;
    TDExpression *expr = [self.engine expressionFromReader:&reader error:&err];
    XCTAssertNil(err);
    XCTAssertNotNil(expr);
    
    NSString *expected = @"Wed, Oct 26, 77";
    NSString *actual = [expr evaluateAsStringInContext:ctx];
    XCTAssertEqualObjects(expected, actual);
}


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"

- (void)testDateFormatApril25Var {
    NSString *fmtStr = @"EEE, MMM d, yy";
    NSString *input = [NSString stringWithFormat:@"mydate|date:'%@'", fmtStr];
    ReaderObjC reader(input);

    NSDate *date = [NSDate dateWithNaturalLanguageString:@"April 25 1996"];
    id vars = @{@"mydate": date};
    id ctx = [[[TDTemplateContext alloc] initWithVariables:vars output:nil] autorelease];
    
    NSError *err = nil;
    TDExpression *expr = [self.engine expressionFromReader:&reader error:&err];
    XCTAssertNil(err);
    XCTAssertNotNil(expr);
    
    NSString *expected = @"Thu, Apr 25, 96";
    NSString *actual = [expr evaluateAsStringInContext:ctx];
    XCTAssertEqualObjects(expected, actual);
}

- (void)testDateFormatApril25Var2 {
    NSString *fmtStr = @"yyyyy.MMMM.dd GGG hh:mm aaa";
    NSString *input = [NSString stringWithFormat:@"mydate|date:'%@'", fmtStr];
    ReaderObjC reader(input);

    NSDate *date = [NSDate dateWithNaturalLanguageString:@"April 25 1996"];
    id vars = @{@"mydate": date};
    id ctx = [[[TDTemplateContext alloc] initWithVariables:vars output:nil] autorelease];
    
    NSError *err = nil;
    TDExpression *expr = [self.engine expressionFromReader:&reader error:&err];
    XCTAssertNil(err);
    XCTAssertNotNil(expr);
    
//    NSString *expected = @"01996.April.25 AD 12:00 PM";
    NSString *expected = @"01996.April.25 AD 12:00";
    NSString *actual = [expr evaluateAsStringInContext:ctx];
    XCTAssertEqualObjects(expected, actual);
}

- (void)testDateFormatApril25Arg {
    NSString *fmtStr = @"EEE, MMM d, yy";
    std::string input = "mydate|date:fmt";
    ReaderCPP reader(input);
    
    NSDate *date = [NSDate dateWithNaturalLanguageString:@"April 25 1996"];
    id vars = @{@"mydate": date, @"fmt": fmtStr};
    id ctx = [[[TDTemplateContext alloc] initWithVariables:vars output:nil] autorelease];
    
    NSError *err = nil;
    TDExpression *expr = [self.engine expressionFromReader:&reader error:&err];
    XCTAssertNil(err);
    XCTAssertNotNil(expr);
    
    NSString *expected = @"Thu, Apr 25, 96";
    NSString *actual = [expr evaluateAsStringInContext:ctx];
    XCTAssertEqualObjects(expected, actual);
}

#pragma clang diagnostic pop

@end
