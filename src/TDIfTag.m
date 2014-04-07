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

#import "TDIfTag.h"
#import "TDElseTag.h"
#import "TDElseIfTag.h"
#import "TDBlockStartNode.h"
#import <TDTemplateEngine/TDTemplateContext.h>
#import <TDTemplateEngine/XPExpression.h>

@implementation TDIfTag

+ (NSString *)tagName {
    return @"if";
}


+ (TDTagType)tagType {
    return TDTagTypeBlock;
}


- (void)doTagInContext:(TDTemplateContext *)ctx {
    TDAssert(ctx);
    TDAssert(self.expression);
    
    BOOL test = [self.expression evaluateAsBooleanInContext:ctx];
    
    if (test) {
//        self.incomplete = NO;
        BOOL foundElse = NO;
        for (TDNode *child in self.node.children) {
            if (foundElse) {
                child.suppressRendering = YES;
            } else {
                if ([child isMemberOfClass:[TDBlockStartNode class]]) {
                    TDTag *tag = [(id)child tag];
                    BOOL isElse = [tag isMemberOfClass:[TDElseIfTag class]] || [tag isMemberOfClass:[TDElseTag class]];
                    if (isElse) {
                        foundElse = YES;
                        child.suppressRendering = YES;
                    }
                }
            }
        }
    } else {
//        self.incomplete = YES;
        BOOL suppress = YES;
        for (TDNode *child in self.node.children) {
            if ([child isMemberOfClass:[TDBlockStartNode class]]) {
                TDTag *tag = [(id)child tag];
                BOOL isElif = [tag isMemberOfClass:[TDElseIfTag class]];
                if (isElif) {
                    suppress = ![tag.expression evaluateAsBooleanInContext:ctx];
                }
                BOOL isElse = [tag isMemberOfClass:[TDElseTag class]];
                if (isElse) {
                    suppress = !suppress;
                }
            }
            child.suppressRendering = suppress;
        }
    }

    [ctx renderBody:self];
    
//    self.incomplete = NO;
}

@end
