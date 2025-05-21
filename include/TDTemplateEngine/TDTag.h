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

#import <TDTemplateEngine/TDNode.h>

@class TDTemplateContext;
@class TDExpression;

typedef NS_ENUM(NSUInteger, TDTagContentType) {
    TDTagContentTypeSimple = 0,
    TDTagContentTypeComplex,
};

typedef NS_ENUM(NSUInteger, TDTagExpressionType) {
    TDTagExpressionTypeDefault = 0,
    TDTagExpressionTypeLoop,
    TDTagExpressionTypeArgs,
    TDTagExpressionTypeKwargs,
    TDTagExpressionTypeLoad,
    TDTagExpressionTypeInclude,
    TDTagExpressionTypeCycle,
};

@interface TDTag : TDNode

// exprs to be evaled at runtime
@property (nonatomic, retain) NSArray *args;
@property (nonatomic, retain) NSDictionary *kwargs;
@end

// Subclasses must override these methods
@interface TDTag (Override)
+ (NSString *)tagName;
+ (TDTagContentType)tagContentType;
+ (TDTagExpressionType)tagExpressionType;

+ (NSString *)outputTemplatePath;

- (id)runInContext:(TDTemplateContext *)ctx;
@end
