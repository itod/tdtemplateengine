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

@interface TDNode ()
@property (nonatomic, assign, readwrite) TDNode *parent; // weakref
@end

@implementation TDNode {
    parsekit::Token _token;
}

+ (instancetype)nodeWithToken:(parsekit::Token)frag parent:(TDNode *)parent {
    return [[[self alloc] initWithToken:frag parent:parent] autorelease];
}


- (instancetype)initWithToken:(parsekit::Token)frag parent:(TDNode *)parent {
    self = [super init];
    if (self) {
        self.parent = parent;
        _token = frag;
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


- (NSString *)description {
    return [self treeDescription];
}


- (NSString *)treeDescription {
    if (![_children count]) {
        return self.tagName;
    }
    
    NSMutableString *ms = [NSMutableString string];
    [ms appendFormat:@"(%@ ", self.tagName];
    
    NSInteger i = 0;
    for (TDNode *child in _children) {
        NSString *fmt = 0 == i++ ? @"%@" : @" %@";
        [ms appendFormat:fmt, [child treeDescription]];
    }
    
    [ms appendString:@")"];
    return [[ms copy] autorelease];
}


- (NSUInteger)type {
    NSAssert2(0, @"%s is an abastract method. Must be overridden in %@", __PRETTY_FUNCTION__, NSStringFromClass([self class]));
    return NSNotFound;
}


- (void)addChild:(TDNode *)kid {
    NSParameterAssert(kid);
    if (!_children) {
        self.children = [NSMutableArray array];
    }
    [_children addObject:kid];
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


#pragma mark -
#pragma mark Properties

- (parsekit::Token)token {
    return _token;
}


- (void)setToken:(parsekit::Token)token {
    _token = token;
}

@end
