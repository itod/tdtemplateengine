//
//  XPEnumeration.h
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 4/4/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "XPExpression.h"

@interface XPEnumeration : XPExpression

- (BOOL)hasMore;

@property (nonatomic, retain) NSArray *values;
@property (nonatomic, assign) NSInteger current;
@end
