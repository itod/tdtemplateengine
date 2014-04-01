//
//  TDBaseScope.h
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 3/31/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import <TDTemplateEngine/TDScope.h>

@interface TDBaseScope : NSObject <TDScope>

@property (nonatomic, retain) NSMutableDictionary *vars;
@end
