//
//  TDTemplate.h
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 5/14/25.
//  Copyright © 2025 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ParseKitCPP/Token.hpp>

@interface TDTemplate : NSObject <NSCopying>

- (NSString *)render:(NSDictionary *)vars error:(NSError **)err;
- (BOOL)render:(NSDictionary *)vars toStream:(NSOutputStream *)output error:(NSError **)err;

- (NSString *)templateSubstringForToken:(parsekit::Token)token;

@property (nonatomic, copy) NSString *filePath;
@end
