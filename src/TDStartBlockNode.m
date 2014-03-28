//
//  TDStartBlockNode.m
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDStartBlockNode.h"

@implementation TDStartBlockNode

- (instancetype)initWithFragment:(TDFragment *)frag {
    self = [super init];
    if (self) {
        self.createsScope = YES;
    }
    return self;
}

@end
