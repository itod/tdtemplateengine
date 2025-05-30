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

#import <TDTemplateEngine/TDTemplateEngine.h>
#import <TDTemplateEngine/TDTemplateContext.h>
#import <TDTemplateEngine/TDTemplateException.h>
#import <TDTemplateEngine/TDTemplate.h>
#import <TDTemplateEngine/TDNode.h>
#import "TDTemplateEngine+ParserSupport.h"

#import "TDRootNode.h"
#import "TDTextNode.h"
#import "TDPrintNode.h"

#import "TDExpression.h"

#import "TDExtendsTag.h"
#import "TDBlockTag.h"
#import "TDIncludeTag.h"
#import "TDLoadTag.h"
#import "TDCSRFTokenTag.h"
#import "TDIfTag.h"
#import "TDElseTag.h"
#import "TDElseIfTag.h"
#import "TDForTag.h"
#import "TDSkipTag.h"
#import "TDCommentTag.h"
#import "TDVerbatimTag.h"
#import "TDCycleTag.h"
#import "TDResetCycleTag.h"
#import "TDAutoescapeTag.h"
#import "TDTrimTag.h"
#import "TDIndentTag.h"
#import "TDNewlineTag.h"
#import "TDSpaceTag.h"
#import "TDTabTag.h"
#import "TDSepTag.h"

#import "TDSafeFilter.h"
#import "TDIntCommaFilter.h"
#import "TDEscapeFilter.h"
#import "TDTrimFilter.h"
#import "TDRoundFilter.h"
#import "TDFloorFilter.h"
#import "TDCeilFilter.h"
#import "TDFabsFilter.h"
#import "TDDivisibleByFilter.h"
#import "TDFloatFormatFilter.h"
#import "TDDateFormatFilter.h"
#import "TDNullFormatFilter.h"
#import "TDLowercaseFilter.h"
#import "TDUppercaseFilter.h"
#import "TDCapitalizeFilter.h"
#import "TDUncapitalizeFilter.h"
#import "TDBoolFilter.h"
#import "TDReplaceFilter.h"
#import "TDAddFilter.h"
#import "TDDefaultFilter.h"
#import "TDDefaultIfNoneFilter.h"
#import "TDPadFilters.h"
#import "TDLengthFilter.h"

#import <ParseKitCPP/Tokenizer.hpp>
#import "TemplateParser.hpp"
#import "TagParser.hpp"

using namespace parsekit;
using namespace templateengine;

NSString * const TDTemplateEngineTagEndPrefix = @"end";
NSString * const TDTemplateEngineErrorDomain = @"TDTemplateEngineErrorDomain";
const NSInteger TDTemplateEngineRenderingErrorCode = 500;

static TDTemplateEngine *sInstance = nil;

@interface TDTemplate ()
- (instancetype)initWithFilePath:(NSString *)path;
@property (nonatomic, retain) TDNode *rootNode;
@property (nonatomic, retain, readwrite) TDTemplate *superTemplate;
@property (nonatomic, retain) TDTemplateContext *staticContext;
@property (nonatomic, copy) NSString *extendsPath;
- (void)setBlock:(TDNode *)block forKey:(NSString *)key;
@end

// PRIVATE
@interface TDTemplateEngine ()
@property (nonatomic, retain, readwrite) TDTemplateContext *staticContext;
@property (nonatomic, retain) NSMutableDictionary *templateCache;

@property (nonatomic, retain) NSRegularExpression *delimiterRegex;
@property (nonatomic, retain) NSRegularExpression *cleanerRegex;
@property (nonatomic, retain) NSRegularExpression *tagNameRegex;
@property (nonatomic, retain) NSMutableDictionary *tagTab;
@property (nonatomic, retain) NSMutableDictionary *filterTab;

@property (nonatomic, copy) NSString *printStartDelimiter;
@property (nonatomic, copy) NSString *printEndDelimiter;
@property (nonatomic, copy) NSString *tagStartDelimiter;
@property (nonatomic, copy) NSString *tagEndDelimiter;
@end

@implementation TDTemplateEngine

+ (void)initialize {
    if ([TDTemplateEngine class] == self) {
        sInstance = [[TDTemplateEngine alloc] init];
    }
}


+ (instancetype)instance {
    TDAssert(sInstance);
    return sInstance;
}


