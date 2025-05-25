//
//  TDTemplate.h
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 5/14/25.
//  Copyright © 2025 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ParseKitCPP/Token.hpp>

//#define TD_TEMPLATE_ENCODING NSUTF16StringEncoding
//#define TD_TEMPLATE_CHARSET "utf-16"
//#define TD_HTML_MIME_TYPE "text/html; charset=utf-16"

#define TD_TEMPLATE_ENCODING NSUTF8StringEncoding
#define TD_TEMPLATE_CHARSET "utf-8"
#define TD_HTML_MIME_TYPE "text/html; charset=utf-8"

@interface TDTemplate : NSObject

- (BOOL)render:(NSDictionary *)vars toStream:(NSOutputStream *)output error:(NSError **)err;

- (NSString *)templateSubstringForToken:(parsekit::Token)token;

@property (nonatomic, copy) NSString *filePath;
@end
