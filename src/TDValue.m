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

#import "TDValue.h"
#import "TDBooleanValue.h"
#import "TDNumericValue.h"
#import "TDStringValue.h"
#import "TDObjectValue.h"
#import "TDTemplateContext.h"
#import "TDParser.h"

TDValue *TDValueFromObject(id obj) {
    //NSCAssert(obj, @""); obj may be nil
    
    TDValue *result = nil;
    if ([obj isKindOfClass:[NSString class]]) {
        result = [TDStringValue stringValueWithString:obj];
    } else if ([obj isKindOfClass:[NSNumber class]]) {
        result = [TDNumericValue numericValueWithNumber:[obj doubleValue]];
    } else {
        result = [TDObjectValue objectValueWithObject:obj];
    }
    return result;
}


double TDNumberFromString(NSString *s) {
    return [s doubleValue];
}


@implementation TDValue

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %p `%@`>", [self class], self, [self objectValue]];
}


- (TDValue *)evaluateInContext:(TDTemplateContext *)ctx {
    return self;
}


- (TDExpression *)simplify {
    return self;
}


- (id)objectValue {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return nil;
}


- (NSString *)stringValue {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return nil;
}


- (double)doubleValue {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return NO;
}


- (BOOL)boolValue {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return NO;
}


- (BOOL)isEqualToValue:(TDValue *)other {

    if ([self isNullValue] || [other isNullValue]) {
        return [self isNullValue] == [other isNullValue];
    }
    
    if ([self isBooleanValue] || [other isBooleanValue]) {
        return [self boolValue] == [other boolValue];
    }
    
    if ([self isNumericValue] || [other isNumericValue]) {
        return [self doubleValue] == [other doubleValue];
    }
    
    return [[self stringValue] isEqualToString:[other stringValue]];
}


- (BOOL)isNotEqualToValue:(TDValue *)other {

    return ![self isEqualToValue:other];
}


- (BOOL)compareToValue:(TDValue *)other usingOperator:(NSInteger)op {

    if (op == TD_TOKEN_KIND_EQ) return [self isEqualToValue:other];
    if (op == TD_TOKEN_KIND_NE) return [self isNotEqualToValue:other];
        
    return [self compareNumber:[self doubleValue] toNumber:[other doubleValue] usingOperator:op];
}


- (BOOL)compareNumber:(double)x toNumber:(double)y usingOperator:(NSInteger)op {
    switch (op) {
        case TD_TOKEN_KIND_LT:
            return x < y;
        case TD_TOKEN_KIND_LE:
            return x <= y;
        case TD_TOKEN_KIND_GT:
            return x > y;
        case TD_TOKEN_KIND_GE:
            return x >= y;
        default:
            return NO;
    }
}


- (BOOL)isBooleanValue {
    return TDDataTypeBoolean == [self dataType];
}


- (BOOL)isNumericValue {
    return TDDataTypeNumber == [self dataType];
}


- (BOOL)isStringValue {
    return TDDataTypeString == [self dataType];
}


- (BOOL)isNullValue {
    return [NSNull null] == self.objectValue;
}

@end
