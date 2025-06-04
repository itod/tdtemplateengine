//
//  CPPCollectionExpressionTests.m
//  TDTemplateEngineTests
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDBaseExpressionTests.h"
#import "TDPairEnumeration.h"
#import <ParseKitCPP/Reader.hpp>

using namespace parsekit;

@interface CPPCollectionExpressionTests : TDBaseExpressionTests
@end

@implementation CPPCollectionExpressionTests

- (void)setUp {
    [super setUp];
    
}

- (void)tearDown {
    
    [super tearDown];
}

- (void)testIInArray4Thru6 {
    std::string input = "for i in foo";
    ReaderCPP reader(input);

    id foo = @[@(4), @(5), @(6)];
    id vars = @{@"foo": foo};
    TDTemplateContext *ctx = [[[TDTemplateContext alloc] initWithVariables:vars output:nil] autorelease];
    
    TDTag *tag = [self.engine tagFromReader:&reader withParent:nil inContext:ctx];
    XCTAssertNotNil(tag);
    
    TDExpression *expr = [tag.expression simplify];
    TDEnumeration *en = [TDEnumeration enumerationWithCollection:[expr evaluateAsObjectInContext:ctx] reversed:NO];

    for (id obj in foo) {
        id res = [en nextObject];
        XCTAssertEqualObjects(obj, res);
    }

    XCTAssertFalse([en hasMore]);
}

- (void)testIInArrayOneTwoThree {
    std::string input = "for i in foo";
    ReaderCPP reader(input);
    
    id foo = @[@"one", @"two", @"three"];
    id vars = @{@"foo": foo};
    TDTemplateContext *ctx = [[[TDTemplateContext alloc] initWithVariables:vars output:nil] autorelease];
    
    TDTag *tag = [self.engine tagFromReader:&reader withParent:nil inContext:ctx];
    XCTAssertNotNil(tag);
    
    TDExpression *expr = [tag.expression simplify];
    TDEnumeration *en = [TDEnumeration enumerationWithCollection:[expr evaluateAsObjectInContext:ctx] reversed:NO];

    for (id obj in foo) {
        id res = [en nextObject];
        XCTAssertEqualObjects(obj, res);
    }

    XCTAssertFalse([en hasMore]);
}

- (void)testObjInSetOneTwoThree {
    std::string input = "for i in foo";
    ReaderCPP reader(input);
    
    id foo = [NSSet setWithObjects:@"one", @"two", @"three", nil];
    id vars = @{@"foo": foo};
    TDTemplateContext *ctx = [[[TDTemplateContext alloc] initWithVariables:vars output:nil] autorelease];
    
    TDTag *tag = [self.engine tagFromReader:&reader withParent:nil inContext:ctx];
    XCTAssertNotNil(tag);
    
    TDExpression *expr = [tag.expression simplify];
    TDEnumeration *en = [TDEnumeration enumerationWithCollection:[expr evaluateAsObjectInContext:ctx] reversed:NO];

    NSMutableSet *test = [NSMutableSet setWithCapacity:[foo count]];
    for (id obj in foo) {
        XCTAssertNotNil(obj); // compiler warn
        id res = [en nextObject];
        XCTAssertNotNil(res);
        [test addObject:res];
    }
    
    XCTAssertFalse([en hasMore]);

    for (id obj in foo) {
        XCTAssertTrue([test containsObject:obj]);
    }
}

- (void)testKeyInDictOneTwoThree {
    std::string input = "for key in dict";
    ReaderCPP reader(input);
    
    id dict = @{@"one": @(1), @"two": @(2), @"three": @(3)};
    id vars = @{@"dict": dict};
    TDTemplateContext *ctx = [[[TDTemplateContext alloc] initWithVariables:vars output:nil] autorelease];
    
    TDTag *tag = [self.engine tagFromReader:&reader withParent:nil inContext:ctx];
    XCTAssertNotNil(tag);
    
    TDExpression *expr = [tag.expression simplify];
    TDEnumeration *en = [TDEnumeration enumerationWithCollection:[expr evaluateAsObjectInContext:ctx] reversed:NO];

    for (id key in dict) {
        id res = [en nextObject];
        XCTAssertEqualObjects(key, res);
    }
    
    XCTAssertFalse([en hasMore]);
}

- (void)testKeyValInDictOneTwoThree {
    std::string input = "for key,val in dict";
    ReaderCPP reader(input);
    
    id dict = @{@"one": @(1), @"two": @(2), @"three": @(3)};
    id vars = @{@"dict": dict};
    TDTemplateContext *ctx = [[[TDTemplateContext alloc] initWithVariables:vars output:nil] autorelease];
    
    TDTag *tag = [self.engine tagFromReader:&reader withParent:nil inContext:ctx];
    XCTAssertNotNil(tag);
    
    TDExpression *expr = [tag.expression simplify];
    TDEnumeration *en = [TDPairEnumeration enumerationWithCollection:[expr evaluateAsObjectInContext:ctx] reversed:NO];

    for (id key in [dict allKeys]) {
        id val = dict[key];
        id pair = [en nextObject];
        XCTAssertEqualObjects(key, [pair firstObject]);
        XCTAssertEqualObjects(val, [pair lastObject]);
    }
    
    XCTAssertFalse([en hasMore]);
}

- (void)testKeyValInDictNumsOneTwoThree {
    std::string input = "for key,val in dict.nums";
    ReaderCPP reader(input);
    
    id nums = @{@"one": @(1), @"two": @(2), @"three": @(3)};
    id dict = @{@"nums": nums};
    id vars = @{@"dict": dict};
    TDTemplateContext *ctx = [[[TDTemplateContext alloc] initWithVariables:vars output:nil] autorelease];
    
    TDTag *tag = [self.engine tagFromReader:&reader withParent:nil inContext:ctx];
    XCTAssertNotNil(tag);
    
    TDExpression *expr = [tag.expression simplify];
    TDEnumeration *en = [TDPairEnumeration enumerationWithCollection:[expr evaluateAsObjectInContext:ctx] reversed:NO];

    for (id key in [dict[@"nums"] allKeys]) {
        id val = dict[@"nums"][key];
        id pair = [en nextObject];
        XCTAssertEqualObjects(key, [pair firstObject]);
        XCTAssertEqualObjects(val, [pair lastObject]);
    }
    
    XCTAssertFalse([en hasMore]);
}

@end
