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

#import "TDPathExpression.h"
#import "TDBooleanValue.h"
#import "TDNumericValue.h"
#import "TDStringValue.h"
#import "TDObjectValue.h"
//#import <PEGKit/PKToken.h>
#import <TDTemplateEngine/TDTemplateContext.h>

@interface TDPathExpression ()
@property (nonatomic, retain) NSString *head;
@property (nonatomic, retain) NSArray *tail;
@end

@implementation TDPathExpression

+ (instancetype)pathExpressionWithSteps:(NSArray *)steps {
    return [[[self alloc] initWithSteps:steps] autorelease];
}


- (instancetype)initWithSteps:(NSArray *)steps {
    self = [super init];
    if (self) {
        NSUInteger c = [steps count];
        TDAssert(c);
        TDAssert(NSNotFound != c);
//        self.head = [[steps firstObject] stringValue];
        self.head = [steps firstObject];
        TDAssert([_head length]);
        if (c > 1) {
            self.tail = [steps subarrayWithRange:NSMakeRange(1, c-1)];
            TDAssert([_tail count]);
        }
    }
    return self;
}


- (void)dealloc {
    self.head = nil;
    self.tail = nil;
    [super dealloc];
}


- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %p `%@.%@`>", [self class], self, self.head, [self.tail componentsJoinedByString:@"."]];
}


- (TDExpression *)simplify {
    return self;
}


- (TDValue *)evaluateInContext:(TDTemplateContext *)ctx {
    TDAssert([_head length]);
    id obj = [ctx resolveVariable:_head];
    
    TDValue *result = nil;
    
    if (obj) {
        if (_tail) {
            // TODO
//            NSMutableArray *strs = [NSMutableArray arrayWithCapacity:[_tail count]];
//            for (PKToken *tok in _tail) {
//                [strs addObject:tok.stringValue];
//            }
//            obj = [obj valueForKeyPath:[strs componentsJoinedByString:@"."]];
            NSString *path = [_tail componentsJoinedByString:@"."];
            obj = [obj valueForKeyPath:path];
        }
        
        result = TDValueFromObject(obj);
    }
    
    return result;
}


- (TDDataType)dataType {
    return TDDataTypeAny;
}

@end
