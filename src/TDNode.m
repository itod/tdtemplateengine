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
#import <PEGKit/PKToken.h>

@interface TDNode ()
- (void)processFragment;
@end

@implementation TDNode

+ (instancetype)nodeWithToken:(PKToken *)frag parent:(TDNode *)parent {
    return [[[self alloc] initWithToken:frag parent:parent] autorelease];
}


- (instancetype)initWithToken:(PKToken *)frag parent:(TDNode *)parent {
    NSParameterAssert(frag);
    self = [super initWithToken:frag];
    if (self) {
        self.parent = parent;
        [self processFragment];
    }
    return self;
}


- (void)dealloc {
    self.parent = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Public

- (void)processFragment {

}


- (void)renderInContext:(TDTemplateContext *)ctx {
    [self renderChildrenInContext:ctx];
}


- (TDNode *)firstAncestorOfClass:(Class)cls {
    NSParameterAssert(cls);
    TDAssert(_parent);
    
    TDNode *result = _parent;
    while (result && ![result isKindOfClass:cls]) {
        result = result.parent;
    }
    return result;
}


#pragma mark -
#pragma mark Private

- (void)renderChildrenInContext:(TDTemplateContext *)ctx {
    for (TDNode *child in self.children) {
        [child renderInContext:ctx];
    }
}

@end
