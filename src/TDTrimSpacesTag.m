//
//  TDTrimSpacesTag.m
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 4/7/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDTrimSpacesTag.h"

@implementation TDTrimSpacesTag

+ (NSString *)tagName {
    return @"trimspaces";
}


+ (TDTrimType)trimType {
    return TDTrimTypeSpaces;
}

@end
