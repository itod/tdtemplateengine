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
            self.firstVariable = vars[0];
            self.secondVariable = vars[1];
        } else if (1 == c) {
            self.firstVariable = vars[0];
        } else {
            [NSException raise:@"" format:@""]; // TODO
        }

        self.enumeration = e;
    }
    return self;
}


- (void)dealloc {
    self.firstVariable = nil;
    self.secondVariable = nil;
    self.enumeration = nil;
    [super dealloc];
}


- (NSString *)description {
    NSString *result = nil;
    if (_firstVariable) {
        result = [NSString stringWithFormat:@"%@,%@ in %@", _firstVariable, _secondVariable, _enumeration];
    } else {
        result = [NSString stringWithFormat:@"%@ in %@", _secondVariable, _enumeration];
    }
    return result;
}


- (id)evaluateInContext:(TDTemplateContext *)ctx {
    TDAssert([_firstVariable length]);
    TDAssert(_enumeration);
    
    id res = [_enumeration evaluateInContext:ctx];
    id firstObj = nil;
    id secondObj = nil;

    if ([res isKindOfClass:[NSArray class]]) {
        TDAssert(2 == [res count]);
        firstObj = res[0];
        secondObj = res[1];
    } else {
        firstObj = res;
    }
    
    if (_secondVariable) {
        TDAssert([_secondVariable length]);
        [ctx defineVariable:_firstVariable withValue:firstObj];
        [ctx defineVariable:_secondVariable withValue:secondObj];
    } else {
        res = firstObj;
        [ctx defineVariable:_firstVariable withValue:firstObj];
    }
    return res;
}

@end
