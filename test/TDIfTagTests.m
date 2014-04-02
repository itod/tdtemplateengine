//
//  TDIfTagTests.m
//  TDTemplateEngineTests
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDTestScaffold.h"

@interface TDIfTagTests : XCTestCase
@property (nonatomic, retain) TDTemplateEngine *engine;
@end

@implementation TDIfTagTests

- (void)setUp {
    [super setUp];
    
    self.engine = [TDTemplateEngine templateEngine];
}

- (void)tearDown {
    self.engine = nil;
    
    [super tearDown];
}

- (void)testIf1 {
    NSString *input = @"{% if 1 %} text {%/if %}";
    id vars = nil;
    
    NSError *err = nil;
    NSString *res = [_engine processTemplateString:input withVariables:vars error:&err];
    TDNotNil(res);
    TDNil(err);
    TDEqualObjects(@" text ", res);
}

- (void)testIf0 {
    NSString *input = @"{% if 0 %} text {%/if %}";
    id vars = nil;
    
    NSError *err = nil;
    NSString *res = [_engine processTemplateString:input withVariables:vars error:&err];
    TDNotNil(res);
    TDNil(err);
    TDEqualObjects(@"", res);
}

- (void)testIfYES {
    NSString *input = @"{% if YES %} text {%/if %}";
    id vars = nil;
    
    NSError *err = nil;
    NSString *res = [_engine processTemplateString:input withVariables:vars error:&err];
    TDNotNil(res);
    TDNil(err);
    TDEqualObjects(@" text ", res);
}

- (void)testIfNO {
    NSString *input = @"{% if NO %} text {%/if %}";
    id vars = nil;
    
    NSError *err = nil;
    NSString *res = [_engine processTemplateString:input withVariables:vars error:&err];
    TDNotNil(res);
    TDNil(err);
    TDEqualObjects(@"", res);
}

- (void)testIfTrue {
    NSString *input = @"{% if true %} text {%/if %}";
    id vars = nil;
    
    NSError *err = nil;
    NSString *res = [_engine processTemplateString:input withVariables:vars error:&err];
    TDNotNil(res);
    TDNil(err);
    TDEqualObjects(@" text ", res);
}

- (void)testIfFalse {
    NSString *input = @"{% if false %} text {%/if %}";
    id vars = nil;
    
    NSError *err = nil;
    NSString *res = [_engine processTemplateString:input withVariables:vars error:&err];
    TDNotNil(res);
    TDNil(err);
    TDEqualObjects(@"", res);
}

- (void)testIfOpenTrueClose {
    NSString *input = @"{% if (true) %} text {%/if %}";
    id vars = nil;
    
    NSError *err = nil;
    NSString *res = [_engine processTemplateString:input withVariables:vars error:&err];
    TDNotNil(res);
    TDNil(err);
    TDEqualObjects(@" text ", res);
}

- (void)testIfOpenFalseClose {
    NSString *input = @"{% if (false) %} text {%/if %}";
    id vars = nil;
    
    NSError *err = nil;
    NSString *res = [_engine processTemplateString:input withVariables:vars error:&err];
    TDNotNil(res);
    TDNil(err);
    TDEqualObjects(@"", res);
}

- (void)testIfSQString {
    NSString *input = @"{% if 'hello' %} text {%/if %}";
    id vars = nil;
    
    NSError *err = nil;
    NSString *res = [_engine processTemplateString:input withVariables:vars error:&err];
    TDNotNil(res);
    TDNil(err);
    TDEqualObjects(@" text ", res);
}

- (void)testIfEmptySQString {
    NSString *input = @"{% if '' %} text {%/if %}";
    id vars = nil;
    
    NSError *err = nil;
    NSString *res = [_engine processTemplateString:input withVariables:vars error:&err];
    TDNotNil(res);
    TDNil(err);
    TDEqualObjects(@"", res);
}

- (void)testIf1Eq1 {
    NSString *input = @"{% if 1 eq 1 %} text {%/if %}";
    id vars = nil;
    
    NSError *err = nil;
    NSString *res = [_engine processTemplateString:input withVariables:vars error:&err];
    TDNotNil(res);
    TDNil(err);
    TDEqualObjects(@" text ", res);
}

- (void)testIf1EqSign1 {
    NSString *input = @"{% if 1 = 1 %} text {%/if %}";
    id vars = nil;
    
    NSError *err = nil;
    NSString *res = [_engine processTemplateString:input withVariables:vars error:&err];
    TDNotNil(res);
    TDNil(err);
    TDEqualObjects(@" text ", res);
}

