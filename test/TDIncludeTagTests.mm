//
//  TDIncludeTagTests.m
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

@interface TDIncludeTagTests : TDBaseExpressionTests
@end

@implementation TDIncludeTagTests

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
    TDTemplateContext *ctx = [[[TDTemplateContext alloc] initWithVariables:vars output:nil] autorelease];
    ctx.delegate = self.eng;
    
    TDIncludeTag *tag = (id)[self.eng tagFromReader:&reader withParent:nil inContext:ctx];

    XCTAssertNotNil(tag);
    
    NSString *outPath = [tag.expression evaluateAsStringInContext:ctx];
    XCTAssertEqualObjects(inPath, outPath);

    XCTAssertNil(tag.kwargs);
}

- (void)testIncludeVariableWithArgs {
    NSString *inPath = @"path/to/file.html";
    NSString *input = @"include my_path with a=1 b='foo' c=bar";
    ReaderObjC reader(input);
    
    id vars = @{@"my_path": inPath, @"bar": @"baz"};
    id ctx = [[[TDTemplateContext alloc] initWithVariables:vars output:nil] autorelease];
    
    NSError *err = nil;
    TDIncludeTag *tag = (id)[self.eng tagFromReader:&reader withParent:nil inContext:ctx];

    XCTAssertNil(err);
    XCTAssertNotNil(tag);
    
    NSString *outPath = [tag.expression evaluateAsStringInContext:ctx];
    XCTAssertEqualObjects(inPath, outPath);

    XCTAssertNotNil(tag.kwargs);
    XCTAssertEqualWithAccuracy(1.0, [[tag.kwargs objectForKey:@"a"] evaluateAsNumberInContext:ctx], 0.001);
    TDEqualObjects(@"foo", [[tag.kwargs objectForKey:@"b"] evaluateAsStringInContext:ctx]);
    TDEqualObjects(@"baz", [[tag.kwargs objectForKey:@"c"] evaluateAsStringInContext:ctx]);
}

@end
