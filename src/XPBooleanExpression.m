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

#import "XPBooleanExpression.h"
#import "XPValue.h"
#import "XPBooleanValue.h"
#import "XPParser.h"

@interface XPBinaryExpression ()
@property (nonatomic, retain) XPExpression *p1;
@property (nonatomic, retain) XPExpression *p2;
@property (nonatomic, assign) NSInteger operator;
@end

@implementation XPBooleanExpression

+ (XPBooleanExpression *)booleanExpression {
    return [[[self alloc] init] autorelease];
}


+ (XPBooleanExpression *)booleanExpressionWithOperand:(XPExpression *)lhs operator:(NSInteger)op operand:(XPExpression *)rhs {
    return [[[self alloc] initWithOperand:lhs operator:op operand:rhs] autorelease];
}


- (XPExpression *)simplify {
    self.p1 = [self.p1 simplify];
    self.p2 = [self.p2 simplify];
    if ([self.p2 isValue] && [self.p2 isValue]) {
        return [self evaluateInContext:nil];
    }
    
    // TODO
    
    return self;
}


- (XPValue *)evaluateInContext:(TDTemplateContext *)ctx {
    BOOL b = [self evaluateAsBooleanInContext:ctx];
    return [XPBooleanValue booleanValueWithBoolean:b];
}


- (BOOL)evaluateAsBooleanInContext:(TDTemplateContext *)ctx {
    BOOL b1 = [self.p1 evaluateAsBooleanInContext:ctx];
    BOOL b2 = [self.p2 evaluateAsBooleanInContext:ctx];
    
    BOOL result = NO;
    switch (self.operator) {
        case XP_TOKEN_KIND_AND:
            result = b1 && b2;
            break;
        case XP_TOKEN_KIND_OR:
            result = b1 || b2;
            break;
        default:
            TDAssert(0);
            break;
    }

    return result;
}


- (XPDataType)dataType {
    return XPDataTypeBoolean;
}

@end
