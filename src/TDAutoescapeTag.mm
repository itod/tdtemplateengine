//
//  TDAutoescapeTag.m
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 4/7/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDAutoescapeTag.h"
#import <TDTemplateEngine/TDTemplateContext.h>

@implementation TDAutoescapeTag

+ (NSString *)tagName {
    return @"autoescape";
}


+ (TDTagContentType)tagContentType {
    return TDTagContentTypeParent;
}


+ (TDTagExpressionType)tagExpressionType {
    return TDTagExpressionTypeAutoescape;
}


- (void)runInContext:(TDTemplateContext *)ctx {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, self);
    TDAssert(ctx);
    
    BOOL oldEnabled = ctx.autoescape;
    
    ctx.autoescape = _enabled;
    [self renderChildrenInContext:ctx];
    ctx.autoescape = oldEnabled;
}

@end
