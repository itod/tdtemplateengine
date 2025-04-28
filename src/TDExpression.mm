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

#import <TDTemplateEngine/TDExpression.h>
#import <TDTemplateEngine/TDTemplateContext.h>
#import "TDValue.h"
#import "TDParser.h"
#import <PEGKit/PKTokenizer.h>

@implementation TDExpression

- (void)dealloc {

    [super dealloc];
}


- (TDValue *)evaluateInContext:(TDTemplateContext *)ctx {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return nil;
}


- (BOOL)evaluateAsBooleanInContext:(TDTemplateContext *)ctx {
    return [[self evaluateInContext:ctx] boolValue];
}


- (double)evaluateAsNumberInContext:(TDTemplateContext *)ctx {
    return [[self evaluateInContext:ctx] doubleValue];
}


- (NSString *)evaluateAsStringInContext:(TDTemplateContext *)ctx {
    return [[self evaluateInContext:ctx] stringValue];
}


- (id)evaluateAsObjectInContext:(TDTemplateContext *)ctx {
    return [[self evaluateInContext:ctx] objectValue];
}


- (BOOL)isValue {
    return [self isKindOfClass:[TDValue class]];
}


- (TDExpression *)simplify {
    return self;
}


- (TDDataType)dataType {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return TDDataTypeAny;
}

@end
