//
//  TDCycleState.m
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 5/30/25.
//  Copyright © 2025 Todd Ditchendorf. All rights reserved.
//

#import "TDCycleState.h"

@interface TDCycleState ()
@property (nonatomic, assign, readwrite) NSUInteger currentIndex;
@property (nonatomic, retain) NSString *currentValue;
@end

@implementation TDCycleState

+ (NSString *)defaultVariableName {
    return @"__cycle__";
}


- (void)dealloc {
    self.currentValue = nil;
    [super dealloc];
}


- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %p (%lu) %@>", [self class], self, _currentIndex, _currentValue];
}


- (void)reset {
    self.currentIndex = 0;
    self.currentValue = nil;
}


- (void)update:(NSString *)value {
    self.currentValue = value;
    ++self.currentIndex;
}


- (NSString *)stringValue {
    return _currentValue;
}


@end
