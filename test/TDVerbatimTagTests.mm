//
//  TDVerbatimTagTests.m
//  TDTemplateEngineTests
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDBaseTestCase.h"

@interface TDVerbatimTagTests : TDBaseTestCase

@end

@implementation TDVerbatimTagTests

- (void)testVerbatimF {
    NSString *input = @"{% verbatim %}f{% endverbatim %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@"f", res);
}

- (void)testVerbatimNestedVar {
    NSString *input = @"{% verbatim %}{{foo}}{% endverbatim %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@"{{foo}}", res);
}

- (void)testVerbatimNestedVarSpace {
    NSString *input = @"{% verbatim %}{{ foo }}{% endverbatim %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@"{{ foo }}", res);
}

- (void)testVerbatimNestedIfTagSpace {
    NSString *input = @"{% verbatim %}{% if 1 %}HI!{% endif %}{% endverbatim %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@"{% if 1 %}HI!{% endif %}", res);
}

- (void)testVerbatimNestedIfTag {
    NSString *input = @"{% verbatim %}{%if 1%}HI!{%endif%}{% endverbatim %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@"{%if 1%}HI!{%endif%}", res);
}

@end
