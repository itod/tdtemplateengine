//
//  TDPrintNodeTests.m
//  TDTemplateEngineTests
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDBaseTestCase.h"

@interface TDPrintNodeTests : TDBaseTestCase

@end

@implementation TDPrintNodeTests

- (void)testAsciiPassthru {
    NSString *input = @"foo";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@"foo", res);
}

- (void)testNonLatin1Passthru {
    NSString *input = @"…";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@"…", res);
}

- (void)testSimpleVarReplacementFoo {
    NSString *input = @"{{foo}}";
    id vars = @{@"foo": @"bar"};
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@"bar", res);
}

- (void)testSimpleVarReplacementFooCapitalize {
    NSString *input = @"{{foo|title}}";
    id vars = @{@"foo": @"bar"};
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@"Bar", res);
}

- (void)testSimpleVarReplacementFooLowercase {
    NSString *input = @"{{foo|lower}}";
    id vars = @{@"foo": @"BAR"};
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@"bar", res);
}

- (void)testSimpleVarReplacementFooUppercase {
    NSString *input = @"{{foo | upper}}";
    id vars = @{@"foo": @"bar"};
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@"BAR", res);
}

- (void)testSimpleVarReplacementBar {
    NSString *input = @"{{bar}}";
    id vars = @{@"bar": @"foo"};
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@"foo", res);
}

- (void)testStaticContext {
    NSString *input = @"{{baz}}";
    id vars = @{@"bar": @"foo"};
    
    [self.engine.staticContext defineVariable:@"baz" value:@"bat"];
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@"bat", res);
}

- (void)testStaticContextShadow {
    NSString *input = @"{{baz}}";
    id vars = @{@"baz": @"foo"};
    
    [self.engine.staticContext defineVariable:@"baz" value:@"bat"];
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@"foo", res);
}

- (void)testSimpleVarReplacementOneTextTwo {
    NSString *input = @"{{one}} text {{two}}";
    id vars = @{@"one": @"1", @"two": @"2"};
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@"1 text 2", res);
}

@end
