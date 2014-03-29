//
//  XPValue.m
//  XPath
//
//  Created by Todd Ditchendorf on 7/12/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPValue.h"
#import "XPBooleanValue.h"
#import "XPNumericValue.h"
#import "XPStringValue.h"
#import "TDTemplateContext.h"

double XPNumberFromString(NSString *s) {
    return [s doubleValue];
}

@implementation XPValue

- (XPValue *)evaluateInContext:(TDTemplateContext *)ctx {
    return self;
}


- (XPExpression *)simplify {
    return self;
}


- (NSUInteger)dependencies {
    return 0;
}


- (NSString *)asString {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return NO;
}


- (double)asNumber {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return NO;
}


- (BOOL)asBoolean {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return NO;
}


- (BOOL)isEqualToValue:(XPValue *)other {

    if ([self isBooleanValue] || [other isBooleanValue]) {
        return [self asBoolean] == [other asBoolean];
    }
    
    if ([self isNumericValue] || [other isNumericValue]) {
        return [self asNumber] == [other asNumber];
    }
    
    return [[self asString] isEqualToString:[other asString]];
}


- (BOOL)isNotEqualToValue:(XPValue *)other {

    return ![self isEqualToValue:other];
}


- (BOOL)compareToValue:(XPValue *)other usingOperator:(NSInteger)op {

    if (op == XPTokenTypeEQ) return [self isEqualToValue:other];
    if (op == XPTokenTypeNE) return [self isNotEqualToValue:other];
        
    return [self compareNumber:[self asNumber] toNumber:[other asNumber] usingOperator:op];
}


- (NSInteger)inverseOperator:(NSInteger)op {
    switch (op) {
        case XPTokenTypeLT:
            return XPTokenTypeGT;
        case XPTokenTypeLE:
            return XPTokenTypeGE;
        case XPTokenTypeGT:
            return XPTokenTypeLT;
        case XPTokenTypeGE:
            return XPTokenTypeLE;
        default:
            return op;
    }
}


- (BOOL)compareNumber:(double)x toNumber:(double)y usingOperator:(NSInteger)op {
    switch (op) {
        case XPTokenTypeLT:
            return x < y;
        case XPTokenTypeLE:
            return x <= y;
        case XPTokenTypeGT:
            return x > y;
        case XPTokenTypeGE:
            return x >= y;
        default:
            return NO;
    }
}


- (XPExpression *)reduceDependencies:(NSUInteger)dep inContext:(TDTemplateContext *)ctx {
    return self;
}


- (BOOL)isBooleanValue {
    return [self isKindOfClass:[XPBooleanValue class]];
    //return XPDataTypeBoolean == [self dataType];
}


- (BOOL)isNumericValue {
    return [self isKindOfClass:[XPNumericValue class]];
    //return XPDataTypeNumber == [self dataType];
}


- (BOOL)isStringValue {
    return [self isKindOfClass:[XPStringValue class]];
    //return XPDataTypeString == [self dataType];
}

@end
