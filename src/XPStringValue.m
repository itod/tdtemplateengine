//
//  XPStringValue.m
//  XPath
//
//  Created by Todd Ditchendorf on 7/14/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPStringValue.h"

@interface XPStringValue ()
@property (nonatomic, copy) NSString *value;
@end

@implementation XPStringValue

+ (XPStringValue *)stringValueWithString:(NSString *)s {
    return [[[self alloc] initWithString:s] autorelease];
}


- (id)initWithString:(NSString *)s {
    if (self = [super init]) {
        self.value = (!s ? @"" : s);
    }
    return self;
}


- (void)dealloc {
    self.value = nil;
    [super dealloc];
}


- (NSString *)asString {
    return _value;
}


- (double)asNumber {
    return XPNumberFromString(_value);
}


- (BOOL)asBoolean {
    return [_value length] > 0;
}


- (NSInteger)dataType {
    return XPDataTypeString;
}


- (BOOL)isEqualToStringValue:(XPStringValue *)v {
    return [_value isEqualToString:v->_value];
}

@end
