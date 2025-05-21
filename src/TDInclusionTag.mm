//
//  TDInclusionTag.m
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 5/21/25.
//  Copyright © 2025 Todd Ditchendorf. All rights reserved.
//

#import <TDTemplateEngine/TDInclusionTag.h>
#import <TDTemplateEngine/TDTemplateContext.h>
#import <TDTemplateEngine/TDTemplate.h>
#import <TDTemplateEngine/TDWriter.h>

@interface TDTemplateContext ()
@property (nonatomic, retain) TDWriter *writer;
@end

@implementation TDInclusionTag

+ (NSString *)outputTemplatePath {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return nil;
}


- (void)dealloc {
    self.outputTemplate = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark TDCompileTimeTag

- (void)compileInContext:(TDTemplateContext *)ctx {
    NSString *relPath = [[self class] outputTemplatePath];
    NSString *absPath = [ctx absolutePathForTemplateRelativePath:relPath];

    NSError *err = nil;
    TDAssert(ctx.delegate);
    TDTemplate *tmpl = [ctx.delegate templateContext:ctx templateForFilePath:absPath error:&err];
    
    if (!tmpl) {
        if (err) NSLog(@"%@", err);
        [NSException raise:@"HTTP500" format:@"%@", err.localizedDescription];
    }
    
    self.outputTemplate = tmpl;
}


#pragma mark -
#pragma mark TDTag

- (void)renderInContext:(TDTemplateContext *)ctx {
    NSParameterAssert(ctx);
    
    id vars = [self runInContext:ctx];
    
    if (vars) {
        TDAssert(self.outputTemplate);
        NSError *err = nil;
        BOOL success = [self.outputTemplate render:vars toStream:ctx.writer.output error:&err];
        if (!success) {
            if (err) NSLog(@"%@", err);
            return;
        }
    }
}


#pragma mark -
#pragma mark TDInclusionTag

- (id)runInContext:(TDTemplateContext *)ctx {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return nil;
}

@end
