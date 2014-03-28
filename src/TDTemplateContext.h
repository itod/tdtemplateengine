//
//  TDTemplateContext.h
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TDTemplateContext <NSObject>
- (NSString *)resolveVariable:(NSString *)name;
@end
