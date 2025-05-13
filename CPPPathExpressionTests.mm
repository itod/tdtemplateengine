//
//  CPPPathExpressionTests.m
//  TDTemplateEngineTests
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDBaseExpressionTests.h"
#import <ParseKitCPP/Reader.hpp>

using namespace parsekit;

@interface CPPPathExpressionTests : TDBaseExpressionTests
@end

@implementation CPPPathExpressionTests

- (void)setUp {
    [super setUp];
    
}

- (void)tearDown {
    
    [super tearDown];
}

- (void)testPathFooBar8 {
    std::string input = "foo.bar";
    Reader reader(input);

    id vars = @{@"foo": @{@"bar": @(8)}};
    id ctx = [[[TDTemplateContext alloc] initWithVariables:vars output:nil] autorelease];
    
    NSError *err = nil;
    TDExpression *expr = [self.eng expressionFromReader:&reader error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDEquals(8.0, [[expr simplify] evaluateAsNumberInContext:ctx]);
}

@end