- (void)testIf1EqEqSign1 {
    NSString *input = @"{% if 1 == 1 %} text {%/if %}";
    id vars = nil;
    
    NSError *err = nil;
    NSString *res = [_engine processTemplateString:input withVariables:vars error:&err];
    TDNotNil(res);
    TDNil(err);
    TDEqualObjects(@" text ", res);
}

- (void)testIf1Eq2 {
    NSString *input = @"{% if 1 eq 2 %} text {%/if %}";
    id vars = nil;
    
    NSError *err = nil;
    NSString *res = [_engine processTemplateString:input withVariables:vars error:&err];
    TDNotNil(res);
    TDNil(err);
    TDEqualObjects(@"", res);
}

- (void)testIf1EqSign2 {
    NSString *input = @"{% if 1 = 2 %} text {%/if %}";
    id vars = nil;
    
    NSError *err = nil;
    NSString *res = [_engine processTemplateString:input withVariables:vars error:&err];
    TDNotNil(res);
    TDNil(err);
    TDEqualObjects(@"", res);
}

- (void)testIf1EqEqSign2 {
    NSString *input = @"{% if 1 == 2 %} text {%/if %}";
    id vars = nil;
    
    NSError *err = nil;
    NSString *res = [_engine processTemplateString:input withVariables:vars error:&err];
    TDNotNil(res);
    TDNil(err);
    TDEqualObjects(@"", res);
}

- (void)testIf1Ne1 {
    NSString *input = @"{% if 1 ne 1 %} text {%/if %}";
    id vars = nil;
    
    NSError *err = nil;
    NSString *res = [_engine processTemplateString:input withVariables:vars error:&err];
    TDNotNil(res);
    TDNil(err);
    TDEqualObjects(@"", res);
}

- (void)testIf1NeSign1 {
    NSString *input = @"{% if 1 != 1 %} text {%/if %}";
    id vars = nil;
    
    NSError *err = nil;
    NSString *res = [_engine processTemplateString:input withVariables:vars error:&err];
    TDNotNil(res);
    TDNil(err);
    TDEqualObjects(@"", res);
}

- (void)testIf1Ne2 {
    NSString *input = @"{% if 1 ne 2 %} text {%/if %}";
    id vars = nil;
    
    NSError *err = nil;
    NSString *res = [_engine processTemplateString:input withVariables:vars error:&err];
    TDNotNil(res);
    TDNil(err);
    TDEqualObjects(@" text ", res);
}

- (void)testIf1NeSign2 {
    NSString *input = @"{% if 1 != 2 %} text {%/if %}";
    id vars = nil;
    
    NSError *err = nil;
    NSString *res = [_engine processTemplateString:input withVariables:vars error:&err];
    TDNotNil(res);
    TDNil(err);
    TDEqualObjects(@" text ", res);
}

- (void)testIf1Lt1 {
    NSString *input = @"{% if 1 < 1 %} text {%/if %}";
    id vars = nil;
    
    NSError *err = nil;
    NSString *res = [_engine processTemplateString:input withVariables:vars error:&err];
    TDNotNil(res);
    TDNil(err);
    TDEqualObjects(@"", res);
}

- (void)testIf1LtEq1 {
    NSString *input = @"{% if 1 <= 1 %} text {%/if %}";
    id vars = nil;
    
    NSError *err = nil;
    NSString *res = [_engine processTemplateString:input withVariables:vars error:&err];
    TDNotNil(res);
    TDNil(err);
    TDEqualObjects(@" text ", res);
}

- (void)testIf1Lt2 {
    NSString *input = @"{% if 1 < 2 %} text {%/if %}";
    id vars = nil;
    
    NSError *err = nil;
    NSString *res = [_engine processTemplateString:input withVariables:vars error:&err];
    TDNotNil(res);
    TDNil(err);
    TDEqualObjects(@" text ", res);
}

- (void)testIf1LtEq2 {
    NSString *input = @"{% if 1 <= 2 %} text {%/if %}";
    id vars = nil;
    
    NSError *err = nil;
    NSString *res = [_engine processTemplateString:input withVariables:vars error:&err];
    TDNotNil(res);
    TDNil(err);
    TDEqualObjects(@" text ", res);
}

