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
#import <TDTemplateEngine/TDNode.h>
#import <TDTemplateEngine/TDTemplateContext.h>
#import <TDTemplateEngine/TDTemplate.h>
#import "TDTemplateEngine+ExpressionSupport.h"

#import "TDRootNode.h"
#import "TDTextNode.h"
#import "TDPrintNode.h"

#import "TDExpression.h"

#import "TDCompileTimeTag.h"
#import "TDIfTag.h"
#import "TDElseTag.h"
#import "TDElseIfTag.h"
#import "TDForTag.h"
#import "TDSkipTag.h"
#import "TDCommentTag.h"
//#import "TDVerbatimTag.h"
#import "TDTrimTag.h"
#import "TDIndentTag.h"
#import "TDNewlineTag.h"
#import "TDSpaceTag.h"
#import "TDTabTag.h"
#import "TDSepTag.h"

#import "TDTrimFilter.h"
#import "TDRoundFilter.h"
#import "TDFloorFilter.h"
#import "TDCeilFilter.h"
#import "TDFabsFilter.h"
#import "TDNumberFormatFilter.h"
#import "TDDateFormatFilter.h"
#import "TDNullFormatFilter.h"
#import "TDLowercaseFilter.h"
#import "TDUppercaseFilter.h"
#import "TDCapitalizeFilter.h"
#import "TDUncapitalizeFilter.h"
#import "TDBoolFilter.h"
#import "TDReplaceFilter.h"
#import "TDPadFilters.h"

#import <ParseKitCPP/Tokenizer.hpp>
#import <ParseKitCPP/ParseException.hpp>
#import "TemplateParser.hpp"
#import "ExpressionParser.hpp"

using namespace parsekit;
using namespace templateengine;

NSString * const TDTemplateEngineTagEndPrefix = @"end";
NSString * const TDTemplateEngineErrorDomain = @"TDTemplateEngineErrorDomain";
const NSInteger TDTemplateEngineRenderingErrorCode = 1;

@interface TDTemplate ()
- (instancetype)initWithDocument:(TDNode *)doc;
- (void)addBlocksFromNode:(TDNode *)node;
@end

// PRIVATE
@interface TDTemplateEngine ()
@property (nonatomic, retain) NSMutableDictionary *templateCache;

@property (nonatomic, retain) NSRegularExpression *delimiterRegex;
@property (nonatomic, retain) NSRegularExpression *cleanerRegex;
@property (nonatomic, retain) NSRegularExpression *tagNameRegex;
@property (nonatomic, retain, readwrite) TDTemplateContext *staticContext;
@property (nonatomic, retain) NSMutableDictionary *tagTab;
@property (nonatomic, retain) NSMutableDictionary *filterTab;

@property (nonatomic, copy) NSString *printStartDelimiter;
@property (nonatomic, copy) NSString *printEndDelimiter;
@property (nonatomic, copy) NSString *tagStartDelimiter;
@property (nonatomic, copy) NSString *tagEndDelimiter;
@end

@implementation TDTemplateEngine

+ (instancetype)templateEngine {
    return [[[TDTemplateEngine alloc] init] autorelease];
}


