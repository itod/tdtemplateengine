//
//  XPNumericValue.h
//  XPath
//
//  Created by Todd Ditchendorf on 7/14/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPValue.h"

@interface XPNumericValue : XPValue

+ (XPNumericValue *)numericValueWithString:(NSString *)s;
+ (XPNumericValue *)numericValueWithNumber:(double)n;

- (id)initWithString:(NSString *)s;
- (id)initWithNumber:(double)n;

@end
