//
//  TDElseTagTests.m
//  TDTemplateEngineTests
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDBaseTestCase.h"

@interface TDElseTagTests : TDBaseTestCase
@property (nonatomic, retain) NSOutputStream *output;
@end

@implementation TDElseTagTests

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

- (void)testIf1Else {
    NSString *input = @"{% if 1 %}foo{% else %}bar{% endif %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"foo", res);
}

- (void)testIf0Else {
    NSString *input = @"{% if 0 %}foo{% else %}bar{% endif %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"bar", res);
}

- (void)testIf0Elif0Else {
    NSString *input = @"{% if 0 %}foo{% elif 0 %}bar{% else %}baz{% endif %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"baz", res);
}

- (void)testIf0Elif0Elif0Else {
    NSString *input = @"{% if 0 %}foo{% elif 0 %}bar{% elif 0 %}baz{% else %}bat{% endif %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"bat", res);
}

- (void)testIf1Elif1Else {
    NSString *input = @"{% if 1 %}foo{% elif 1 %}bar{% else %}baz{% endif %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"foo", res);
}

- (void)testIf1Elif0Else {
    NSString *input = @"{% if 1 %}foo{% elif 0 %}bar{% else %}baz{% endif %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"foo", res);
}

- (void)testIf0Elif1Else {
    NSString *input = @"{% if 0 %}foo{% elif 1 %}bar{% else %}baz{% endif %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"bar", res);
}

@end
