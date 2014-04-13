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

@class TDNode;
@class TDTag;
@class TDFilter;
@class TDTemplateContext;

extern NSString * const TDTemplateEngineTagEndPrefix;
extern NSString * const TDTemplateEngineErrorDomain;
extern const NSInteger TDTemplateEngineRenderingErrorCode;

@interface TDTemplateEngine : NSObject

+ (instancetype)templateEngine;

// pre-compile template into a tree
- (TDNode *)compileTemplateString:(NSString *)str error:(NSError **)err;
- (TDNode *)compileTemplateFile:(NSString *)path encoding:(NSStringEncoding)enc error:(NSError **)err;

// render pre-compiled tree with render-time vars
- (BOOL)renderTemplateTree:(TDNode *)root withVariables:(NSDictionary *)vars toStream:(NSOutputStream *)output error:(NSError **)err;

// convenience. compile + render with render-time vars in one shot
- (BOOL)processTemplateString:(NSString *)str withVariables:(NSDictionary *)vars toStream:(NSOutputStream *)output error:(NSError **)err;
- (BOOL)processTemplateFile:(NSString *)path encoding:(NSStringEncoding)enc withVariables:(NSDictionary *)vars toStream:(NSOutputStream *)output error:(NSError **)err;

// static/compile-time vars go here. this is the global scope at both compile-time and render-time. persists across compiles and renders.
@property (nonatomic, retain, readonly) TDTemplateContext *staticContext;

@property (nonatomic, copy) NSString *printStartDelimiter;
@property (nonatomic, copy) NSString *printEndDelimiter;
@property (nonatomic, copy) NSString *tagStartDelimiter;
@property (nonatomic, copy) NSString *tagEndDelimiter;
@end

@interface TDTemplateEngine (TagRegistration)
- (void)registerTagClass:(Class)cls forName:(NSString *)tagName;
- (Class)registerdTagClassForName:(NSString *)tagName;
- (TDTag *)makeTagForName:(NSString *)tagName;
@end

@interface TDTemplateEngine (FilterRegistration)
- (void)registerFilterClass:(Class)cls forName:(NSString *)filterName;
- (Class)registerdFilterClassForName:(NSString *)filterName;
- (TDFilter *)makeFilterForName:(NSString *)filterName;
@end
