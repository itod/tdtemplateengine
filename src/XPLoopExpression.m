//
//  XPLoopExpression.m
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 4/3/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "XPLoopExpression.h"

@implementation XPLoopExpression

+ (instancetype)loopExpressionWithVarName:(NSString *)var enumeration:(id <XPEnumeration>)e {
    return [[[self alloc] initWithVarName:var enumeration:e] autorelease];
}


- (instancetype)initWithVarName:(NSString *)var enumeration:(id <XPEnumeration>)e {
    self = [super init];
    if (self) {
        self.var = var;
        self.enumeration = e;
    }
    return self;
}


- (void)dealloc {
    self.var = nil;
    self.enumeration = nil;
    [super dealloc];
}

@end
