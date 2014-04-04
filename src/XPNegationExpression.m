//
//  XPNegationExpression.m
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 4/4/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "XPNegationExpression.h"
#import "XPBooleanValue.h"

@interface XPNegationExpression ()
@property (nonatomic, retain) XPExpression *expr;
@end

@implementation XPNegationExpression

+ (instancetype)negationExpressionWithExpression:(XPExpression *)expr {
    return [[[self alloc] initWithExpression:expr] autorelease];
}

- (instancetype)initWithExpression:(XPExpression *)expr {
    self = [super init];
    if (self) {
        self.expr = expr;
    }
    return self;
}


- (void)dealloc {
    self.expr = nil;
    [super dealloc];
}


- (XPValue *)evaluateInContext:(TDTemplateContext *)ctx {
    BOOL b = [_expr evaluateAsBooleanInContext:ctx];
    XPValue *res = [XPBooleanValue booleanValueWithBoolean:!b];
    return res;
}

@end
