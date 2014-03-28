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

#import "TDTemplateEngine.h"

@interface TDTemplateEngine ()
@property (nonatomic, retain) NSString *varStartDelimiter;
@property (nonatomic, retain) NSString *varEndDelimiter;
@property (nonatomic, retain) NSString *blockStartDelimiter;
@property (nonatomic, retain) NSString *blockEndDelimiter;
@property (nonatomic, retain) NSRegularExpression *delimiterRegex;
@end

@implementation TDTemplateEngine

+ (TDTemplateEngine *)templateEngine {
    return [[[TDTemplateEngine alloc] init] autorelease];
}


- (instancetype)init {
    self = [super init];
    if (self) {
        self.varStartDelimiter = @"\\{\\{";
        self.varEndDelimiter = @"\\}\\}";
        self.blockStartDelimiter = @"\\{%";
        self.blockEndDelimiter = @"%\\}";
    }
    return self;
}


- (void)dealloc {
    self.varStartDelimiter = nil;
    self.varEndDelimiter = nil;
    self.blockStartDelimiter = nil;
    self.blockEndDelimiter = nil;
    self.delimiterRegex = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Public

- (NSString *)processTemplateString:(NSString *)str withVariables:(NSDictionary *)vars {
    NSParameterAssert([str length]);
    TDAssertMainThread();
    TDAssert([_varStartDelimiter length]);
    TDAssert([_varEndDelimiter length]);
    TDAssert([_blockStartDelimiter length]);
    TDAssert([_blockEndDelimiter length]);

    NSString *result = nil;
    NSError *err = nil;
    
    if (![self setUpDelimiterRegex:&err]) {
        NSLog(@"%@", err);
        goto done;
    }

    result = @"bar";
    
done:
    return result;
}


- (NSString *)processTemplateFile:(NSString *)path withVariables:(NSDictionary *)vars encoding:(NSStringEncoding)enc error:(NSError **)err {
    NSParameterAssert([path length]);
    
    NSString *result = nil;
    NSString *str = [NSString stringWithContentsOfFile:path encoding:enc error:err];
    
    if (str) {
        result = [self processTemplateString:str withVariables:vars];
    }
    
    return result;
}


#pragma mark -
#pragma mark Private

- (BOOL)setUpDelimiterRegex:(NSError **)outErr {
    TDAssertMainThread();
    
    NSString *pattern = [NSString stringWithFormat:@"(%@.*?%@|%@.*?%@)", _varStartDelimiter, _varEndDelimiter, _blockStartDelimiter, _blockEndDelimiter];
    
    
    self.delimiterRegex = [[[NSRegularExpression alloc] initWithPattern:pattern options:0 error:outErr] autorelease];
    
    BOOL success = nil != _delimiterRegex;
    return success;
}

@end
