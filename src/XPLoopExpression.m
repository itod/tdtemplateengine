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

+ (instancetype)loopExpressionWithVariables:(NSArray *)vars enumeration:(XPExpression *)e {
    return [[[self alloc] initWithVariables:vars enumeration:e] autorelease];
}


- (instancetype)initWithVariables:(NSArray *)vars enumeration:(XPExpression *)e {
    self = [super init];
    if (self) {
        NSUInteger c = [vars count];
        if (2 == c) {
            self.keyVariable = vars[0];
            self.valueVariable = vars[1];
        } else if (1 == c) {
            self.keyVariable = nil;
            self.valueVariable = vars[0];
        } else {
            [NSException raise:@"" format:@""]; // TODO
        }

        self.enumeration = e;
    }
    return self;
}


- (void)dealloc {
    self.keyVariable = nil;
    self.valueVariable = nil;
    self.enumeration = nil;
    [super dealloc];
}


- (NSString *)description {
    NSString *result = nil;
    if (_keyVariable) {
        result = [NSString stringWithFormat:@"%@,%@ in %@", _keyVariable, _valueVariable, _enumeration];
    } else {
        result = [NSString stringWithFormat:@"%@ in %@", _valueVariable, _enumeration];
    }
    return result;
}


- (id)evaluateInContext:(TDTemplateContext *)ctx {
    TDAssert([_valueVariable length]);
    TDAssert(_enumeration);
    
    id res = nil;
    if (_keyVariable) {
        TDAssert([_keyVariable length]);
        res = [_enumeration evaluateInContext:ctx];
        TDAssert([res isKindOfClass:[NSArray class]]);
        
    } else {
        res = [_enumeration evaluateInContext:ctx];
        [ctx defineVariable:_valueVariable withValue:res];
    }
    return res;
}

@end
