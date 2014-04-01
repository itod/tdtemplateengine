//
//  TDScope.h
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 3/31/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TDScope <NSObject>

- (id)resolveVariable:(NSString *)name;
- (void)defineVariable:(NSString *)name withValue:(id)value;

@property (nonatomic, retain) id <TDScope>enclosingScope;
@end
