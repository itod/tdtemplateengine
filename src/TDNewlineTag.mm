//
//  TDNewlineTag.m
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 4/7/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDNewlineTag.h"
#import <TDTemplateEngine/TDTemplateContext.h>

@implementation TDNewlineTag

+ (NSString *)tagName {
    return @"br";
}


+ (NSString *)outputString {
    return @"\n";
}


//- (NSString *)outputStringInContext:(TDTemplateContext *)ctx {
//    NSString *str = [[self class] outputString];
//
//    NSInteger depth = ctx.blockDepth;
//    if (depth > 0) {
//        NSMutableString *buff = [NSMutableString stringWithString:str];
//        
//        for (NSUInteger i = 0; i < depth; ++i) {
//            [buff appendString:@"    "];
//        }
//        
//        str = buff;
//    }
//    
//    return str;
//}

@end
