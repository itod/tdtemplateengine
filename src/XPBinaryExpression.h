//
//  XPBinaryExpression.h
//  XPath
//
//  Created by Todd Ditchendorf on 7/17/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPExpression.h"

@interface XPBinaryExpression : XPExpression

+ (XPBinaryExpression *)binaryExpression;

+ (XPBinaryExpression *)binaryExpressionWithOperand:(XPExpression *)lhs operator:(NSInteger)op operand:(XPExpression *)rhs;

- (id)initWithOperand:(XPExpression *)lhs operator:(NSInteger)op operand:(XPExpression *)rhs;

- (void)setOperand:(XPExpression *)lhs operator:(NSInteger)op operand:(XPExpression *)rhs;

@end
