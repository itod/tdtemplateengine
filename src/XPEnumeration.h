//
//  XPEnumeration.h
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 4/2/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol XPEnumeration <NSObject>

- (id)next;
- (BOOL)hasMore;
@end
