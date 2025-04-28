//
//  TDSpaceTag.m
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 4/7/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDSpaceTag.h"

@implementation TDSpaceTag

+ (NSString *)tagName {
    return @"nbsp";
}


+ (NSString *)outputString {
    return @" ";
}

@end
