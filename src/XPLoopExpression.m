//
//  XPLoopExpression.m
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 4/3/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "XPLoopExpression.h"

@implementation XPLoopExpression

+ (instancetype)loopExpressionWithVariable:(NSString *)var enumeration:(id <XPEnumeration>)e {
    return [[[self alloc] initWithVariable:var enumeration:e] autorelease];
}


- (instancetype)initWithVariable:(NSString *)var enumeration:(id <XPEnumeration>)e {
    self = [super init];
    if (self) {
        self.variable = var;
        self.enumeration = e;
    }
    return self;
}


- (void)dealloc {
    self.variable = nil;
    self.enumeration = nil;
    [super dealloc];
}


- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %p %@>", [self class], self, _variable];
}

@end
