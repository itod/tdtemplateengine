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
    
//    NSStringEncoding enc = NSUTF8StringEncoding;
//    NSUInteger maxByteLen = [str maximumLengthOfBytesUsingEncoding:enc];
//    char zstr[maxByteLen+1]; // +1 for null-term
//    NSUInteger byteLen;
//    NSRange remaining;
//    
//    if (![str getBytes:zstr maxLength:maxByteLen usedLength:&byteLen encoding:enc options:0 range:NSMakeRange(0, str.length) remainingRange:&remaining]) {
//        TDAssert(0);
//    }
//    TDAssert(0 == remaining.length);
//
//    // must make it null-terminated bc -getBytes: does not include terminator
//    zstr[byteLen] = '\0';
//    
//    std::string input(zstr);
//    ReaderCPP reader(input);
    
    ReaderObjC reader(str);
    
    expr = [self expressionOfType:TDTagExpressionTypeDefault fromReader:&reader error:outErr];
    return expr;
}


- (TDExpression *)expressionFromReader:(parsekit::Reader *)reader error:(NSError **)outErr {
    return [self expressionOfType:TDTagExpressionTypeDefault fromReader:reader error:outErr];
}


- (TDExpression *)loopExpressionFromReader:(parsekit::Reader *)reader error:(NSError **)outErr {
    return [self expressionOfType:TDTagExpressionTypeLoop fromReader:reader error:outErr];
}


- (TDExpression *)expressionOfType:(TDTagExpressionType)et fromReader:(parsekit::Reader *)reader error:(NSError **)outErr {
    ExpressionParser p(self);
    p.setTagExpressionType(et);

    TDExpression *expr = [self expressionFromParser:&p reader:reader error:outErr];

    expr = [expr simplify];
    return expr;
}


- (TDExpression *)expressionFromParser:(ExpressionParser *)parser reader:(Reader *)reader error:(NSError **)outErr {
    TDExpression *expr = nil;
    
    try {
        expr = parser->parseExpression(reader);
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
    return expr;
}

@end
