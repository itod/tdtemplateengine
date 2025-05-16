//
//  TDTemplate.m
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 5/14/25.
//  Copyright © 2025 Todd Ditchendorf. All rights reserved.
//

#import <TDTemplateEngine/TDTemplate.h>
#import <TDTemplateEngine/TDTemplateContext.h>
#import <TDTemplateEngine/TDTemplateEngine.h>
#import "TDRootNode.h"

@interface TDRootNode ()
@property (nonatomic, retain) NSMutableDictionary *blockTab;
@end

@interface TDTemplate ()
@property (nonatomic, retain) TDRootNode *document;
@end

@implementation TDTemplate

- (instancetype)initWithDocument:(TDRootNode *)doc {
    self = [super init];
    if (self) {
        self.document = doc;
    }
    return self;
}


- (void)dealloc {
    self.document = nil;
    self.filePath = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark NSCopying

- (id)copyWithZone:(NSZone *)zone {
    TDTemplate *tmpl = [[TDTemplate alloc] init];
    
    tmpl->_document = [_document retain];
    
    return tmpl;
}


#pragma mark -
#pragma mark Friend API

- (void)adoptBlocksFromNode:(TDRootNode *)that {
    // absorb the blocks in node into this template's root node
    [self.document.blockTab addEntriesFromDictionary:that.blockTab];
}


#pragma mark -
#pragma mark Public

- (NSString *)render:(NSDictionary *)vars error:(NSError **)err {
    return nil;
}


- (BOOL)render:(NSDictionary *)vars toStream:(NSOutputStream *)output error:(NSError **)err {
    NSParameterAssert([_document isKindOfClass:[TDRootNode class]]);
    NSParameterAssert(output);
    
    [output open];
    TDAssert([output hasSpaceAvailable]);
    
    TDTemplateContext *dynamicContext = [[[TDTemplateContext alloc] initWithVariables:vars output:output] autorelease];
    TDAssert(_document.templateString);
    [dynamicContext pushTemplateString:_document.templateString];
    
    //TDAssert(_staticContext);
    //dynamicContext.enclosingScope = _staticContext;
    //dynamicContext.templateString = [(id)root templateString];
    
    BOOL success = YES;
    
    @try {
        [_document renderInContext:dynamicContext];
    }
    @catch (NSException *ex) {
        success = NO;
        if (err) *err = [NSError errorWithDomain:TDTemplateEngineErrorDomain code:TDTemplateEngineRenderingErrorCode userInfo:[[[ex userInfo] copy] autorelease]];
    }
    
    [dynamicContext popTemplateString];
    
    return success;
}


- (NSString *)templateSubstringForToken:(parsekit::Token)token {
    TDAssert(_document.templateString);
    NSString *result = [_document.templateString substringWithRange:NSMakeRange(token.range().location, token.range().length)];
    return result;
}

@end
