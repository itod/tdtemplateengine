//
//  TDCommentTagTests.m
//  TDTemplateEngineTests
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDBaseTestCase.h"

@interface TDCommentTagTests : TDBaseTestCase
@property (nonatomic, retain) NSOutputStream *output;
@end

@implementation TDCommentTagTests

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

- (void)testCommentF {
    NSString *input = @"{% comment %}f{% endcomment %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"", res);
}

- (void)testCommentMixedContent1 {
    NSString *input = @"foo {% comment %}bar {% endcomment %} baz.";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"foo  baz.", res);
}

- (void)testCommentMixedContent2 {
    NSString *input = @"foo {% comment %}bar {% endcomment %}baz.";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"foo baz.", res);
}

- (void)testCommentMixedContent3 {
    NSString *input = @"foo{% comment %}bar {% endcomment %}baz.";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"foobaz.", res);
}

- (void)testCommentMixedContent4 {
    NSString *input = @"foo{% comment %}bar{% endcomment %}baz.";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"foobaz.", res);
}

- (void)testCommentMixedContent5 {
    NSString *input = @"foo{% comment %}bar{% endcomment %}baz{% comment %}bat{% endcomment %}.";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"foobaz.", res);
}

@end
