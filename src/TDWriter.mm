//
//  TDWriter.m
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 4/2/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import <TDTemplateEngine/TDWriter.h>
#import <TDTemplateEngine/TDTemplateEngine.h>

#define USE_GET_BYTES 1

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


- (void)appendString:(NSString *)str {
    TDAssert(_output);
    TDAssert(str);
        
#if USE_GET_BYTES
    NSStringEncoding enc = NSUTF8StringEncoding;
    NSUInteger maxLen = [str maximumLengthOfBytesUsingEncoding:enc];
    if (maxLen) {
        NSUInteger len;
        char bytes[maxLen+1]; // +1 for null-term
        if (![str getBytes:bytes maxLength:maxLen usedLength:&len encoding:enc options:0 range:NSMakeRange(0, str.length) remainingRange:NULL]) {
            TDAssert(0);
            TDAssert(len <= maxLen);
        }
        // make it null-terminated bc -getBytes: does not include terminator
        bytes[len] = '\0';
        const uint8_t *zstr = (const uint8_t *)bytes;
#else
    const uint8_t *zstr = (const uint8_t *)[str UTF8String];
    size_t len = strlen((const char *)zstr);
    if (len) {
#endif
        NSUInteger remaining = len;
        do {
            NSInteger trim = remaining - len;
            if (trim > 0) {
                zstr += trim;
            }
            NSInteger written = [_output write:zstr maxLength:len];
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
