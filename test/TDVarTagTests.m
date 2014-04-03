//
//  TDVarTagTests.m
//  TDTemplateEngineTests
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDTestScaffold.h"

@interface TDVarTagTests : XCTestCase
@property (nonatomic, retain) TDTemplateEngine *engine;
@property (nonatomic, retain) NSOutputStream *output;
@end

@implementation TDVarTagTests

- (void)setUp {
    [super setUp];
    
    self.engine = [TDTemplateEngine templateEngine];
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

- (void)testSimpleVarReplacementFoo {
    NSString *input = @"{{foo}}";
    id vars = @{@"foo": @"bar"};
    
    NSError *err = nil;
    BOOL success = [_engine processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"bar", res);
}

- (void)testSimpleVarReplacementBar {
    NSString *input = @"{{bar}}";
    id vars = @{@"bar": @"foo"};
    
    NSError *err = nil;
    BOOL success = [_engine processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"foo", res);
}

- (void)testStaticContext {
    NSString *input = @"{{baz}}";
    id vars = @{@"bar": @"foo"};
    
    [_engine.staticContext defineVariable:@"baz" withValue:@"bat"];
    NSError *err = nil;
    BOOL success = [_engine processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"bat", res);
}

- (void)testStaticContextShadow {
    NSString *input = @"{{baz}}";
    id vars = @{@"baz": @"foo"};
    
    [_engine.staticContext defineVariable:@"baz" withValue:@"bat"];
    NSError *err = nil;
    BOOL success = [_engine processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"foo", res);
}

- (void)testSimpleVarReplacementOneTextTwo {
    NSString *input = @"{{one}} text {{two}}";
    id vars = @{@"one": @"1", @"two": @"2"};
    
    NSError *err = nil;
    BOOL success = [_engine processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"1 text 2", res);
}

@end