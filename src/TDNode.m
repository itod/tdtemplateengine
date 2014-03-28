//
//  TDNode.m
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDNode.h"
#import "TDFragment.h"

@interface TDNode ()

@end

@implementation TDNode

+ (instancetype)nodeWithFragment:(TDFragment *)frag {
    return [[[self alloc] initWithFragment:frag] autorelease];
}


- (instancetype)initWithFragment:(TDFragment *)frag {
    NSParameterAssert(frag);
    self = [super init];
    if (self) {
        self.fragment = frag;
        self.children = [NSMutableArray array];
        self.createsScope = NO;
        [self processFragment:frag];
    }
    return self;
}


- (void)dealloc {
    self.fragment = nil;
    self.children = nil;
    [super dealloc];
}


- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %p>", [self class], self];
}


#pragma mark -
#pragma mark Public

- (void)processFragment:(TDFragment *)frag {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
}


- (NSString *)renderInContext:(id <TDTemplateContext>)ctx {
    //NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);

    return [self renderChildren:_children inContext:ctx];
}


- (void)enterScope {
    
}


- (void)exitScope {
    
}


#pragma mark -
#pragma mark Private

- (NSString *)renderChildren:(NSArray *)children inContext:(id <TDTemplateContext>)ctx {
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
