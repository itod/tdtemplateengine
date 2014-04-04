//
//  XPLoopExpression.m
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 4/3/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "XPLoopExpression.h"
#import <TDTemplateEngine/TDTemplateContext.h>

@implementation XPLoopExpression

+ (instancetype)loopExpressionWithVariable:(NSString *)var enumeration:(XPExpression *)e {
    return [[[self alloc] initWithVariable:var enumeration:e] autorelease];
}


- (instancetype)initWithVariable:(NSString *)var enumeration:(XPExpression *)e {
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
    return [NSString stringWithFormat:@"%@ in %@", _variable, _enumeration];
//    return [NSString stringWithFormat:@"<%@ %p `%@ in %@`>", [self class], self, _variable, _enumeration];
}


- (id)evaluateInContext:(TDTemplateContext *)ctx {
    TDAssert([_variable length]);
    TDAssert(_enumeration);
    
    id val = [_enumeration evaluateInContext:ctx];
    [ctx defineVariable:_variable withValue:val];
    return val;
}

@end
