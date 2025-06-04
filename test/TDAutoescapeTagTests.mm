//
//  TDAutoescapeTagTests.m
//  TDTemplateEngineTests
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDBaseTestCase.h"

@interface TDAutoescapeTagTests : TDBaseTestCase

@end

@implementation TDAutoescapeTagTests

- (void)testDefaultAutoescape {
    NSString *foo = @"<a>'\"&";
    id vars = @{
        @"foo": foo,
    };
    
    NSString *input = [NSString stringWithFormat:@"{{foo}} %@", foo];
    NSError *err = nil;
    BOOL success = NO;
    
    success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@"&lt;a&gt;&apos;&quot;&amp; <a>'\"&", res);
}

- (void)testAutoescapeOn {
    NSString *foo = @"<a>'\"&";
    id vars = @{
        @"foo": foo,
    };
    
    NSString *input = @"{% autoescape on %}{{foo}}{% endautoescape %}";
    NSError *err = nil;
    BOOL success = NO;
    
    success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@"&lt;a&gt;&apos;&quot;&amp;", res);
}

- (void)testAutoescapeOff {
    NSString *foo = @"<a>'\"&";
    id vars = @{
        @"foo": foo,
    };
    
    NSString *input = @"{% autoescape off %}{{foo}}{% endautoescape %}";
    NSError *err = nil;
    BOOL success = NO;
    
    success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(foo, res);
}

- (void)testAutoescapeOnEscapeFilter {
    NSString *foo = @"<a>'\"&";
    id vars = @{
        @"foo": foo,
    };
    
    // MUST NOT DOUBLE-ESCAPE HERE!!!
    NSString *input = @"{% autoescape on %}{{foo|escape}}{% endautoescape %}";
    NSError *err = nil;
    BOOL success = NO;
    
    success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@"&lt;a&gt;&apos;&quot;&amp;", res);
}

- (void)testAutoescapeOffEscapeFilter {
    NSString *foo = @"<a>'\"&";
    id vars = @{
        @"foo": foo,
    };
    
    NSString *input = @"{% autoescape off %}{{foo|escape}}{% endautoescape %}";
    NSError *err = nil;
    BOOL success = NO;
    
    success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@"&lt;a&gt;&apos;&quot;&amp;", res);
}

@end
