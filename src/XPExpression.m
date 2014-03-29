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
#import <TDTemplateEngine/TDTemplateContext.h>
#import "XPValue.h"
#import "XPParser.h"
#import "XPAssembler.h"
#import <PEGKit/PKAssembly.h>

static PKParser *sParser = nil;

@interface XPExpression ()

@end

@implementation XPExpression

+ (void)initialize {
    if ([XPExpression class] == self) {
        XPAssembler *sAssembler = [[XPAssembler alloc] init];
        sParser = [[XPParser alloc] initWithDelegate:sAssembler];
        TDAssert(sParser);
    }
}


+ (XPExpression *)expressionFromTokens:(NSArray *)toks error:(NSError **)outErr {
    TDAssert(sParser);
    PKAssembly *a = [sParser parseTokens:toks error:outErr];

    XPExpression *expr = [a pop];
    TDAssert([expr isKindOfClass:[XPExpression class]]);
    
    expr = [expr simplify];
    return expr;
}


- (void)dealloc {

    [super dealloc];
}


- (XPValue *)evaluateInContext:(TDTemplateContext *)ctx {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return NO;
}


- (BOOL)evaluateAsBooleanInContext:(TDTemplateContext *)ctx {
    return [[self evaluateInContext:ctx] asBoolean];
}


- (double)evaluateAsNumberInContext:(TDTemplateContext *)ctx {
    return [[self evaluateInContext:ctx] asNumber];
}


- (NSString *)evaluateAsStringInContext:(TDTemplateContext *)ctx {
    return [[self evaluateInContext:ctx] asString];
}


- (BOOL)isValue {
    return [self isKindOfClass:[XPValue class]];
}


- (BOOL)isContextDocumentNodeSet {
    return NO;
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
