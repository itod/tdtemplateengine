//
//  XPEnumeration.m
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 4/4/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "XPEnumeration.h"

@implementation XPEnumeration

- (void)dealloc {
    self.values = nil;
    [super dealloc];
}


- (BOOL)hasMore {
    return _current < [_values count];
}

@end
