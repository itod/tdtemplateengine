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

#import "XPCollectionExpression.h"
#import <TDTemplateEngine/TDTemplateContext.h>

@interface XPCollectionExpression ()
@property (nonatomic, retain) NSArray *keys;
@property (nonatomic, assign) BOOL started;
@end

@implementation XPCollectionExpression

+ (instancetype)collectionExpressionWithVariable:(NSString *)var {
    return [[[self alloc] initWithVariable:var] autorelease];
}


- (instancetype)initWithVariable:(NSString *)var {
    self = [super init];
    if (self) {
        self.var = var;
    }
    return self;
}


- (void)dealloc {
    self.var = nil;
    self.keys = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark XPEnumeration

- (void)beginInContext:(TDTemplateContext *)ctx {
    TDAssert([_var length]);
    id col = [ctx resolveVariable:_var];
    
    if ([col isKindOfClass:[NSArray class]]) {
        self.keys = nil;
        self.values = col;
    } else if ([col isKindOfClass:[NSSet class]]) {
        self.keys = nil;
        self.values = [col allObjects];
    } else if ([col isKindOfClass:[NSDictionary class]]) {
        self.keys = [col allKeys];
        self.values = [col allObjects];
    } else {
        [NSException raise:@"" format:@""]; // TODO
    }

    self.current = 0;
}


- (id)evaluateInContext:(TDTemplateContext *)ctx; {
    if (!_started) {
        [self beginInContext:ctx];
        self.started = YES;
    }
    
    id result = nil;
    if ([self hasMore]) {
        if (_keys) {
            id key = _keys[self.current];
            TDAssert(key);
            id val = self.values[self.current];
            TDAssert(val);
            result = @[key, val];
        } else {
            result = self.values[self.current];
            TDAssert(result);
        }
        self.current++;
    } else {
        self.started = NO;
    }
    
    return result;
}

@end
