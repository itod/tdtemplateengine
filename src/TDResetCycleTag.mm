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

#import "TDResetCycleTag.h"
#import "TDCycleTag.h"
#import <TDTemplateEngine/TDPathExpression.h>
#import <TDTemplateEngine/TDTemplateContext.h>

@implementation TDResetCycleTag

+ (NSString *)tagName {
    return @"resetcycle";
}


+ (TDTagContentType)tagContentType {
    return TDTagContentTypeSimple;
}


+ (TDTagExpressionType)tagExpressionType {
    return TDTagExpressionTypeArgs;
}


- (id)runInContext:(TDTemplateContext *)ctx {
    TDAssert(ctx);
    
    NSString *name = nil;
    
    // unfortunately django templates are poorly designed :(
    // _expression here is not a string value that resolves to the name,
    // but rather the hard-coded name
    if ([self.expression isMemberOfClass:[TDPathExpression class]]) {
        TDPathExpression *path = (id)self.expression;
        name = path.head;
    } else {
        name = [TDCycleTag contextKey];
    }
    
    [ctx defineVariable:name value:@0];
    
    return nil;
}

@end
