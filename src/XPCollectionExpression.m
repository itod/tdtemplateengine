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
@property (nonatomic, retain) id collection;
@property (nonatomic, assign) NSInteger current;
@end

@implementation XPCollectionExpression

+ (instancetype)collectionExpressionWithVarName:(NSString *)var {
    return [[[self alloc] initWithVarName:var] autorelease];
}


- (instancetype)initWithVarName:(NSString *)var {
    self = [super init];
    if (self) {
        self.var = var;
    }
    return self;
}


- (void)dealloc {
    self.var = nil;
    self.collection = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark XPEnumeration

- (void)begin:(TDTemplateContext *)ctx {
    TDAssert(ctx);
    TDAssert([_var length]);
    
    self.collection = [ctx resolveVariable:_var];
    self.current = 0;
}


- (id)next {
    id result = nil;
    if ([self hasMore]) {
        result = _collection[_current];
        self.current++;
    }
    return result;
}


- (BOOL)hasMore {
    return _current < [_collection count];
}

@end
