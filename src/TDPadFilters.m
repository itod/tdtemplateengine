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

#import "TDPadFilters.h"

@implementation TDAbstractPadFilter

- (id)runFilter:(id)input withArgs:(NSArray *)args inContext:(TDTemplateContext *)ctx {
    TDAssert(input);
    
    [self validateArgs:args min:1 max:2];
    
    NSString *inStr = TDStringFromObject(input);
    NSString *result = inStr;
    
    NSString *pad = @"";
    
    NSUInteger len = 0;
    if (args.count > 1) {
        len = [args[1] unsignedIntegerValue];
    }
    
    if (0 == len && inStr.length) {
        pad = args[0];
    } else if (result.length < len) {
        pad = args[0];
        NSMutableString *buf = [NSMutableString stringWithCapacity:len];
        
        for (NSUInteger i = len - result.length; i > 0; --i) {
            [buf appendString:pad];
        }
        
        pad = buf;
    }

    if (self.left) {
        result = [NSString stringWithFormat:@"%@%@", pad, result];
    } else {
        result = [NSString stringWithFormat:@"%@%@", result, pad];
    }

    return result;
}

@end

@implementation TDLpadFilter

+ (NSString *)filterName {
    return @"lpad";
}


- (instancetype)init {
    self = [super init];
    if (self) {
        self.left = YES;
    }
    return self;
}

@end

@implementation TDRpadFilter

+ (NSString *)filterName {
    return @"rpad";
}

@end
