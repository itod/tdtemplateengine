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

+ (instancetype)loopExpressionWithVariable:(NSString *)var enumeration:(id <XPEnumeration>)e;
- (instancetype)initWithVariable:(NSString *)var enumeration:(id <XPEnumeration>)e;

@property (nonatomic, copy) NSString *variable;
@property (nonatomic, retain) id <XPEnumeration>enumeration;

@end
