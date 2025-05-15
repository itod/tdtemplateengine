//
//  TDTemplate.m
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 5/14/25.
//  Copyright © 2025 Todd Ditchendorf. All rights reserved.
//

#import "TDTemplate.h"

@implementation TDTemplate

+ (instancetype)templateWithContentsOfFile:(NSString *)path error:(NSError **)outErr {
    NSStringEncoding enc;
    NSString *str = [NSString stringWithContentsOfFile:path usedEncoding:&enc error:outErr];
    if (!str) return nil;
    
    return [self templateWithString:str error:outErr];
}


+ (instancetype)templateWithString:(NSString *)path error:(NSError **)outErr {
    id node = nil; // compile
    
    TDTemplate *tmpl = [[[TDTemplate alloc] init] autorelease];
    return tmpl;
}


- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}


- (NSString *)render:(NSDictionary *)vars error:(NSError **)outErr {
    return nil;
}


- (BOOL)render:(NSDictionary *)vars toStream:(NSOutputStream *)stream error:(NSError **)outErr {
    return NO;
}

@end
