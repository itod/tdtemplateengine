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


- (id)runFilter:(TDExpression *)expr withArgs:(NSArray<TDExpression *> *)args inContext:(TDTemplateContext *)ctx {
    [self validateArgs:args min:1 max:1];
    
    NSDate *date = [expr evaluateAsDateInContext:ctx];
    
    NSMutableString *fmtStr = [[[args.firstObject evaluateAsStringInContext:ctx] mutableCopy] autorelease];
    [sMRegex replaceMatchesInString:fmtStr options:0 range:NSMakeRange(0, fmtStr.length) withTemplate:@"MMM"];

    NSString *result = nil;
    TDAssert(sDateFormatter);
    @synchronized (sDateFormatter) {
        sDateFormatter.dateFormat = fmtStr;
        result = [sDateFormatter stringFromDate:date];
    }
    
    return result;
}

@end
