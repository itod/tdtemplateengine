//
//  TDRootNode.m
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDRootNode.h"

@implementation TDRootNode

+ (instancetype)rootNode {
    return [self nodeWithFragment:@"((ROOT))"];
}

@end
