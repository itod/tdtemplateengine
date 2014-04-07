//
//  TDWriter.m
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 4/2/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDWriter.h"
#import "TDTemplateEngine.h"

@implementation TDWriter

+ (instancetype)writerWithOutputStream:(NSOutputStream *)output {
    return [[[self alloc] initWithOutputStream:output] autorelease];
}


- (instancetype)initWithOutputStream:(NSOutputStream *)output {
    self = [super init];
    if (self) {
        self.output = output;
    }
    return self;
}


- (void)dealloc {
    self.output = nil;
    [super dealloc];
}


- (void)appendObject:(id)obj {
    NSString *str = nil;
    if ([obj isKindOfClass:[NSString class]]) {
        str = obj;
    } else if ([obj respondsToSelector:@selector(stringValue)]) {
        str = [obj stringValue];
    } else {
        str = [obj description];
    }
    [self appendString:str];
}


- (void)appendString:(NSString *)str {
    TDAssert(_output);
    TDAssert(str);
    
    NSUInteger len = [str lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    if (len) {
        const uint8_t *zstr = (const uint8_t *)[str UTF8String];
        NSUInteger remaining = len;
        do {
            NSInteger trim = remaining - len;
            if (trim > 0) {
                zstr += trim;
            }
            NSInteger written = [_output write:zstr maxLength:remaining];
            if (-1 == written) {
                [NSException raise:TDTemplateEngineErrorDomain format:@"Error while writing template output string"];
            }
            remaining -= written;
        } while (remaining > 0);
    }
}


- (void)appendFormat:(NSString *)fmt, ... {
    va_list vargs;
    va_start(vargs, fmt);
    
    NSString *str = [[[NSString alloc] initWithFormat:fmt arguments:vargs] autorelease];
    [self appendString:str];
    
    va_end(vargs);
}

@end
