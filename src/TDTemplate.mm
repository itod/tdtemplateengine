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

@interface TDTemplate () // FriendAPI
@property (nonatomic, retain) TDRootNode *rootNode;
@property (nonatomic, retain) TDTemplate *superTemplate;
@property (nonatomic, copy) NSString *extendsPath;

// blocks
@property (nonatomic, retain) NSMutableDictionary *blockTab;
- (TDNode *)blockForKey:(NSString *)key;
- (void)setBlock:(TDNode *)block forKey:(NSString *)key;
@end

@implementation TDTemplate

- (instancetype)initWithFilePath:(NSString *)path {
    self = [super init];
    if (self) {
        self.filePath = path;
    }
    return self;
}


- (void)dealloc {
    self.filePath = nil;
    self.rootNode = nil;
    self.superTemplate = nil;
    self.extendsPath = nil;

    self.blockTab = nil;
    [super dealloc];
}


- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %p %@>", [self class], self, _filePath];
}


#pragma mark -
#pragma mark Public

- (NSString *)render:(NSDictionary *)vars error:(NSError **)err {
    NSOutputStream *output = [NSOutputStream outputStreamToMemory];
    
    NSString *result = nil;
    if ([self render:vars toStream:output error:err]) {
        result = [[[NSString alloc] initWithData:[output propertyForKey:NSStreamDataWrittenToMemoryStreamKey] encoding:NSUTF8StringEncoding] autorelease];
    }
    
    return result;
}


- (BOOL)render:(NSDictionary *)vars toStream:(NSOutputStream *)output error:(NSError **)err {
    NSParameterAssert([_rootNode isKindOfClass:[TDRootNode class]]);
    NSParameterAssert(output);
    
    TDRootNode *document = (id)[self blockForKey:@""];
    if (!document) {
        *err = [NSError errorWithDomain:TDTemplateEngineErrorDomain code:TDTemplateEngineRenderingErrorCode userInfo:@{
            NSLocalizedFailureReasonErrorKey: [NSString stringWithFormat:@"Could not find Document Node for template: `%@`", _filePath],
        }];
        return NO;
    }
    
    [output open];
    TDAssert([output hasSpaceAvailable]);
    
    TDTemplateContext *dynamicContext = [[[TDTemplateContext alloc] initWithVariables:vars output:output] autorelease];
    dynamicContext.derivedTemplate = self;
    TDAssert(document.templateString);
    [dynamicContext pushTemplateString:document.templateString];
    
    //TDAssert(_staticContext);
    //dynamicContext.enclosingScope = _staticContext;
    //dynamicContext.templateString = [(id)root templateString];
    
    BOOL success = YES;
    
    @try {
        [document renderInContext:dynamicContext];
    }
    @catch (NSException *ex) {
        success = NO;
        if (err) *err = [NSError errorWithDomain:TDTemplateEngineErrorDomain code:TDTemplateEngineRenderingErrorCode userInfo:[[[ex userInfo] copy] autorelease]];
    }
    
    [dynamicContext popTemplateString];
    
    return success;
}


- (NSString *)templateSubstringForToken:(parsekit::Token)token {
    TDAssert(_rootNode.templateString);
    NSString *result = [_rootNode.templateString substringWithRange:NSMakeRange(token.range().location, token.range().length)];
    return result;
}


#pragma mark -
#pragma mark Friend Blocks API

- (TDNode *)blockForKey:(NSString *)key {
    TDNode *node = [_blockTab objectForKey:key];
    if (!node) {
        node = [_superTemplate blockForKey:key];
    }
    return node;
}


- (void)setBlock:(TDNode *)block forKey:(NSString *)key {
    TDAssert(block);
    TDAssert(key);
    if (!_blockTab) {
        self.blockTab = [NSMutableDictionary dictionary];
    }
    [_blockTab setObject:block forKey:key];
}

@end
