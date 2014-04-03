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

#import "TDBlockStartNode.h"
#import <TDTemplateEngine/TDTemplateContext.h>
#import <TDTemplateEngine/TDEnumeration.h>
#import <TDTemplateEngine/TDWriter.h>
#import <TDTemplateEngine/TDTag.h>
#import <TDTemplateEngine/XPExpression.h>
#import <PEGKit/PKToken.h>
#import <PEGKit/PKTokenizer.h>
#import <PEGKit/PKWhitespaceState.h>

@interface TDTemplateContext ()
@property (nonatomic, retain) TDNode *currentNode;
@end

@interface TDBlockStartNode ()
@property (nonatomic, retain) TDTag *tag;
@end

@implementation TDBlockStartNode

- (instancetype)initWithToken:(PKToken *)frag {
    self = [super initWithToken:frag];
    if (self) {

    }
    return self;
}


- (void)dealloc {
    self.tagName = nil;
    [super dealloc];
}


- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %p %@>", [self class], self, _tagName];
}


- (void)processFragment {
    NSParameterAssert(self.token);
    TDAssert([self.token.stringValue length]);
    
    NSMutableArray *toks = [NSMutableArray array];

    NSString *tagName = nil;

    PKTokenizer *t = [XPExpression tokenizer];
    t.string = self.token.stringValue;
    
    PKToken *tok = nil;
    PKToken *eof = [PKToken EOFToken];
    while (eof != (tok = [t nextToken])) {
        if (!tagName && PKTokenTypeWord == tok.tokenType) {
            tagName = tok.stringValue;
            continue;
        }
        
        [toks addObject:tok];
    }
    
    self.tagName = tagName;
    self.tag = [TDTag tagForName:tagName];

    _tag.expression = [XPExpression expressionFromTokens:toks error:nil];
    
    TDAssert(_tag);
}


- (void)renderInContext:(TDTemplateContext *)ctx {
    NSParameterAssert(ctx);
    TDAssert(_tag);
    
    TDTemplateContext *local = [[[TDTemplateContext alloc] initWithVariables:nil output:ctx.writer.output] autorelease];
    local.enclosingScope = ctx;
    local.currentNode = self;
    
    [_tag doTagInContext:local];
}

@end
