//
//  TDTemplateException.h
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 5/24/25.
//  Copyright © 2025 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ParseKitCPP/Token.hpp>

using namespace parsekit;

@interface TDTemplateException : NSException

- (instancetype)initWithWrappedException:(NSException *)ex token:(Token)tok;

@property (nonatomic, retain) NSException *wrappedException;
@property (nonatomic, assign) Token token;
@end
