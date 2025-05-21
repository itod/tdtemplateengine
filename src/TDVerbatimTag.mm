//
//  TDVerbatimTag.m
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 4/7/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDVerbatimTag.h"
#import <TDTemplateEngine/TDTemplateContext.h>


@implementation TDVerbatimTag

+ (NSString *)tagName {
    return @"verbatim";
}


+ (TDTagContentType)tagContentType {
    return TDTagContentTypeComplex;
}


// optimization for TemplateParser
- (BOOL)isVerbatim {
    return YES;
}


- (id)runInContext:(TDTemplateContext *)ctx {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, self);
    TDAssert(ctx);
    
    NSString *str = [ctx templateSubstringForToken:self.token];
    [ctx writeString:str];
    
    return nil;
}

@end
