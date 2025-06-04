//
//  TDCommentTagTests.m
//  TDTemplateEngineTests
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDBaseTestCase.h"

@interface TDCommentTagTests : TDBaseTestCase

@end

@implementation TDCommentTagTests

- (void)testCommentF {
    NSString *input = @"{% comment %}f{% endcomment %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@"", res);
}

- (void)testCommentMixedContent1 {
    NSString *input = @"foo {% comment %}bar {% endcomment %} baz.";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@"foo  baz.", res);
}

- (void)testCommentMixedContent2 {
    NSString *input = @"foo {% comment %}bar {% endcomment %}baz.";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@"foo baz.", res);
}

- (void)testCommentMixedContent3 {
    NSString *input = @"foo{% comment %}bar {% endcomment %}baz.";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@"foobaz.", res);
}

- (void)testCommentMixedContent4 {
    NSString *input = @"foo{% comment %}bar{% endcomment %}baz.";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@"foobaz.", res);
}

- (void)testCommentMixedContent5 {
    NSString *input = @"foo{% comment %}bar{% endcomment %}baz{% comment %}bat{% endcomment %}.";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@"foobaz.", res);
}

@end
