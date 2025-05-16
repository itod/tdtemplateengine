//
//  TDVerbatimTag.m
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 4/7/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDVerbatimTag.h"
#import <TDTemplateEngine/TDTemplateContext.h>
//#import "PKToken+Verbatim.h"

//@interface TDTag ()
//@property (nonatomic, retain) PKToken *endTagToken;
//@end

@implementation TDVerbatimTag

+ (NSString *)tagName {
    return @"verbatim";
}


+ (TDTagType)tagType {
    return TDTagTypeComplex;
}


- (void)dealloc {
    
    [super dealloc];
}


- (void)doTagInContext:(TDTemplateContext *)ctx {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, self);
    TDAssert(ctx);
    
    NSString *str = [ctx templateSubstringForToken:self.verbatimToken];
    [ctx writeString:str];
    
//    for (TDNode *child in self.children) {
//        [self render:child to:ctx];
//    }
//}
//
//
//- (void)render:(TDNode *)node to:(TDTemplateContext *)ctx {
//    
//    NSString *str = [ctx templateSubstringForToken:node.token];
//    [ctx writeString:str];
//    
//    for (TDNode *child in node.children) {
//        [self render:child to:ctx];
//    }
//    
//    if ([node isKindOfClass:[TDTag class]]) {
//        TDTag *tag = (id)node;
//        str = [ctx templateSubstringForToken:tag.token];
//        [ctx writeString:str];
//    }
}

@end
