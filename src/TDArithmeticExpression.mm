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

#import "TDArithmeticExpression.h"
#import "TDValue.h"
#import "TDNumericValue.h"
#import "TagParser.hpp"

using namespace templateengine;

@interface TDBinaryExpression ()
@property (nonatomic, retain) TDExpression *p1;
@property (nonatomic, retain) TDExpression *p2;
@property (nonatomic, assign) NSInteger binaryOperator;
@end

@implementation TDArithmeticExpression

+ (TDArithmeticExpression *)arithmeticExpression {
    return [[[self alloc] init] autorelease];
}


+ (TDArithmeticExpression *)arithmeticExpressionWithOperand:(TDExpression *)lhs operator:(NSInteger)op operand:(TDExpression *)rhs {
    return [[[self alloc] initWithOperand:lhs operator:op operand:rhs] autorelease];
}


- (TDValue *)evaluateInContext:(TDTemplateContext *)ctx {
    double n = [self evaluateAsNumberInContext:ctx];
    return [TDNumericValue numericValueWithNumber:n];
}


- (double)evaluateAsNumberInContext:(TDTemplateContext *)ctx {
    double n1 = [self.p1 evaluateAsNumberInContext:ctx];
    double n2 = [self.p2 evaluateAsNumberInContext:ctx];

    double res = 0.0;
    switch (self.binaryOperator) {
        case TDTokenType_PLUS:
            res = n1 + n2;
            break;
        case TDTokenType_MINUS:
            res = n1 - n2;
            break;
        case TDTokenType_TIMES:
            res = n1 * n2;
            break;
        case TDTokenType_DIV:
            res = n1 / n2;
            break;
        case TDTokenType_MOD:
            res = lrint(n1) % lrint(n2);
            break;
        default:
            [NSException raise:@"TDTemplateEngineErrorDomain" format:@"invalid operator in arithmetic expr"];
            res = NAN;
            break;
    }
    return res;
}


- (TDDataType)dataType {
    return TDDataTypeNumber;
}

@end
