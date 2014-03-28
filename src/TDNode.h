//
//  TDNode.h
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDNode : NSObject

+ (instancetype)nodeWithFragment:(NSString *)frag;
- (instancetype)initWithFragment:(NSString *)frag;

- (void)processFragment:(NSString *)frag;
- (NSString *)renderInContext:(id)ctx;

- (void)enterScope;
- (void)exitScope;

@property (nonatomic, retain) NSMutableArray *children;
@property (nonatomic, assign) BOOL createsScope;
@end
