//
//  TDAutoescapeTag.m
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 4/7/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDAutoescapeTag.h"
#import "TDAutoescapeTag.h"
#import <TDTemplateEngine/TDPathExpression.h>
#import <TDTemplateEngine/TDTemplateContext.h>

@implementation TDAutoescapeTag

+ (NSString *)tagName {
    return @"autoescape";
}


+ (TDTagContentType)tagContentType {
    return TDTagContentTypeComplex;
}


- (id)runInContext:(TDTemplateContext *)ctx {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, self);
    TDAssert(ctx);
    
    BOOL oldEscape = ctx.autoescape;
    BOOL newEscape = oldEscape;
    
    BOOL valid = NO;
    if (self.expression) {
        // This is dumb, but we have to match Django's behavior here with a static on or off
        TDPathExpression *path = (id)self.expression;
        if ([path isKindOfClass:[TDPathExpression class]]) {
            if ([path.head isEqualToString:@"on"]) {
                newEscape = YES;
                valid = YES;
            } else if ([path.head isEqualToString:@"off"]) {
                newEscape = NO;
                valid = YES;
            }
        }
    }
    
    if (!valid) {
        [NSException raise:@"TDTemplateException" format:@"`autoescape` tag requires `on` or `off` argument"];
    }

    ctx.autoescape = newEscape;
    [self renderChildrenInContext:ctx];
    ctx.autoescape = oldEscape;

    return nil;
}

@end
