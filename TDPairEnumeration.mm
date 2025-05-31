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

#import "TDPairEnumeration.h"

@interface TDEnumeration ()
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) BOOL reversed;
@property (nonatomic, retain) NSArray *values;
@end

@interface TDPairEnumeration ()
@property (nonatomic, retain) NSArray *keys;
@end

@implementation TDPairEnumeration

+ (instancetype)enumerationWithCollection:(id)coll reversed:(BOOL)rev {
    return [[[self alloc] initWithCollection:coll reversed:rev] autorelease];
}


- (instancetype)initWithCollection:(id)coll reversed:(BOOL)rev {
    self = [super init];
    if (self) {
        TDAssert([coll isKindOfClass:[NSDictionary class]]);
        
        self.keys = [coll allKeys];
        self.values = [coll allValues];
        self.reversed = rev;
        self.index = rev ? [coll count] -1 : 0;
    }
    return self;
}


- (void)dealloc {
    self.keys = nil;
    [super dealloc];
}


- (id)nextObject {
    return @[self.keys[self.index], self.values[self.reversed ? self.index-- : self.index++]];
}

@end
