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
#import "EXToken.h"

@interface TDTag ()
@property (nonatomic, retain) NSArray *args;
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


- (void)dealloc {
    self.args = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark TDNode

- (void)renderInContext:(TDTemplateContext *)ctx {
    NSParameterAssert(ctx);

    //ctx = [[ctx copy] autorelease];
    
    [self doTagInContext:ctx];
}


#pragma mark -
#pragma mark TDTag

- (void)doTagInContext:(TDTemplateContext *)ctx {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
}


- (NSString *)tagName {
    return [[self class] tagName];
}


- (NSArray *)evaluatedArgs:(TDTemplateContext *)ctx {
    NSUInteger c = [_args count];
    
    id evaledArgs = nil;
    if (c) {
        evaledArgs = [NSMutableArray arrayWithCapacity:c];
        
        for (EXToken *tok in _args) {
            switch (tok.tokenType) {
                case TokenType_QUOTED_STRING:
                    [evaledArgs addObject:tok.stringValue];
                    break;
                case TokenType_WORD:
                    [evaledArgs addObject:[ctx resolveVariable:tok.stringValue]];
                    break;
                case TokenType_NUMBER:
                    [evaledArgs addObject:@(tok.doubleValue)];
                    break;
                default:
                    TDAssert(0);
                    break;
            }
        }
    }
    
    return evaledArgs;
}

@end
