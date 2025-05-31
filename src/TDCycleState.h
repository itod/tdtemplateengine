//
//  TDCycleState.h
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 5/30/25.
//  Copyright © 2025 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDCycleState : NSObject

+ (NSString *)defaultVariableName;

- (void)reset;
- (void)update:(NSString *)value;

@property (nonatomic, assign, readonly) NSUInteger currentIndex;
@end
