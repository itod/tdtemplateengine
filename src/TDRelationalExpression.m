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

#import "TDRelationalExpression.h"
#import "TDValue.h"
#import "TDBooleanValue.h"

@interface TDBinaryExpression ()
@property (nonatomic, retain) TDExpression *p1;
@property (nonatomic, retain) TDExpression *p2;
@property (nonatomic, assign) NSInteger operator;
@end

@implementation TDRelationalExpression

+ (TDRelationalExpression *)relationalExpression {
    return [[[self alloc] init] autorelease];
}


+ (TDRelationalExpression *)relationalExpressionWithOperand:(TDExpression *)lhs operator:(NSInteger)op operand:(TDExpression *)rhs {
    return [[[self alloc] initWithOperand:lhs operator:op operand:rhs] autorelease];
}


- (TDExpression *)simplify {
    self.p1 = [self.p1 simplify];
    self.p2 = [self.p2 simplify];
    
    // TODO
    
    if ([self.p1 isValue] && [self.p2 isValue]) {
        return [self evaluateInContext:nil];
    }
    
    // TODO
    return self;
}


- (TDValue *)evaluateInContext:(TDTemplateContext *)ctx {
    BOOL b = [self evaluateAsBooleanInContext:ctx];
    return [TDBooleanValue booleanValueWithBoolean:b];
}


- (BOOL)evaluateAsBooleanInContext:(TDTemplateContext *)ctx {
    TDValue *s1 = [self.p1 evaluateInContext:ctx];
    TDValue *s2 = [self.p2 evaluateInContext:ctx];
    
    return [s1 compareToValue:s2 usingOperator:self.operator];
}


- (TDDataType)dataType {
    return TDDataTypeBoolean;
}

@end
