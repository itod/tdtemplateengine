//
//  EXToken.m
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 5/13/25.
//  Copyright © 2025 Todd Ditchendorf. All rights reserved.
//

#import "EXToken.h"

@interface EXToken ()
@property (nonatomic, assign, readwrite) TokenType tokenType;
@property (nonatomic, retain, readwrite) NSString *stringValue;
@property (nonatomic, assign, readwrite) double doubleValue;
@end

@implementation EXToken

+ (EXToken *)tokenWithTokenType:(TokenType)tt stringValue:(NSString *)s doubleValue:(double)n {
    return [[[self alloc] initWithTokenType:tt stringValue:s doubleValue:n] autorelease];
}


- (instancetype)initWithTokenType:(TokenType)tt stringValue:(NSString *)s doubleValue:(double)n {
    self = [super init];
    if (self) {
        self.tokenType = tt;
        self.stringValue = s;
        self.doubleValue = n;
    }
    return self;
}


- (void)dealloc {
    self.stringValue = nil;
    [super dealloc];
}


- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %p %@ %@ %@>", [self class], self, @(_tokenType), _stringValue, @(_doubleValue)];
}


@end
