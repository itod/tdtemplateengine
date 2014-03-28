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
#import "TDVariableNode.h"

#import <PEGKit/PKTokenizer.h>
#import <PEGKit/PKSymbolState.h>
#import <PEGKit/PKToken.h>

@interface TDTemplateEngine ()
@property (nonatomic, retain) NSString *varStartDelimiter;
@property (nonatomic, retain) NSString *varEndDelimiter;
@property (nonatomic, retain) NSString *blockStartDelimiter;
@property (nonatomic, retain) NSString *blockEndDelimiter;
@property (nonatomic, retain) NSRegularExpression *delimiterRegex;
@end

@implementation TDTemplateEngine

+ (TDTemplateEngine *)templateEngine {
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
    self.delimiterRegex = nil;
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
    result = [root renderInContext:vars];
    
done:
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

//- (BOOL)setUpDelimiterRegex:(NSError **)outErr {
//    TDAssertMainThread();
//    
//    NSString *pattern = [NSString stringWithFormat:@"(%@.*?%@|%@.*?%@)", _varStartDelimiter, _varEndDelimiter, _blockStartDelimiter, _blockEndDelimiter];
//    
//    self.delimiterRegex = [[[NSRegularExpression alloc] initWithPattern:pattern options:0 error:outErr] autorelease];
//    
//    BOOL success = nil != _delimiterRegex;
//    return success;
//}



- (NSArray *)fragmentsFromString:(NSString *)inStr {
    //    NSError *err = nil;
    //
    //    if (![self setUpDelimiterRegex:&err]) {
    //        NSLog(@"%@", err);
    //        goto done;
    //    }
    //
    ////    TDAssert(_delimiterRegex);
    ////    NSArray *frags = [_delimiterRegex matchesInString:str options:NSMatchingReportCompletion range:NSMakeRange(0, [str length])];
    ////    TDAssert([frags count]);
    //
    NSMutableArray *frags = [NSMutableArray array];
    //
    //    NSRange r = NSMakeRange(0, [inStr length]);
    //    [_delimiterRegex enumerateMatchesInString:inStr options:NSMatchingReportCompletion range:r usingBlock:^(NSTextCheckingResult *current, NSMatchingFlags flags, BOOL *stop) {
    //        NSString *s = [inStr substringWithRange:current.range];
    //        NSUInteger type = 0;
    //        if ([s hasPrefix:_varStartDelimiter]) {
    //            type = VAR_FRAGMENT;
    //        } else if ([s hasPrefix:_blockStartDelimiter]) {
    //            type
    //        }
    //        id frag = @{@"type": @(type), @"string": s};
    //    }];
    
    
    PKTokenizer *t = [PKTokenizer tokenizerWithString:inStr];
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
                TDFragment *frag = [[[TDFragment alloc] init] autorelease];
                frag.string = fragStr;
                frag.type = fragType;
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
            
            TDFragment *frag = [[[TDFragment alloc] init] autorelease];
            frag.string = fragStr;
            frag.type = fragType;
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
//      // TODO
//    NSMutableString *mstr = [NSMutableString string];
//    for (PKToken *tok in tokbuff) {
//        [mstr appendString:tok.stringValue];
//    }
    return [TDNode nodeWithFragment:frag];
}


- (TDNode *)compile:(NSArray *)frags {
    
    TDNode *root = [TDRootNode rootNode];
    
    NSMutableArray *scopeStack = [NSMutableArray arrayWithObject:root];
    
    for (TDFragment *frag in frags) {
        if (![scopeStack count]) {
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
