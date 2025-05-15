//
//  TDVerbatimTag.m
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 4/7/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDVerbatimTag.h"
#import <TDTemplateEngine/TDTemplateContext.h>
#import <PEGKit/PKToken.h>
#import "PKToken+Verbatim.h"

@interface TDTag ()
@property (nonatomic, retain) PKToken *endTagToken;
@end

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
    
    for (TDNode *child in self.children) {
        [self render:child to:ctx];
    }
}


- (void)render:(TDNode *)node to:(TDTemplateContext *)ctx {
    
    [ctx writeString:node.token.verbatimString];
    
    for (TDNode *child in node.children) {
        [self render:child to:ctx];
    }
    
    if ([node isKindOfClass:[TDTag class]]) {
        TDTag *tag = (id)node;
        [ctx writeString:tag.endTagToken.verbatimString];
    }
}

@end
