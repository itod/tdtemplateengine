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

#import "TDTemplateEngine+XPExpressionSupport.h"

#import "XPParser.h"
#import "XPExpression.h"

#import <PEGKit/PKAssembly.h>

@interface TDTemplateEngine ()
@property (nonatomic, retain) XPParser *expressionParser;
@end

@implementation TDTemplateEngine (XPExpressionSupport)

- (PKTokenizer *)tokenizer {
    TDAssert(self.expressionParser);
    return [self.expressionParser tokenizer];
}


- (XPExpression *)expressionFromString:(NSString *)str error:(NSError **)outErr {
    TDAssert(self.expressionParser);
    PKAssembly *a = [self.expressionParser parseString:str error:outErr];
    
    XPExpression *expr = [a pop];
    
    expr = [expr simplify];
    return expr;
}


- (XPExpression *)expressionFromTokens:(NSArray *)toks error:(NSError **)outErr {
    TDAssert(self.expressionParser);
    PKAssembly *a = [self.expressionParser parseTokens:toks error:outErr];
    
    XPExpression *expr = [a pop];
    
    expr = [expr simplify];
    return expr;
}


- (XPExpression *)loopExpressionFromTokens:(NSArray *)toks error:(NSError **)outErr {
    TDAssert(self.expressionParser);
    self.expressionParser.doLoopExpr = YES;
    PKAssembly *a = [self.expressionParser parseTokens:toks error:outErr];
    self.expressionParser.doLoopExpr = NO;
    
    XPExpression *expr = [a pop];
    
    expr = [expr simplify];
    return expr;
}

@end