- (instancetype)init {
    self = [super init];
    if (self) {
        self.printStartDelimiter = @"{{";
        self.printEndDelimiter = @"}}";
        self.tagStartDelimiter = @"{%";
        self.tagEndDelimiter = @"%}";
        self.staticContext = [[[TDTemplateContext alloc] init] autorelease];
        
        NSError *err = nil;
        self.cleanerRegex = [NSRegularExpression regularExpressionWithPattern:@"([{}\\[\\]\\(\\).+?*])" options:NSRegularExpressionAnchorsMatchLines error:&err];
        TDAssert(!err);
        TDAssert(_cleanerRegex);
        
        self.tagTab = [NSMutableDictionary dictionary];
        [self registerTagClass:[TDIfTag class] forName:[TDIfTag tagName]];
        [self registerTagClass:[TDElseTag class] forName:[TDElseTag tagName]];
        [self registerTagClass:[TDElseIfTag class] forName:[TDElseIfTag tagName]];
        [self registerTagClass:[TDForTag class] forName:[TDForTag tagName]];
        [self registerTagClass:[TDSkipTag class] forName:[TDSkipTag tagName]];
        [self registerTagClass:[TDCommentTag class] forName:[TDCommentTag tagName]];
//        [self registerTagClass:[TDVerbatimTag class] forName:[TDVerbatimTag tagName]];
        [self registerTagClass:[TDTrimTag class] forName:[TDTrimTag tagName]];
        [self registerTagClass:[TDIndentTag class] forName:[TDIndentTag tagName]];
        [self registerTagClass:[TDNewlineTag class] forName:[TDNewlineTag tagName]];
        [self registerTagClass:[TDSpaceTag class] forName:[TDSpaceTag tagName]];
        [self registerTagClass:[TDTabTag class] forName:[TDTabTag tagName]];
        [self registerTagClass:[TDSepTag class] forName:[TDSepTag tagName]];
        
        self.filterTab = [NSMutableDictionary dictionary];
        [self registerFilterClass:[TDTrimFilter class] forName:[TDTrimFilter filterName]];
        [self registerFilterClass:[TDRoundFilter class] forName:[TDRoundFilter filterName]];
        [self registerFilterClass:[TDFloorFilter class] forName:[TDFloorFilter filterName]];
        [self registerFilterClass:[TDCeilFilter class] forName:[TDCeilFilter filterName]];
        [self registerFilterClass:[TDFabsFilter class] forName:[TDFabsFilter filterName]];
        [self registerFilterClass:[TDNumberFormatFilter class] forName:[TDNumberFormatFilter filterName]];
        [self registerFilterClass:[TDDateFormatFilter class] forName:[TDDateFormatFilter filterName]];
        [self registerFilterClass:[TDNullFormatFilter class] forName:[TDNullFormatFilter filterName]];
        [self registerFilterClass:[TDLowercaseFilter class] forName:[TDLowercaseFilter filterName]];
        [self registerFilterClass:[TDUppercaseFilter class] forName:[TDUppercaseFilter filterName]];
        [self registerFilterClass:[TDCapitalizeFilter class] forName:[TDCapitalizeFilter filterName]];
        [self registerFilterClass:[TDUncapitalizeFilter class] forName:[TDUncapitalizeFilter filterName]];
        [self registerFilterClass:[TDBoolFilter class] forName:[TDBoolFilter filterName]];
        [self registerFilterClass:[TDReplaceFilter class] forName:[TDReplaceFilter filterName]];
        [self registerFilterClass:[TDLpadFilter class] forName:[TDLpadFilter filterName]];
        [self registerFilterClass:[TDRpadFilter class] forName:[TDRpadFilter filterName]];
    }
    return self;
}


