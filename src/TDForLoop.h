//
//  TDForLoop.h
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 4/4/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDForLoop : NSObject

@property (nonatomic, assign) NSInteger counter;
@property (nonatomic, assign) NSInteger counter0;
@property (nonatomic, assign) BOOL first;
@property (nonatomic, assign) BOOL last;
@property (nonatomic, retain) TDForLoop *parentloop;
@end
