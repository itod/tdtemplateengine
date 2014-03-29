//
//  NSError+XPAdditions.h
//  XPath
//
//  Created by Todd Ditchendorf on 7/19/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (XPAdditions)

+ (id)XPathErrorWithCode:(NSInteger)code format:(NSString *)format, ...;

@end
