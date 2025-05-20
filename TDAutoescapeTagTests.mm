//
//  TDAutoescapeTagTests.m
//  TDTemplateEngineTests
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDTestScaffold.h"

@interface TDAutoescapeTagTests : XCTestCase
@property (nonatomic, retain) TDTemplateEngine *engine;
@property (nonatomic, retain) NSOutputStream *output;
@end

@implementation TDAutoescapeTagTests

- (void)setUp {
    [super setUp];
    
    self.engine = [[TDTemplateEngine new] autorelease];
    self.output = [NSOutputStream outputStreamToMemory];
}

- (void)tearDown {
    self.engine = nil;
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
    
    success = [_engine processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"&lt;a&gt;&#x27;&quot;&amp; <a>'\"&", res);
}

- (void)testAutoescapeOn {
    NSString *foo = @"<a>'\"&";
    id vars = @{
        @"foo": foo,
    };
    
    NSString *input = @"{% autoescape on %}{{foo}}{% endautoescape %}";
    NSError *err = nil;
    BOOL success = NO;
    
    success = [_engine processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"&lt;a&gt;&#x27;&quot;&amp;", res);
}

- (void)testAutoescapeOff {
    NSString *foo = @"<a>'\"&";
    id vars = @{
        @"foo": foo,
    };
    
    NSString *input = @"{% autoescape off %}{{foo}}{% endautoescape %}";
    NSError *err = nil;
    BOOL success = NO;
    
    success = [_engine processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(foo, res);
}


@end
