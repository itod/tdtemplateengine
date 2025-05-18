//
//  TDPair.m
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 5/17/25.
//  Copyright © 2025 Todd Ditchendorf. All rights reserved.
//

#import "TDPair.h"

@interface TDPair ()
@property (nonatomic, retain, readwrite) id first;
@property (nonatomic, retain, readwrite) id second;
@end

@implementation TDPair

+ (instancetype)pairWithFirst:(id)first second:(id)second {
    return [[[TDPair alloc] initWithFirst:first second:second] autorelease];
}


- (instancetype)initWithFirst:(id)first second:(id)second {
    self = [super init];
    if (self) {
        self.first = first;
        self.second = second;
    }
    return self;
}


- (void)dealloc {
    self.first = nil;
    self.second = nil;
    [super dealloc];
}


- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %p %@ %@>", [self class], self, _first, _second];
}


- (BOOL)isEqual:(id)that {
    if (![that isKindOfClass:[TDPair class]]) {
        return NO;
    }
    return [self isEqualToPair:that];
}


- (BOOL)isEqualToPair:(TDPair *)that {
    return [_first isEqual:that->_first] && [_second isEqual:that->_second];
}

@end
