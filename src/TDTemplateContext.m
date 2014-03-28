//
//  TDTemplateContext.m
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDTemplateContext.h"

@interface TDTemplateContext ()
@property (nonatomic, retain) NSDictionary *vars;
@end

@implementation TDTemplateContext

- (instancetype)initWithVariables:(NSDictionary *)vars {
    self = [super init];
    if (self) {
        self.vars = vars;
    }
    return self;
}


- (void)dealloc {
    self.vars = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Public

- (NSString *)resolveVariable:(NSString *)name {
    return _vars[name];
}

@end
