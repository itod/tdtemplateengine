//
//  TDRootNode.m
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDRootNode.h"
#import "TDFragment.h"

@implementation TDRootNode

+ (instancetype)rootNode {
    TDFragment *frag = [[[TDFragment alloc] init] autorelease];
    frag.string = @"((ROOT))";
    return [self nodeWithFragment:frag];
}

@end
