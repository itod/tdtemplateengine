//
//  TDEvaluator.h
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TDTemplateContext;

@interface TDEvaluator : NSObject

- (BOOL)evaluateAsBoolean:(NSArray *)toks inContext:(TDTemplateContext *)ctx;
- (double)evaluateAsDouble:(NSArray *)toks inContext:(TDTemplateContext *)ctx;
- (NSString *)evaluateAsString:(NSArray *)toks inContext:(TDTemplateContext *)ctx;
@end
