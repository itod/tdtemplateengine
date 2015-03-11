//
//  TDBlockTag.m
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 4/7/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDBlockTag.h"
#import <TDTemplateEngine/TDTemplateContext.h>

@implementation TDBlockTag

+ (NSString *)tagName {
    return @"block";
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

    ctx.blockDepth++;

    [self renderChildrenInContext:ctx];
    
    ctx.blockDepth--;
}

@end
