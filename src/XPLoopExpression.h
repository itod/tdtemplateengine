//
//  XPLoopExpression.h
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 4/3/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "XPExpression.h"

@class XPEnumeration;

@interface XPLoopExpression : XPExpression

+ (instancetype)loopExpressionWithVariables:(NSArray *)vars enumeration:(XPEnumeration *)e;
- (instancetype)initWithVariables:(NSArray *)vars enumeration:(XPEnumeration *)e;

@property (nonatomic, copy) NSString *firstVariable;
@property (nonatomic, copy) NSString *secondVariable;
@property (nonatomic, retain) XPEnumeration *enumeration;
@end
