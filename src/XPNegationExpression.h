//
//  XPNegationExpression.h
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 4/4/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "XPExpression.h"

@interface XPNegationExpression : XPExpression

+ (instancetype)negationExpressionWithExpression:(XPExpression *)expr;

- (instancetype)initWithExpression:(XPExpression *)expr;
@end
