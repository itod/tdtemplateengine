//
//  NSString+TDAdditions.m
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 5/20/25.
//  Copyright © 2025 Todd Ditchendorf. All rights reserved.
//

#import <TDTemplateEngine/NSString+TDAdditions.h>
#import <objc/runtime.h>

@implementation NSString (TDAdditions)

- (NSString *)markSafe {
    objc_setAssociatedObject(self, "__html__", @YES, OBJC_ASSOCIATION_RETAIN);
    return self;
}


- (BOOL)isSafe {
    return [objc_getAssociatedObject(self, "__html__") boolValue];
}

@end
