//
//  XPNumericValue.m
//  XPath
//
//  Created by Todd Ditchendorf on 7/14/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPNumericValue.h"

@implementation XPNumericValue{
    double _value;
}

+ (XPNumericValue *)numericValueWithString:(NSString *)s {
    return [[[self alloc] initWithString:s] autorelease];
}


+ (XPNumericValue *)numericValueWithNumber:(double)n {
    return [[[self alloc] initWithNumber:n] autorelease];
}


- (id)initWithString:(NSString *)s {
    return [self initWithNumber:XPNumberFromString(s)];
}


- (id)initWithNumber:(double)n {
    if (self = [super init]) {
        _value = n;
    }
    return self;
}


- (NSString *)asString {
    // TODO
    return [[NSNumber numberWithDouble:_value] stringValue];
}


- (double)asNumber {
    return _value;
}


- (BOOL)asBoolean {
    return (_value != 0.0 && !isnan(_value));
}


- (NSInteger)dataType {
    return XPDataTypeNumber;
}


- (void)display:(NSInteger)level {
    //NSLog(@"%@number (%@)", [self indent:level], [self asString]);
}


- (NSString *)description {
    return [NSString stringWithFormat:@"<XPNumericValue %p %@>", self, [self asString]];
}

@end
