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

@interface TDTemplate ()
@property (nonatomic, retain) TDRootNode *rootNode;
- (TDNode *)blockForKey:(NSString *)key;
- (void)setBlock:(TDNode *)block forKey:(NSString *)key;
@end

@interface TDIncludeTag ()
@property (nonatomic, copy) NSString *key;
@end

@implementation TDIncludeTag

+ (NSString *)tagName {
    return @"include";
}


+ (TDTagType)tagType {
    return TDTagTypeSimple;
}


- (void)dealloc {
    self.key = nil;
    [super dealloc];
}


- (void)compileInContext:(TDTemplateContext *)staticContext {
    NSString *relPath = [self.expression evaluateAsStringInContext:staticContext];
    
    NSString *absPath = [staticContext absolutePathForPath:relPath];
    self.key = [NSString stringWithFormat:@"__include:%@", absPath];
    
    NSError *err = nil;
    TDAssert(staticContext.delegate);
    TDTemplate *tmpl = [staticContext.delegate templateContext:staticContext templateForFilePath:absPath error:&err];
    
    if (!tmpl) {
        if (err) NSLog(@"%@", err);
        // raise HTTP500
        return;
    }
    
    TDRootNode *root = tmpl.rootNode;
    [staticContext.derivedTemplate setBlock:root forKey:self.key];
}


#pragma mark -
#pragma mark Runtime

- (void)doTagInContext:(TDTemplateContext *)ctx {
    NSParameterAssert(ctx);
    
    TDTemplate *tmpl = ctx.derivedTemplate;
    TDAssert(tmpl);
    TDRootNode *delegate = (TDRootNode *)[tmpl blockForKey:self.key];
    TDAssert([delegate isKindOfClass:[TDRootNode class]]);
    
    [ctx pushTemplateString:delegate.templateString];
    [delegate renderChildrenInContext:ctx];
    [ctx popTemplateString];
}

@end
