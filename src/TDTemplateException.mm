//
//  TDTemplateException.m
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 5/24/25.
//  Copyright © 2025 Todd Ditchendorf. All rights reserved.
//

#import <TDTemplateEngine/TDTemplateException.h>
#import <TDTemplateEngine/TDTemplateContext.h>
#import <TDTemplateEngine/TDNode.h>

using namespace parsekit;

@implementation TDTemplateException

+ (void)raiseFromException:(NSException *)ex context:(TDTemplateContext *)ctx node:(TDNode *)node {
    NSString *filePath = ctx.currentTemplateFilePath;
    //TDAssert(filePath);
    NSString *sample = [ctx templateSubstringForToken:node.token];
    TDAssert(sample);
    TDTemplateException *tex = [[[TDTemplateException alloc] initWithName:ex.name reason:ex.reason userInfo:ex.userInfo] autorelease];
    TDAssert(tex);
    tex.filePath = filePath;
    tex.token = node.token;
    tex.sample = sample;
    [tex raise];
}

//- (instancetype)initWithWrappedException:(NSException *)ex token:(Token)tok sample:(NSString *)sample {
//- (instancetype)initWithFilePath:(NSString *)filePath token:(Token)tok sample:(NSString *)sample {
//    self = [super initWithName:ex.name reason:ex.reason userInfo:ex.userInfo];
//    if (self) {
//        self.filePath = filePath;
//        self.token = tok;
//        self.sample = sample;
//    }
//    return self;
//}


- (void)dealloc {
//    self.wrappedException = nil;
    self.filePath = nil;
    self.sample = nil;
    [super dealloc];
}

@end
