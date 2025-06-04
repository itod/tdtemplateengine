//
//  CPPRangeExpressionTests.m
//  TDTemplateEngineTests
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDBaseExpressionTests.h"
#import "TDEnumeration.h"
#import <ParseKitCPP/Reader.hpp>

using namespace parsekit;

@interface CPPRangeExpressionTests : TDBaseExpressionTests
@end

@implementation CPPRangeExpressionTests

- (void)setUp {
    [super setUp];
    
}

- (void)tearDown {
    
    [super tearDown];
}

- (void)testIIn0To4 {
    std::string input = "for i in 0 to 4";
    ReaderCPP reader(input);
    
    id foo = @[@(0), @(1), @(2), @(3)];
    id vars = @{@"foo": foo};
    TDTemplateContext *ctx = [[[TDTemplateContext alloc] initWithVariables:vars output:nil] autorelease];
    
    TDTag *tag = [self.engine tagFromReader:&reader withParent:nil inContext:ctx];
    XCTAssertNotNil(tag);
    
    TDExpression *expr = [tag.expression simplify];
    TDEnumeration *en = [TDEnumeration enumerationWithCollection:[expr evaluateAsObjectInContext:ctx] reversed:NO];

    for (id obj in foo) {
        id res = [en nextObject];
        TDEqualObjects(obj, res);
    }
    
    TDFalse([en hasMore]);
}

- (void)testIIn5To2 {
    std::string input = "for i in 5 to 2";
    ReaderCPP reader(input);

    id foo = @[@(5), @(4), @(3)];
    id vars = @{@"foo": foo};
    TDTemplateContext *ctx = [[[TDTemplateContext alloc] initWithVariables:vars output:nil] autorelease];
    
    TDTag *tag = [self.engine tagFromReader:&reader withParent:nil inContext:ctx];
    XCTAssertNotNil(tag);
    
    TDExpression *expr = [tag.expression simplify];
    TDEnumeration *en = [TDEnumeration enumerationWithCollection:[expr evaluateAsObjectInContext:ctx] reversed:NO];

    for (id obj in foo) {
        id res = [en nextObject];
        TDEqualObjects(obj, res);
    }
    
    TDFalse([en hasMore]);
}

- (void)testIIn0To10By2 {
    std::string input = "for i in 0 to 10 by 2";
    ReaderCPP reader(input);

    id foo = @[@(0), @(2), @(4), @(6), @(8)];
    id vars = @{@"foo": foo};
    TDTemplateContext *ctx = [[[TDTemplateContext alloc] initWithVariables:vars output:nil] autorelease];
    
    TDTag *tag = [self.engine tagFromReader:&reader withParent:nil inContext:ctx];
    XCTAssertNotNil(tag);
    
    TDExpression *expr = [tag.expression simplify];
    TDEnumeration *en = [TDEnumeration enumerationWithCollection:[expr evaluateAsObjectInContext:ctx] reversed:NO];

    for (id obj in foo) {
        id res = [en nextObject];
        TDEqualObjects(obj, res);
    }
    
    TDFalse([en hasMore]);
}

- (void)testIIn10To0ByNeg2 {
    std::string input = "for i in 10 to 0 by -2";
    ReaderCPP reader(input);

    id foo = @[@(10), @(8), @(6), @(4), @(2)];
    id vars = @{@"foo": foo};
    TDTemplateContext *ctx = [[[TDTemplateContext alloc] initWithVariables:vars output:nil] autorelease];
    
    TDTag *tag = [self.engine tagFromReader:&reader withParent:nil inContext:ctx];
    XCTAssertNotNil(tag);
    
    TDExpression *expr = [tag.expression simplify];
    TDEnumeration *en = [TDEnumeration enumerationWithCollection:[expr evaluateAsObjectInContext:ctx] reversed:NO];

    for (id obj in foo) {
        id res = [en nextObject];
        TDEqualObjects(obj, res);
    }
    
    TDFalse([en hasMore]);
}

@end
