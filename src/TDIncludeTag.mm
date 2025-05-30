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
    return TDTagContentTypeLeaf;
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

    TDAssert(ctx.delegate);
    // throws TDTemplateException & bubbles up to client
    TDTemplate *tmpl = [ctx.delegate templateContext:ctx templateForFilePath:absPath];
    
    if (tmpl) {
        TDRootNode *root = tmpl.rootNode;
        TDAssert(root);
        
        //NSLog(@"setting inc `%@` in current tmpl: %@", relPath, ctx.currentTemplate.filePath.lastPathComponent);
        [ctx.currentTemplate setBlock:root forKey:self.key];
    } else {
        TDAssert(0);
    }
}


#pragma mark -
#pragma mark Runtime

- (void)runInContext:(TDTemplateContext *)inCtx {
    NSParameterAssert(inCtx);
    
    TDTemplate *tmpl = inCtx.currentTemplate;
    TDAssert(tmpl);
    //NSLog(@"getting inc `%@` in current tmpl: %@", self.key.lastPathComponent, tmpl.filePath.lastPathComponent);
    TDRootNode *delegate = (TDRootNode *)[tmpl blockForKey:self.key];
    TDAssert(delegate);
    TDAssert([delegate isKindOfClass:[TDRootNode class]]);
    
    // need one outer ctx for user variables
    TDTemplateContext *outer = [[[TDTemplateContext alloc] initWithVariables:nil output:inCtx.writer.output] autorelease];
    outer.delegate = inCtx.delegate;
    outer.enclosingScope = inCtx;
    outer.originDerivedTemplate = inCtx.originDerivedTemplate;
    TDAssert(delegate.owningTemplate.filePath);
    outer.currentTemplate = delegate.owningTemplate;
    TDTemplateContext *ctx = outer;

    if (self.kwargs.count) {
        for (NSString *name in self.kwargs) {
            TDExpression *expr = [self.kwargs objectForKey:name];
            id val = [expr evaluateAsObjectInContext:outer];
            [outer defineVariable:name value:val];
        }
        
//        // and another for variables generated in the template like `forloop`. we dont want these to overwrite any user vars
//        TDTemplateContext *inner = [[[TDTemplateContext alloc] initWithVariables:nil output:inCtx.writer.output] autorelease];
//        inner.delegate = inCtx.delegate;
//        inner.enclosingScope = outer;
//        inner.originDerivedTemplate = inCtx.originDerivedTemplate; // ??
//        inner.currentTemplate = tmpl;
//        inner.currentTemplateFilePath = delegate.templateFilePath;
//        ctx = inner;
    }
    
    [ctx pushTemplateString:delegate.templateString];
    [delegate renderChildrenInContext:ctx];
    [ctx popTemplateString];
}

@end
