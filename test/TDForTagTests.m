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
@end

@implementation TDForTagTests

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

@end
