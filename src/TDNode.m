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

#import "TDNode.h"
#import <TDTemplateEngine/TDTemplateContext.h>
#import <TDTemplateEngine/TDWriter.h>

@implementation TDNode

+ (instancetype)nodeWithToken:(PKToken *)frag parent:(TDNode *)parent {
    return [[[self alloc] initWithToken:frag parent:parent] autorelease];
}


- (instancetype)initWithToken:(PKToken *)frag parent:(TDNode *)parent {
    NSParameterAssert(frag);
    self = [super initWithToken:frag];
    if (self) {
        self.parent = parent;
    }
    return self;
}


- (void)dealloc {
    self.parent = nil;
    self.expression = nil;
    
    [super dealloc];
}


#pragma mark -
#pragma mark Public

- (TDNode *)firstAncestorOfClass:(Class)cls {
    NSParameterAssert(cls);
    TDAssert(_parent);
    
    TDNode *result = _parent;
    while (result && ![result isKindOfClass:cls]) {
        result = result.parent;
    }
    return result;
}


- (TDNode *)firstAncestorOfTagName:(NSString *)tagName {
    NSParameterAssert([tagName length]);
    TDAssert(_parent);
    
    TDNode *result = _parent;
    while (result && ![result.tagName isEqualToString:tagName]) {
        result = result.parent;
    }
    return result;
}


- (NSString *)tagName {
    return nil;
}

#pragma mark -
#pragma mark Render

- (void)renderInContext:(TDTemplateContext *)ctx {
    NSParameterAssert(ctx);
    [self renderChildrenInContext:ctx];
}


- (void)renderChildrenInContext:(TDTemplateContext *)ctx {
    NSParameterAssert(ctx);
    for (TDNode *child in self.children) {
        [child renderInContext:ctx];
    }
}

@end
