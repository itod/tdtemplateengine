//
//  TDTemplateException.h
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 5/24/25.
//  Copyright © 2025 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ParseKitCPP/Token.hpp>

@class TDTemplateContext;
@class TDNode;

using namespace parsekit;

@interface TDTemplateException : NSException

// it seems like we dont actually need the wrapped ex. somehow, callStackSymbols is auto propogated???
+ (void)raiseFromException:(NSException *)ex token:(Token)token sample:(NSString *)sample filePath:(NSString *)filePath;
+ (void)raiseWithReason:(NSString *)reason token:(Token)token sample:(NSString *)sample filePath:(NSString *)filePath;

@property (nonatomic, retain) NSString *filePath;
@property (nonatomic, assign) Token token;
@property (nonatomic, retain) NSString *sample;
@end