- (void)dealloc {
    self.printStartDelimiter = nil;
    self.printEndDelimiter = nil;
    self.tagStartDelimiter = nil;
    self.tagEndDelimiter = nil;
    self.delimiterRegex = nil;
    self.cleanerRegex = nil;
    self.staticContext = nil;
    self.tagTab = nil;
    self.filterTab = nil;
    self.tagNameRegex = nil;
    self.templateCache = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Public

- (TDRootNode *)compileTemplateFile:(NSString *)path encoding:(NSStringEncoding)enc error:(NSError **)err {
    NSParameterAssert([path length]);
    
    TDRootNode *root = nil;
    NSString *str = [NSString stringWithContentsOfFile:path encoding:enc error:err];
    
    if (str) {
        root = [self compileTemplateString:str error:err];
    }
    
    return root;
}


- (TDRootNode *)compileTemplateString:(NSString *)str error:(NSError **)err {
    NSParameterAssert([str length]);
    TDAssert([_printStartDelimiter length]);
    TDAssert([_printEndDelimiter length]);
    TDAssert([_tagStartDelimiter length]);
    TDAssert([_tagEndDelimiter length]);
    
    TDAssert(_staticContext);
    _staticContext.templateString = str;
    
    // lex
    TokenListPtr frags = nil;
    
    @try {
        frags = [self fragmentsFromString:str];
    } @catch (NSException *ex) {
        if (err) {
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:[ex userInfo]];
            if (![userInfo count]) {
                userInfo[NSLocalizedFailureReasonErrorKey] = ex.reason;
            }
            *err = [NSError errorWithDomain:TDTemplateEngineErrorDomain code:TDTemplateEngineRenderingErrorCode userInfo:userInfo];
        }
        return nil;
    }
    TDAssert(frags);
    
    // compile
    TDRootNode *root = [self compile:frags error:err];
    
    _staticContext.templateString = nil;
    
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
    dynamicContext.templateString = [(id)root templateString];
    
    BOOL success = YES;
    
    @try {
        [root renderInContext:dynamicContext];
    }
    @catch (NSException *ex) {
        success = NO;
        if (err) *err = [NSError errorWithDomain:TDTemplateEngineErrorDomain code:TDTemplateEngineRenderingErrorCode userInfo:[[[ex userInfo] copy] autorelease]];
    }
    
    return success;
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


- (TDTemplate *)templateWithContentsOfFile:(NSString *)path error:(NSError **)err {
    TDTemplate *tmpl = nil;
    
    if (_cacheTemplates) {
        tmpl = [_templateCache objectForKey:path];
        if (tmpl) return tmpl;
    }
    
    NSStringEncoding enc;
    NSString *str = [NSString stringWithContentsOfFile:path usedEncoding:&enc error:err];
    if (!str) {
        if (*err) NSLog(@"%@", *err);
        return nil;
    }
    
    tmpl = [self _templateFromString:str error:err];
    
    if (tmpl && _cacheTemplates) {
        if (!_templateCache) {
            self.templateCache = [NSMutableDictionary dictionary];
        }
        [_templateCache setObject:tmpl forKey:path];
    }
    
    return tmpl;
}


- (TDTemplate *)_templateFromString:(NSString *)str error:(NSError **)err {
    TDRootNode *node = [self compileTemplateString:str error:err];
    if (!node) {
        if (*err) NSLog(@"%@", *err);
        return nil;
    }
    
    TDTemplate *tmpl = nil;
    
    // check `doc` to see if starts wtih {% extends %}
    if (node.extendsPath) {
        TDTemplate *superTemplate = [self templateWithContentsOfFile:node.extendsPath error:err];
        if (!superTemplate) {
            NSLog(@"Could not extend template `%@` bc it coult not be loaded or compiled.", node.extendsPath);
            return nil;
        }
        
        tmpl = [[superTemplate copy] autorelease];
        [tmpl addBlocksFromNode:node];
        
    } else {
        tmpl = [[[TDTemplate alloc] initWithDocument:node] autorelease];
    }
    
    TDAssert(tmpl);
    return tmpl;
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
            
            // else if Block Tag {% if .. %} or {% endif %}
        } else if (NSOrderedSame == [inStr compare:_tagStartDelimiter options:NSAnchoredSearch range:NSMakeRange(currRange.location, tagStartDelimLen)]) {
            contentRange.location += tagStartDelimLen;
            contentRange.length -= tagStartDelimLen + tagEndDelimLen;
            
            NSRange tagNameRange = [self.tagNameRegex rangeOfFirstMatchInString:inStr options:0 range:contentRange];
            NSRange endPrefixCheckRange = NSMakeRange(tagNameRange.location, TDTemplateEngineTagEndPrefix.length);
            if (NSOrderedSame == [inStr compare:TDTemplateEngineTagEndPrefix options:NSAnchoredSearch range:endPrefixCheckRange]) {
                contentRange = tagNameRange;
                tokenType = TemplateTokenType_BLOCK_END_TAG;
            } else {
                NSString *tagName = [inStr substringWithRange:tagNameRange];
                Class tagCls = [self registerdTagClassForName:tagName];
                
                switch ([tagCls tagType]) {
                    case TDTagTypeBlock:
                        tokenType = TemplateTokenType_BLOCK_START_TAG;
                        break;
                    case TDTagTypeEmpty:
                        tokenType = TemplateTokenType_EMPTY_TAG;
                        break;
                    default:
                        TDAssert(0);
                        break;
                }
            }
        } else {
            TDAssert(0);
        }
        
        Token frag_(tokenType, {contentRange.location, contentRange.length});
        frags->push_back(frag_);
    }];
    
    // detect trailing text node
    textNodeDetector(NSMaxRange(entireRange));
    
    return frags;
}


