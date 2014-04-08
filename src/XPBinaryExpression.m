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

#import "XPBinaryExpression.h"
#import "XPValue.h"

@interface XPBinaryExpression ()
@property (nonatomic, retain) XPExpression *p1;
@property (nonatomic, retain) XPExpression *p2;
@property (nonatomic, assign) NSInteger operator;
@end

@implementation XPBinaryExpression

+ (XPBinaryExpression *)binaryExpression {
    return [[[self alloc] init] autorelease];
}


+ (XPBinaryExpression *)binaryExpressionWithOperand:(XPExpression *)lhs operator:(NSInteger)op operand:(XPExpression *)rhs {
    return [[[self alloc] initWithOperand:lhs operator:op operand:rhs] autorelease];
}


- (id)init {
    return [self initWithOperand:nil operator:-1 operand:nil];
}


- (id)initWithOperand:(XPExpression *)lhs operator:(NSInteger)op operand:(XPExpression *)rhs {
    if (self = [super init]) {
        self.p1 = lhs;
        self.p2 = rhs;
        self.operator = op;
    }
    return self;
}


- (void)dealloc {
    self.p1 = nil;
    self.p2 = nil;
    [super dealloc];
}


- (void)setOperand:(XPExpression *)lhs operator:(NSInteger)op operand:(XPExpression *)rhs {
    self.p1 = lhs;
    self.p2 = rhs;
    self.operator = op;
}


- (XPExpression *)simplify {
    self.p1 = [_p1 simplify];
    self.p2 = [_p2 simplify];
    
    if ([_p1 isValue] && [_p2 isValue]) {
        return [self evaluateInContext:nil];
    }
    
    return self;
}

@end
