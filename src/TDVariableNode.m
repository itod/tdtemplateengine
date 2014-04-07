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

#import "TDVariableNode.h"
#import "XPExpression.h"
#import <TDTemplateEngine/TDTemplateEngine.h>
#import <TDTemplateEngine/TDTemplateContext.h>
#import <TDTemplateEngine/TDWriter.h>
#import <PEGKit/PKToken.h>

@interface TDVariableNode ()
@property (nonatomic, retain) XPExpression *expression;
@end

@implementation TDVariableNode

- (void)dealloc {
    self.expression = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Public

- (void)processFragment {
    NSParameterAssert(self.token);
    NSString *str = self.token.stringValue;
    TDAssert([str length]);
    
    NSError *err = nil;
    self.expression = [XPExpression expressionFromString:str error:&err];
    if (!_expression) {
        [NSException raise:TDTemplateEngineErrorDomain format:@"Error while compiling var tag expression `%@` : %@", str, [err localizedFailureReason]];
    }
}


- (void)renderInContext:(TDTemplateContext *)ctx {
    NSParameterAssert(ctx);
    TDAssert(_expression);
    
    id val = [_expression evaluateInContext:ctx];
    TDWriter *writer = ctx.writer;
    
    TDAssert(writer);
    [writer appendObject:val];
}


- (void)renderChildrenInContext:(TDTemplateContext *)ctx {
    // no-op
}


- (void)renderChildrenVerbatimInContext:(TDTemplateContext *)ctx {
    // no-op
}

@end
