//
//  CPPUnaryExpressionTests.m
//  TDTemplateEngineTests
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDBaseExpressionTests.h"
#import "ExpressionParser.hpp"

using namespace parsekit;
using namespace templateengine;

@interface CPPUnaryExpressionTests : TDBaseExpressionTests
@property (nonatomic, retain) NSOutputStream *output;
@end

@implementation CPPUnaryExpressionTests

- (void)setUp {
    [super setUp];
    
    self.output = [NSOutputStream outputStreamToMemory];
}

- (void)tearDown {
    self.output = nil;
    
    [super tearDown];
}

- (NSString *)outputString {
    NSString *str = [[[NSString alloc] initWithData:[_output propertyForKey:NSStreamDataWrittenToMemoryStreamKey] encoding:NSUTF8StringEncoding] autorelease];
    return str;
}

- (void)testNeg1 {
    std::string input = "-1";
    
    ExpressionParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parse(&r);
    XCTAssertNotNil(expr);
    XCTAssertEqual(-1, [[expr simplify] evaluateAsNumberInContext:nil]);

}

- (void)testNegNeg1 {
    std::string input = "--1";
    
    ExpressionParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parse(&r);
    XCTAssertNotNil(expr);
    XCTAssertEqual(1, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)testNegNegNeg1 {
    std::string input = "---1";
    
    ExpressionParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parse(&r);
    XCTAssertNotNil(expr);
    XCTAssertEqual(-1, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)testNegNegNegNeg1 {
    std::string input = "----1";
    
    ExpressionParser p;
    ReaderCPP r(input);
    TDExpression *expr = p.parse(&r);
    XCTAssertNotNil(expr);
    XCTAssertEqual(1, [[expr simplify] evaluateAsNumberInContext:nil]);
}

//- (void)testNegVar {
//    NSString *input = @"{{-foo}}";
//    id vars = @{@"foo": @1};
//    
//    NSError *err = nil;
//    BOOL success = [self.eng processTemplateString:input withVariables:vars toStream:_output error:&err];
//    XCTAssertTrue(success);
//    XCTAssertNil(err);
//    NSString *res = [self outputString];
//    XCTAssertEqualObjects(@"-1", res);
//}
//
//- (void)testNegNegVar {
//    NSString *input = @"{{--foo}}";
//    id vars = @{@"foo": @1};
//    
//    NSError *err = nil;
//    BOOL success = [self.eng processTemplateString:input withVariables:vars toStream:_output error:&err];
//    XCTAssertTrue(success);
//    XCTAssertNil(err);
//    NSString *res = [self outputString];
//    XCTAssertEqualObjects(@"1", res);
//}
//
//- (void)testNegNegNegVar {
//    NSString *input = @"{{---foo}}";
//    id vars = @{@"foo": @1};
//    
//    NSError *err = nil;
//    BOOL success = [self.eng processTemplateString:input withVariables:vars toStream:_output error:&err];
//    XCTAssertTrue(success);
//    XCTAssertNil(err);
//    NSString *res = [self outputString];
//    XCTAssertEqualObjects(@"-1", res);
//}
//
//- (void)testNegNegNegNegVar {
//    NSString *input = @"{{----foo}}";
//    id vars = @{@"foo": @1};
//    
//    NSError *err = nil;
//    BOOL success = [self.eng processTemplateString:input withVariables:vars toStream:_output error:&err];
//    XCTAssertTrue(success);
//    XCTAssertNil(err);
//    NSString *res = [self outputString];
//    XCTAssertEqualObjects(@"1", res);
//}

@end
