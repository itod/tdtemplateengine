//
//  TDTemplateEngine+XPExpressionSupport.h
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 4/4/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import <TDTemplateEngine/TDTemplateEngine.h>

@class PKTokenizer;
@class XPExpression;

@interface TDTemplateEngine (XPExpressionSupport)
- (PKTokenizer *)tokenizer;
- (XPExpression *)expressionFromString:(NSString *)str error:(NSError **)outErr;
- (XPExpression *)expressionFromTokens:(NSArray *)toks error:(NSError **)outErr;
@end
