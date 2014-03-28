//
//  TDFragment.h
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, TDFragmentType) {
    TDFragmentTypeText          = 0,
    TDFragmentTypeVariable      = 1,
    TDFragmentTypeStartBlock    = 2,
    TDFragmentTypeEndBlock      = 3,
};

@interface TDFragment : NSObject

- (instancetype)initWithType:(TDFragmentType)t string:(NSString *)s tokens:(NSArray *)toks;

@property (nonatomic, assign) TDFragmentType type;
@property (nonatomic, retain) NSString *string;
@property (nonatomic, retain) NSArray *tokens;
@end