- (void)testIf1Gt1 {
    NSString *input = @"{% if 1 > 1 %} text {%/if %}";
    id vars = nil;
    
    NSError *err = nil;
    NSString *res = [_engine processTemplateString:input withVariables:vars error:&err];
    TDNotNil(res);
    TDNil(err);
    TDEqualObjects(@"", res);
}

- (void)testIf1GtEq1 {
    NSString *input = @"{% if 1 >= 1 %} text {%/if %}";
    id vars = nil;
    
    NSError *err = nil;
    NSString *res = [_engine processTemplateString:input withVariables:vars error:&err];
    TDNotNil(res);
    TDNil(err);
    TDEqualObjects(@" text ", res);
}

- (void)testIf1Gt2 {
    NSString *input = @"{% if 1 > 2 %} text {%/if %}";
    id vars = nil;
    
    NSError *err = nil;
    NSString *res = [_engine processTemplateString:input withVariables:vars error:&err];
    TDNotNil(res);
    TDNil(err);
    TDEqualObjects(@"", res);
}

- (void)testIf1GtEq2 {
    NSString *input = @"{% if 1 >= 2 %} text {%/if %}";
    id vars = nil;
    
    NSError *err = nil;
    NSString *res = [_engine processTemplateString:input withVariables:vars error:&err];
    TDNotNil(res);
    TDNil(err);
    TDEqualObjects(@"", res);
}

- (void)testIf1And0 {
    NSString *input = @"{% if 1 and 0 %} text {%/if %}";
    id vars = nil;
    
    NSError *err = nil;
    NSString *res = [_engine processTemplateString:input withVariables:vars error:&err];
    TDNotNil(res);
    TDNil(err);
    TDEqualObjects(@"", res);
}

- (void)testIf0And1 {
    NSString *input = @"{% if 0 and 1 %} text {%/if %}";
    id vars = nil;
    
    NSError *err = nil;
    NSString *res = [_engine processTemplateString:input withVariables:vars error:&err];
    TDNotNil(res);
    TDNil(err);
    TDEqualObjects(@"", res);
}

- (void)testIf1And1 {
    NSString *input = @"{% if 1 and 1 %} text {%/if %}";
    id vars = nil;
    
    NSError *err = nil;
    NSString *res = [_engine processTemplateString:input withVariables:vars error:&err];
    TDNotNil(res);
    TDNil(err);
    TDEqualObjects(@" text ", res);
}

- (void)testIf1Or0 {
    NSString *input = @"{% if 1 or 0 %} text {%/if %}";
    id vars = nil;
    
    NSError *err = nil;
    NSString *res = [_engine processTemplateString:input withVariables:vars error:&err];
    TDNotNil(res);
    TDNil(err);
    TDEqualObjects(@" text ", res);
}

- (void)testIf0Or1 {
    NSString *input = @"{% if 0 or 1 %} text {%/if %}";
    id vars = nil;
    
    NSError *err = nil;
    NSString *res = [_engine processTemplateString:input withVariables:vars error:&err];
    TDNotNil(res);
    TDNil(err);
    TDEqualObjects(@" text ", res);
}

- (void)testIf1Or1 {
    NSString *input = @"{% if 1 or 1 %} text {%/if %}";
    id vars = nil;
    
    NSError *err = nil;
    NSString *res = [_engine processTemplateString:input withVariables:vars error:&err];
    TDNotNil(res);
    TDNil(err);
    TDEqualObjects(@" text ", res);
}

- (void)testIf1SpacePlusSpace2 {
    NSString *input = @"{% if 1 + 2 %} text {%/if %}";
    id vars = nil;
    
    NSError *err = nil;
    NSString *res = [_engine processTemplateString:input withVariables:vars error:&err];
    TDNotNil(res);
    TDNil(err);
    TDEqualObjects(@" text ", res);
}

- (void)testIf1Plus2 {
    NSString *input = @"{% if 1+2 %} text {%/if %}";
    id vars = nil;
    
    NSError *err = nil;
    NSString *res = [_engine processTemplateString:input withVariables:vars error:&err];
    TDNotNil(res);
    TDNil(err);
    TDEqualObjects(@" text ", res);
}

- (void)testIf1SpaceMinusSpace1 {
    NSString *input = @"{% if 1 - 1 %} text {%/if %}";
    id vars = nil;
    
    NSError *err = nil;
    NSString *res = [_engine processTemplateString:input withVariables:vars error:&err];
    TDNotNil(res);
    TDNil(err);
    TDEqualObjects(@"", res);
}

@end
