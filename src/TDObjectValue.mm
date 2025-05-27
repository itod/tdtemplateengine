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

#import "TDObjectValue.h"

static TDObjectValue *sNullValue = nil;

@interface TDObjectValue ()
@property (nonatomic, retain) id value;
@end

@implementation TDObjectValue

+ (void)initialize {
    if ([TDObjectValue class] == self) {
        sNullValue = [[TDObjectValue alloc] initWithObject:[NSNull null]];
//        sNullValue = [[TDObjectValue alloc] initWithObject:nil];
    }
}


+ (TDObjectValue *)nullValue {
    TDAssert(sNullValue);
    return sNullValue;
}


+ (TDObjectValue *)objectValueWithObject:(id)obj {
    return [[[self alloc] initWithObject:obj] autorelease];
}


- (instancetype)initWithObject:(id)obj {
    self = [super init];
    if (self) {
        self.value = obj;
    }
    return self;
}


- (void)dealloc {
    self.value = nil;
    [super dealloc];
}


- (TDDataType)dataType {
    return TDDataTypeObject;
}


- (id)objectValue {
    return _value;
}


- (NSString *)stringValue {
    NSString *str = @"";
    if (self.isNullValue) {
        str = @""; //@"((null))";
    } else if ([_value isKindOfClass:[NSString class]]) {
        str = _value;
    } else if ([_value respondsToSelector:@selector(count)] && 0 == [_value count]) {
        str = @"";
    } else if ([_value respondsToSelector:@selector(stringValue)]) {
        str = [_value stringValue];
    } else {
        str = [_value description];
    }
    return str;
}


- (double)doubleValue {
    double d = 0.0;
    if ([_value respondsToSelector:@selector(doubleValue)]) {
        d = [_value doubleValue];
    } else {
        d = TDNumberFromString([self stringValue]);
    }
    return d;
}


- (BOOL)boolValue {
    BOOL yn = NO;
    if (self.isNullValue) {
        yn = NO;
    } else if ([_value isKindOfClass:[NSString class]]) {
        yn = [_value length];
    } else if ([_value respondsToSelector:@selector(count)]) {
        yn = [_value count];
    } else if ([_value respondsToSelector:@selector(doubleValue)]) {
        yn = (0.0 != [_value doubleValue] && !isnan([_value doubleValue]));
    } else if ([_value respondsToSelector:@selector(stringValue)]) {
        yn = [[_value stringValue] length];
    } else if (_value != nil) {
        yn = YES;
    }
    return yn;
}

@end
