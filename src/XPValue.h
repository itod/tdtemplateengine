//
//  XPValue.h
//  XPath
//
//  Created by Todd Ditchendorf on 7/12/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <TDTemplateEngine/XPExpression.h>

typedef enum {
	XPTokenTypeEQ = 0,
	XPTokenTypeNE,
	XPTokenTypeGT,
	XPTokenTypeLT,
	XPTokenTypeGE,
	XPTokenTypeLE,
	XPTokenTypePlus,
	XPTokenTypeMinus,
	XPTokenTypeMult,
	XPTokenTypeDiv,
	XPTokenTypeMod,
} XPTokenType;

double XPNumberFromString(NSString *s);

@interface XPValue : XPExpression

- (NSString *)asString;

- (double)asNumber;

- (BOOL)asBoolean;

- (BOOL)isEqualToValue:(XPValue *)other;

- (BOOL)isNotEqualToValue:(XPValue *)other;

- (BOOL)compareToValue:(XPValue *)other usingOperator:(NSInteger)op;

- (NSInteger)inverseOperator:(NSInteger)op;
    
- (BOOL)compareNumber:(double)x toNumber:(double)y usingOperator:(NSInteger)op;

- (XPExpression *)reduceDependencies:(NSUInteger)dep inContext:(TDTemplateContext *)ctx;

// convenience
- (BOOL)isBooleanValue;
- (BOOL)isNumericValue;
- (BOOL)isStringValue;
@end
