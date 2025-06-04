//
//  TDBaseTestCase.m
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 6/4/25.
//  Copyright © 2025 Todd Ditchendorf. All rights reserved.
//

#import "TDBaseTestCase.h"

@interface TDTemplateEngine ()
@property (nonatomic, retain) NSMutableDictionary *filterTab;
- (TDTemplate *)_templateFromString:(NSString *)str filePath:(NSString *)path context:(TDTemplateContext *)inCtx;
- (NSError *)errorFromParseException:(TDTemplateException *)ex;
@end

@implementation TDBaseTestCase

- (void)setUp {
    [super setUp];
    
    self.engine = [[[TDTemplateEngine alloc] init] autorelease]; // create thread local temp engine
    self.output = [NSOutputStream outputStreamToMemory];
}

- (void)tearDown {
    self.engine = nil;
    self.output = nil;

    [super tearDown];
}


- (BOOL)processTemplateFile:(NSString *)path encoding:(NSStringEncoding)enc withVariables:(NSDictionary *)vars toStream:(NSOutputStream *)output error:(NSError **)err {
    TDTemplate *tmpl = [self.engine templateWithContentsOfFile:path error:err];
    
    BOOL success = NO;

    if (tmpl) {
        success = [tmpl render:vars toStream:output error:err];
    }
    
    return success;
}


- (BOOL)processTemplateString:(NSString *)str withVariables:(NSDictionary *)vars toStream:(NSOutputStream *)output error:(NSError **)outError {
    TDTemplate *tmpl = nil;
    
    BOOL success = NO;
    @try {
        tmpl = [self.engine _templateFromString:str filePath:nil context:nil];
        if (tmpl) {
            success = [tmpl render:vars toStream:output error:outError];
        }
    } @catch (TDTemplateException *ex) {
        if (outError) {
            *outError = [self.engine errorFromParseException:ex];
        }
    }
    
    return success;
}


- (NSString *)outputString {
    NSString *str = [[[NSString alloc] initWithData:[_output propertyForKey:NSStreamDataWrittenToMemoryStreamKey] encoding:NSUTF8StringEncoding] autorelease];
    return str;
}

@end
