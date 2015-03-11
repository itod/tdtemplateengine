//
//  TDTrimTag.m
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 4/7/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDTrimTag.h"
#import <TDTemplateEngine/TDExpression.h>

@interface TDTag ()
@property (nonatomic, retain) PKToken *endTagToken;
@end

@implementation TDTrimTag

+ (NSString *)tagName {
    return @"trim";
}


+ (TDTagType)tagType {
    return TDTagTypeBlock;
}


+ (TDTrimType)trimType {
    return TDTrimTypeBoth;
}


- (void)dealloc {
    
    [super dealloc];
}


- (void)doTagInContext:(TDTemplateContext *)ctx {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, self);
    TDAssert(ctx);
    
    TDTrimType oldTrim = ctx.trimType;
    
    TDTrimType newTrim = [[self class] trimType];
    
    if (self.expression) {
        BOOL enable = [self.expression evaluateAsBooleanInContext:ctx];
        if (!enable) {
            newTrim = TDTrimTypeNone;
        }
    }

    NSUInteger lastIdx = [self.children count] - 1;
    NSUInteger childIdx = 0;

    for (TDNode *child in self.children) {
        if (0 == childIdx || childIdx == lastIdx) {
            ctx.trimType = newTrim;
            [child renderInContext:ctx];
            ctx.trimType = oldTrim;
        } else {
            [child renderInContext:ctx];
        }
        ++childIdx;
    }
}

@end
