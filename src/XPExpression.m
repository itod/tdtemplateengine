//
//  XPExpression.m
//  XPath
//
//  Created by Todd Ditchendorf on 3/5/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <TDTemplateEngine/XPExpression.h>
#import <TDTemplateEngine/TDTemplateContext.h>
#import "XPValue.h"
#import "NSError+XPAdditions.h"
#import "XPParser.h"
#import "XPAssembler.h"
#import <PEGKit/PKAssembly.h>

static PKParser *sParser = nil;

@interface XPExpression ()

@end

@implementation XPExpression

+ (void)initialize {
    if ([XPExpression class] == self) {
        XPAssembler *assembler = [[[XPAssembler alloc] init] autorelease];
        sParser = [[XPParser alloc] initWithDelegate:assembler];
        TDAssert(sParser);
    }
}


+ (XPExpression *)expressionFromTokens:(NSArray *)toks error:(NSError **)outErr {
    TDAssert(sParser);
    @try {
        PKAssembly *a = [sParser parseTokens:toks error:outErr];

        XPExpression *expr = [a pop];
        TDAssert([expr isKindOfClass:[XPExpression class]]);
        
        expr = [expr simplify];
        return expr;
    }
    @catch (NSException *e) {
        if (outErr) *outErr = [NSError XPathErrorWithCode:47 format:[e reason]];
    }
    return nil;
}


- (void)dealloc {

    [super dealloc];
}


- (XPValue *)evaluateInContext:(TDTemplateContext *)ctx {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return NO;
}


- (BOOL)evaluateAsBooleanInContext:(TDTemplateContext *)ctx {
    return [[self evaluateInContext:ctx] asBoolean];
}


- (double)evaluateAsNumberInContext:(TDTemplateContext *)ctx {
    return [[self evaluateInContext:ctx] asNumber];
}


- (NSString *)evaluateAsStringInContext:(TDTemplateContext *)ctx {
    return [[self evaluateInContext:ctx] asString];
}


- (BOOL)isValue {
    return [self isKindOfClass:[XPValue class]];
}


- (BOOL)isContextDocumentNodeSet {
    return NO;
}


- (XPExpression *)simplify {
    return self;
}


- (NSUInteger)dependencies {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return 0;
}


- (XPExpression *)reduceDependencies:(NSUInteger)dep inContext:(TDTemplateContext *)ctx {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return nil;
}


- (NSInteger)dataType {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return -1;
}


- (void)display:(NSInteger)level {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
}

@end
