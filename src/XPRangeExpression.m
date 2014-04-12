// The MIT License (MIT)
//
// Copyright (c) 2014 Todd Ditchendorf
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "XPRangeExpression.h"

@interface XPRangeExpression ()
@property (nonatomic, assign) BOOL started;
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


//- (NSString *)description {
//    // be very careful trying to print `self.values` here. seems to cause infinite loop while stepping thru in debugger
//    return [NSString stringWithFormat:@"%@ to %@", self.values[0], [self.values lastObject]];
//}


#pragma mark -
#pragma mark XPEnumeration

- (void)beginInContext:(TDTemplateContext *)ctx {
    NSInteger start = [_start evaluateAsNumberInContext:ctx];
    NSInteger stop = [_stop evaluateAsNumberInContext:ctx];
    NSInteger step = [_by evaluateAsNumberInContext:ctx];

    step = 0 == step ? 1 : step;
    step = start > stop ? -labs(step) : step;
    
    NSMutableArray *range = [NSMutableArray array];
    NSInteger val = 0;
    
    BOOL(^test)(NSInteger);
    
    if (step > 0) {
        test = ^BOOL(NSInteger val) {
            return val <= stop;
        };
    } else if (step < 0) {
        test = ^BOOL(NSInteger val) {
            return val >= stop;
        };
    } else {
        [NSException raise:@"" format:@""]; // TODO
        return;
    }

    // For a positive step, the contents of a range r are determined by the formula
    // `r[i] = start + step*i` where `i >= 0 && r[i] < stop`.
    
    // For a negative step, the contents of the range are still determined by the formula
    // `r[i] = start + step*i`, but the constraints are `i >= 0 && r[i] > stop`.

    for (NSInteger i = 0; ; ++i) {
        val = start + step*i;
        if (i >= 0 && test(val)) {
            [range addObject:@(val)];
        } else {
            break;
        }
    }

    self.values = range;
    self.current = 0;
}


- (id)evaluateInContext:(TDTemplateContext *)ctx; {
    if (!_started) {
        [self beginInContext:ctx];
        self.started = YES;
    }
    
    id result = nil;
    if ([self hasMore]) {
        result = self.values[self.current];
        self.current++;
    } else {
        self.started = NO;
    }
    
    return result;
}

@end
