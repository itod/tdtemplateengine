//
//  TDVariableNode.m
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDVariableNode.h"
#import "TDTemplateContext.h"
#import "TDFragment.h"
#import <PEGKit/PKToken.h>

@implementation TDVariableNode

- (void)dealloc {
    self.name = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Public

- (void)processFragment:(TDFragment *)frag {
    NSParameterAssert(frag);
    NSArray *toks = frag.tokens;
    TDAssert([toks count] >= 3);
    
    for (PKToken *tok in toks) {
        if (PKTokenTypeWord == tok.tokenType) {
            self.name = tok.stringValue;
            break;
        }
    }
    TDAssert([_name length]);
}


- (NSString *)renderInContext:(id <TDTemplateContext>)ctx {
    NSParameterAssert(ctx);
    TDAssert([_name length]);
    
    NSString *s = [ctx resolveVariable:_name];
    return s;
}

@end
