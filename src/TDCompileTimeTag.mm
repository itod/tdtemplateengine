//
//  TDCompileTimeTag.m
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 5/15/25.
//  Copyright © 2025 Todd Ditchendorf. All rights reserved.
//

#import "TDCompileTimeTag.h"

@implementation TDCompileTimeTag

- (void)compileInContext:(TDTemplateContext *)staticContext {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
}


- (void)doTagInContext:(TDTemplateContext *)ctx {
    // runtime is a noop
}

@end
