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

#import "TDTemplateEngine+ExpressionSupport.h"
#import "TDExpression.h"

#import <ParseKitCPP/Reader.hpp>
#import "ExpressionParser.hpp"

using namespace parsekit;
using namespace templateengine;

@implementation TDTemplateEngine (ExpressionSupport)

- (TDExpression *)expressionFromString:(NSString *)str error:(NSError **)outErr {
    TDExpression *expr = nil;
    
    NSUInteger strLen = str.length;
    
    NSStringEncoding enc = NSUTF8StringEncoding;
    NSUInteger maxByteLen = [str maximumLengthOfBytesUsingEncoding:enc];
    char zstr[maxByteLen+1];
    NSUInteger byteLen;
    NSRange remaining;
    
    // TODO make while loop and check `remaining`
    if ([str getBytes:zstr maxLength:maxByteLen usedLength:&byteLen encoding:enc options:0 range:NSMakeRange(0, strLen) remainingRange:&remaining]) {
        // must make it null-terminated bc -getBytes: does not include NULL.
        zstr[byteLen] = NULL;
        
        std::string input(zstr);
        Reader reader(input);
        
        expr = [self expressionFromReader:&reader error:outErr];
    }
    
    return expr;
}


- (TDExpression *)expressionFromReader:(Reader *)reader error:(NSError **)outErr {
    ExpressionParser p(self);
    
    TDExpression *expr = nil;
    
    try {
        expr = p.parse(reader);
    } catch (ParseException& ex) {
        if (outErr) {
            NSError *err = [NSError errorWithDomain:@"TDTemplateEngine"
                                               code:0
                                           userInfo:@{
                NSLocalizedDescriptionKey: [NSString stringWithUTF8String:ex.message().c_str()],
            }];
            *outErr = err;
        }
    }

    expr = [expr simplify];
    return expr;
}


- (TDExpression *)loopExpressionFromReader:(Reader *)reader error:(NSError **)outErr {
    ExpressionParser p(self);
    p.setDoLoopExpr(true);
    TDExpression *expr = nil;
    
    try {
        expr = p.parse(reader);
    } catch (ParseException& ex) {
        if (outErr) {
            NSError *err = [NSError errorWithDomain:@"TDTemplateEngine"
                                               code:0
                                           userInfo:@{
                NSLocalizedDescriptionKey: [NSString stringWithUTF8String:ex.message().c_str()],
            }];
            *outErr = err;
        }
    }
    p.setDoLoopExpr(false);
    
    expr = [expr simplify];
    return expr;
}

@end
