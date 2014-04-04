//
//  XPEnumeration.h
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 4/2/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TDTemplateContext;

@protocol XPEnumeration <NSObject>

- (void)beginInContext:(TDTemplateContext *)ctx;

- (id)next;
- (BOOL)hasMore;
@end
