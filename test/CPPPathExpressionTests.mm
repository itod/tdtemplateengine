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

@interface TestPerson : NSObject
@property (nonatomic, retain) NSString *name;
@end

@implementation TestPerson
- (void)dealloc {
    self.name = nil;
    [super dealloc];
}
@end

@interface CPPPathExpressionTests : TDBaseExpressionTests
@end

@implementation CPPPathExpressionTests

- (void)setUp {
    [super setUp];
    
}

- (void)tearDown {
    
    [super tearDown];
}

- (void)testPathFooBarDictionary {
    std::string input = "foo.bar";
    ReaderCPP reader(input);

    id vars = @{@"foo": @{@"bar": @(8)}};
    id ctx = [[[TDTemplateContext alloc] initWithVariables:vars output:nil] autorelease];
    
    NSError *err = nil;
    TDExpression *expr = [self expressionFromReader:&reader error:&err];
    XCTAssertNil(err);
    XCTAssertNotNil(expr);
    XCTAssertEqual(8.0, [[expr simplify] evaluateAsNumberInContext:ctx]);
}

- (void)testPathFooBarProperty {
    std::string input = "foo.name";
    ReaderCPP reader(input);

    TestPerson *p = [[[TestPerson alloc] init] autorelease];
    p.name = @"John";
    id vars = @{@"foo": p};
    id ctx = [[[TDTemplateContext alloc] initWithVariables:vars output:nil] autorelease];
    
    NSError *err = nil;
    TDExpression *expr = [self expressionFromReader:&reader error:&err];
    XCTAssertNil(err);
    XCTAssertNotNil(expr);
    XCTAssertEqualObjects(@"John", [[expr simplify] evaluateAsStringInContext:ctx]);
}

@end
