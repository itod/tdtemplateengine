//
//  TDTrimLinesTag.m
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 4/7/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDTrimLinesTag.h"

@implementation TDTrimLinesTag

+ (NSString *)tagName {
    return @"trimlines";
}


+ (TDTrimType)trimType {
    return TDTrimTypeLines;
}

@end
