//
//  TDTabTag.m
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 4/7/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDTabTag.h"

@implementation TDTabTag

+ (NSString *)tagName {
    return @"tab";
}


+ (NSString *)outputString {
    return @"\t";
}

@end
