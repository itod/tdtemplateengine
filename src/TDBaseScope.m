//
//  TDBaseScope.m
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 3/31/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDBaseScope.h"

@implementation TDBaseScope

- (instancetype)init {
    self = [super init];
    if (self) {
        self.vars = [NSMutableDictionary dictionary];
    }
    return self;
}


- (void)dealloc {
    self.vars = nil;
    self.enclosingScope = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark TDScope

- (id)resolveVariable:(NSString *)name {
    NSParameterAssert([name length]);
    TDAssert(_vars);
    id result = _vars[name];
    
    if (!result && self.enclosingScope) {
        result = [self.enclosingScope resolveVariable:name];
    }
    
    return result;
}


- (void)defineVariable:(NSString *)name withValue:(id)value {
    NSParameterAssert([name length]);
    NSParameterAssert(value);
    TDAssert(_vars);
    _vars[name] = value;
}

@synthesize enclosingScope;
@end