- (TDRootNode *)compile:(TokenListPtr)frags error:(NSError **)outError {
    
    TDAssert(_staticContext);
    TemplateParser p(self, _staticContext);
    
    TDRootNode *root = nil;
    try {
        root = p.parse(frags);
    }
//    @catch (PKRecognitionException *rex) {
//        NSString *domain = PEGKitErrorDomain;
//        NSString *name = rex.currentName;
//        NSString *reason = rex.currentReason;
//        NSRange range = rex.range;
//        NSUInteger lineNumber = rex.lineNumber;
//        //NSLog(@"%@: %@", name, reason);
//
//        if (outError) {
//            *outError = [self errorWithDomain:domain name:name reason:reason range:range lineNumber:lineNumber];
//        } else {
//            [rex raise];
//        }
//    }
    catch (ParseException& ex) {
        NSString *domain = @"ParseKitErrorDomain";
        NSString *name = @"ParseError"; //[ex name];
        NSString *reason = [NSString stringWithUTF8String:ex.message().c_str()]; //[ex reason];
        //NSLog(@"%@", reason);
        
        if (outError) {
            *outError = [self errorWithDomain:domain name:name reason:reason range:NSMakeRange(NSNotFound, 0) lineNumber:0];
        } else {
            throw ex;
        }
    }

    return root;
}


- (NSError *)errorWithDomain:(NSString *)domain name:(NSString *)name reason:(NSString *)reason range:(NSRange)r lineNumber:(NSUInteger)lineNum {
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];

    // get description
    name = name ? name : NSLocalizedString(@"A parsing recognition exception occured.", @"");
    [userInfo setObject:name forKey:NSLocalizedDescriptionKey];
    
    // get reason
    reason = reason ? reason : @"";
    userInfo[NSLocalizedFailureReasonErrorKey] = reason;
    userInfo[@"ParseKitErrorRangeKey"] = [NSValue valueWithRange:r];
    
    id lineNumVal = nil;
    if (NSNotFound == lineNum) {
        lineNumVal = NSLocalizedString(@"Unknown", @"");
    } else {
        lineNumVal = @(lineNum);
    }
    userInfo[@"ParseKitErrorLineNumberKey"] = lineNumVal;
    
    // convert to NSError
    NSError *err = [NSError errorWithDomain:@"ParseKitErrorDomain" code:0 userInfo:[[userInfo copy] autorelease]];
    return err;
}


#pragma mark -
#pragma mark TemplateParser API

- (TDPrintNode *)printNodeFromFragment:(Token)frag withParent:(TDNode *)parent {
    NSParameterAssert(!frag.is_eof());
    NSParameterAssert(parent);
    
    NSString *str = [_staticContext templateSubstringForToken:frag];
    TDAssert(str.length);
    
    NSError *err = nil;
    TDExpression *expr = [self expressionFromString:str error:&err];
    if (!expr) {
        [NSException raise:TDTemplateEngineErrorDomain format:@"Error while compiling print node expression `%@`\n\n%@", str, [err localizedFailureReason]];
    }
    
    TDAssert(expr);
    TDPrintNode *printNode = [TDPrintNode nodeWithToken:frag parent:parent];
    printNode.expression = expr;
    return printNode;
}


