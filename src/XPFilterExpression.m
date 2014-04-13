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

#import "XPFilterExpression.h"
#import "XPValue.h"
#import <TDTemplateEngine/TDTemplateEngine.h>
#import <TDTemplateEngine/TDTemplateContext.h>
#import <TDTemplateEngine/TDFilter.h>
#import <PEGKit/PKToken.h>

@interface XPFilterExpression ()
@property (nonatomic, retain) XPExpression *expr;
@property (nonatomic, retain) TDFilter *filter;
@property (nonatomic, retain) NSArray *args;
@end

@implementation XPFilterExpression

+ (instancetype)filterExpressionWithExpression:(XPExpression *)expr filter:(TDFilter *)filter arguments:(NSArray *)args {
    return [[[self alloc] initWithExpression:expr filter:filter arguments:args] autorelease];
}


- (instancetype)initWithExpression:(XPExpression *)expr filter:(TDFilter *)filter arguments:(NSArray *)args {
    self = [super init];
    if (self) {
        TDAssert([expr isKindOfClass:[XPExpression class]]);
        self.expr = expr;
        
        self.filter = filter;
        TDAssert(_filter);
        
        if ([args count]) {
            self.args = args;
        }
    }
    return self;
}


- (void)dealloc {
    self.expr = nil;
    self.filter = nil;
    self.args = nil;
    [super dealloc];
}


- (XPValue *)evaluateInContext:(TDTemplateContext *)ctx {
    TDAssert(ctx);
    TDAssert(_expr);
    TDAssert(_filter);
    
    NSArray *evaledArgs = [self evaluatedArgs:ctx];
    id obj = [_expr evaluateInContext:ctx];
    obj = [_filter doFilter:obj withArguments:evaledArgs];
    
    XPValue *val = XPValueFromObject(obj);
    return val;
}


- (NSArray *)evaluatedArgs:(TDTemplateContext *)ctx {
    NSUInteger c = [_args count];
    
    id evaledArgs = nil;
    if (c) {
        evaledArgs = [NSMutableArray arrayWithCapacity:c];
        
        for (PKToken *tok in _args) {
            switch (tok.tokenType) {
                case PKTokenTypeQuotedString:
                    [evaledArgs addObject:[tok.stringValue substringWithRange:NSMakeRange(1, [tok.stringValue length]-2)]];
                    break;
                case PKTokenTypeWord:
                    [evaledArgs addObject:[ctx resolveVariable:tok.stringValue]];
                    break;
                default:
                    TDAssert(0);
                    break;
            }
        }
    }
    
    return evaledArgs;
}

@end
