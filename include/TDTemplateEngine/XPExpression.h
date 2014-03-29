//
//  XPExpression.h
//  XPath
//
//  Created by Todd Ditchendorf on 3/5/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TDTemplateContext;
@class XPValue;

typedef enum {
    XPDataTypeBoolean,
    XPDataTypeNumber,
    XPDataTypeString,
    XPDataTypeObject,
    XPDataTypeAny
} XPDataType;

@interface XPExpression : NSObject

+ (XPExpression *)expressionFromTokens:(NSArray *)toks error:(NSError **)outErr;

- (XPValue *)evaluateInContext:(TDTemplateContext *)ctx;
- (BOOL)evaluateAsBooleanInContext:(TDTemplateContext *)ctx;
- (double)evaluateAsNumberInContext:(TDTemplateContext *)ctx;
- (NSString *)evaluateAsStringInContext:(TDTemplateContext *)ctx;

- (BOOL)isValue;

- (XPExpression *)simplify;
- (NSUInteger)dependencies;
- (XPExpression *)reduceDependencies:(NSUInteger)dep inContext:(TDTemplateContext *)ctx;

- (NSInteger)dataType;

- (void)display:(NSInteger)level;
@end
