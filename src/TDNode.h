//
//  TDNode.h
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TDFragment;

@interface TDNode : NSObject

+ (instancetype)nodeWithFragment:(TDFragment *)frag;
- (instancetype)initWithFragment:(TDFragment *)frag;

- (void)processFragment:(TDFragment *)frag;
- (NSString *)renderInContext:(id)ctx;

- (void)enterScope;
- (void)exitScope;

@property (nonatomic, retain) TDFragment *fragment;
@property (nonatomic, retain) NSMutableArray *children;
@property (nonatomic, assign) BOOL createsScope;
@end