- (instancetype)init {
    self = [super init];
    if (self) {
        self.staticContext = [[[TDTemplateContext alloc] init] autorelease];
        self.templateCache = [NSMutableDictionary dictionary];

        self.printStartDelimiter = @"{{";
        self.printEndDelimiter = @"}}";
        self.tagStartDelimiter = @"{%";
        self.tagEndDelimiter = @"%}";
        
        NSError *err = nil;
        self.cleanerRegex = [NSRegularExpression regularExpressionWithPattern:@"([{}\\[\\]\\(\\).+?*])" options:NSRegularExpressionAnchorsMatchLines error:&err];
        TDAssert(!err);
        TDAssert(_cleanerRegex);
        
        self.tagTab = [NSMutableDictionary dictionary];
        [self registerTagClass:[TDExtendsTag class] forName:[TDExtendsTag tagName]];
        [self registerTagClass:[TDBlockTag class] forName:[TDBlockTag tagName]];
        [self registerTagClass:[TDIncludeTag class] forName:[TDIncludeTag tagName]];
        [self registerTagClass:[TDLoadTag class] forName:[TDLoadTag tagName]];

        [self registerTagClass:[TDCSRFTokenTag class] forName:[TDCSRFTokenTag tagName]];
        [self registerTagClass:[TDIfTag class] forName:[TDIfTag tagName]];
        [self registerTagClass:[TDElseTag class] forName:[TDElseTag tagName]];
        [self registerTagClass:[TDElseIfTag class] forName:[TDElseIfTag tagName]];
        [self registerTagClass:[TDForTag class] forName:[TDForTag tagName]];
        [self registerTagClass:[TDSkipTag class] forName:[TDSkipTag tagName]];
        [self registerTagClass:[TDCommentTag class] forName:[TDCommentTag tagName]];
        [self registerTagClass:[TDVerbatimTag class] forName:[TDVerbatimTag tagName]];
        [self registerTagClass:[TDCycleTag class] forName:[TDCycleTag tagName]];
        [self registerTagClass:[TDResetCycleTag class] forName:[TDResetCycleTag tagName]];
        [self registerTagClass:[TDAutoescapeTag class] forName:[TDAutoescapeTag tagName]];
        [self registerTagClass:[TDTrimTag class] forName:[TDTrimTag tagName]];
        [self registerTagClass:[TDIndentTag class] forName:[TDIndentTag tagName]];
        [self registerTagClass:[TDNewlineTag class] forName:[TDNewlineTag tagName]];
        [self registerTagClass:[TDSpaceTag class] forName:[TDSpaceTag tagName]];
        [self registerTagClass:[TDTabTag class] forName:[TDTabTag tagName]];
        [self registerTagClass:[TDSepTag class] forName:[TDSepTag tagName]];
        
        self.filterTab = [NSMutableDictionary dictionary];
        [self registerFilterClass:[TDSafeFilter class] forName:[TDSafeFilter filterName]];
        [self registerFilterClass:[TDIntCommaFilter class] forName:[TDIntCommaFilter filterName]];
        [self registerFilterClass:[TDEscapeFilter class] forName:[TDEscapeFilter filterName]];
        [self registerFilterClass:[TDTrimFilter class] forName:[TDTrimFilter filterName]];
        [self registerFilterClass:[TDRoundFilter class] forName:[TDRoundFilter filterName]];
        [self registerFilterClass:[TDFloorFilter class] forName:[TDFloorFilter filterName]];
        [self registerFilterClass:[TDCeilFilter class] forName:[TDCeilFilter filterName]];
        [self registerFilterClass:[TDFabsFilter class] forName:[TDFabsFilter filterName]];
        [self registerFilterClass:[TDDivisibleByFilter class] forName:[TDDivisibleByFilter filterName]];
        [self registerFilterClass:[TDFloatFormatFilter class] forName:[TDFloatFormatFilter filterName]];
        [self registerFilterClass:[TDDateFormatFilter class] forName:[TDDateFormatFilter filterName]];
        [self registerFilterClass:[TDNullFormatFilter class] forName:[TDNullFormatFilter filterName]];
        [self registerFilterClass:[TDLowercaseFilter class] forName:[TDLowercaseFilter filterName]];
        [self registerFilterClass:[TDUppercaseFilter class] forName:[TDUppercaseFilter filterName]];
        [self registerFilterClass:[TDCapitalizeFilter class] forName:[TDCapitalizeFilter filterName]];
        [self registerFilterClass:[TDUncapitalizeFilter class] forName:[TDUncapitalizeFilter filterName]];
        [self registerFilterClass:[TDBoolFilter class] forName:[TDBoolFilter filterName]];
        [self registerFilterClass:[TDReplaceFilter class] forName:[TDReplaceFilter filterName]];
        [self registerFilterClass:[TDAddFilter class] forName:[TDAddFilter filterName]];
        [self registerFilterClass:[TDDefaultFilter class] forName:[TDDefaultFilter filterName]];
        [self registerFilterClass:[TDDefaultIfNoneFilter class] forName:[TDDefaultIfNoneFilter filterName]];
        [self registerFilterClass:[TDLpadFilter class] forName:[TDLpadFilter filterName]];
        [self registerFilterClass:[TDRpadFilter class] forName:[TDRpadFilter filterName]];
        [self registerFilterClass:[TDLengthFilter class] forName:[TDLengthFilter filterName]];
    }
    return self;
}


