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

#import "TDLoopExpression.h"
#import "TDPair.h"
#import "TDObjectValue.h"
#import <TDTemplateEngine/TDTemplateContext.h>

@implementation TDLoopExpression

+ (instancetype)loopExpressionWithVariables:(NSArray *)vars enumeration:(TDEnumeration *)e {
    return [[[self alloc] initWithVariables:vars enumeration:e] autorelease];
}


- (instancetype)initWithVariables:(NSArray *)vars enumeration:(TDEnumeration *)e {
    self = [super init];
    if (self) {
        NSUInteger c = [vars count];
        if (2 == c) {
            self.firstVariable = vars[0];
            self.secondVariable = vars[1];
        } else if (1 == c) {
            self.firstVariable = vars[0];
        } else {
            [NSException raise:@"" format:@""]; // TODO
        }

        self.enumeration = e;
    }
    return self;
}


- (void)dealloc {
    self.firstVariable = nil;
    self.secondVariable = nil;
    self.enumeration = nil;
    [super dealloc];
}


- (NSString *)description {
    NSString *result = nil;
    if (_firstVariable) {
        result = [NSString stringWithFormat:@"%@,%@ in %@", _firstVariable, _secondVariable, _enumeration];
    } else {
        result = [NSString stringWithFormat:@"%@ in %@", _secondVariable, _enumeration];
    }
    return result;
}


- (TDValue *)evaluateInContext:(TDTemplateContext *)ctx {
    TDAssert([_firstVariable length]);
    TDAssert(_enumeration);
    
    id res = [_enumeration evaluateAsObjectInContext:ctx];
    id firstObj = nil;
    id secondObj = nil;

    if ([res isKindOfClass:[TDPair class]]) {
        TDPair *pair = (TDPair *)res;
        firstObj = pair.first;
        secondObj = pair.second;
    } else {
        firstObj = res;
    }
    
    if (_secondVariable) {
        TDAssert([_secondVariable length]);
        [ctx defineVariable:_firstVariable value:firstObj];
        [ctx defineVariable:_secondVariable value:secondObj];
    } else {
        res = firstObj;
        [ctx defineVariable:_firstVariable value:firstObj];
    }
    
    return res ? [TDObjectValue objectValueWithObject:res] : nil;
}

@end
