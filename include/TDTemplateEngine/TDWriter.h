//
//  TDWriter.h
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 4/2/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDWriter : NSObject

+ (instancetype)writerWithOutputStream:(NSOutputStream *)output;
- (instancetype)initWithOutputStream:(NSOutputStream *)output;

@property (nonatomic, retain) NSOutputStream *output;

- (void)appendObject:(id)obj;
- (void)appendString:(NSString *)str;
- (void)appendFormat:(NSString *)fmt, ... NS_FORMAT_FUNCTION(1,2);

@end
