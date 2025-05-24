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

#import "TDPrintNode.h"
#import "TDExpression.h"
#import <TDTemplateEngine/TDTemplate.h>
#import <TDTemplateEngine/TDTemplateContext.h>
#import <TDTemplateEngine/TDTemplateException.h>

@interface NSString ()
- (BOOL)isSafe;
@end

@implementation TDPrintNode

- (void)dealloc {
    self.expression = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Public

- (void)renderInContext:(TDTemplateContext *)ctx {
    NSParameterAssert(ctx);
    TDAssert(self.expression);
    
    NSString *str = nil;
    try {
        str = [self.expression evaluateAsStringInContext:ctx];
    } catch (NSException *ex) {
        [TDTemplateException raiseFromException:ex context:ctx node:self];
    }
    
    if (str.length) {
        if (ctx.autoescape && ![str isSafe]) {
            str = [ctx escapedStringForString:str];
        }
        [ctx writeObject:str];
    }
}


- (void)renderChildrenInContext:(TDTemplateContext *)ctx {
    // no-op
}

@end
