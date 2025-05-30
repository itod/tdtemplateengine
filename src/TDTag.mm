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

#import <TDTemplateEngine/TDTag.h>
#import <TDTemplateEngine/TDTemplateEngine.h>
#import <TDTemplateEngine/TDTemplateException.h>
#import <TDTemplateEngine/TDSkipException.h>

@implementation TDTag

+ (NSString *)tagName {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return nil;
}


+ (TDTagContentType)tagContentType {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return TDTagContentTypeLeaf;
}


+ (TDTagExpressionType)tagExpressionType {
    return TDTagExpressionTypeDefault;
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
    
    @try {
        [self runInContext:ctx];
    } @catch (TDTemplateException *tex) {
        [tex raise];
    } @catch (TDSkipException *sex) {
        [sex raise];
    } @catch (NSException *ex) {
        NSString *sample = [ctx templateSubstringForToken:self.token];
        [TDTemplateException raiseFromException:ex token:self.token sample:sample filePath:ctx.currentTemplate.filePath];
    }
}


#pragma mark -
#pragma mark TDTag

- (void)runInContext:(TDTemplateContext *)ctx {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
}


- (NSString *)tagName {
    return [[self class] tagName];
}


- (void)validateArgsWithMin:(NSUInteger)min max:(NSUInteger)max {
    NSUInteger actual = self.args.count;
    
    NSString *plural = min > 1 ? @"s" : @"";
    if (actual < min) {
        [NSException raise:TDTemplateEngineErrorDomain format:@"Filter '%@' requires at least %lu argument%@. %lu given.", [[self class] filterName], min, plural, actual];
    }

    plural = (0 == max || max > 1) ? @"s" : @"";
    if (actual > max) {
        [NSException raise:TDTemplateEngineErrorDomain format:@"Filter '%@' requires at most %lu argument%@. %lu given.", [[self class] filterName], max, plural, actual];
    }
}

@end
