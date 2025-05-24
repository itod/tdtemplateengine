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

+ (void)raiseFromException:(NSException *)ex context:(TDTemplateContext *)ctx node:(TDNode *)node;

// it seems like we dont actually need the wrapped ex. somehow, callStackSymbols is auto propogated???
//- (instancetype)initWithWrappedException:(NSException *)ex token:(Token)tok sample:(NSString *)sample;

//- (instancetype)initWithFilePath:(NSString *)filePath token:(Token)tok sample:(NSString *)sample;

//@property (nonatomic, retain) NSException *wrappedException;
@property (nonatomic, retain) NSString *filePath;
@property (nonatomic, assign) Token token;
@property (nonatomic, retain) NSString *sample;
@end
