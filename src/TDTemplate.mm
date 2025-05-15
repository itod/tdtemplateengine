//
//  TDTemplate.m
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 5/14/25.
//  Copyright © 2025 Todd Ditchendorf. All rights reserved.
//

#import <TDTemplateEngine/TDTemplate.h>
#import "TDNode.h"

@interface TDTemplate ()
//@property (nonatomic, retain) id rootNode; // TDNode or TDRootNode?
@property (nonatomic, retain) NSMutableDictionary *blockNodes;
@end

@implementation TDTemplate

//+ (instancetype)templateWithContentsOfFile:(NSString *)path error:(NSError **)outErr {
//    NSStringEncoding enc;
//    NSString *str = [NSString stringWithContentsOfFile:path usedEncoding:&enc error:outErr];
//    if (!str) return nil;
//    
//    return [self templateWithString:str error:outErr];
//}
//
//
//+ (instancetype)templateWithString:(NSString *)path error:(NSError **)outErr {
//    id node = nil; // compile
//    
//    TDTemplate *tmpl = [[[TDTemplate alloc] init] autorelease];
//    return tmpl;
//}


- (instancetype)initWithDocument:(TDNode *)doc {
    self = [super init];
    if (self) {
//        self.rootNode = root;
        
        self.blockNodes = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                           doc, @"__doc__",
                           nil];
    }
    return self;
}


- (void)dealloc {
//    self.rootNode = nil;
    self.blockNodes = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark NSCopying

- (id)copyWithZone:(NSZone *)zone {
    TDTemplate *tmpl = [[TDTemplate alloc] init];
    
    tmpl->_blockNodes = [_blockNodes retain];
    
    return tmpl;
}


#pragma mark -
#pragma mark Friend API

- (void)addBlocksFromNode:(TDNode *)node {
    // absorb the blocks in node into _nodes
}


#pragma mark -
#pragma mark Public

- (NSString *)render:(NSDictionary *)vars error:(NSError **)outErr {
    return nil;
}


- (BOOL)render:(NSDictionary *)vars toStream:(NSOutputStream *)stream error:(NSError **)outErr {
    return NO;
}

@end
