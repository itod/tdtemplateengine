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

#ifdef TARGET_OS_IPHONE
#import <TDTemplateEngine/TDExpression.h>
#import <TDTemplateEngine/TDFilter.h>
#import <TDTemplateEngine/TDNode.h>
#import <TDTemplateEngine/TDTag.h>
#import <TDTemplateEngine/TDTemplateContext.h>
#import <TDTemplateEngine/TDTemplateEngine.h>
#import <TDTemplateEngine/TDWriter.h>
#import <TDTemplateEngine/TDTemplate.h>
#endif

//
//  TDTemplateengine.h
//  TDTemplateengine
//
//  Created by Todd Ditchendorf on 5/12/16.
//  Copyright © 2016 Todd Ditchendorf. All rights reserved.
//

//! Project version number for TDTemplateengine.
FOUNDATION_EXPORT double TDTemplateengineVersionNumber;

//! Project version string for TDTemplateengine.
FOUNDATION_EXPORT const unsigned char TDTemplateengineVersionString[];

@class TDTag;
@class TDFilter;
@class TDTemplateContext;
@class TDTemplate;

extern NSString * const TDTemplateEngineTagEndPrefix;
extern NSString * const TDTemplateEngineErrorDomain;
extern const NSInteger TDTemplateEngineRenderingErrorCode;

@interface TDTemplateEngine : NSObject

+ (instancetype)templateEngine;

// static/compile-time vars go here. this is the global scope at both compile-time and render-time. persists across compiles and renders.
@property (nonatomic, retain, readonly) TDTemplateContext *staticContext;

- (TDTemplate *)templateWithContentsOfFile:(NSString *)path error:(NSError **)err;
@property (nonatomic, assign) BOOL cacheTemplates;
@end

@interface TDTemplateEngine (TagRegistration)
- (void)registerTagClass:(Class)cls forName:(NSString *)tagName;
- (Class)registerdTagClassForName:(NSString *)tagName;
- (TDTag *)makeTagForName:(NSString *)tagName;
@end

@interface TDTemplateEngine (FilterRegistration)
- (void)registerFilterClass:(Class)cls forName:(NSString *)filterName;
- (Class)registeredFilterClassForName:(NSString *)filterName;
- (TDFilter *)makeFilterForName:(NSString *)filterName;
@end

// TODO move all this to private & testing?
@class TDNode;
@class TDRootNode;
@interface TDTemplateEngine (FriendAPI)
// pre-compile template into a tree
- (TDRootNode *)compileTemplateString:(NSString *)str error:(NSError **)err;
- (TDRootNode *)compileTemplateFile:(NSString *)path encoding:(NSStringEncoding)enc error:(NSError **)err;


// TODO all these need to go away
// render pre-compiled tree with render-time vars
//- (BOOL)renderTemplateTree:(TDRootNode *)root withVariables:(NSDictionary *)vars toStream:(NSOutputStream *)output error:(NSError **)err;

// convenience. compile + render with render-time vars in one shot
- (BOOL)processTemplateString:(NSString *)str withVariables:(NSDictionary *)vars toStream:(NSOutputStream *)output error:(NSError **)err;
- (BOOL)processTemplateFile:(NSString *)path encoding:(NSStringEncoding)enc withVariables:(NSDictionary *)vars toStream:(NSOutputStream *)output error:(NSError **)err;
@end
