//
//  XPCollectionExpression.h
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 4/3/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "XPExpression.h"
#import "XPEnumeration.h"

@interface XPCollectionExpression : XPExpression <XPEnumeration>

+ (instancetype)collectionExpressionWithVariable:(NSString *)var;
- (instancetype)initWithVariable:(NSString *)var;

@property (nonatomic, copy) NSString *var;
@end
