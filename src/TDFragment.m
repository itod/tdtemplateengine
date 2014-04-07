//
//  TDFragment.m
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 4/7/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDFragment.h"

@implementation TDFragment

- (void)dealloc {
    self.verbatimString = nil;
    [super dealloc];
}

@end
