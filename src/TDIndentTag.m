//
//  TDBlockTag.m
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 4/7/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDIndentTag.h"
#import <TDTemplateEngine/TDTemplateContext.h>

@implementation TDIndentTag

+ (NSString *)tagName {
    return @"indent";
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

    ctx.indentDepth++;

    // leading indent WS
//    {
//        NSMutableString *str = [NSMutableString string];
//        for (NSUInteger depth = 0; depth < ctx.indentDepth; ++depth) {
//            [str appendString:@"    "];
//        }
//        [ctx.writer appendString:str];
//    }
    
    [self renderChildrenInContext:ctx];
    
    ctx.indentDepth--;
}

@end
