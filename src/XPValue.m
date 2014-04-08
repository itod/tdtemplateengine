// The MIT License (MIT)
//
// Copyright (c) 2014 Todd Ditchendorf
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "XPValue.h"
#import "XPBooleanValue.h"
#import "XPNumericValue.h"
#import "XPStringValue.h"
#import "XPObjectValue.h"
#import "TDTemplateContext.h"
#import "XPParser.h"

XPValue *XPValueFromObject(id obj) {
    assert(obj);
    
    XPValue *result = nil;
    if ([obj isKindOfClass:[NSString class]]) {
        result = [XPStringValue stringValueWithString:obj];
    } else if ([obj isKindOfClass:[NSNumber class]]) {
        result = [XPNumericValue numericValueWithNumber:[obj doubleValue]];
    } else {
        result = [XPObjectValue objectValueWithObject:obj];
    }
    return result;
}


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


- (NSString *)stringValue {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return NO;
}


- (double)doubleValue {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return NO;
}


- (BOOL)boolValue {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return NO;
}


- (BOOL)isEqualToValue:(XPValue *)other {

    if ([self isBooleanValue] || [other isBooleanValue]) {
        return [self boolValue] == [other boolValue];
    }
    
    if ([self isNumericValue] || [other isNumericValue]) {
        return [self doubleValue] == [other doubleValue];
    }
    
    return [[self stringValue] isEqualToString:[other stringValue]];
}


- (BOOL)isNotEqualToValue:(XPValue *)other {

    return ![self isEqualToValue:other];
}


- (BOOL)compareToValue:(XPValue *)other usingOperator:(NSInteger)op {

    if (op == XP_TOKEN_KIND_EQ) return [self isEqualToValue:other];
    if (op == XP_TOKEN_KIND_NE) return [self isNotEqualToValue:other];
        
    return [self compareNumber:[self doubleValue] toNumber:[other doubleValue] usingOperator:op];
}


- (NSInteger)inverseOperator:(NSInteger)op {
    switch (op) {
        case XP_TOKEN_KIND_LT:
            return XP_TOKEN_KIND_GT;
        case XP_TOKEN_KIND_LE:
            return XP_TOKEN_KIND_GE;
        case XP_TOKEN_KIND_GT:
            return XP_TOKEN_KIND_LT;
        case XP_TOKEN_KIND_GE:
            return XP_TOKEN_KIND_LE;
        default:
            return op;
    }
}


- (BOOL)compareNumber:(double)x toNumber:(double)y usingOperator:(NSInteger)op {
    switch (op) {
        case XP_TOKEN_KIND_LT:
            return x < y;
        case XP_TOKEN_KIND_LE:
            return x <= y;
        case XP_TOKEN_KIND_GT:
            return x > y;
        case XP_TOKEN_KIND_GE:
            return x >= y;
        default:
            return NO;
    }
}


- (BOOL)isBooleanValue {
    return XPDataTypeBoolean == [self dataType];
}


- (BOOL)isNumericValue {
    return XPDataTypeNumber == [self dataType];
}


- (BOOL)isStringValue {
    return XPDataTypeString == [self dataType];
}

@end
