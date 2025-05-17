//
//  CPPIncludeExpressionTests.m
//  TDTemplateEngineTests
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDBaseExpressionTests.h"
#import "TDTemplateEngine+ParserSupport.h"
#import <TDTemplateEngine/TDIncludeTag.h>
#import <ParseKitCPP/Reader.hpp>

using namespace parsekit;

@interface CPPIncludeExpressionTests : TDBaseExpressionTests
@end

@implementation CPPIncludeExpressionTests

- (void)setUp {
    [super setUp];
    
}

- (void)tearDown {
    
    [super tearDown];
}

- (void)testIncludeStringLiteral {
    NSString *inPath = @"foo/bar.html";
    NSString *input = [NSString stringWithFormat:@"include '%@'", inPath];
    ReaderObjC reader(input);
    
    id vars = @{};
    id ctx = [[[TDTemplateContext alloc] initWithVariables:vars output:nil] autorelease];
    
    NSError *err = nil;
    TDIncludeTag *tag = (id)[self.eng tagFromReader:&reader withParent:nil inContext:ctx];

    XCTAssertNil(err);
    XCTAssertNotNil(tag);
    
    NSString *outPath = [tag.expression evaluateAsStringInContext:ctx];
    XCTAssertEqualObjects(inPath, outPath);

    XCTAssertNil(tag.kwargs);
    //TDEqualObjects(@"bar", [expr evaluateAsStringInContext:ctx]);
}

@end
