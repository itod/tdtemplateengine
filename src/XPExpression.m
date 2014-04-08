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

#import <TDTemplateEngine/XPExpression.h>
#import "TDTemplateEngine+XPExpressionSupport.h"
#import <TDTemplateEngine/TDTemplateContext.h>
#import "XPValue.h"
#import "XPParser.h"
#import <PEGKit/PKTokenizer.h>

@implementation XPExpression

+ (PKTokenizer *)tokenizer {
    return [[TDTemplateEngine currentTemplateEngine] tokenizer];
}


+ (XPExpression *)expressionFromString:(NSString *)str error:(NSError **)outErr {
    return [[TDTemplateEngine currentTemplateEngine] expressionFromString:str error:outErr];
}


+ (XPExpression *)expressionFromTokens:(NSArray *)toks error:(NSError **)outErr {
    return [[TDTemplateEngine currentTemplateEngine] expressionFromTokens:toks error:outErr];
}


+ (XPExpression *)loopExpressionFromTokens:(NSArray *)toks error:(NSError **)outErr {
    return [[TDTemplateEngine currentTemplateEngine] loopExpressionFromTokens:toks error:outErr];
}


- (void)dealloc {

    [super dealloc];
}


- (XPValue *)evaluateInContext:(TDTemplateContext *)ctx {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return NO;
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


- (BOOL)isValue {
    return [self isKindOfClass:[XPValue class]];
}


- (XPExpression *)simplify {
    return self;
}


- (NSUInteger)dependencies {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return 0;
}


- (XPExpression *)reduceDependencies:(NSUInteger)dep inContext:(TDTemplateContext *)ctx {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return nil;
}


- (XPDataType)dataType {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return -1;
}


- (void)display:(NSInteger)level {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
}

@end
