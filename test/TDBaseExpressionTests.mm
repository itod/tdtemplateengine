//
//  TDBaseExpressionTests.m
//  TDTemplateEngineTests
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDBaseExpressionTests.h"

@implementation TDBaseExpressionTests

- (void)setUp {
    [super setUp];
    
    self.eng = [[TDTemplateEngine new] autorelease]; // create thread local temp engine
    self.expr = nil;
}

- (void)tearDown {
    self.expr = nil;
    self.eng = nil;
    
    [super tearDown];
}

@end
