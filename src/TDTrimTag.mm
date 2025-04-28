//
//  TDTrimTag.m
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 4/7/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDTrimTag.h"
#import <TDTemplateEngine/TDExpression.h>
#import <TDTemplateEngine/TDTemplateContext.h>

@implementation TDTrimTag

+ (NSString *)tagName {
    return @"trim";
}


+ (TDTagType)tagType {
    return TDTagTypeBlock;
}


- (void)dealloc {
    
    [super dealloc];
}


- (void)doTagInContext:(TDTemplateContext *)ctx {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, self);
    TDAssert(ctx);
    
    BOOL oldTrim = ctx.trimLines;
    
    BOOL newTrim = YES;
    
    if (self.expression) {
        BOOL enable = [self.expression evaluateAsBooleanInContext:ctx];
        if (!enable) {
            newTrim = NO;
        }
    }

    ctx.trimLines = newTrim;
    [self renderChildrenInContext:ctx];
    ctx.trimLines = oldTrim;
}

@end
