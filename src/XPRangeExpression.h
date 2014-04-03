//
//  XPRangeExpression.h
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 4/2/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "XPExpression.h"
#import "XPEnumeration.h"

@interface XPRangeExpression : XPExpression <XPEnumeration>

+ (instancetype)rangeExpressionWithStart:(XPExpression *)start stop:(XPExpression *)stop by:(XPExpression *)by;

- (instancetype)initWithStart:(XPExpression *)start stop:(XPExpression *)stop by:(XPExpression *)by;

@property (nonatomic, retain) XPExpression *start;
@property (nonatomic, retain) XPExpression *stop;
@property (nonatomic, retain) XPExpression *by;
@end
