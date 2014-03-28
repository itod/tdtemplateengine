//
//  TDNode.m
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDNode.h"

@interface TDNode ()
@end

@implementation TDNode

+ (instancetype)nodeWithFragment:(NSString *)frag {
    return [[[self alloc] initWithFragment:frag] autorelease];
}


- (instancetype)initWithFragment:(NSString *)frag {
    NSParameterAssert([frag length]);
    self = [super init];
    if (self) {
        self.children = [NSMutableArray array];
        self.createsScope = NO;
        [self processFragment:frag];
    }
    return self;
}


- (void)dealloc {
    self.children = nil;
    [super dealloc];
}


- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %p>", [self class], self];
}


#pragma mark -
#pragma mark Public

- (void)processFragment:(NSString *)frag {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
}


- (NSString *)renderInContext:(id)ctx {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return nil;
}


- (void)enterScope {
    
}


- (void)exitScope {
    
}


#pragma mark -
#pragma mark Private

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
