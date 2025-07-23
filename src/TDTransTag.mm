//
//  TDTransTag.m
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 4/7/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDTransTag.h"
#import <TDTemplateEngine/TDExpression.h>
#import <TDTemplateEngine/TDTemplateContext.h>

@implementation TDTransTag

+ (NSString *)tagName {
    return @"trans";
}


+ (TDTagContentType)tagContentType {
    return TDTagContentTypeLeaf;
}


+ (TDTagExpressionType)tagExpressionType {
    return TDTagExpressionTypeArgs;
}


- (void)runInContext:(TDTemplateContext *)ctx {

    NSString *str  = [[self.args objectAtIndex:0] evaluateAsStringInContext:ctx];
    
    // TODO translate

    [ctx writeString:str];
}

@end
