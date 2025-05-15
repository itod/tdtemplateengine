//
//  TDTemplate.h
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 5/14/25.
//  Copyright © 2025 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDTemplate : NSObject <NSCopying>

//+ (instancetype)templateWithContentsOfFile:(NSString *)path error:(NSError **)err;
//+ (instancetype)templateWithString:(NSString *)path error:(NSError **)err;

//- (BOOL)compile:(NSError **)outErr;

- (NSString *)render:(NSDictionary *)vars error:(NSError **)outErr;
- (BOOL)render:(NSDictionary *)vars toStream:(NSOutputStream *)stream error:(NSError **)outErr;

@end
