//
//  XPRelationalExpression.h
//  XPath
//
//  Created by Todd Ditchendorf on 7/17/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPBinaryExpression.h"

@interface XPRelationalExpression : XPBinaryExpression

+ (XPRelationalExpression *)relationalExpression;

+ (XPRelationalExpression *)relationalExpressionWithOperand:(XPExpression *)lhs operator:(NSInteger)op operand:(XPExpression *)rhs;

@end
