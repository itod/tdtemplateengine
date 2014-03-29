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

#import "TDTemplateEngine.h"
#import "TDFragment.h"
#import "TDNode.h"
#import "TDRootNode.h"
#import "TDTextNode.h"
#import "TDVariableNode.h"
#import "TDStartBlockNode.h"
#import "TDEndBlockNode.h"
#import <TDTemplateEngine/TDTemplateContext.h>

#import <PEGKit/PKTokenizer.h>
#import <PEGKit/PKWhitespaceState.h>
#import <PEGKit/PKSymbolState.h>
#import <PEGKit/PKToken.h>

@interface TDTemplateEngine ()

@end

@implementation TDTemplateEngine

+ (instancetype)templateEngine {
    return [[[TDTemplateEngine alloc] init] autorelease];
}


- (instancetype)init {
    self = [super init];
    if (self) {
        self.varStartDelimiter = @"{{";
        self.varEndDelimiter = @"}}";
        self.blockStartDelimiter = @"{%";
        self.blockEndDelimiter = @"%}";
    }
    return self;
}


- (void)dealloc {
    self.varStartDelimiter = nil;
    self.varEndDelimiter = nil;
    self.blockStartDelimiter = nil;
    self.blockEndDelimiter = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Public

- (NSString *)processTemplateString:(NSString *)inStr withVariables:(NSDictionary *)vars {
    NSParameterAssert([inStr length]);
    TDAssertMainThread();
    TDAssert([_varStartDelimiter length]);
    TDAssert([_varEndDelimiter length]);
    TDAssert([_blockStartDelimiter length]);
    TDAssert([_blockEndDelimiter length]);

    NSString *result = nil;

    NSArray *frags = [self fragmentsFromString:inStr];
    
    TDNode *root = [self compile:frags];
    TDTemplateContext *ctx = [[[TDTemplateContext alloc] initWithVariables:vars] autorelease];
    
    result = [root renderInContext:ctx];

    return result;
}


- (NSString *)processTemplateFile:(NSString *)path withVariables:(NSDictionary *)vars encoding:(NSStringEncoding)enc error:(NSError **)err {
    NSParameterAssert([path length]);
    
    NSString *result = nil;
    NSString *str = [NSString stringWithContentsOfFile:path encoding:enc error:err];
    
    if (str) {
        result = [self processTemplateString:str withVariables:vars];
    }
    
    return result;
}


#pragma mark -
#pragma mark Private

- (NSArray *)fragmentsFromString:(NSString *)inStr {
    NSMutableArray *frags = [NSMutableArray array];
    
    PKTokenizer *t = [PKTokenizer tokenizerWithString:inStr];
    t.whitespaceState.reportsWhitespaceTokens = YES;
    [t.symbolState add:_varStartDelimiter];
    [t.symbolState add:_varEndDelimiter];
    [t.symbolState add:_blockStartDelimiter];
    [t.symbolState add:_blockEndDelimiter];
    
    PKToken *tok = nil;
    PKToken *eof = [PKToken EOFToken];
    
    TDFragmentType fragType = TDFragmentTypeText;
    NSMutableString *fragStr = nil;
    NSMutableArray *fragToks = nil;
    
    while (eof != (tok = [t nextToken])) {
        NSString *s = tok.stringValue;
        
        if ([s isEqualToString:_varStartDelimiter] || [s isEqualToString:_blockStartDelimiter]) {
            if (fragStr) {
                TDFragment *frag = [[[TDFragment alloc] initWithType:fragType string:fragStr tokens:fragToks] autorelease];
                [frags addObject:frag];
            }
            fragToks = [NSMutableArray array];
            fragStr = [NSMutableString string];
            
            if ([s isEqualToString:_varStartDelimiter]) {
                fragType = TDFragmentTypeVariable;
            } else {
                [fragStr appendString:s];
                [fragToks addObject:tok];

                tok = [t nextToken];
                while (PKTokenTypeWhitespace == tok.tokenType) {
                    [fragStr appendString:tok.stringValue];
                    [fragToks addObject:tok];
                    tok = [t nextToken];
                }
                s = tok.stringValue;
                fragType = [s isEqualToString:@"/"] ? TDFragmentTypeEndBlock : TDFragmentTypeStartBlock; // TODO
            }
            [fragStr appendString:s];
            [fragToks addObject:tok];
        } else if ([s isEqualToString:_varEndDelimiter] || [s isEqualToString:_blockEndDelimiter]) {
            [fragStr appendString:s];
            [fragToks addObject:tok];
            
            TDFragment *frag = [[[TDFragment alloc] initWithType:fragType string:fragStr tokens:fragToks] autorelease];
            [frags addObject:frag];
            fragStr = nil;
            fragToks = nil;
        } else {
            if (!fragStr) {
                fragType = TDFragmentTypeText;
                fragStr = [NSMutableString string];
                fragToks = nil;
            }
            [fragStr appendString:s];
            [fragToks addObject:tok];
        }
    }

    NSLog(@"%@", frags);
    return frags;
}


- (TDNode *)makeNode:(TDFragment *)frag {
    
    Class cls = Nil;
    switch (frag.type) {
        case TDFragmentTypeText:
            cls = [TDTextNode class];
            break;
        case TDFragmentTypeVariable:
            cls = [TDVariableNode class];
            break;
        case TDFragmentTypeStartBlock:
            cls = [TDStartBlockNode class];
            break;
        case TDFragmentTypeEndBlock:
            cls = [TDEndBlockNode class];
            break;
        default:
            TDAssert(0);
            break;
    }

    TDNode *node = [cls nodeWithFragment:frag];
    return node;
}


- (TDNode *)compile:(NSArray *)frags {
    
    TDNode *root = [TDRootNode rootNode];
    
    NSMutableArray *scopeStack = [NSMutableArray arrayWithObject:root];
    
    for (TDFragment *frag in frags) {
        if (![scopeStack count]) {
            TDAssert(0);
            //raise TemplateError('nesting issues')
        }
    
        TDNode *parentScope = [scopeStack lastObject];
        if (frag.type == TDFragmentTypeEndBlock) {
            [parentScope exitScope];
            [scopeStack removeLastObject];
            continue;
        }
        
        TDNode *newNode = [self makeNode:frag];
        
        if (newNode) {
            [parentScope.children addObject:newNode];
            if (newNode.createsScope) {
                [scopeStack addObject:newNode];
                [newNode enterScope];
            }
        }
    }
    
    return root;
}

@end
