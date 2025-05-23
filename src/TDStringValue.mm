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

#import "TDStringValue.h"

@interface TDStringValue ()
@property (nonatomic, copy) NSString *value;
@end

@implementation TDStringValue

+ (TDStringValue *)stringValueWithString:(NSString *)s {
    return [[[self alloc] initWithString:s] autorelease];
}


- (instancetype)initWithString:(NSString *)s {
    if (self = [super init]) {
        self.value = (!s ? @"" : s);
    }
    return self;
}


- (void)dealloc {
    self.value = nil;
    [super dealloc];
}


- (id)objectValue {
    return _value;
}


- (NSString *)stringValue {
    return _value;
}


#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
- (NSDate *)dateValue {
    return [NSDate dateWithNaturalLanguageString:_value];
}
#pragma GCC diagnostic pop


- (NSDecimalNumber *)decimalValue {
    return [NSDecimalNumber decimalNumberWithString:_value];
}


- (double)doubleValue {
    return TDNumberFromString(_value);
}


- (BOOL)boolValue {
    return [_value length] > 0;
}


- (TDDataType)dataType {
    return TDDataTypeString;
}


- (BOOL)isEqualToStringValue:(TDStringValue *)v {
    return [_value isEqualToString:v->_value];
}

@end
