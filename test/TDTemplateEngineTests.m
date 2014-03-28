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

- (void)testExample {
    //XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

@end
