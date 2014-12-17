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

#import "TDReplaceFilter.h"

@implementation TDReplaceFilter

+ (NSString *)filterName {
    return @"replace";
}


- (id)doFilter:(id)input withArguments:(NSArray *)args {
    TDAssert(input);
    
    [self validateArguments:args min:2 max:3];
    
    NSString *inStr = TDStringFromObject(input);
    
    NSString *searchPat = args[0];
    NSString *replacePat = args[1];
    
    NSRegularExpressionOptions opts = NSRegularExpressionCaseInsensitive;
    
    if (3 == [args count]) {
        NSString *optStr = args[2];

        if ([optStr length]) {
            if ([optStr rangeOfString:@"i"].length) {
                opts |= NSRegularExpressionCaseInsensitive;
            }
            
            if ([optStr rangeOfString:@"m"].length) {
                opts |= NSRegularExpressionAnchorsMatchLines;
            }
            
            if ([optStr rangeOfString:@"x"].length) {
                opts |= NSRegularExpressionAllowCommentsAndWhitespace;
            }
            
            if ([optStr rangeOfString:@"s"].length) {
                opts |= NSRegularExpressionDotMatchesLineSeparators;
            }
            
            if ([optStr rangeOfString:@"u"].length) {
                opts |= NSRegularExpressionUseUnicodeWordBoundaries;
            }
        }
    }
    
    searchPat = [searchPat stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];

    NSError *err = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:searchPat options:opts error:&err];

    NSString *result = [regex stringByReplacingMatchesInString:inStr options:NSMatchingReportCompletion range:NSMakeRange(0, [inStr length]) withTemplate:replacePat];
 
    return result;
}

@end
