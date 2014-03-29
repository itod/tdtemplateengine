//
//  XPBooleanExpression.h
//  XPath
//
//  Created by Todd Ditchendorf on 7/19/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPBinaryExpression.h"

@interface XPBooleanExpression : XPBinaryExpression

+ (XPBooleanExpression *)booleanExpression;

+ (XPBooleanExpression *)booleanExpressionWithOperand:(XPExpression *)lhs operator:(NSInteger)op operand:(XPExpression *)rhs;

@end
