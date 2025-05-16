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

@interface TDTemplate ()
@property (nonatomic, retain, readwrite) TDTemplate *superTemplate;
@property (nonatomic, retain) TDRootNode *rootNode;
@property (nonatomic, retain) NSMutableDictionary *blockTab;
@end

@implementation TDTemplate

- (instancetype)initWithFilePath:(NSString *)path {
    self = [super init];
    if (self) {
        self.filePath = path;
    }
    return self;
}
//- (instancetype)initWithDocument:(TDRootNode *)doc {
//    self = [super init];
//    if (self) {
//        self.document = doc;
//    }
//    return self;
//}


- (void)dealloc {
    self.rootNode = nil;
    self.blockTab = nil;

    self.filePath = nil;

    self.superTemplate = nil;
    self.extendsPath = nil;

    [super dealloc];
}


- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %p %@>", [self class], self, _filePath];
}



//#pragma mark -
//#pragma mark NSCopying
//
//- (id)copyWithZone:(NSZone *)zone {
//    TDTemplate *tmpl = [[TDTemplate alloc] init];
//    
//    tmpl->_document = [_document retain];
//    
//    return tmpl;
//}


#pragma mark -
#pragma mark Public

- (NSString *)render:(NSDictionary *)vars error:(NSError **)err {
    return nil;
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
