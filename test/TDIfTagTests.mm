//
//  TDIfTagTests.m
//  TDTemplateEngineTests
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDBaseTestCase.h"

@interface TDIfTagTests : TDBaseTestCase

@end

@implementation TDIfTagTests

- (void)testIf1Var {
    NSString *input = @"{% if 1 %}{{foo}}{% endif %}";
    id vars = @{@"foo": @"bar"};
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@"bar", res);
}

- (void)testIf0Var {
    NSString *input = @"{% if 0 %}{{foo}}{% endif %}";
    id vars = @{@"foo": @"bar"};
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@"", res);
}

- (void)testIf1FooIf0Baz {
    NSString *input = @"{% if 1 %}{{foo}}{% endif %}{% if 0 %}{{baz}}{% endif %}";
    id vars = @{@"foo": @"bar", @"baz": @"bat"};
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@"bar", res);
}

- (void)testIf1FooIf1Baz {
    NSString *input = @"{% if 1 %}{{foo}}{% endif %}{% if 1 %}{{baz}}{% endif %}";
    id vars = @{@"foo": @"bar", @"baz": @"bat"};
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@"barbat", res);
}

- (void)testIf0FooIf1Baz {
    NSString *input = @"{% if 0 %}{{foo}}{% endif %}{% if 1 %}{{baz}}{% endif %}";
    id vars = @{@"foo": @"bar", @"baz": @"bat"};
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@"bat", res);
}

- (void)testNestedIf1 {
    NSString *input = @"{% if 1 %}{% if 1 %}foo{% endif %}{% endif %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@"foo", res);
}

- (void)testNestedIf2 {
    NSString *input = @"{% if 1 %}{% if 0 %}foo{% endif %}{% endif %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@"", res);
}

- (void)testNestedIf3 {
    NSString *input = @"{% if 0 %}{% if 0 %}foo{% endif %}{% endif %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@"", res);
}

- (void)testNestedIf4 {
    NSString *input = @"{% if 0 %}{% if 1 %}foo{% endif %}{% endif %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@"", res);
}

- (void)testIf1 {
    NSString *input = @"{% if 1 %} text {% endif %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@" text ", res);
}

- (void)testIf0 {
    NSString *input = @"{% if 0 %} text {% endif %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@"", res);
}

- (void)testIfTrue {
    NSString *input = @"{% if True %} text {% endif %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@" text ", res);
}

- (void)testIfFalse {
    NSString *input = @"{% if False %} text {% endif %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@"", res);
}

- (void)testIfOpenTrueClose {
    NSString *input = @"{% if (True) %} text {% endif %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@" text ", res);
}

- (void)testIfOpenFalseClose {
    NSString *input = @"{% if (False) %} text {% endif %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@"", res);
}

- (void)testIfSQString {
    NSString *input = @"{% if 'hello' %} text {% endif %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@" text ", res);
}

- (void)testIfEmptySQString {
    NSString *input = @"{% if '' %} text {% endif %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@"", res);
}

- (void)testIf1Eq1 {
    NSString *input = @"{% if 1 eq 1 %} text {% endif %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@" text ", res);
}

- (void)testIf1EqSign1 {
    NSString *input = @"{% if 1 = 1 %} text {% endif %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertFalse(success);
    XCTAssertNotNil(err);
}

- (void)testIf1EqEqSign1 {
    NSString *input = @"{% if 1 == 1 %} text {% endif %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@" text ", res);
}

- (void)testIf1Eq2 {
    NSString *input = @"{% if 1 eq 2 %} text {% endif %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@"", res);
}

- (void)testIf1EqSign2 {
    NSString *input = @"{% if 1 = 2 %} text {% endif %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertFalse(success);
    XCTAssertNotNil(err);
}

- (void)testIf1EqEqSign2 {
    NSString *input = @"{% if 1 == 2 %} text {% endif %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@"", res);
}

