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

#import "TDCycleTag.h"
#import <TDTemplateEngine/TDTemplateContext.h>
#import <TDTemplateEngine/TDExpression.h>

@implementation TDCycleTag

+ (NSString *)tagName {
    return @"cycle";
}


+ (TDTagContentType)tagContentType {
    return TDTagContentTypeLeaf;
}


+ (TDTagExpressionType)tagExpressionType {
    return TDTagExpressionTypeCycle;
}


- (void)runInContext:(TDTemplateContext *)ctx {
    TDAssert(ctx);
    TDAssert(self.args);
    
    NSString *name = self.name;
    if (!name) {
        name = [TDCycleTag contextKey];
    }
    NSString *idxName = [NSString stringWithFormat:@"%@-idx", name];
    
    // get the current index of this cycle tag, non-existant is the same as 0
    // idx must be stored in the ctx, bc the `resetcycle` tag also interacts with it.
    NSUInteger idx = [[ctx resolveVariable:idxName] unsignedIntValue]; // nil returns 0
    idx = idx % self.args.count;
    
    // increment index for next time
    [ctx defineVariable:idxName value:@(idx+1)];
    
    // eval the value at the current index
    NSString *output = [[self.args objectAtIndex:idx] evaluateAsStringInContext:ctx];
    
    // define current indexed value in context in case it can be used in print tags {{foo}} or ref'ed in resetcycle tags
    [ctx defineVariable:name value:output];
    
    // if not silent, write the current indexed value to stream too
    if (!self.silent) {
        // django docs say cycle vals are autoescaped
        if (ctx.autoescape) {
            output = [ctx escapedStringForString:output];
        }
        
        [ctx writeString:output];
    }
}


+ (NSString *)contextKey {
    return [NSString stringWithFormat:@"__%@__", [TDCycleTag tagName]];
}

@end
