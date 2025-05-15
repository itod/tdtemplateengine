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
#import "TDRootNode.h"
#import "TDPathExpression.h"

@interface TDPathExpression ()
@property (nonatomic, retain) NSString *head;
@end

@implementation TDBlockTag

+ (NSString *)tagName {
    return @"block";
}


+ (TDTagType)tagType {
    return TDTagTypeComplex;
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


- (void)compileInContext:(TDTemplateContext *)staticContext {
    TDRootNode *root = (id)[self firstAncestorOfClass:[TDRootNode class]];
    [root setBlock:self forKey:self.key];
}


#pragma mark -
#pragma mark Runtime

- (void)doTagInContext:(TDTemplateContext *)ctx {
    NSParameterAssert(ctx);
    
    TDRootNode *root = (id)[self firstAncestorOfClass:[TDRootNode class]];
    TDNode *delegate = [root blockForKey:self.key];
    
    [delegate renderChildrenInContext:ctx];
}

@end
