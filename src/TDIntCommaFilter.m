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

#import "TDIntCommaFilter.h"
#import <TDTemplateEngine/TDExpression.h>

@implementation TDIntCommaFilter

+ (NSString *)filterName {
    return @"intcomma";
}


- (id)runFilter:(TDExpression *)expr withArgs:(NSArray<TDExpression *> *)args inContext:(TDTemplateContext *)ctx {
    NSString *str = [expr evaluateAsStringInContext:ctx];
    NSString *res = str;
    
    NSUInteger oldLen = str.length;
    if (oldLen) {
        
        unichar old[oldLen];
        [str getCharacters:old];
        
        NSUInteger newLen = 0;
        unichar rev[oldLen << 1];
        
        for (NSUInteger i = 1; i <= oldLen; i++) {
            rev[newLen++] = old[oldLen - i];
            if (i != oldLen && 0 == i % 3) {
                rev[newLen++] = ',';
            }
        }
        
        unichar fwd[newLen];
        for (NSUInteger i = 0; i < newLen; i++) {
            fwd[i] = rev[newLen - (i+1)];
        }
        
        res = [NSString stringWithCharacters:fwd length:newLen];
    }
    
    return res;
}

@end
