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

#import <PEGKit/PKAST.h>
#import <ParseKitCPP/Token.hpp>

@class PKToken;
@class TDTemplateContext;
@class TDExpression;

@interface TDNode : PKAST

// TODO remove
+ (instancetype)nodeWithToken:(PKToken *)frag parent:(TDNode *)parent;
- (instancetype)initWithToken:(PKToken *)frag parent:(TDNode *)parent;

// TODO remove `_`
+ (instancetype)nodeWithToken_:(parsekit::Token)frag parent:(TDNode *)parent;
- (instancetype)initWithToken_:(parsekit::Token)frag parent:(TDNode *)parent;

- (void)renderInContext:(TDTemplateContext *)ctx;
- (void)renderChildrenInContext:(TDTemplateContext *)ctx;

- (TDNode *)firstAncestorOfClass:(Class)cls;
- (TDNode *)firstAncestorOfTagName:(NSString *)tagName;

@property (nonatomic, assign) TDNode *parent; // weakref

@property (nonatomic, copy, readonly) NSString *tagName;
@property (nonatomic, retain) TDExpression *expression;

// TODO rename
@property (nonatomic, assign, readonly) parsekit::Token goodToken;
@end
