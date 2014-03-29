//
//  XPArithmeticExpression.m
//  XPath
//
//  Created by Todd Ditchendorf on 7/17/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

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
        case XP_TOKEN_KIND_PERCENT:
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
