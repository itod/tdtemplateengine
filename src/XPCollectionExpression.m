//
//  XPCollectionExpression.m
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 4/3/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "XPCollectionExpression.h"
#import <TDTemplateEngine/TDTemplateContext.h>

@interface XPCollectionExpression ()
@property (nonatomic, retain) NSArray *keys;
@property (nonatomic, assign) BOOL started;
@end

@implementation XPCollectionExpression

+ (instancetype)collectionExpressionWithVariable:(NSString *)var {
    return [[[self alloc] initWithVariable:var] autorelease];
}


- (instancetype)initWithVariable:(NSString *)var {
    self = [super init];
    if (self) {
        self.var = var;
    }
    return self;
}


- (void)dealloc {
    self.var = nil;
    self.keys = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark XPEnumeration

- (void)beginInContext:(TDTemplateContext *)ctx {
    TDAssert([_var length]);
    id col = [ctx resolveVariable:_var];
    
    if ([col isKindOfClass:[NSArray class]]) {
        self.keys = nil;
        self.values = col;
    } else if ([col isKindOfClass:[NSSet class]]) {
        self.keys = nil;
        self.values = [col allObjects];
    } else if ([col isKindOfClass:[NSDictionary class]]) {
        self.keys = [col allKeys];
        self.values = [col allObjects];
    } else {
        [NSException raise:@"" format:@""]; // TODO
    }

    self.current = 0;
}


- (id)evaluateInContext:(TDTemplateContext *)ctx; {
    if (!_started) {
        [self beginInContext:ctx];
        self.started = YES;
    }
    
    id result = nil;
    if ([self hasMore]) {
        if (_keys) {
            id key = _keys[self.current];
            TDAssert(key);
            id val = self.values[self.current];
            TDAssert(val);
            result = @[key, val];
        } else {
            result = self.values[self.current];
            TDAssert(result);
        }
        self.current++;
    } else {
        self.started = NO;
    }
    
    return result;
}

@end
