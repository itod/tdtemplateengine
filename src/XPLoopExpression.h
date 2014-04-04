//
//  XPLoopExpression.h
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 4/3/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "XPExpression.h"

@interface XPLoopExpression : XPExpression

+ (instancetype)loopExpressionWithVariable:(NSString *)var enumeration:(XPExpression *)e;
- (instancetype)initWithVariable:(NSString *)var enumeration:(XPExpression *)e;

@property (nonatomic, copy) NSString *variable;
@property (nonatomic, retain) XPExpression *enumeration;

@end
