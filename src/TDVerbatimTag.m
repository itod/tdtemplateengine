//
//  TDVerbatimTag.m
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 4/7/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDVerbatimTag.h"
#import <TDTemplateEngine/TDTemplateContext.h>
#import <TDTemplateEngine/TDWriter.h>
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
    return TDTagTypeBlock;
}


- (void)dealloc {
    
    [super dealloc];
}


- (void)doTagInContext:(TDTemplateContext *)ctx {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, self);
    TDAssert(ctx);
    
    TDWriter *writer = ctx.writer;
    for (TDNode *child in self.children) {
        [self render:child to:writer];
    }
}


- (void)render:(TDNode *)node to:(TDWriter *)writer {
    
    [writer appendString:node.token.verbatimString];
    
    for (TDNode *child in node.children) {
        [self render:child to:writer];
    }
    
    if ([node isKindOfClass:[TDTag class]]) {
        TDTag *tag = (id)node;
        [writer appendString:tag.endTagToken.verbatimString];
    }
}

@end
