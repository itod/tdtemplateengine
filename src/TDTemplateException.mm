//
//  TDTemplateException.m
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 5/24/25.
//  Copyright © 2025 Todd Ditchendorf. All rights reserved.
//

#import <TDTemplateEngine/TDTemplateException.h>

using namespace parsekit;

@implementation TDTemplateException

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
