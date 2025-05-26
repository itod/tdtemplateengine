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
static NSRegularExpression *sMRegex = nil;

@implementation TDDateFormatFilter

+ (void)initialize {
    if ([TDDateFormatFilter class] == self) {
        sDateFormatter = [[NSDateFormatter alloc] init];
        
        // python thinks M == Jan, but objc things M = 1, MMM = Jan.
        sMRegex = [[NSRegularExpression alloc] initWithPattern:@"\\bM\\b" options:0 error:nil];
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
    
    NSMutableString *fmtStr = [[[args objectAtIndex:0] mutableCopy] autorelease];
    [sMRegex replaceMatchesInString:fmtStr options:0 range:NSMakeRange(0, fmtStr.length) withTemplate:@"MMM"];

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
