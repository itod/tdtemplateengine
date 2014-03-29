//
//  NSError+XPAdditions.m
//  XPath
//
//  Created by Todd Ditchendorf on 7/19/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "NSError+XPAdditions.h"

@implementation NSError (XPAdditions)

+ (id)XPathErrorWithCode:(NSInteger)code format:(NSString *)format, ... {
	va_list vargs;
	va_start(vargs, format);
	
	NSMutableString *str = [[[NSMutableString alloc] initWithFormat:format arguments:vargs] autorelease];
	
	va_end(vargs);

    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:str forKey:NSLocalizedDescriptionKey];
	return [NSError errorWithDomain:@"XPathErrorDomain" code:code userInfo:userInfo];
}

@end
