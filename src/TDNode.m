//
//  TDNode.m
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDNode.h"

@interface TDNode ()
@property (nonatomic, assign) BOOL createsScope;
@end

@implementation TDNode

- (instancetype)initWithFragment:(NSString *)frag {
    self = [super init];
    if (self) {
        self.createsScope = NO;
        [self processFragment:frag];
    }
    return self;
}


- (void)processFragment:(NSString *)frag {
    
}


- (void)enterScope {
    
}


- (NSString *)renderInContext:(id)ctx {
    return nil;
}


- (void)exitScope {
    
}


- (NSString *)renderChildren:(NSArray *)children inContext:(id)ctx {
    children = children ? children : self.children;
    
    NSMutableString *buff = [NSMutableString string];
    for (TDNode *child in children) {
        NSString *childStr = [child renderInContext:ctx];
        if (childStr) {
            [buff appendString:childStr];
        }
    }

    return buff;
}

@end
