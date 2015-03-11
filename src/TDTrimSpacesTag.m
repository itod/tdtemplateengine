//
//  TDTrimSpacesTag.m
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 4/7/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDTrimSpacesTag.h"
#import <TDTemplateEngine/TDTemplateContext.h>
#import <TDTemplateEngine/TDExpression.h>

@interface TDTag ()
@property (nonatomic, retain) PKToken *endTagToken;
@end

@implementation TDTrimSpacesTag

+ (NSString *)tagName {
    return @"trimspaces";
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
    
    TDTrimType oldTrim = ctx.trimType;
    
    TDTrimType newTrim = TDTrimTypeSpaces;
    
    if (self.expression) {
        BOOL enable = [self.expression evaluateAsBooleanInContext:ctx];
        if (!enable) {
            newTrim = TDTrimTypeNone;
        }
    }
    
    ctx.trimType = newTrim; {
        [self renderChildrenInContext:ctx];
    } ctx.trimType = oldTrim;
}

@end
