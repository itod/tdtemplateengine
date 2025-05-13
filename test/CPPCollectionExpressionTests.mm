//
//  CPPCollectionExpressionTests.m
//  TDTemplateEngineTests
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDBaseExpressionTests.h"
#import "TDLoopExpression.h"
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
    std::string input = "i in foo";
    Reader reader(input);

    id foo = @[@(4), @(5), @(6)];
    id vars = @{@"foo": foo};
    TDTemplateContext *ctx = [[[TDTemplateContext alloc] initWithVariables:vars output:nil] autorelease];
    
    NSError *err = nil;
    TDExpression *expr = [[self.eng loopExpressionFromReader:&reader error:&err] simplify];
    TDNil(err);
    TDNotNil(expr);
    TDTrue([expr isKindOfClass:[TDLoopExpression class]]);
    
    for (id obj in foo) {
        id res = [expr evaluateInContext:ctx];
        TDEqualObjects(obj, res);
    }

    TDNil([expr evaluateInContext:ctx]);
}

- (void)testIInArrayOneTwoThree {
    std::string input = "i in foo";
    Reader reader(input);
    
    id foo = @[@"one", @"two", @"three"];
    id vars = @{@"foo": foo};
    TDTemplateContext *ctx = [[[TDTemplateContext alloc] initWithVariables:vars output:nil] autorelease];
    
    NSError *err = nil;
    TDExpression *expr = [[self.eng loopExpressionFromReader:&reader error:&err] simplify];
    TDNil(err);
    TDNotNil(expr);
    TDTrue([expr isKindOfClass:[TDLoopExpression class]]);
    
    for (id obj in foo) {
        id res = [expr evaluateInContext:ctx];
        TDEqualObjects(obj, res);
    }
    
    TDNil([expr evaluateInContext:ctx]);
}

- (void)testObjInSetOneTwoThree {
    std::string input = "i in foo";
    Reader reader(input);
    
    id foo = [NSSet setWithObjects:@"one", @"two", @"three", nil];
    id vars = @{@"foo": foo};
    TDTemplateContext *ctx = [[[TDTemplateContext alloc] initWithVariables:vars output:nil] autorelease];
    
    NSError *err = nil;
    TDExpression *expr = [[self.eng loopExpressionFromReader:&reader error:&err] simplify];
    TDNil(err);
    TDNotNil(expr);
    TDTrue([expr isKindOfClass:[TDLoopExpression class]]);
    
    NSMutableSet *test = [NSMutableSet setWithCapacity:[foo count]];
    for (id obj in foo) {
        TDNotNil(obj); // compiler warn
        id res = [expr evaluateInContext:ctx];
        TDNotNil(res);
        [test addObject:res];
    }
    
    TDNil([expr evaluateInContext:ctx]);
    
    for (id obj in foo) {
        TDTrue([test containsObject:obj]);
    }
}

- (void)testKeyInDictOneTwoThree {
    std::string input = "key in dict";
    Reader reader(input);
    
    id dict = @{@"one": @(1), @"two": @(2), @"three": @(3)};
    id vars = @{@"dict": dict};
    TDTemplateContext *ctx = [[[TDTemplateContext alloc] initWithVariables:vars output:nil] autorelease];
    
    NSError *err = nil;
    TDExpression *expr = [[self.eng loopExpressionFromReader:&reader error:&err] simplify];
    TDNil(err);
    TDNotNil(expr);
    TDTrue([expr isKindOfClass:[TDLoopExpression class]]);
    
    for (id key in dict) {
        id res = [expr evaluateInContext:ctx];
        TDEqualObjects(key, res);
        TDEqualObjects(key, [ctx resolveVariable:@"key"]);
    }
    
    TDNil([expr evaluateInContext:ctx]);
}

- (void)testKeyValInDictOneTwoThree {
    std::string input = "key,val in dict";
    Reader reader(input);
    
    id dict = @{@"one": @(1), @"two": @(2), @"three": @(3)};
    id vars = @{@"dict": dict};
    TDTemplateContext *ctx = [[[TDTemplateContext alloc] initWithVariables:vars output:nil] autorelease];
    
    NSError *err = nil;
    TDExpression *expr = [[self.eng loopExpressionFromReader:&reader error:&err] simplify];
    TDNil(err);
    TDNotNil(expr);
    TDTrue([expr isKindOfClass:[TDLoopExpression class]]);
    
    for (id key in [dict allKeys]) {
        id val = dict[key];
        id res = [expr evaluateInContext:ctx];
        TDEqualObjects((@[key, val]), res);
        TDEqualObjects(key, [ctx resolveVariable:@"key"]);
        TDEqualObjects(val, [ctx resolveVariable:@"val"]);
    }
    
    TDNil([expr evaluateInContext:ctx]);
}

//- (void)testKeyValInDictNumsOneTwoThree {
//    std::string input = "key,val in dict.nums";
//    Reader reader(input);
//    
//    id nums = @{@"one": @(1), @"two": @(2), @"three": @(3)};
//    id dict = @{@"nums": nums};
//    id vars = @{@"dict": dict};
//    TDTemplateContext *ctx = [[[TDTemplateContext alloc] initWithVariables:vars output:nil] autorelease];
//    
//    NSError *err = nil;
//    TDExpression *expr = [[self.eng loopExpressionFromReader:&reader error:&err] simplify];
//    TDNil(err);
//    TDNotNil(expr);
//    TDTrue([expr isKindOfClass:[TDLoopExpression class]]);
//    
//    for (id key in [dict[@"nums"] allKeys]) {
//        id val = dict[@"nums"][key];
//        id res = [expr evaluateInContext:ctx];
//        TDEqualObjects((@[key, val]), res);
//        TDEqualObjects(key, [ctx resolveVariable:@"key"]);
//        TDEqualObjects(val, [ctx resolveVariable:@"val"]);
//    }
//    
//    TDNil([expr evaluateInContext:ctx]);
//}

@end
