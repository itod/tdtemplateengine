//
//  TDDateFormatFilter.m
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 4/8/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDDateFormatFilter.h"
#import <TDTemplateEngine/TDDateValue.h>

static NSDateFormatter *sDateFormatter = nil;

@implementation TDDateFormatFilter

+ (void)initialize {
    if ([TDDateFormatFilter class] == self) {
        sDateFormatter = [[NSDateFormatter alloc] init];
    }
}


+ (NSString *)filterName {
    return @"date";
}


- (id)runFilter:(id)input withArgs:(NSArray *)args inContext:(TDTemplateContext *)ctx {
    TDAssert(input);
    
    [self validateArgs:args min:1 max:1];
    
    NSDate *date = TDDateFromObject(input);
    TDAssert(date);
    
    TDAssert(1 == [args count]); // already validated above
    NSString *fmtStr = args[0];

    NSString *result = nil;
    TDAssert(sDateFormatter);
    @synchronized (sDateFormatter) {
        sDateFormatter.dateFormat = fmtStr;
        result = [sDateFormatter stringFromDate:date];
    }
    TDAssert(result.length);
    
    return result;
}

@end
