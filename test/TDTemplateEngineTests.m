//
//  TDTemplateEngineTests.m
//  TDTemplateEngineTests
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDTestScaffold.h"

@interface TDTemplateEngineTests : XCTestCase
@property (nonatomic, retain) TDTemplateEngine *engine;
@end

@implementation TDTemplateEngineTests

- (void)setUp {
    [super setUp];
    
    self.engine = [TDTemplateEngine templateEngine];
}

- (void)tearDown {
    self.engine = nil;
    
    [super tearDown];
}

- (void)testSimpleVarReplacementFoo {
    NSString *input = @"{{foo}}";
    id vars = @{@"foo": @"bar"};
    
    NSString *res = [_engine processTemplateString:input withVariables:vars];
    TDNotNil(res);
    TDEqualObjects(@"bar", res);
}

- (void)testSimpleVarReplacementBar {
    NSString *input = @"{{bar}}";
    id vars = @{@"bar": @"foo"};
    
    NSString *res = [_engine processTemplateString:input withVariables:vars];
    TDNotNil(res);
    TDEqualObjects(@"foo", res);
}

- (void)testSimpleVarReplacementOneTextTwo {
    NSString *input = @"{{one}} text {{two}}";
    id vars = @{@"one": @"1", @"two": @"2"};
    
    NSString *res = [_engine processTemplateString:input withVariables:vars];
    TDNotNil(res);
    TDEqualObjects(@"1 text 2", res);
}

- (void)testIf1 {
    NSString *input = @"{% if 1 %} text {% endif %}";
    id vars = nil;
    
    NSString *res = [_engine processTemplateString:input withVariables:vars];
    TDNotNil(res);
    TDEqualObjects(@" text ", res);
}

- (void)testIf0 {
    NSString *input = @"{% if 0 %} text {% endif %}";
    id vars = nil;
    
    NSString *res = [_engine processTemplateString:input withVariables:vars];
    TDNotNil(res);
    TDEqualObjects(@"", res);
}

- (void)testIfYES {
    NSString *input = @"{% if YES %} text {% endif %}";
    id vars = nil;
    
    NSString *res = [_engine processTemplateString:input withVariables:vars];
    TDNotNil(res);
    TDEqualObjects(@" text ", res);
}

- (void)testIfNO {
    NSString *input = @"{% if NO %} text {% endif %}";
    id vars = nil;
    
    NSString *res = [_engine processTemplateString:input withVariables:vars];
    TDNotNil(res);
    TDEqualObjects(@"", res);
}

- (void)testIfTrue {
    NSString *input = @"{% if true %} text {% endif %}";
    id vars = nil;
    
    NSString *res = [_engine processTemplateString:input withVariables:vars];
    TDNotNil(res);
    TDEqualObjects(@" text ", res);
}

- (void)testIfFalse {
    NSString *input = @"{% if false %} text {% endif %}";
    id vars = nil;
    
    NSString *res = [_engine processTemplateString:input withVariables:vars];
    TDNotNil(res);
    TDEqualObjects(@"", res);
}

- (void)testIfOpenTrueClose {
    NSString *input = @"{% if (true) %} text {% endif %}";
    id vars = nil;
    
    NSString *res = [_engine processTemplateString:input withVariables:vars];
    TDNotNil(res);
    TDEqualObjects(@" text ", res);
}

- (void)testIfOpenFalseClose {
    NSString *input = @"{% if (false) %} text {% endif %}";
    id vars = nil;
    
    NSString *res = [_engine processTemplateString:input withVariables:vars];
    TDNotNil(res);
    TDEqualObjects(@"", res);
}

@end
