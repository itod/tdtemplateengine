//
//  TDSepTag.m
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 4/7/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDSepTag.h"
#import "TDForLoop.h"
#import <TDTemplateEngine/TDTemplateContext.h>

@implementation TDSepTag

+ (NSString *)tagName {
    return @"sep";
}


+ (TDTagContentType)tagContentType {
    return TDTagContentTypeFull;
}


- (void)runInContext:(TDTemplateContext *)ctx {
    TDForLoop *loop = [ctx resolveVariable:@"forloop"];
    if (loop && !loop.last) {
        [self renderChildrenInContext:ctx];
    }
}

@end
