//
//  TDAutoescapeTagTests.m
//  TDTemplateEngineTests
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDBaseTestCase.h"

@interface TDAutoescapeTagTests : TDBaseTestCase
@property (nonatomic, retain) NSOutputStream *output;
@end

@implementation TDAutoescapeTagTests

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

- (void)testDefaultAutoescape {
    NSString *foo = @"<a>'\"&";
    id vars = @{
        @"foo": foo,
    };
    
    NSString *input = [NSString stringWithFormat:@"{{foo}} %@", foo];
    NSError *err = nil;
    BOOL success = NO;
    
    success = [self processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"&lt;a&gt;&apos;&quot;&amp; <a>'\"&", res);
}

- (void)testAutoescapeOn {
    NSString *foo = @"<a>'\"&";
    id vars = @{
        @"foo": foo,
    };
    
    NSString *input = @"{% autoescape on %}{{foo}}{% endautoescape %}";
    NSError *err = nil;
    BOOL success = NO;
    
    success = [self processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"&lt;a&gt;&apos;&quot;&amp;", res);
}

- (void)testAutoescapeOff {
    NSString *foo = @"<a>'\"&";
    id vars = @{
        @"foo": foo,
    };
    
    NSString *input = @"{% autoescape off %}{{foo}}{% endautoescape %}";
    NSError *err = nil;
    BOOL success = NO;
    
    success = [self processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(foo, res);
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
    
    success = [self processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"&lt;a&gt;&apos;&quot;&amp;", res);
}

- (void)testAutoescapeOffEscapeFilter {
    NSString *foo = @"<a>'\"&";
    id vars = @{
        @"foo": foo,
    };
    
    NSString *input = @"{% autoescape off %}{{foo|escape}}{% endautoescape %}";
    NSError *err = nil;
    BOOL success = NO;
    
    success = [self processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"&lt;a&gt;&apos;&quot;&amp;", res);
}

@end
