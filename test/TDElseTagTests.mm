//
//  TDElseTagTests.m
//  TDTemplateEngineTests
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDBaseTestCase.h"

@interface TDElseTagTests : TDBaseTestCase

@end

@implementation TDElseTagTests

- (void)testIf1Else {
    NSString *input = @"{% if 1 %}foo{% else %}bar{% endif %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@"foo", res);
}

- (void)testIf0Else {
    NSString *input = @"{% if 0 %}foo{% else %}bar{% endif %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@"bar", res);
}

- (void)testIf0Elif0Else {
    NSString *input = @"{% if 0 %}foo{% elif 0 %}bar{% else %}baz{% endif %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@"baz", res);
}

- (void)testIf0Elif0Elif0Else {
    NSString *input = @"{% if 0 %}foo{% elif 0 %}bar{% elif 0 %}baz{% else %}bat{% endif %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@"bat", res);
}

- (void)testIf1Elif1Else {
    NSString *input = @"{% if 1 %}foo{% elif 1 %}bar{% else %}baz{% endif %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@"foo", res);
}

- (void)testIf1Elif0Else {
    NSString *input = @"{% if 1 %}foo{% elif 0 %}bar{% else %}baz{% endif %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@"foo", res);
}

- (void)testIf0Elif1Else {
    NSString *input = @"{% if 0 %}foo{% elif 1 %}bar{% else %}baz{% endif %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@"bar", res);
}

@end
