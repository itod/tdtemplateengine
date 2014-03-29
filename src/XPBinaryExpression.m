//
//  XPBinaryExpression.m
//  XPath
//
//  Created by Todd Ditchendorf on 7/17/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPBinaryExpression.h"
#import "XPValue.h"

@interface XPBinaryExpression ()
@property (nonatomic, retain) XPExpression *p1;
@property (nonatomic, retain) XPExpression *p2;
@property (nonatomic, assign) NSInteger operator;
@end

@implementation XPBinaryExpression

+ (XPBinaryExpression *)binaryExpression {
    return [[[self alloc] init] autorelease];
}


+ (XPBinaryExpression *)binaryExpressionWithOperand:(XPExpression *)lhs operator:(NSInteger)op operand:(XPExpression *)rhs {
    return [[[self alloc] initWithOperand:lhs operator:op operand:rhs] autorelease];
}


- (id)init {
    return [self initWithOperand:nil operator:-1 operand:nil];
}


- (id)initWithOperand:(XPExpression *)lhs operator:(NSInteger)op operand:(XPExpression *)rhs {
    if (self = [super init]) {
        self.p1 = lhs;
        self.p2 = rhs;
        self.operator = op;
    }
    return self;
}


- (void)dealloc {
    self.p1 = nil;
    self.p2 = nil;
    [super dealloc];
}


- (void)setOperand:(XPExpression *)lhs operator:(NSInteger)op operand:(XPExpression *)rhs {
    self.p1 = lhs;
    self.p2 = rhs;
    self.operator = op;
}


- (XPExpression *)simplify {
    self.p1 = [_p1 simplify];
    self.p2 = [_p2 simplify];
    
    if ([_p1 isValue] && [_p2 isValue]) {
        return [self evaluateInContext:nil];
    }
    
    return self;
}


- (NSUInteger)dependencies {
    return [_p1 dependencies] | [_p2 dependencies];
}


- (XPExpression *)reduceDependencies:(NSUInteger)dep inContext:(TDTemplateContext *)ctx {
    if (([self dependencies] & dep) != 0) {
        XPExpression *expr = [[[[self class] alloc] initWithOperand:[_p1 reduceDependencies:dep inContext:ctx]
                                                           operator:_operator
                                                            operand:[_p2 reduceDependencies:dep inContext:ctx]] autorelease];
        return [expr simplify];
    } else {
        return self;
    }
}

@end
