//
//  XPLoopExpression.h
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 4/3/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "XPExpression.h"

@protocol XPEnumeration;

@interface XPLoopExpression : XPExpression

+ (instancetype)loopExpressionWithVarName:(NSString *)var enumeration:(id <XPEnumeration>)e;
- (instancetype)initWithVarName:(NSString *)var enumeration:(id <XPEnumeration>)e;

@property (nonatomic, copy) NSString *var;
@property (nonatomic, retain) id <XPEnumeration>enumeration;

@end
