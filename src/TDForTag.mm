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

#import "TDForTag.h"
#import "TDForLoop.h"
#import <TDTemplateEngine/TDTemplateContext.h>

#import "TDExpression.h"
#import "TDEnumeration.h"
#import "TDPairEnumeration.h"
#import "TDSkipException.h"

#define VARIABLE_NAME @"forloop"

@implementation TDForTag

+ (NSString *)tagName {
    return @"for";
}


+ (TDTagContentType)tagContentType {
    return TDTagContentTypeParent;
}


+ (TDTagExpressionType)tagExpressionType {
    return TDTagExpressionTypeFor;
}


- (void)dealloc {
    self.firstVariable = nil;
    self.secondVariable = nil;
    [super dealloc];
}



- (NSString *)description {
    return [NSString stringWithFormat:@"%p for %@", self, self.expression];
}


- (void)runInContext:(TDTemplateContext *)ctx {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, self);
    TDAssert(ctx);
    
    @autoreleasepool {
        id collection = [self.expression evaluateAsObjectInContext:ctx];
        if (![collection count]) return;

        TDForLoop *parentLoop = [ctx resolveVariable:VARIABLE_NAME];
        TDForLoop *currentLoop = [[[TDForLoop alloc] init] autorelease];
        currentLoop.parentloop = parentLoop;

        [ctx defineVariable:VARIABLE_NAME value:currentLoop];

        TDEnumeration *en = ({
            Class cls = _secondVariable ? [TDPairEnumeration class] : [TDEnumeration class];
            [cls enumerationWithCollection:collection reversed:_reversed];
        });

        while ([en hasMore]) {
            id member = [en nextObject];
            
            if (_secondVariable) {
                TDAssert(2 == [member count]);
                [ctx defineVariable:_firstVariable value:[member firstObject]];
                [ctx defineVariable:_secondVariable value:[member lastObject]];
            } else {
                [ctx defineVariable:_firstVariable value:member];
            }
            
            currentLoop.last = ![en hasMore];

            //NSLog(@"rendering body of %@", self);
            @try {
                [self renderChildrenInContext:ctx];
            }
            @catch (TDSkipException *ex) {
                continue;
            }
            @finally {
                currentLoop.counter0++;
                currentLoop.first = NO;
            }
        }
        
        // pop stack
        [ctx defineVariable:VARIABLE_NAME value:parentLoop];
        currentLoop.parentloop = nil;
    }
}

@end
