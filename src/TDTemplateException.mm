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

+ (void)raiseFromException:(NSException *)ex token:(Token)token sample:(NSString *)sample filePath:(NSString *)filePath {
    id userInfo = [NSMutableDictionary dictionaryWithDictionary:ex.userInfo];
    [userInfo setObject:ex.name forKey:@"name"];
    [userInfo setObject:ex.reason forKey:@"reason"];
    TDTemplateException *tex = [[[TDTemplateException alloc] initWithName:ex.name reason:ex.reason userInfo:userInfo] autorelease];
    TDAssert(tex);
    tex.token = token;
    tex.sample = sample;
    tex.filePath = filePath;
    [tex raise];
}


+ (void)raiseWithReason:(NSString *)reason token:(Token)token sample:(NSString *)sample filePath:(NSString *)filePath {
    TDTemplateException *tex = [[[TDTemplateException alloc] initWithName:@"TDTemplateCompileTimeException" reason:reason userInfo:nil] autorelease];
    TDAssert(tex);
    tex.token = token;
    tex.sample = sample;
    tex.filePath = filePath;
    [tex raise];
}


- (void)dealloc {
    self.filePath = nil;
    self.sample = nil;
    [super dealloc];
}

@end
