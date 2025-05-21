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

#import "TDBlockTag.h"
#import "TDTemplate.h"
#import "TDRootNode.h"
#import "TDPathExpression.h"
#import "TDTemplateContext.h"

@interface TDTemplate ()
- (TDNode *)blockForKey:(NSString *)key;
- (void)setBlock:(TDNode *)block forKey:(NSString *)key;
@end

@implementation TDBlockTag

+ (NSString *)tagName {
    return @"block";
}


+ (TDTagContentType)tagContentType {
    return TDTagContentTypeComplex;
}


- (void)dealloc {
    self.templateString = nil;
    [super dealloc];
}


- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %p %@>", [self class], self, self.key];
}


#pragma mark -
#pragma mark Compiletime

- (NSString *)key {
    NSString *key = nil;
    if ([self.expression isKindOfClass:[TDPathExpression class]]) {
        TDPathExpression *pexpr = (id)self.expression;
        key = pexpr.head;
    }
    TDAssert(key);
    return key;
}


- (void)compileInContext:(TDTemplateContext *)ctx {
    [ctx.derivedTemplate setBlock:self forKey:self.key];
}


#pragma mark -
#pragma mark Runtime

- (id)runInContext:(TDTemplateContext *)ctx {
    NSParameterAssert(ctx);
    
    TDTemplate *tmpl = ctx.derivedTemplate;
    TDAssert(tmpl);
    TDNode *delegate = [tmpl blockForKey:self.key];
    TDAssert(delegate);
    
    TDRootNode *blockRoot = (id)[delegate firstAncestorOfClass:[TDRootNode class]];
    
    [ctx pushTemplateString:blockRoot.templateString];
    [delegate renderChildrenInContext:ctx];
    [ctx popTemplateString];
    
    return nil;
}

@end
