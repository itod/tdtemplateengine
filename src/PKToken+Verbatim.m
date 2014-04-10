//
//  PKToken+Verbatim.m
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 4/10/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "PKToken+Verbatim.h"
#import <objc/runtime.h>

@implementation PKToken (Verbatim)

- (void)setVerbatimString:(NSString *)str {
    objc_setAssociatedObject(self, @selector(verbatimString), str, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (NSString *)verbatimString {
    return objc_getAssociatedObject(self, @selector(verbatimString));
}

@dynamic verbatimString;
@end