- (TDTag *)tagFromFragment:(Token)frag withParent:(TDNode *)parent {
    NSParameterAssert(!frag.is_eof());
    NSParameterAssert(parent);
    
    NSString *str = [_staticContext templateSubstringForToken:frag];
    
    NSStringEncoding enc = NSUTF8StringEncoding;
    NSUInteger maxByteLen = [str maximumLengthOfBytesUsingEncoding:enc];
    char zstr[maxByteLen+1]; // +1 for null-term
    NSUInteger byteLen;
    NSRange remaining;
    
    if (![str getBytes:zstr maxLength:maxByteLen usedLength:&byteLen encoding:enc options:0 range:NSMakeRange(0, str.length) remainingRange:&remaining]) {
        TDAssert(0);
    }
    TDAssert(0 == remaining.length);
    
    // must make it null-terminated bc -getBytes: does not include terminator
    zstr[byteLen] = '\0';

    std::string input(zstr);
    ReaderCPP r(input);
    
    Tokenizer *t = ExpressionParser::tokenizer();
    Token tok = t->next(&r);
    TDAssert(TokenType_WORD == tok.token_type());
    NSString *tagName = [NSString stringWithUTF8String:r.cpp_substr(tok).c_str()];
    
    // tokenize
    TDTag *tag = [self makeTagForName:tagName token:frag parent:parent];
    TDAssert(tag);
    
    // compile expression if present
    size_t offset = r.offset();
    tok = t->next(&r);
    if (TokenType_EOF != tok.token_type()) {
        r.set_offset(offset);
        tag.expression = [self expressionForTagName:tagName fromFragment:frag reader:&r];
    }
    
    if ([tag isKindOfClass:[TDCompileTimeTag class]]) {
        TDCompileTimeTag *cttag = (TDCompileTimeTag *)tag;
        [cttag compileInContext:_staticContext];
    }
    
    return tag;
}


- (TDExpression *)expressionForTagName:(NSString *)tagName fromFragment:(Token)frag reader:(Reader *)reader {
    NSParameterAssert(reader);
    
    TDExpression *expr = nil;
    NSError *err = nil;
    
    BOOL doLoop = [tagName isEqualToString:@"for"];
    if (doLoop) {
        expr = [self loopExpressionFromReader:reader error:&err];
    } else {
        expr = [self expressionFromReader:reader error:&err];
    }
    
    if (!expr) {
        // TODO
        NSString *exprString = [_staticContext templateSubstringForToken:frag];
        NSString *msg = [NSString stringWithFormat:@"Error while compiling tag expression `%@` : %@", exprString, [err localizedFailureReason]];
        throw ParseException([msg UTF8String]);
    }
    
    return expr;
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


- (TDTag *)makeTagForName:(NSString *)tagName token:(Token)token parent:(TDNode *)parent {
    TDAssert(_tagTab);
    Class cls = [self registerdTagClassForName:tagName];
    if (!cls) {
        [NSException raise:TDTemplateEngineErrorDomain format:@"Unknown tag name '%@'", tagName];
    }
    TDTag *tag = [[[cls alloc] initWithToken:token parent:parent] autorelease];
    TDAssert(tag);
    TDAssert([tag.tagName isEqualToString:tagName]);
    return tag;
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


- (TDFilter *)makeFilterForName:(NSString *)filterName {
    Class cls = _filterTab[filterName];
    if (!cls) {
        [NSException raise:TDTemplateEngineErrorDomain format:@"Unknown filter name '%@'", filterName];
    }
    TDFilter *filter = [[[cls alloc] init] autorelease];
    TDAssert(filter);
    TDAssert([filter.filterName isEqualToString:filterName]);
    return filter;
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
