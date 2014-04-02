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
#import "TDTemplateParser.h"
#import "TDNode.h"
#import "TDRootNode.h"
#import "TDTextNode.h"
#import "TDVariableNode.h"
#import "TDBlockStartNode.h"
#import "TDBlockEndNode.h"

#import <TDTemplateEngine/TDScope.h>
#import <TDTemplateEngine/TDTemplateContext.h>

#import <PEGKit/PKTokenizer.h>
#import <PEGKit/PKWhitespaceState.h>
#import <PEGKit/PKSymbolState.h>
#import <PEGKit/PKToken.h>

NSString * const TDTemplateEngineErrorDomain = @"TDTemplateEngineErrorDomain";
NSInteger TDTemplateEngineRenderingErrorCode = 1;

@interface TDTemplateEngine ()
@property (nonatomic, retain) NSRegularExpression *delimiterRegex;
@property (nonatomic, retain, readwrite) id <TDScope>staticContext;
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
        self.tagStartDelimiter = @"{%";
        self.tagEndDelimiter = @"%}";
        self.staticContext = [[[TDTemplateContext alloc] init] autorelease];
    }
    return self;
}


- (void)dealloc {
    self.varStartDelimiter = nil;
    self.varEndDelimiter = nil;
    self.tagStartDelimiter = nil;
    self.tagEndDelimiter = nil;
    self.delimiterRegex = nil;
    self.staticContext = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Public

- (TDNode *)compileTemplateFile:(NSString *)path encoding:(NSStringEncoding)enc error:(NSError **)err {
    NSParameterAssert([path length]);
    
    TDNode *root = nil;
    NSString *str = [NSString stringWithContentsOfFile:path encoding:enc error:err];
    
    if (str) {
        root = [self compileTemplateString:str error:err];
    }
    
    return root;
}


- (TDNode *)compileTemplateString:(NSString *)str error:(NSError **)err {
    NSParameterAssert([str length]);
    TDAssertMainThread();
    TDAssert([_varStartDelimiter length]);
    TDAssert([_varEndDelimiter length]);
    TDAssert([_tagStartDelimiter length]);
    TDAssert([_tagEndDelimiter length]);

    // lex
    NSArray *frags = [self fragmentsFromString:str];
    TDAssert(frags);
    
    // compile
    TDNode *root = [self compile:frags error:err];
    return root;
}


- (BOOL)renderTemplateTree:(TDNode *)root withVariables:(NSDictionary *)vars toStream:(NSOutputStream *)output error:(NSError **)err {
    NSParameterAssert([root isKindOfClass:[TDRootNode class]]);
    NSParameterAssert(output);
    
    [output open];
    TDAssert([output hasSpaceAvailable]);
    
    TDTemplateContext *dynamicContext = [[[TDTemplateContext alloc] initWithVariables:vars output:output] autorelease];
    TDAssert(_staticContext);
    dynamicContext.enclosingScope = _staticContext;
    
    BOOL success = YES;

    @try {
        [root renderInContext:dynamicContext];
    }
    @catch (NSException *ex) {
        success = NO;
        *err = [NSError errorWithDomain:TDTemplateEngineErrorDomain code:TDTemplateEngineRenderingErrorCode userInfo:[[[ex userInfo] copy] autorelease]];
    }
    
    return success;;
}


- (BOOL)processTemplateFile:(NSString *)path encoding:(NSStringEncoding)enc withVariables:(NSDictionary *)vars toStream:(NSOutputStream *)output error:(NSError **)err {
    TDNode *root = [self compileTemplateFile:path encoding:enc error:err];

    BOOL success = NO;
    
    if (root) {
        success = [self renderTemplateTree:root withVariables:vars toStream:output error:err];
    }
    
    return success;
}


- (BOOL)processTemplateString:(NSString *)str withVariables:(NSDictionary *)vars toStream:(NSOutputStream *)output error:(NSError **)err {
    TDNode *root = [self compileTemplateString:str error:err];
    
    BOOL success = NO;
    
    if (root) {
        success = [self renderTemplateTree:root withVariables:vars toStream:output error:err];
    }
    
    return success;
}


#pragma mark -
#pragma mark Private

- (NSString *)cleanPattern:(NSString *)inStr {
    NSMutableString *outSr = [[inStr mutableCopy] autorelease];
    [outSr replaceOccurrencesOfString:@"{" withString:@"\\{" options:0 range:NSMakeRange(0, [outSr length])];
    [outSr replaceOccurrencesOfString:@"}" withString:@"\\}" options:0 range:NSMakeRange(0, [outSr length])];
    [outSr replaceOccurrencesOfString:@"[" withString:@"\\[" options:0 range:NSMakeRange(0, [outSr length])];
    [outSr replaceOccurrencesOfString:@"]" withString:@"\\]" options:0 range:NSMakeRange(0, [outSr length])];
    [outSr replaceOccurrencesOfString:@"(" withString:@"\\(" options:0 range:NSMakeRange(0, [outSr length])];
    [outSr replaceOccurrencesOfString:@")" withString:@"\\)" options:0 range:NSMakeRange(0, [outSr length])];
    [outSr replaceOccurrencesOfString:@"." withString:@"\\." options:0 range:NSMakeRange(0, [outSr length])];
    [outSr replaceOccurrencesOfString:@"+" withString:@"\\+" options:0 range:NSMakeRange(0, [outSr length])];
    [outSr replaceOccurrencesOfString:@"?" withString:@"\\?" options:0 range:NSMakeRange(0, [outSr length])];
    [outSr replaceOccurrencesOfString:@"*" withString:@"\\*" options:0 range:NSMakeRange(0, [outSr length])];
    return outSr;
}


- (BOOL)setUpDelimiterRegex:(NSError **)outErr {
    TDAssertMainThread();
    
    NSString *varStartDelimiter = [self cleanPattern:_varStartDelimiter];
    NSString *varEndDelimiter   = [self cleanPattern:_varEndDelimiter];
    NSString *tagStartDelimiter = [self cleanPattern:_tagStartDelimiter];
    NSString *tagEndDelimiter   = [self cleanPattern:_tagEndDelimiter];
    
    NSString *pattern = [NSString stringWithFormat:@"(%@.*?%@|%@.*?%@)", varStartDelimiter, varEndDelimiter, tagStartDelimiter, tagEndDelimiter];

    self.delimiterRegex = [[[NSRegularExpression alloc] initWithPattern:pattern options:0 error:outErr] autorelease];

    BOOL success = nil != _delimiterRegex;
    return success;
}


- (NSArray *)fragmentsFromString:(NSString *)inStr {
    
    NSError *err = nil;
    if (![self setUpDelimiterRegex:&err]) {
        NSLog(@"%@", err);
        return nil;
    }

    NSMutableArray *frags = [NSMutableArray array];

    NSUInteger varStartDelimLen = [_varStartDelimiter length];
    NSUInteger varEndDelimLen   = [_varEndDelimiter length];
    NSUInteger tagStartDelimLen = [_tagStartDelimiter length];
    NSUInteger tagEndDelimLen   = [_tagEndDelimiter length];
    
    NSCharacterSet *wsSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];

    __block NSRange lastRange = NSMakeRange(0, 0);
    [_delimiterRegex enumerateMatchesInString:inStr options:NSMatchingReportCompletion range:NSMakeRange(0, [inStr length]) usingBlock:^(NSTextCheckingResult *current, NSMatchingFlags flags, BOOL *stop) {
        NSRange currRange = current.range;

        NSString *str = [inStr substringWithRange:currRange];
        NSUInteger len = [str length];
        if (!len) return;
        //NSLog(@"%@", str);

        // detect text node
        NSUInteger diff = currRange.location - NSMaxRange(lastRange);
        if (diff > 0) {
            NSString *txt = [inStr substringWithRange:NSMakeRange(NSMaxRange(lastRange), diff)];
            
            PKToken *txtFrag = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:txt doubleValue:0.0];
            txtFrag.tokenKind = TDTEMPLATE_TOKEN_KIND_TEXT;
            
            [frags addObject:txtFrag];
        }
        
        lastRange = currRange;
        NSUInteger kind = 0;
        
        if ([str hasPrefix:_varStartDelimiter]) {
            kind = TDTEMPLATE_TOKEN_KIND_VAR;
            str = [str substringToIndex:len - varEndDelimLen];
            str = [str substringFromIndex:varStartDelimLen];
            str = [str stringByTrimmingCharactersInSet:wsSet];
            
        } else if ([str hasPrefix:_tagStartDelimiter]) {
            str = [str substringToIndex:len - tagEndDelimLen];
            str = [str substringFromIndex:tagStartDelimLen];
            str = [str stringByTrimmingCharactersInSet:wsSet];
            
            if ([str hasPrefix:@"/"]) {
                //str = [str substringFromIndex:1];
                kind = TDTEMPLATE_TOKEN_KIND_BLOCK_END_TAG;
            } else {
                kind = TDTEMPLATE_TOKEN_KIND_BLOCK_START_TAG;
            }
        } else {
            TDAssert(0);
        }
        
        PKToken *frag = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:str doubleValue:0.0];
        frag.tokenKind = kind;
        
        [frags addObject:frag];
    }];
    
    return frags;
}


- (TDNode *)compile:(NSArray *)frags error:(NSError **)err {
    
    TDTemplateParser *p = [[[TDTemplateParser alloc] initWithDelegate:nil] autorelease];

    TDAssert(_staticContext);
    p.staticContext = _staticContext;
    
    TDNode *root = [p parseTokens:frags error:err];
    
    return root;
}

@end
