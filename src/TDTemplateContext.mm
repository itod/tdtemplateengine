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

#import <TDTemplateEngine/TDTemplateContext.h>
#import <TDTemplateEngine/TDTemplate.h>
#import <TDTemplateEngine/TDRootNode.h>
#import <TDTemplateEngine/TDWriter.h>
#import <ParseKitCPP/Token.hpp>

static NSCharacterSet *sSpaceSet = nil;
static NSCharacterSet *sNewlineSet = nil;

@interface NSString (TDAdditions)
- (NSString *)td_stringByTrimmingLeadingCharactersInSet:(NSCharacterSet *)set;
- (NSString *)td_stringByTrimmingTrailingCharactersInSet:(NSCharacterSet *)set;
@end

@implementation NSString (TDAdditions)

- (NSString *)td_stringByTrimmingLeadingCharactersInSet:(NSCharacterSet *)set {
    NSString *result = self;
    
    if ([self length]) {
        NSRange leadingRange = [self rangeOfCharacterFromSet:[set invertedSet]];
        
        if (leadingRange.length) {
            result = [self substringFromIndex:leadingRange.location];
        } else {
            result = @"";
        }
    }
    
    return result;
}


- (NSString *)td_stringByTrimmingTrailingCharactersInSet:(NSCharacterSet *)set {
    NSString *result = self;
    
    if ([self length]) {
        NSRange trailingRange = [self rangeOfCharacterFromSet:[set invertedSet] options:NSBackwardsSearch];
        
        if (trailingRange.length) {
            result = [self substringToIndex:NSMaxRange(trailingRange)];
        } else {
            result = @"";
        }
    }
    
    return result;
}

@end

@interface TDTemplate ()
@property (nonatomic, retain) TDRootNode *rootNode;
@end

@interface TDTemplateContext ()
@property (nonatomic, retain) NSMutableArray *templateStringStack;

@property (nonatomic, retain) NSMutableDictionary *vars;
@property (nonatomic, retain, readwrite) TDWriter *writer;
@property (nonatomic, assign) BOOL wroteNewline;
@property (nonatomic, assign) BOOL wroteChars;

@property (nonatomic, assign) BOOL firstWriteAfterIndent;
@end

@implementation TDTemplateContext

+ (void)initialize {
    if (self == [TDTemplateContext class]) {
        sSpaceSet = [[NSCharacterSet whitespaceCharacterSet] retain];
        sNewlineSet = [[NSCharacterSet newlineCharacterSet] retain];
    }
}


- (instancetype)init {
    TDAssert(0);
    return nil;
}


- (instancetype)initWithTemplate:(TDTemplate *)tmpl {
    self = [super init];
    if (self) {
        self.derivedTemplate = tmpl;
    }
    return self;
}


- (instancetype)initWithVariables:(NSDictionary *)vars output:(NSOutputStream *)output {
    self = [super init];
    if (self) {
        self.vars = [NSMutableDictionary dictionary];
        [_vars addEntriesFromDictionary:vars];
        
        self.writer = [TDWriter writerWithOutputStream:output];
    }
    return self;
}


- (void)dealloc {
    self.delegate = nil;
    self.writer = nil;
    self.enclosingScope = nil;
    self.derivedTemplate = nil;
    
    self.templateStringStack = nil;
    self.vars = nil;
    [super dealloc];
}


- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %p global: %d, %@>", [self class], self, nil == self.enclosingScope, self.vars];
}


#pragma mark -
#pragma mark NSCopying

//- (instancetype)copyWithZone:(NSZone *)zone {  // TODO remove????
//    TDTemplateContext *ctx = [[TDTemplateContext alloc] initWithVariables:nil output:_writer.output];
//    ctx.derivedTemplate = _derivedTemplate;
//    ctx.templateStringStack = [_templateStringStack mutableCopy];
//    ctx.trimLines = _trimLines;
//    ctx.indentDepth = _indentDepth;
//    ctx.firstWriteAfterIndent = _firstWriteAfterIndent;
//    ctx.enclosingScope = self;
//    ctx.wroteNewline = _wroteNewline;
//    ctx.wroteChars = _wroteChars;
//    return ctx;
//}


#pragma mark -
#pragma mark TDScope

- (id)resolveVariable:(NSString *)name {
    NSParameterAssert([name length]);
    TDAssert(_vars);
    id result = _vars[name];
    
    if (!result && self.enclosingScope) {
        result = [self.enclosingScope resolveVariable:name];
    }
    
    return result;
}


