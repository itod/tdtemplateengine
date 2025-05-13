//
//  EXToken.h
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 5/13/25.
//  Copyright © 2025 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ParseKitCPP/Token.hpp>

using namespace parsekit;

@interface EXToken : NSObject

+ (EXToken *)tokenWithTokenType:(TokenType)tt stringValue:(NSString *)s doubleValue:(double)n;
- (instancetype)initWithTokenType:(TokenType)tt stringValue:(NSString *)s doubleValue:(double)n;

@property (nonatomic, assign, readonly) TokenType tokenType;
@property (nonatomic, retain, readonly) NSString *stringValue;
@property (nonatomic, assign, readonly) double doubleValue;
@end
