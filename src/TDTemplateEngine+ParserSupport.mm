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

#import "TDTemplateEngine+ParserSupport.h"
#import <TDTemplateEngine/TDExpression.h>
#import <TDTemplateEngine/TDCompileTimeTag.h>
#import <TDTemplateEngine/TDPrintNode.h>

#import <ParseKitCPP/Reader.hpp>
#import "TagParser.hpp"

using namespace parsekit;
using namespace templateengine;

@implementation TDTemplateEngine (ParserSupport)

#pragma mark -
#pragma mark TemplateParser API

- (TDPrintNode *)printNodeFromFragment:(Token)frag withParent:(TDNode *)parent inContext:(TDTemplateContext *)ctx {
    NSParameterAssert(!frag.is_eof());
    NSParameterAssert(parent);
    
    NSString *str = [ctx templateSubstringForToken:frag];
    TDAssert(str.length);
    
    NSError *err = nil;
    TDExpression *expr = [self expressionFromString:str error:&err];
    if (!expr) {
        [NSException raise:TDTemplateEngineErrorDomain format:@"Error while compiling print node expression `%@`\n\n%@", str, [err localizedFailureReason]];
    }
    
    TDAssert(expr);
    TDPrintNode *printNode = [TDPrintNode nodeWithToken:frag parent:parent];
    printNode.expression = expr;
    return printNode;
}


- (TDTag *)tagFromFragment:(Token)frag withParent:(TDNode *)parent inContext:(TDTemplateContext *)ctx {
    NSParameterAssert(!frag.is_eof());
    NSParameterAssert(parent);
    
    NSString *str = [ctx templateSubstringForToken:frag];
    
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
//    ReaderCPP r(input);
    
    ReaderObjC reader(str);
    
    // tokenize
    TDTag *tag = [self tagFromReader:&reader withParent:parent inContext:ctx];
    TDAssert(tag);
    
    if ([tag conformsToProtocol:@protocol(TDCompileTimeTag)]) {
        id <TDCompileTimeTag>cttag = (id <TDCompileTimeTag>)tag;
        [cttag compileInContext:ctx];
    }
    
    return tag;
}


- (TDTag *)tagFromReader:(Reader *)reader withParent:(TDNode *)parent inContext:(TDTemplateContext *)ctx {
    NSParameterAssert(reader);
    
    TagParser parser(self);

    TDTag *tag = nil;
    try {
        tag = parser.parseTag(reader, parent);
    } catch (ParseException& ex) {
        TDAssert(0);
//        if (0) {
//            NSError *err = [NSError errorWithDomain:@"TDTemplateEngine"
//                                               code:0
//                                           userInfo:@{
//                NSLocalizedDescriptionKey: [NSString stringWithUTF8String:ex.message().c_str()],
//            }];
//            //*outErr = err;
//        }
    }
    
    return tag;
}


- (TDTag *)makeTagForName:(NSString *)tagName token:(Token)token parent:(TDNode *)parent {
    Class cls = [self registerdTagClassForName:tagName];
    if (!cls) {
        [NSException raise:TDTemplateEngineErrorDomain format:@"Unknown tag name '%@'", tagName];
    }
    TDTag *tag = [[[cls alloc] initWithToken:token parent:parent] autorelease];
    TDAssert(tag);
    TDAssert([tag.tagName isEqualToString:tagName]);
    
    return tag;
}


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
    
    expr = [self expressionFromReader:&reader error:outErr];
    return expr;
}


- (TDExpression *)expressionFromReader:(parsekit::Reader *)reader error:(NSError **)outErr {
    TagParser p(self);

    TDExpression *expr = [self expressionFromParser:&p reader:reader error:outErr];

    expr = [expr simplify];
    return expr;
}


- (TDExpression *)expressionFromParser:(TagParser *)parser reader:(Reader *)reader error:(NSError **)outErr {
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
