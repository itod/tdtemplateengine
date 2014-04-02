//
//  XPRangeExpression.m
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 4/2/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "XPRangeExpression.h"

@interface XPRangeExpression ()
@property (nonatomic, assign) NSInteger current;
@end

@implementation XPRangeExpression

+ (instancetype)rangeExpressionWithStart:(XPExpression *)start stop:(XPExpression *)stop by:(XPExpression *)by {
    return [[[self alloc] initWithStart:start stop:stop by:by] autorelease];
}


- (instancetype)initWithStart:(XPExpression *)start stop:(XPExpression *)stop by:(XPExpression *)by {
    self = [super init];
    if (self) {
        self.start = start;
        self.stop = stop;
        self.by = by;
    }
    return self;
}


- (void)dealloc {
    self.start = nil;
    self.stop = nil;
    self.by = nil;
    [super dealloc];
}


- (id)next {
    return nil;
}


- (BOOL)hasMore {
    return NO;
}

@end
