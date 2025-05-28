//
//  TDInclusionTag.m
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 5/21/25.
//  Copyright © 2025 Todd Ditchendorf. All rights reserved.
//

#import <TDTemplateEngine/TDInclusionTag.h>
#import <TDTemplateEngine/TDTemplateContext.h>
#import <TDTemplateEngine/TDTemplateException.h>
#import <TDTemplateEngine/TDTemplate.h>
#import <TDTemplateEngine/TDWriter.h>

@interface TDTemplateContext ()
@property (nonatomic, retain) TDWriter *writer;
@end

@implementation TDInclusionTag

+ (NSString *)inclusionTemplatePath {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return nil;
}


- (void)dealloc {
    self.inclusionTemplate = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark TDCompileTimeTag

- (void)compileInContext:(TDTemplateContext *)ctx {
    NSString *relPath = [[self class] inclusionTemplatePath];
    NSString *absPath = [ctx absolutePathForTemplateRelativePath:relPath];

    TDAssert(ctx.delegate);
    // throws TDTemplateException & bubbles up to client
    TDTemplate *tmpl = [ctx.delegate templateContext:ctx templateForFilePath:absPath];
    
    if (tmpl) {
        self.inclusionTemplate = tmpl;
    } else {
        TDAssert(0);
    }
}


#pragma mark -
#pragma mark TDTag

- (void)renderInContext:(TDTemplateContext *)ctx {
    NSParameterAssert(ctx);
    
    id vars = [self runInContext:ctx];
    
    if (vars) {
        TDAssert(_inclusionTemplate);
        NSError *err = nil;
        BOOL success = [_inclusionTemplate render:vars toStream:ctx.writer.output error:&err];
        if (!success) {
            if (err) NSLog(@"%@", err);
            [TDTemplateException raiseFromError:err];
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
