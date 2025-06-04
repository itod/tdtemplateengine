//
//  TDPadFilterTests.m
//  TDTemplateEngineTests
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDBaseTestCase.h"

@interface TDPadFilterTests : TDBaseTestCase

@end

@implementation TDPadFilterTests

- (void)testLpadSpace {
    NSString *input = @"{{foo|lpad:' '}}";
    id vars = @{@"foo": @"bar"};
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@" bar", res);
}

- (void)testLpadSpaceEmpty {
    NSString *input = @"{{foo|lpad:' '}}";
    id vars = @{@"foo": @""};
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@"", res);
}

- (void)testRpadSpace {
    NSString *input = @"{{foo|rpad:' '}}";
    id vars = @{@"foo": @"bar"};
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@"bar ", res);
}

- (void)testRpadSpaceEmpty {
    NSString *input = @"{{foo|rpad:' '}}";
    id vars = @{@"foo": @""};
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@"", res);
}

- (void)testLpadSpace0 {
    NSString *input = @"{{foo|lpad:' ',0}}";
    id vars = @{@"foo": @"bar"};
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@" bar", res);
}

- (void)testLpadSpace0Empty {
    NSString *input = @"{{foo|lpad:' ',0}}";
    id vars = @{@"foo": @""};
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@"", res);
}

- (void)testLpadSpace8 {
    NSString *input = @"{{foo|lpad:' ',8}}";
    id vars = @{@"foo": @"bar"};
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@"     bar", res);
}

- (void)testLpadSpace8Empty {
    NSString *input = @"{{foo|lpad:' ',8}}";
    id vars = @{@"foo": @""};
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@"        ", res);
}

- (void)testRpadSpace0 {
    NSString *input = @"{{foo|rpad:' ',0}}";
    id vars = @{@"foo": @"bar"};
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@"bar ", res);
}

- (void)testRpadSpace0Empty {
    NSString *input = @"{{foo|rpad:' ',0}}";
    id vars = @{@"foo": @""};
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@"", res);
}

- (void)testRpadSpace8 {
    NSString *input = @"{{foo|rpad:' ',8}}";
    id vars = @{@"foo": @"bar"};
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@"bar     ", res);
}

- (void)testRpadSpace8Empty {
    NSString *input = @"{{foo|rpad:' ',8}}";
    id vars = @{@"foo": @""};
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@"        ", res);
}

@end
