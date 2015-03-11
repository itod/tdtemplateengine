//
//  TDConditionalOutputTag.m
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 4/7/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDConditionalOutputTag.h"
#import <TDTemplateEngine/TDTemplateContext.h>
#import <TDTemplateEngine/TDExpression.h>

@implementation TDConditionalOutputTag

+ (TDTagType)tagType {
    return TDTagTypeEmpty;
}


+ (NSString *)outputString {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return nil;
}


- (void)dealloc {
    
    [super dealloc];
}


- (void)doTagInContext:(TDTemplateContext *)ctx {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, self);
    TDAssert(ctx);
    
    NSUInteger count = 1;
    
    if (self.expression) {
        count = [self.expression evaluateAsNumberInContext:ctx];
    }
    
    TDTrimType oldTrim = ctx.trimType;
    
    NSString *output = [[self class] outputString];

    ctx.trimType = TDTrimTypeNone; {
        
        for (NSUInteger i = 0; i < count; ++i) {
            [ctx writeString:output];
        }
        
    } ctx.trimType = oldTrim;
}

@end
