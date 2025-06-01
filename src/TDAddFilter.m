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

#import <TDTemplateEngine/TDAddFilter.h>
#import <TDTemplateEngine/TDExpression.h>

@implementation TDAddFilter

+ (NSString *)filterName {
    return @"add";
}


- (id)runFilter:(TDExpression *)expr withArgs:(NSArray<TDExpression *> *)args inContext:(TDTemplateContext *)ctx {
    [self validateArgs:args min:1 max:1];

    id res = nil;
    
    id input = [expr evaluateAsObjectInContext:ctx];
    
    if ([input respondsToSelector:@selector(integerValue)]) {
        NSInteger i = [input integerValue];
        NSInteger j = lround([args.firstObject evaluateAsNumberInContext:ctx]);
        res = @(i + j);
    } else if ([input isKindOfClass:[NSString class]]) {
        NSString *rhs = [args.firstObject evaluateAsStringInContext:ctx];
        res = [NSString stringWithFormat:@"%@%@", input, rhs];
    } else if ([input isKindOfClass:[NSArray class]]) {
        res = [NSMutableArray arrayWithArray:input];
        id arg = [args.firstObject evaluateAsObjectInContext:ctx];
        if ([arg isKindOfClass:[NSArray class]]) {
            [res addObjectsFromArray:arg];
        } else {
            [res addObject:arg];
        }
    } else if ([input isKindOfClass:[NSDictionary class]]) {
        id arg = [args.firstObject evaluateAsObjectInContext:ctx];
        if ([arg isKindOfClass:[NSDictionary class]]) {
            res = [NSMutableDictionary dictionaryWithDictionary:input];
            [res addEntriesFromDictionary:arg];
        }
    }
    
    return res;
}

@end
