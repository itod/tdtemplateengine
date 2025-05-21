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

#import "TDTag.h"
#import <TDTemplateEngine/TDTemplateEngine.h>
#import <TDTemplateEngine/TDTemplateContext.h>
#import <TDTemplateEngine/TDWriter.h>
#import <TDTemplateEngine/TDExpression.h>
#import "TDValue.h"

@interface TDTemplateContext ()
@property (nonatomic, retain) TDWriter *writer;
@end

@implementation TDTag

+ (NSString *)tagName {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return nil;
}


+ (TDTagContentType)tagContentType {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return TDTagContentTypeSimple;
}


+ (TDTagExpressionType)tagExpressionType {
    return TDTagExpressionTypeDefault;
}


+ (NSString *)outputTemplatePath {
    return nil;
}


- (void)dealloc {
    self.args = nil;
    self.kwargs = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark TDNode

- (void)renderInContext:(TDTemplateContext *)ctx {
    NSParameterAssert(ctx);
    
    id vars = [self runInContext:ctx];
    
    if (vars) {
        NSString *templatePath = [[self class] outputTemplatePath];
        NSError *err = nil;
        TDTemplate *tmpl = [ctx.delegate templateContext:ctx templateForFilePath:templatePath error:&err];
        if (!tmpl) {
            if (err) NSLog(@"%@", err);
            return;
        }
        
        BOOL success = [tmpl render:vars toStream:ctx.writer.output error:&err];
        if (!success) {
            if (err) NSLog(@"%@", err);
            return;
        }
    }
}


#pragma mark -
#pragma mark TDTag

- (id)runInContext:(TDTemplateContext *)ctx {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return nil;
}


- (NSString *)tagName {
    return [[self class] tagName];
}

@end