- (void)dealloc {
    self.staticContext = nil;
    self.printStartDelimiter = nil;
    self.printEndDelimiter = nil;
    self.tagStartDelimiter = nil;
    self.tagEndDelimiter = nil;
    self.delimiterRegex = nil;
    self.cleanerRegex = nil;
    self.tagTab = nil;
    self.filterTab = nil;
    self.tagNameRegex = nil;
    self.templateCache = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Public

- (TDTemplate *)_cachedTemplateForFilePath:(NSString *)path {
    TDTemplate *tmpl = nil;
    if (_cacheTemplates) {
        @synchronized (_templateCache) {
            tmpl = [_templateCache objectForKey:path];
        }
    }
    return tmpl;
}


- (void)_setCachedTemplate:(TDTemplate *)tmpl forFilePath:(NSString *)path {
    if (tmpl && _cacheTemplates) {
        @synchronized (_templateCache) {
            [_templateCache setObject:tmpl forKey:path];
        }
    }
}


- (TDTemplate *)templateWithContentsOfFile:(NSString *)filePath error:(NSError **)outError {
    
    TDTemplate *tmpl = nil;
    @try {
        tmpl = [self templateWithContentsOfFile:filePath];
    }
    @catch (TDTemplateException *ex) {
        if (outError) {
            NSError *err = [self errorFromParseException:ex];
            *outError = err;
        } else {
            throw ex;
        }
    }
    
    return tmpl;
}


- (NSError *)errorFromParseException:(TDTemplateException *)ex {
    NSString *reason = ex.reason;
    NSString *sample = ex.sample;
    NSString *filePath = ex.filePath;
    Token token = ex.token;
    
    id userInfo = @{
        @"reason": reason ? reason : [NSNull null],
        @"sample": sample ? sample : [NSNull null],
        @"filePath": filePath ? filePath : [NSNull null],
        @"name": ex.name,
        @"location": @(token.location()),
        @"length": @(token.length()),
        @"lineNumber": @(token.line_number()),
    };
    NSError *err = [NSError errorWithDomain:TDTemplateEngineErrorDomain code:0 userInfo:userInfo];
    return err;
}


// throws
- (TDTemplate *)templateWithContentsOfFile:(NSString *)filePath {
    return [self templateWithContentsOfFile:filePath context:nil];
}


- (TDTemplate *)templateWithContentsOfFile:(NSString *)filePath context:(TDTemplateContext *)ctx {
    TDTemplate *tmpl = [self _cachedTemplateForFilePath:filePath];
    if (tmpl) return tmpl;
    
    NSStringEncoding enc;
    NSError *err = nil;
    NSString *str = [NSString stringWithContentsOfFile:filePath usedEncoding:&enc error:&err];
    if (!str) {
        NSString *reason = [NSString stringWithFormat:@"Error reading file at path: `%@`: %@", filePath, err.localizedDescription];
        [TDTemplateException raiseWithReason:reason token:Token() sample:nil filePath:filePath];
        return nil;
    }
    
    tmpl = [self _templateFromString:str filePath:filePath context:ctx];
    
    [self _setCachedTemplate:tmpl forFilePath:filePath];
    
    return tmpl;
}


- (TDTemplate *)_templateFromString:(NSString *)str filePath:(NSString *)filePath context:(TDTemplateContext *)inCtx {
    NSParameterAssert([str length]);
    TDAssert([_printStartDelimiter length]);
    TDAssert([_printEndDelimiter length]);
    TDAssert([_tagStartDelimiter length]);
    TDAssert([_tagEndDelimiter length]);
    
    TDTemplate *tmpl = [[[TDTemplate alloc] initWithFilePath:filePath] autorelease];
    TDTemplateContext *ctx = [[[TDTemplateContext alloc] initWithTemplate:inCtx ? inCtx.originDerivedTemplate : tmpl] autorelease];
    ctx.delegate = self;
    ctx.enclosingScope = _staticContext;

    [ctx pushTemplateString:str];
    
    // lex
    TokenListPtr frags = nil;
    
    @try {
        frags = [self fragmentsFromString:str];
    } @catch (NSException *ex) {
        [TDTemplateException raiseFromException:ex token:Token() sample:nil filePath:filePath];
    }
    TDAssert(frags);
    
    // compile
    TDRootNode *root = [self compile:frags filePath:filePath inContext:ctx];
    tmpl.rootNode = root;
    tmpl.staticContext = _staticContext;
    
    // check new tmpl to see if starts wtih {% extends %}, if so inherit
    if (tmpl.extendsPath) {
        TDTemplate *superTemplate = [self templateWithContentsOfFile:tmpl.extendsPath];
        if (!superTemplate) {
            NSLog(@"Could not extend template `%@` bc it coult not be loaded or compiled.", tmpl.extendsPath);
            return nil;
        }
        
        tmpl.superTemplate = superTemplate;
    } else {
        [tmpl setBlock:root forKey:@""];
    }
    
    [ctx popTemplateString];

    return tmpl;
}


#pragma mark -
#pragma mark TDTemplateContextDelegate

- (TDTemplate *)templateContext:(TDTemplateContext *)ctx templateForFilePath:(NSString *)filePath {
    return [self templateWithContentsOfFile:filePath context:ctx];
}


- (BOOL)templateContext:(TDTemplateContext *)ctx loadTagLibrary:(NSString *)libName {
    static NSSet *sKnown = nil;
    if (!sKnown) {
        sKnown = [[NSSet alloc] initWithObjects:@"static", nil];
    }
    
    if ([sKnown containsObject:libName]) {
        return YES;
    } else {
        // TODO
        return YES;
    }
}


#pragma mark -
#pragma mark Private

- (NSString *)cleanPattern:(NSString *)inStr {
    TDAssert([inStr length]);
    TDAssert(_cleanerRegex);
    
    NSString *result = [_cleanerRegex stringByReplacingMatchesInString:inStr options:0 range:NSMakeRange(0, [inStr length]) withTemplate:@"\\\\$1"];
    return result;
}


- (BOOL)setUpDelimiterRegex:(NSError **)outErr {
    NSString *printStartDelimiter = [self cleanPattern:_printStartDelimiter];
    NSString *printEndDelimiter   = [self cleanPattern:_printEndDelimiter];
    NSString *tagStartDelimiter = [self cleanPattern:_tagStartDelimiter];
    NSString *tagEndDelimiter   = [self cleanPattern:_tagEndDelimiter];
    
    NSString *pattern = [NSString stringWithFormat:@"(%@.*?%@|%@.*?%@)", printStartDelimiter, printEndDelimiter, tagStartDelimiter, tagEndDelimiter];
    
    self.delimiterRegex = [[[NSRegularExpression alloc] initWithPattern:pattern options:0 error:outErr] autorelease];
    
    BOOL success = nil != _delimiterRegex;
    return success;
}


- (TokenListPtr)fragmentsFromString:(NSString *)inStr {
    
    NSError *err = nil;
    if (![self setUpDelimiterRegex:&err]) {
        NSLog(@"%@", err);
        return nil;
    }
    
    TokenListPtr frags = TokenListPtr(new TokenList());
    
    NSUInteger printStartDelimLen = [_printStartDelimiter length];
    NSUInteger printEndDelimLen   = [_printEndDelimiter length];
    NSUInteger tagStartDelimLen = [_tagStartDelimiter length];
    NSUInteger tagEndDelimLen   = [_tagEndDelimiter length];
    
    __block NSRange lastRange = NSMakeRange(0, 0);
    
    void(^textNodeDetector)(NSUInteger) = ^(NSUInteger currLoc) {
        NSUInteger diff = currLoc - NSMaxRange(lastRange);
        if (diff > 0) {
            NSRange txtRange = NSMakeRange(NSMaxRange(lastRange), diff);
            
            Token txtFrag_(TemplateTokenType_TEXT, {txtRange.location, txtRange.length});
            frags->push_back(txtFrag_);
        }
    };
    
    NSRange entireRange = NSMakeRange(0, inStr.length);
    [_delimiterRegex enumerateMatchesInString:inStr options:NSMatchingReportCompletion range:entireRange usingBlock:^(NSTextCheckingResult *current, NSMatchingFlags flags, BOOL *stop) {
        NSRange currRange = current.range;
        
        if (!currRange.length) return;
        
        // detect text node
        textNodeDetector(currRange.location);
        
        lastRange = currRange;
        
        TemplateTokenType tokenType = TokenType_EOF;
        NSRange contentRange = currRange;
        
        // if Print, {{foo}}
        if (NSOrderedSame == [inStr compare:_printStartDelimiter options:NSAnchoredSearch range:NSMakeRange(currRange.location, printStartDelimLen)]) {
            tokenType = TemplateTokenType_PRINT;
            contentRange.location += printStartDelimLen;
            contentRange.length -= printStartDelimLen + printEndDelimLen;
            
            Token frag(tokenType, {contentRange.location, contentRange.length});
            frags->push_back(frag);

            // else if Block Tag {% if .. %} or {% endif %}
        } else if (NSOrderedSame == [inStr compare:_tagStartDelimiter options:NSAnchoredSearch range:NSMakeRange(currRange.location, tagStartDelimLen)]) {
            contentRange.location += tagStartDelimLen;
            contentRange.length -= tagStartDelimLen + tagEndDelimLen;
            
            NSRange tagNameRange = [self.tagNameRegex rangeOfFirstMatchInString:inStr options:0 range:contentRange];
            NSRange endPrefixCheckRange = NSMakeRange(tagNameRange.location, TDTemplateEngineTagEndPrefix.length);
            if (NSOrderedSame == [inStr compare:TDTemplateEngineTagEndPrefix options:NSAnchoredSearch range:endPrefixCheckRange]) {
                contentRange = tagNameRange;
                tokenType = TemplateTokenType_BLOCK_END_TAG;
                
                frags->push_back(Token(tokenType, {contentRange.location, contentRange.length}));
                frags->push_back(Token(TemplateTokenType_TAG, {currRange.location, currRange.length}));
            } else {
                NSString *tagName = [inStr substringWithRange:tagNameRange];
                Class tagCls = [self registerdTagClassForName:tagName];
                
                switch ([tagCls tagContentType]) {
                    case TDTagContentTypeParent:
                        tokenType = TemplateTokenType_BLOCK_START_TAG;
                        frags->push_back(Token(tokenType, {contentRange.location, contentRange.length}));
                        frags->push_back(Token(TemplateTokenType_TAG, {currRange.location, currRange.length}));
                        break;
                    case TDTagContentTypeLeaf:
                        tokenType = TemplateTokenType_EMPTY_TAG;
                        frags->push_back(Token(tokenType, {contentRange.location, contentRange.length}));
                        break;
                    default:
                        TDAssert(0);
                        break;
                }
                
            }
        } else {
            TDAssert(0);
        }
    }];
    
    // detect trailing text node
    textNodeDetector(NSMaxRange(entireRange));
    
    return frags;
}



// throws TDTemplateException
- (TDRootNode *)compile:(TokenListPtr)frags filePath:(NSString *)filePath inContext:(TDTemplateContext *)ctx {
    
    TDAssert(ctx);
    TemplateParser p(self, ctx, filePath);
    
    TDRootNode *root = p.parse(frags);

    return root;
}


#pragma mark -
#pragma mark TagRegistration

- (void)registerTagClass:(Class)cls forName:(NSString *)tagName {
    TDAssert(_tagTab);
    _tagTab[tagName] = cls;
}


- (Class)registerdTagClassForName:(NSString *)tagName {
    TDAssert(_tagTab);
    Class cls = _tagTab[tagName];
    return cls;
}


#pragma mark -
#pragma mark Filter Registration

- (void)registerFilterClass:(Class)cls forName:(NSString *)filterName {
    TDAssert(_filterTab);
    _filterTab[filterName] = cls;
}


- (Class)registeredFilterClassForName:(NSString *)filterName {
    TDAssert(_filterTab);
    Class cls = _filterTab[filterName];
    return cls;
}


#pragma mark -
#pragma mark Properties

- (NSRegularExpression *)tagNameRegex {
    if (!_tagNameRegex) {
        // get contents of tag while trimming whitespace
        self.tagNameRegex = [NSRegularExpression regularExpressionWithPattern:@"\\S+" options:0 error:nil];
        TDAssert(_tagNameRegex);
    }
    return _tagNameRegex;
}

@end
