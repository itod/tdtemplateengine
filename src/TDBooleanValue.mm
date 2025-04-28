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

#import "TDBooleanValue.h"

@implementation TDBooleanValue {
    BOOL _value;
}

+ (TDBooleanValue *)booleanValueWithBoolean:(BOOL)b {
    return [[[self alloc] initWithBoolean:b] autorelease];
}


- (instancetype)initWithBoolean:(BOOL)b {
    if (self = [super init]) {
        _value = b;
    }
    return self;
}


- (NSString *)stringValue {
    return _value ? @"true" : @"false";
}


- (id)objectValue {
    return @(_value);
}


- (double)doubleValue {
    return _value ? 1.0 : 0.0;
}


- (BOOL)boolValue {
    return _value;
}


- (TDDataType)dataType {
    return TDDataTypeBoolean;
}


- (void)display:(NSInteger)level {
    //NSLog(@"%@boolean (%@)", [self indent:level], [self stringValue]);
}


- (NSString *)description {
    return [NSString stringWithFormat:@"<TDBooleanValue %@>", [self stringValue]];
}

@end
