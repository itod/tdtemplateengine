//
//  TDVariableNode.h
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDNode.h"

@interface TDVariableNode : TDNode

@property (nonatomic, copy) NSString *name;
@end