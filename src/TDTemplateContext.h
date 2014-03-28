//
//  TDTemplateContext.h
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDTemplateContext : NSObject

- (instancetype)initWithVariables:(NSDictionary *)vars;

- (NSString *)resolveVariable:(NSString *)name;
@end
