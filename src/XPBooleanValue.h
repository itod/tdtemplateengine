//
//  XPBooleanValue.h
//  XPath
//
//  Created by Todd Ditchendorf on 7/12/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPValue.h"

@interface XPBooleanValue : XPValue

+ (XPBooleanValue *)booleanValueWithBoolean:(BOOL)b;

- (id)initWithBoolean:(BOOL)b;

@end
