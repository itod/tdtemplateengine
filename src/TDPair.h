//
//  TDPair.h
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 5/17/25.
//  Copyright © 2025 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDPair : NSObject
+ (instancetype)pairWithFirst:(id)first second:(id)second;
- (instancetype)initWithFirst:(id)first second:(id)second;

@property (nonatomic, retain, readonly) id first;
@property (nonatomic, retain, readonly) id second;

- (BOOL)isEqualToPair:(TDPair *)that;
@end
