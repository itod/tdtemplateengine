//
//  TDEvaluator.m
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import <TDTemplateEngine/TDEvaluator.h>
#import <TDTemplateEngine/TDTemplateContext.h>

@implementation TDEvaluator

- (BOOL)evaluateAsBoolean:(NSArray *)toks inContext:(TDTemplateContext *)ctx {
    double d = [self evaluateAsDouble:toks inContext:ctx];
    BOOL result = d != 0.0;
    return result;
}


- (double)evaluateAsDouble:(NSArray *)toks inContext:(TDTemplateContext *)ctx {
    return [[toks firstObject] doubleValue]; // TODO
}


- (NSString *)evaluateAsString:(NSArray *)toks inContext:(TDTemplateContext *)ctx {
    return [[toks firstObject] stringValue]; // TODO
}

@end
