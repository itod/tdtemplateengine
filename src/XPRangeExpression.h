//
//  XPRangeExpression.h
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 4/2/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "XPExpression.h"
#import <TDTemplateEngine/TDEnumeration.h>

@interface XPRangeExpression : XPExpression <TDEnumeration>

+ (instancetype)rangeExpressionWithVar:(NSString *)var start:(XPExpression *)start stop:(XPExpression *)stop by:(XPExpression *)by;

- (instancetype)initWithVar:(NSString *)var start:(XPExpression *)start stop:(XPExpression *)stop by:(XPExpression *)by;

@property (nonatomic, copy) NSString *var;
@property (nonatomic, retain) XPExpression *start;
@property (nonatomic, retain) XPExpression *stop;
@property (nonatomic, retain) XPExpression *by;
@end
