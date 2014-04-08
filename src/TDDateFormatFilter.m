//
//  TDDateFormatFilter.m
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 4/8/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDDateFormatFilter.h"

@implementation TDDateFormatFilter

+ (NSString *)filterName {
    return @"dateFormat";
}


- (id)doFilter:(id)input withArguments:(NSArray *)args {
    TDAssert(input);
    
    [self validateArguments:args min:1 max:1];
    
    NSDate *date = nil;
    if ([input isKindOfClass:[NSDate class]]) {
        date = input;
    } else {
        NSString *inStr = TDStringFromObject(input);
        date = [NSDate dateWithNaturalLanguageString:inStr];
    }
    
    TDAssert(1 == [args count]); // already validated above
    NSString *fmtStr = args[0];
    
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:fmtStr];
    
    NSString *result = [formatter stringFromDate:date];
    TDAssert([result length]);
    
    return result;
}

@end
