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

#import "TDEnumeration.h"

@interface TDEnumeration ()
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) NSInteger reversed;
@property (nonatomic, retain) NSArray *values;
@end

@implementation TDEnumeration

+ (instancetype)enumerationWithCollection:(id)coll reversed:(BOOL)rev {
    return [[[self alloc] initWithCollection:coll reversed:rev] autorelease];
}


- (instancetype)initWithCollection:(id)coll reversed:(BOOL)rev {
    self = [super init];
    if (self) {
        NSArray *values = nil;
        if ([coll respondsToSelector:@selector(allKeys)]) {
            values = [coll allKeys];
        } else if ([coll respondsToSelector:@selector(allObjects)]) {
            values = [coll allObjects];
        } else {
            TDAssert([coll respondsToSelector:@selector(objectAtIndex:)] && [coll respondsToSelector:@selector(count)]);
            values = coll;
        }
        self.values = values;
        self.reversed = rev;
        self.index = rev ? [coll count] -1 : 0;
    }
    return self;
}


- (void)dealloc {
    self.values = nil;
    [super dealloc];
}


- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %p (%lu of %lu)>", [self class], self, _index, _values.count];
}


- (id)nextObject {
    return [_values objectAtIndex:_reversed ? _index-- : _index++];
}


- (BOOL)hasMore {
    return _reversed ? _index >= 0 : _index < [_values count];
}

@end
