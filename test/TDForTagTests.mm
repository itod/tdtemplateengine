//
//  TDForTagTests.m
//  TDTemplateEngineTests
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDTestScaffold.h"

@interface TDForTagTests : XCTestCase
@property (nonatomic, retain) TDTemplateEngine *engine;
@property (nonatomic, retain) NSOutputStream *output;
@end

@implementation TDForTagTests

- (void)setUp {
    [super setUp];
    
    self.engine = [TDTemplateEngine templateEngine];
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

- (void)testForObjInVec {
    NSString *input = @"{% for obj in vec %}{{obj}}{% endfor %}";
    id vars = @{@"vec": @[@"foo", @"bar", @"baz"]};
    
    NSError *err = nil;
    BOOL success = [_engine processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"foobarbaz", res);
}

- (void)testFor0To4F {
    NSString *input = @"{% for i in 0 to 3 %}f{% endfor %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [_engine processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"ffff", res);
}

- (void)testFor0To4FNoSpace {
    NSString *input = @"{%for i in 0 to 3%}f{%endfor%}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [_engine processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"ffff", res);
}

- (void)testFor0ToDepthF {
    NSString *input = @"{% for i in 0 to depth %}f{% endfor %}";
    id vars = @{@"depth": @(3)};
    
    NSError *err = nil;
    BOOL success = [_engine processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"ffff", res);
}

- (void)testForloopCurrentIndex {
    NSString *input = @"{% for i in 5 to 2 %}{{currentLoop.currentIndex}}{% endfor %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [_engine processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"0123", res);
}

- (void)testForloopFirst {
    NSString *input = @"{% for i in 5 to 2 %}{{currentLoop.first}}{% endfor %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [_engine processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"1000", res);
}

- (void)testForloopLast {
    NSString *input = @"{% for i in 5 to 2 %}{{currentLoop.last}}{% endfor %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [_engine processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"0001", res);
}

- (void)testFor0To4I {
    NSString *input = @"{% for i in 0 to 3 %}{{i}}{% endfor %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [_engine processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"0123", res);
}

- (void)testNestedFor {
    NSString *input =   @"{% for i in 0 to 1 %}"
                            @"{% for j in 0 to 2 %}"
                                @"{{i}}:{{j}}\n"
                            @"{% endfor %}"
                        @"{% endfor %}";
    id vars = nil;
    NSError *err = nil;
    BOOL success = [_engine processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"0:0\n0:1\n0:2\n1:0\n1:1\n1:2\n", res);
}

- (void)test2NestedFors {
    NSString *input =   @"{% for i in 0 to 0 %}"
                            @"{% for j in 0 to 1 %}"
                                @"{% for k in 0 to 2 %}"
                                    @"{{i}}:{{j}}:{{k}}\n"
                                @"{% endfor %}"
                            @"{% endfor %}"
                        @"{% endfor %}";
    id vars = nil;
    NSError *err = nil;
    BOOL success = [_engine processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"0:0:0\n0:0:1\n0:0:2\n0:1:0\n0:1:1\n0:1:2\n", res);
}

- (void)testNestedForParentloop {
    NSString *input =   @"{% for i in 0 to 1 %}"
                            @"{% for j in 0 to 2 %}"
                                @"{{currentLoop.parentLoop.currentIndex}}:{{currentLoop.currentIndex}}\n"
                            @"{% endfor %}"
                        @"{% endfor %}";
    id vars = nil;
    NSError *err = nil;
    BOOL success = [_engine processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"0:0\n0:1\n0:2\n1:0\n1:1\n1:2\n", res);
}

- (void)testReverseBy {
    NSString *input =  @"{% for i in 70 to 60 by 2 %}"
                            @"{{i}}{% if not currentLoop.last %},{% endif %}"
                        @"{% endfor %}";
    id vars = nil;
    NSError *err = nil;
    BOOL success = [_engine processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"70,68,66,64,62,60", res);
}

- (void)testSkip {
    NSString *input =  @"{% for i in 1 to 3 %}"
    @"{% skip %}{{i}}{% if not currentLoop.last %},{% endif %}"
    @"{% endfor %}";
    id vars = nil;
    NSError *err = nil;
    BOOL success = [_engine processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"", res);
}

- (void)testSkipIeq1 {
    NSString *input =  @"{% for i in 1 to 3 %}"
                            @"{% skip i == 1 %}{{i}}{% if not currentLoop.last %},{% endif %}"
                        @"{% endfor %}";
    id vars = nil;
    NSError *err = nil;
    BOOL success = [_engine processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"2,3", res);
}

- (void)testSkipIeq2 {
    NSString *input =  @"{% for i in 1 to 3 %}"
                            @"{% skip i == 2 %}{{i}}{% if not currentLoop.last %},{% endif %}"
                        @"{% endfor %}";
    id vars = nil;
    NSError *err = nil;
    BOOL success = [_engine processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"1,3", res);
}

- (void)testSkipIeq3 {
    NSString *input =  @"{% for i in 1 to 3 %}"
                            @"{% skip i == 3 %}{{i}}{% if not currentLoop.last %},{% endif %}"
                        @"{% endfor %}";
    id vars = nil;
    NSError *err = nil;
    BOOL success = [_engine processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"1,2,", res);
}

@end
