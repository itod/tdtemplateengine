//
//  TDTextNode.m
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDTextNode.h"
#import "TDFragment.h"

@implementation TDTextNode

- (NSString *)renderInContext:(id <TDTemplateContext>)ctx {
    NSParameterAssert(ctx);
    TDAssert([self.fragment.string length]);
    
    NSString *s = self.fragment.string;
    return s;
}

@end
