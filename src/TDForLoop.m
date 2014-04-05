//
//  TDForLoop.m
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 4/4/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDForLoop.h"

@implementation TDForLoop

- (instancetype)init {
    self = [super init];
    if (self) {
        self.counter = 1;
        self.counter0 = 0;
        self.first = YES;
        self.last = NO;
    }
    return self;
}


- (void)dealloc {
    self.parentloop = nil;
    [super dealloc];
}

@end
