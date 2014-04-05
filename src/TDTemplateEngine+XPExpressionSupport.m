//
//  TDTemplateEngine+XPExpressionSupport.m
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 4/4/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDTemplateEngine+XPExpressionSupport.h"

#import "XPParser.h"
#import "XPExpression.h"

#import <PEGKit/PKAssembly.h>

@interface TDTemplateEngine ()
@property (nonatomic, retain) XPParser *expressionParser;
@end

@implementation TDTemplateEngine (XPExpressionSupport)

- (PKTokenizer *)tokenizer {
    TDAssert(self.expressionParser);
    return [self.expressionParser tokenizer];
}


- (XPExpression *)expressionFromString:(NSString *)str error:(NSError **)outErr {
    TDAssert(self.expressionParser);
    PKAssembly *a = [self.expressionParser parseString:str error:outErr];
    
    XPExpression *expr = [a pop];
    TDAssert([expr isKindOfClass:[XPExpression class]]);
    
    expr = [expr simplify];
    return expr;
}


- (XPExpression *)expressionFromTokens:(NSArray *)toks error:(NSError **)outErr {
    TDAssert(self.expressionParser);
    PKAssembly *a = [self.expressionParser parseTokens:toks error:outErr];
    
    XPExpression *expr = [a pop];
    TDAssert([expr isKindOfClass:[XPExpression class]]);
    
    expr = [expr simplify];
    return expr;
}

@end
