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

#import "XPArithmeticExpression.h"
#import "XPValue.h"
#import "XPNumericValue.h"
#import "XPParser.h"

@interface XPBinaryExpression ()
@property (nonatomic, retain) XPExpression *p1;
@property (nonatomic, retain) XPExpression *p2;
@property (nonatomic, assign) NSInteger operator;
@end

@implementation XPArithmeticExpression

+ (XPArithmeticExpression *)arithmeticExpression {
    return [[[self alloc] init] autorelease];
}


+ (XPArithmeticExpression *)arithmeticExpressionWithOperand:(XPExpression *)lhs operator:(NSInteger)op operand:(XPExpression *)rhs {
    return [[[self alloc] initWithOperand:lhs operator:op operand:rhs] autorelease];
}


- (XPValue *)evaluateInContext:(TDTemplateContext *)ctx {
    double n = [self evaluateAsNumberInContext:ctx];
    return [XPNumericValue numericValueWithNumber:n];
}


- (double)evaluateAsNumberInContext:(TDTemplateContext *)ctx {
    double n1 = [self.p1 evaluateAsNumberInContext:ctx];
    double n2 = [self.p2 evaluateAsNumberInContext:ctx];

    switch (self.operator) {
        case XP_TOKEN_KIND_PLUS:
            return n1 + n2;
        case XP_TOKEN_KIND_MINUS:
            return n1 - n2;
        case XP_TOKEN_KIND_TIMES:
            return n1 * n2;
        case XP_TOKEN_KIND_DIV:
            return n1 / n2;
        case XP_TOKEN_KIND_MOD:
            return lrint(n1) % lrint(n2);
//        case XP_TOKEN_KIND_MINUS:
//            return -n2;
        default:
            [NSException raise:@"XPathException" format:@"invalid operator in arithmetic expr"];
            return NAN;
            break;
    }
}


- (XPDataType)dataType {
    return XPDataTypeNumber;
}

@end