- (void)testIf1Ne1 {
    NSString *input = @"{% if 1 ne 1 %} text {% endif %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@"", res);
}

- (void)testIf1NeSign1 {
    NSString *input = @"{% if 1 != 1 %} text {% endif %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@"", res);
}

- (void)testIf1Ne2 {
    NSString *input = @"{% if 1 ne 2 %} text {% endif %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@" text ", res);
}

- (void)testIf1NeSign2 {
    NSString *input = @"{% if 1 != 2 %} text {% endif %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@" text ", res);
}

- (void)testIf1Lt1 {
    NSString *input = @"{% if 1 < 1 %} text {% endif %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@"", res);
}

- (void)testIf1LtEq1 {
    NSString *input = @"{% if 1 <= 1 %} text {% endif %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@" text ", res);
}

- (void)testIf1Lt2 {
    NSString *input = @"{% if 1 < 2 %} text {% endif %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@" text ", res);
}

- (void)testIf1LtEq2 {
    NSString *input = @"{% if 1 <= 2 %} text {% endif %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@" text ", res);
}

- (void)testIf1Gt1 {
    NSString *input = @"{% if 1 > 1 %} text {% endif %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@"", res);
}

- (void)testIf1GtEq1 {
    NSString *input = @"{% if 1 >= 1 %} text {% endif %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@" text ", res);
}

- (void)testIf1Gt2 {
    NSString *input = @"{% if 1 > 2 %} text {% endif %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@"", res);
}

- (void)testIf1GtEq2 {
    NSString *input = @"{% if 1 >= 2 %} text {% endif %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@"", res);
}

- (void)testIf1And0 {
    NSString *input = @"{% if 1 and 0 %} text {% endif %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@"", res);
}

- (void)testIf0And1 {
    NSString *input = @"{% if 0 and 1 %} text {% endif %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@"", res);
}

- (void)testIf1And1 {
    NSString *input = @"{% if 1 and 1 %} text {% endif %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@" text ", res);
}

- (void)testIf1Or0 {
    NSString *input = @"{% if 1 or 0 %} text {% endif %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@" text ", res);
}

- (void)testIf0Or1 {
    NSString *input = @"{% if 0 or 1 %} text {% endif %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@" text ", res);
}

- (void)testIf1Or1 {
    NSString *input = @"{% if 1 or 1 %} text {% endif %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@" text ", res);
}

- (void)testIf1SpacePlusSpace2 {
    NSString *input = @"{% if 1 + 2 %} text {% endif %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@" text ", res);
}

- (void)testIf1Plus2 {
    NSString *input = @"{% if 1+2 %} text {% endif %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@" text ", res);
}

- (void)testIf1SpaceMinusSpace1 {
    NSString *input = @"{% if 1 - 1 %} text {% endif %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@"", res);
}

- (void)testIfFooIsBar1 {
    NSString *input = @"{% if foo is bar %}1{% else %}0{% endif %}";
    NSString *s = @"baz";
    id vars = @{
        @"foo": s,
        @"bar": s,
    };
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@"1", res);
}

- (void)testIfFooIsBar0 {
    NSString *input = @"{% if foo is bar %}1{% else %}0{% endif %}";
    id vars = @{
        @"foo": @"foo",
        @"bar": @"bar",
    };
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@"0", res);
}

- (void)testIfFooIsNotBar0 {
    NSString *input = @"{% if foo is not bar %}1{% else %}0{% endif %}";
    NSString *s = @"baz";
    id vars = @{
        @"foo": s,
        @"bar": s,
    };
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@"0", res);
}

- (void)testIfFooIsNotBar1 {
    NSString *input = @"{% if foo is not bar %}1{% else %}0{% endif %}";
    id vars = @{
        @"foo": @"foo",
        @"bar": @"bar",
    };
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);
    NSString *res = [self outputString];
    XCTAssertEqualObjects(@"1", res);
}

@end
