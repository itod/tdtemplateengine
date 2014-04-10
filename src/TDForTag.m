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

#import "TDForTag.h"
#import "TDForLoop.h"
#import <TDTemplateEngine/TDTemplateContext.h>

#import "XPLoopExpression.h"
#import "XPEnumeration.h"

@interface TDForTag ()
@property (nonatomic, retain) TDForLoop *currentLoop;
@end

@implementation TDForTag

+ (NSString *)tagName {
    return @"for";
}


+ (TDTagType)tagType {
    return TDTagTypeBlock;
}


- (void)dealloc {
    self.currentLoop = nil;
    [super dealloc];
}


- (NSString *)description {
    return [NSString stringWithFormat:@"%p for %@", self, self.expression];
}


- (void)doTagInContext:(TDTemplateContext *)ctx {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, self);
    TDAssert(ctx);
    
    XPLoopExpression *expr = (id)self.expression;
    TDAssert([expr isKindOfClass:[XPLoopExpression class]]);
    
    [self setUpForLoop:ctx];
    
    while ([expr evaluateInContext:ctx]) {
        _currentLoop.last = ![expr.enumeration hasMore];
        //NSLog(@"rendering body of %@", self);
        [self renderChildrenInContext:ctx];
        
        _currentLoop.currentIndex++;
        _currentLoop.first = NO;
    }

    [self tearDownForLoop:ctx];
}


- (void)setUpForLoop:(TDTemplateContext *)ctx {
    self.currentLoop = [[[TDForLoop alloc] init] autorelease];
    
    TDForTag *enclosingForTag = (id)[self firstAncestorOfTagName:@"for"];
    _currentLoop.parentLoop = enclosingForTag.currentLoop;

    [ctx defineVariable:@"currentLoop" value:_currentLoop];
}


- (void)tearDownForLoop:(TDTemplateContext *)ctx {
    [ctx defineVariable:@"currentLoop" value:nil];
    _currentLoop.parentLoop = nil;
    self.currentLoop = nil;
}

@end