- (void)defineVariable:(NSString *)name value:(id)value {
    //NSLog(@"%s %@=%@", __PRETTY_FUNCTION__, name, value);
    
    NSParameterAssert([name length]);
    TDAssert(_vars);
    if (value) {
        _vars[name] = value;
    } else {
        //TDAssert(_vars[name]);
        [_vars removeObjectForKey:name];
    }
}


#pragma mark -
#pragma mark Rendering

- (void)writeObject:(id)obj {
    TDAssert(_writer);
    
    NSString *str = nil;
    if ([obj isKindOfClass:[NSString class]]) {
        str = obj;
    } else if ([obj respondsToSelector:@selector(stringValue)]) {
        str = [obj stringValue];
    } else {
        str = [obj description];
    }
    [self writeString:str];
}


- (void)writeString:(NSString *)str {
    TDAssert(_writer);
    
    if (_trimLines) {
        NSArray *comps = [str componentsSeparatedByCharactersInSet:sNewlineSet];
        
        BOOL isFirst = YES;
        BOOL isLast = NO;
        NSUInteger idx = 0;
        NSUInteger lastIdx = [comps count] - 1;
        NSString *fmt = nil;
        
        for (NSString *comp in comps) {
            isLast = lastIdx == idx++;
            
            if (isFirst && isLast) {
                fmt = @"%@";
            } else if (isFirst && _wroteChars && ![comp length]) {
                comp = @"\n";
                fmt = @"%@";
            } else if (isFirst) {
                comp = [comp td_stringByTrimmingTrailingCharactersInSet:sSpaceSet];
                fmt = @"%@\n";
            } else if (isLast) {
                comp = [comp td_stringByTrimmingLeadingCharactersInSet:sSpaceSet];
                fmt = @"%@";
            } else {
                comp = [comp stringByTrimmingCharactersInSet:sSpaceSet];
                if ([comp length]) {
                    fmt = @"%@\n";
                } else {
                    comp = @"\n";
                    fmt = @"%@";
                }
            }
            
            if ([comp length]) {
                if (_firstWriteAfterIndent || _wroteNewline) {
                    self.firstWriteAfterIndent = NO;
                    for (NSUInteger depth = 0; depth < _indentDepth; ++depth) {
                        [_writer appendString:@"    "];
                    }
                }
                [_writer appendFormat:fmt, comp];
                self.wroteNewline = [fmt hasSuffix:@"\n"] || [comp hasSuffix:@"\n"];
                self.wroteChars = !_wroteNewline;
            }
            isFirst = NO;
        }
    } else {
        [_writer appendString:str];
    }
}


- (NSArray *)iterations:(NSUInteger)count of:(NSString *)str {
    TDAssert(str);
    NSMutableArray *vec = [NSMutableArray arrayWithCapacity:count];
    while (count > 0) {
        [vec addObject:str];
        --count;
    }
    return vec;
}


- (void)increaseIndentDepth:(NSUInteger)times {
    self.indentDepth += times;
    self.firstWriteAfterIndent = YES;
}


- (void)decreaseIndentDepth:(NSUInteger)times {
    self.indentDepth -= times;
    self.firstWriteAfterIndent = YES;
}


- (NSString *)absolutePathForPath:(NSString *)relPath {
    NSString *peerPath = _derivedTemplate.filePath;
    NSString *absPath = nil;
    
    if (!peerPath || [relPath hasPrefix:@"/"]) {
        absPath = relPath;
    } else {
        NSString *dirPath = [peerPath stringByDeletingLastPathComponent];
        absPath = [dirPath stringByAppendingPathComponent:relPath];
    }

    return absPath;
}


- (NSString *)templateSubstringForToken:(parsekit::Token)token {
    NSString *result = nil;
    if ([self peekTemplateString]) {
        parsekit::TokenRange range = token.range();
        result = [[self peekTemplateString] substringWithRange:NSMakeRange(range.location, range.length)];
    } else {
        result = [self.enclosingScope templateSubstringForToken:token];
    }
    return result;
}


- (void)pushTemplateString:(NSString *)str {
    TDAssert(str);
    if (!_templateStringStack) {
        self.templateStringStack = [NSMutableArray array];
    }
    [_templateStringStack addObject:str];
}


- (void)popTemplateString {
    TDAssert(_templateStringStack);
    [_templateStringStack removeLastObject];
}


- (NSString *)peekTemplateString {
    TDAssert(_templateStringStack);
    return _templateStringStack.lastObject;
}

@end
