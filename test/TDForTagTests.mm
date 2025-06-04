//
//  TDForTagTests.m
//  TDTemplateEngineTests
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDBaseTestCase.h"

@interface TDForTagTests : TDBaseTestCase
@property (nonatomic, retain) NSOutputStream *output;
@end

@implementation TDForTagTests

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

- (void)testForObjInVec {
    NSString *input = @"{% for obj in vec %}{{obj}}{% endfor %}";
    id vars = @{@"vec": @[@"foo", @"bar", @"baz"]};
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"foobarbaz", res);
}

- (void)testFor0To3F {
    NSString *input = @"{% for i in 0 to 3 %}f{% endfor %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"fff", res);
}

- (void)testFor0To3FNoSpace {
    NSString *input = @"{%for i in 0 to 3%}f{%endfor%}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"fff", res);
}

- (void)testFor0ToDepthF {
    NSString *input = @"{% for i in 0 to depth %}f{% endfor %}";
    id vars = @{@"depth": @(3)};
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"fff", res);
}

- (void)testForloopCurrentIndex {
    NSString *input = @"{% for i in 5 to 2 %}{{forloop.counter0}}{% endfor %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"012", res);
}

- (void)testForloopFirst {
    NSString *input = @"{% for i in 5 to 2 %}{{forloop.first}}{% endfor %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"100", res);
}

- (void)testForloopLast {
    NSString *input = @"{% for i in 5 to 2 %}{{forloop.last}}{% endfor %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"001", res);
}

- (void)testFor0To4I {
    NSString *input = @"{% for i in 0 to 3 %}{{i}}{% endfor %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"012", res);
}

- (void)testNestedFor {
    NSString *input =   @"{% for i in 0 to 2 %}"
                            @"{% for j in 0 to 3 %}"
                                @"{{i}}:{{j}}\n"
                            @"{% endfor %}"
                        @"{% endfor %}";
    id vars = nil;
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"0:0\n0:1\n0:2\n1:0\n1:1\n1:2\n", res);
}

- (void)test2NestedFors {
    NSString *input =   @"{% for i in 0 to 1 %}"
                            @"{% for j in 0 to 2 %}"
                                @"{% for k in 0 to 3 %}"
                                    @"{{i}}:{{j}}:{{k}}\n"
                                @"{% endfor %}"
                            @"{% endfor %}"
                        @"{% endfor %}";
    id vars = nil;
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"0:0:0\n0:0:1\n0:0:2\n0:1:0\n0:1:1\n0:1:2\n", res);
}

- (void)testNestedForParentloop {
    NSString *input =   @"{% for i in 0 to 2 %}"
                            @"{% for j in 0 to 3 %}"
                                @"{{forloop.parentloop.counter0}}:{{forloop.counter0}}\n"
                            @"{% endfor %}"
                        @"{% endfor %}";
    id vars = nil;
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"0:0\n0:1\n0:2\n1:0\n1:1\n1:2\n", res);
}

- (void)testReverseBy {
    NSString *input =  @"{% for i in 70 to 60 by 2 %}"
                            @"{{i}}{% if not forloop.last %},{% endif %}"
                        @"{% endfor %}";
    id vars = nil;
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"70,68,66,64,62", res);
}

- (void)testSkip {
    NSString *input =  @"{% for i in 1 to 3 %}"
    @"{% skip %}{{i}}{% if not forloop.last %},{% endif %}"
    @"{% endfor %}";
    id vars = nil;
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"", res);
}

- (void)testSkipIeq1 {
    NSString *input =  @"{% for i in 1 to 4 %}"
                            @"{% skip i == 1 %}{{i}}{% if not forloop.last %},{% endif %}"
                        @"{% endfor %}";
    id vars = nil;
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"2,3", res);
}

- (void)testSkipIeq2 {
    NSString *input =  @"{% for i in 1 to 4 %}"
                            @"{% skip i == 2 %}{{i}}{% if not forloop.last %},{% endif %}"
                        @"{% endfor %}";
    id vars = nil;
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"1,3", res);
}

- (void)testSkipIeq3 {
    NSString *input =  @"{% for i in 1 to 4 %}"
                            @"{% skip i == 3 %}{{i}}{% if not forloop.last %},{% endif %}"
                        @"{% endfor %}";
    id vars = nil;
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"1,2,", res);
}

- (void)testFor0To3Range {
    NSString *input = @"{% for i in 0 to 4 %}{{i}}{% endfor %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"0123", res);
}

- (void)testFor0To3RangeReversed {
    NSString *input = @"{% for i in 0 to 4 reversed %}{{i}}{% endfor %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"3210", res);
}

- (void)testFor0To3Coll {
    NSString *input = @"{% for i in list %}{{i}}{% endfor %}";
    id vars = @{
        @"list": @[@0, @1, @2, @3],
    };
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"0123", res);
}

- (void)testFor0To3CollReversed {
    NSString *input = @"{% for i in list reversed %}{{i}}{% endfor %}";
    id vars = @{
        @"list": @[@0, @1, @2, @3],
    };
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"3210", res);
}

@end
