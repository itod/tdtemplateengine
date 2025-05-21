// The MIT License (MIT)
//
// Copyright (c) 2014 Todd Ditchendorf
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "TDIncludeTag.h"
#import "TDExpression.h"
#import "TDTemplate.h"
#import "TDTemplateContext.h"
#import "TDRootNode.h"
#import "TDWriter.h"

@interface TDTemplate ()
@property (nonatomic, retain) TDRootNode *rootNode;
- (TDNode *)blockForKey:(NSString *)key;
- (void)setBlock:(TDNode *)block forKey:(NSString *)key;
@end

@interface TDTemplateContext ()
@property (nonatomic, retain) TDWriter *writer;
@end

@interface TDIncludeTag ()
@property (nonatomic, copy) NSString *key;
@end

@implementation TDIncludeTag

+ (NSString *)tagName {
    return @"include";
}


+ (TDTagContentType)tagContentType {
    return TDTagContentTypeSimple;
}


+ (TDTagExpressionType)tagExpressionType {
    return TDTagExpressionTypeInclude;
}


- (void)dealloc {
    self.key = nil;
    [super dealloc];
}


- (void)compileInContext:(TDTemplateContext *)ctx {
        
    NSString *relPath = [self.expression evaluateAsStringInContext:ctx];
    NSString *absPath = [ctx absolutePathForTemplateRelativePath:relPath];

    self.key = [NSString stringWithFormat:@"__include:%@", absPath];
    
    NSError *err = nil;
    TDAssert(ctx.delegate);
    TDTemplate *tmpl = [ctx.delegate templateContext:ctx templateForFilePath:absPath error:&err];
    
    if (!tmpl) {
        if (err) NSLog(@"%@", err);
        [NSException raise:@"HTTP500" format:@"%@", err.localizedDescription];
    }
    
    TDRootNode *root = tmpl.rootNode;
    [ctx.derivedTemplate setBlock:root forKey:self.key];
}


#pragma mark -
#pragma mark Runtime

- (id)runInContext:(TDTemplateContext *)inCtx {
    NSParameterAssert(inCtx);
    
    TDTemplate *tmpl = inCtx.derivedTemplate;
    TDAssert(tmpl);
    TDRootNode *delegate = (TDRootNode *)[tmpl blockForKey:self.key];
    TDAssert([delegate isKindOfClass:[TDRootNode class]]);
    
    TDTemplateContext *ctx = inCtx;
    if (self.kwargs.count) {
        ctx = [[[TDTemplateContext alloc] initWithVariables:nil output:inCtx.writer.output] autorelease];
        ctx.enclosingScope = inCtx;
        
        for (NSString *name in self.kwargs) {
            TDExpression *expr = [self.kwargs objectForKey:name];
            id val = [expr evaluateAsObjectInContext:ctx];
            [ctx defineVariable:name value:val];
        }
    }
    
    [ctx pushTemplateString:delegate.templateString];
    [delegate renderChildrenInContext:ctx];
    [ctx popTemplateString];
    
    return nil;
}

@end
