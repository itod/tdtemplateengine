//
//  XPBooleanValue.m
//  XPath
//
//  Created by Todd Ditchendorf on 7/12/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPBooleanValue.h"

@implementation XPBooleanValue {
    BOOL _value;
}

+ (XPBooleanValue *)booleanValueWithBoolean:(BOOL)b {
    return [[[self alloc] initWithBoolean:b] autorelease];
}


- (id)initWithBoolean:(BOOL)b {
    if (self = [super init]) {
        _value = b;
    }
    return self;
}


- (NSString *)asString {
    return _value ? @"true" : @"false";
}


- (double)asNumber {
    return _value ? 1.0 : 0.0;
}


- (BOOL)asBoolean {
    return _value;
}


- (NSInteger)dataType {
    return XPDataTypeBoolean;
}


- (void)display:(NSInteger)level {
    //NSLog(@"%@boolean (%@)", [self indent:level], [self asString]);
}


- (NSString *)description {
    return [NSString stringWithFormat:@"<XPBooleanValue %@>", [self asString]];
}

@end
