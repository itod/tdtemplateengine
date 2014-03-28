//
//  TDNode.h
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import <PEGKit/PEGKit.h>

@interface TDNode : PKAST

- (void)processFragment:(NSString *)frag;
- (NSString *)renderInContext:(id)ctx;
@end
