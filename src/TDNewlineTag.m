//
//  TDNewlineTag.m
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 4/7/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDNewlineTag.h"
#import <TDTemplateEngine/TDTemplateContext.h>
#import <TDTemplateEngine/TDExpression.h>

@interface TDTag ()
@property (nonatomic, retain) PKToken *endTagToken;
@end

@implementation TDNewlineTag

+ (NSString *)tagName {
    return @"nl";
}


+ (TDTagType)tagType {
    return TDTagTypeEmpty;
}


- (void)dealloc {
    
    [super dealloc];
}


- (void)doTagInContext:(TDTemplateContext *)ctx {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, self);
    TDAssert(ctx);
    
    NSUInteger count = 1;
    
    if (self.expression) {
        count = [self.expression evaluateAsNumberInContext:ctx];
    }
    
    for (NSUInteger i = 0; i < count; ++i) {
        [ctx writeString:@"\n"];
    }
}

@end
