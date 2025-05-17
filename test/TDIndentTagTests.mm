//
//  TDIndentTagTests.m
//  TDTemplateEngineTests
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDTestScaffold.h"

@interface TDIndentTagTests : XCTestCase
@property (nonatomic, retain) TDTemplateEngine *engine;
@property (nonatomic, retain) NSOutputStream *output;
@end

@implementation TDIndentTagTests

- (void)setUp {
    [super setUp];
    
    self.engine = [[TDTemplateEngine new] autorelease];
    self.output = [NSOutputStream outputStreamToMemory];
}

- (void)tearDown {
    self.engine = nil;
    self.output = nil;
    
    [super tearDown];
}

- (NSString *)outputString {
    NSString *str = [[[NSString alloc] initWithData:[_output propertyForKey:NSStreamDataWrittenToMemoryStreamKey] encoding:NSUTF8StringEncoding] autorelease];
    return str;
}

- (void)testTrimF {
    NSString *input =
    @"{% trim %}\n"
    @"    {% indent %}\n"
    @"f\n"
    @"    {% endindent %}"
    @"{% endtrim %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [_engine processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"    f\n", res);
}

- (void)testTrimF2 {
    NSString *input =
    @"{% trim %}\n"
    @"    {% indent %}\n"
    @"f\n"
    @"    f\n"
    @"f\n"
    @"    {% endindent %}"
    @"{% endtrim %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [_engine processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"    f\n    f\n    f\n", res);
}

- (void)testTrimF2Times {
    NSString *input =
    @"{% trim %}\n"
    @"    {% indent 2 %}\n"
    @"f\n"
    @"    f\n"
    @"f\n"
    @"    {% endindent %}"
    @"{% endtrim %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [_engine processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"        f\n        f\n        f\n", res);
}

@end
