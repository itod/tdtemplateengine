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

- (instancetype)initWithWrappedException:(NSException *)ex token:(Token)tok {
    self = [super initWithName:ex.name reason:ex.reason userInfo:ex.userInfo];
    if (self) {
        self.wrappedException = ex;
        self.token = tok;
    }
    return self;
}


- (void)dealloc {
    self.wrappedException = nil;
    [super dealloc];
}

@end
