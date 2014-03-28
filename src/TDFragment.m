//
//  TDFragment.m
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDFragment.h"

@implementation TDFragment

- (void)dealloc {
    self.string = nil;
    self.tokens = nil;
    [super dealloc];
}


- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %p %lu `%@`>", [self class], self, _type, _string];
}

@end
