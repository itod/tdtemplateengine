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
@end

@implementation TDVarTagTests

- (void)setUp {
    [super setUp];
    
    self.engine = [TDTemplateEngine templateEngine];
}

- (void)tearDown {
    self.engine = nil;
    
    [super tearDown];
}

- (void)testSimpleVarReplacementFoo {
    NSString *input = @"{{foo}}";
    id vars = @{@"foo": @"bar"};
    
    NSError *err = nil;
    NSString *res = [_engine processTemplateString:input withVariables:vars error:&err];
    TDNotNil(res);
    TDNil(err);
    TDEqualObjects(@"bar", res);
}

- (void)testSimpleVarReplacementBar {
    NSString *input = @"{{bar}}";
    id vars = @{@"bar": @"foo"};
    
    NSError *err = nil;
    NSString *res = [_engine processTemplateString:input withVariables:vars error:&err];
    TDNotNil(res);
    TDNil(err);
    TDEqualObjects(@"foo", res);
}

- (void)testStaticContext {
    NSString *input = @"{{baz}}";
    id vars = @{@"bar": @"foo"};
    
    [_engine.staticContext defineVariable:@"baz" withValue:@"bat"];
    NSError *err = nil;
    NSString *res = [_engine processTemplateString:input withVariables:vars error:&err];
    TDNotNil(res);
    TDNil(err);
    TDEqualObjects(@"bat", res);
}

- (void)testStaticContextShadow {
    NSString *input = @"{{baz}}";
    id vars = @{@"baz": @"foo"};
    
    [_engine.staticContext defineVariable:@"baz" withValue:@"bat"];
    NSError *err = nil;
    NSString *res = [_engine processTemplateString:input withVariables:vars error:&err];
    TDNotNil(res);
    TDNil(err);
    TDEqualObjects(@"foo", res);
}

- (void)testSimpleVarReplacementOneTextTwo {
    NSString *input = @"{{one}} text {{two}}";
    id vars = @{@"one": @"1", @"two": @"2"};
    
    NSError *err = nil;
    NSString *res = [_engine processTemplateString:input withVariables:vars error:&err];
    TDNotNil(res);
    TDNil(err);
    TDEqualObjects(@"1 text 2", res);
}

@end
