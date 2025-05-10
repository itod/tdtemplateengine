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

#import "TDBinaryExpression.h"
#import "TDValue.h"

@interface TDBinaryExpression ()
@property (nonatomic, retain) TDExpression *p1;
@property (nonatomic, retain) TDExpression *p2;
@property (nonatomic, assign) NSInteger binaryOperator;
@end

@implementation TDBinaryExpression

+ (TDBinaryExpression *)binaryExpression {
    return [[[self alloc] init] autorelease];
}


+ (TDBinaryExpression *)binaryExpressionWithOperand:(TDExpression *)lhs operator:(NSInteger)op operand:(TDExpression *)rhs {
    return [[[self alloc] initWithOperand:lhs operator:op operand:rhs] autorelease];
}


- (instancetype)init {
    return [self initWithOperand:nil operator:-1 operand:nil];
}


- (instancetype)initWithOperand:(TDExpression *)lhs operator:(NSInteger)op operand:(TDExpression *)rhs {
    if (self = [super init]) {
        self.p1 = lhs;
        self.p2 = rhs;
        self.binaryOperator = op;
    }
    return self;
}


- (void)dealloc {
    self.p1 = nil;
    self.p2 = nil;
    [super dealloc];
}


- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %p `%@ %ld %@`>", [self class], self, self.p1, self.binaryOperator, self.p2];
}


- (void)setOperand:(TDExpression *)lhs operator:(NSInteger)op operand:(TDExpression *)rhs {
    self.p1 = lhs;
    self.p2 = rhs;
    self.binaryOperator = op;
}


- (TDExpression *)simplify {
    self.p1 = [_p1 simplify];
    self.p2 = [_p2 simplify];
    
    if ([_p1 isValue] && [_p2 isValue]) {
        return [self evaluateInContext:nil];
    }
    
    return self;
}

@end
