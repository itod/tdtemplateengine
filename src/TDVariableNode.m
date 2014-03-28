//
//  TDVariableNode.m
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDVariableNode.h"

@implementation TDVariableNode

- (void)dealloc {
    self.name = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Public

- (void)processFragment:(NSString *)frag {
    NSParameterAssert([frag length]);
    self.name = frag;
}


- (NSString *)renderInContext:(id)ctx {
    NSParameterAssert(ctx);
    TDAssert([_name length]);
    
    return nil; //[self resolveName:_name inContext:ctx];
}

@end
