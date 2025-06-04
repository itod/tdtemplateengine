//
//  TDVerbatimTagTests.m
//  TDTemplateEngineTests
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDBaseTestCase.h"

@interface TDVerbatimTagTests : TDBaseTestCase
@property (nonatomic, retain) NSOutputStream *output;
@end

@implementation TDVerbatimTagTests

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

- (void)testVerbatimF {
    NSString *input = @"{% verbatim %}f{% endverbatim %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"f", res);
}

- (void)testVerbatimNestedVar {
    NSString *input = @"{% verbatim %}{{foo}}{% endverbatim %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"{{foo}}", res);
}

- (void)testVerbatimNestedVarSpace {
    NSString *input = @"{% verbatim %}{{ foo }}{% endverbatim %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"{{ foo }}", res);
}

- (void)testVerbatimNestedIfTagSpace {
    NSString *input = @"{% verbatim %}{% if 1 %}HI!{% endif %}{% endverbatim %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"{% if 1 %}HI!{% endif %}", res);
}

- (void)testVerbatimNestedIfTag {
    NSString *input = @"{% verbatim %}{%if 1%}HI!{%endif%}{% endverbatim %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"{%if 1%}HI!{%endif%}", res);
}

@end
