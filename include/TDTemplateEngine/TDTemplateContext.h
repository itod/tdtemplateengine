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

#import <Foundation/Foundation.h>
#import <ParseKitCPP/Token.hpp>

@class TDTemplate;
@class TDWriter;
@class TDTemplateContext;

@protocol TDTemplateContextDelegate <NSObject>
- (TDTemplate *)templateContext:(TDTemplateContext *)ctx templateForFilePath:(NSString *)filePath error:(NSError **)err;
- (BOOL)templateContext:(TDTemplateContext *)ctx loadTagLibrary:(NSString *)libName error:(NSError **)err;
@end

@interface TDTemplateContext : NSObject

- (instancetype)init; // static
- (instancetype)initWithTemplate:(TDTemplate *)tmpl; // compile time
- (instancetype)initWithVariables:(NSDictionary *)vars output:(NSOutputStream *)output; // runtime

@property (nonatomic, assign) id <TDTemplateContextDelegate>delegate; // weakref

// Scope
- (id)resolveVariable:(NSString *)name;
- (void)defineVariable:(NSString *)name value:(id)value; // dont put TDValues or TDExpressions in here. should be evaled already

- (void)writeObject:(id)obj;
- (void)writeString:(NSString *)str;
- (NSString *)escapedStringForString:(NSString *)inStr;

@property (nonatomic, retain) TDTemplateContext *enclosingScope;
@property (nonatomic, assign) BOOL trimLines;
@property (nonatomic, assign) BOOL autoescape;
@property (nonatomic, retain) NSMutableArray *expressionObjectStack;

- (void)increaseIndentDepth:(NSUInteger)times;
- (void)decreaseIndentDepth:(NSUInteger)times;
@property (nonatomic, assign) NSInteger indentDepth;

@property (nonatomic, retain) TDTemplate *derivedTemplate;
- (NSString *)absolutePathForTemplateRelativePath:(NSString *)relPath;
- (NSString *)absolutePathForPath:(NSString *)relPath relativeTo:(NSString *)peerPath;

- (NSString *)templateSubstringForToken:(parsekit::Token)token;
- (void)pushTemplateString:(NSString *)str;
- (void)popTemplateString;
- (NSString *)peekTemplateString;
@end
