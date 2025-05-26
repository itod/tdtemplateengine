//
//  TDExtendsTests.m
//  TDTemplateEngineTests
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDTestScaffold.h"

@interface TDTemplateEngine ()
- (TDTemplate *)_cachedTemplateForFilePath:(NSString *)path;
- (void)_setCachedTemplate:(TDTemplate *)tmpl forFilePath:(NSString *)path;
- (TDTemplate *)_templateFromString:(NSString *)str filePath:(NSString *)path context:(TDTemplateContext *)ctx;
@end

@interface TDExtendsTests : XCTestCase
@property (nonatomic, retain) TDTemplateEngine *engine;
@property (nonatomic, retain) NSOutputStream *output;
@end

@implementation TDExtendsTests

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

- (void)testInheritance {
    _engine.cacheTemplates = YES;
    //return;
    NSString *parentStr = @"<html><head>{% block head %}{% endblock %}</head><body>{% block body %}{% endblock %}</body></html>";
    NSString *cousinStr = @"baz";
    NSString *childStr  = @"{% extends 'parent.html' %}\n{% block body %}bar {% include 'cousin.html' %}{% endblock %}";
    NSString *enkelStr  = @"{% extends 'child.html' %}\n{% block head %}foo{% endblock %}";

    NSString *path = @"parent.html";
    TDTemplate *parent = [_engine _templateFromString:parentStr filePath:path context:nil];
    XCTAssert(parent);
    [_engine _setCachedTemplate:parent forFilePath:path];
    
    path = @"cousin.html";
    TDTemplate *cousin = [_engine _templateFromString:cousinStr filePath:path context:nil];
    XCTAssert(cousin);
    [_engine _setCachedTemplate:cousin forFilePath:path];

    path = @"child.html";
    TDTemplate *child = [_engine _templateFromString:childStr filePath:path context:nil];
    XCTAssert(child);
    [_engine _setCachedTemplate:child forFilePath:path];

    path = @"enkel.html";
    TDTemplate *enkel = [_engine _templateFromString:enkelStr filePath:path context:nil];
    XCTAssert(enkel);
    [_engine _setCachedTemplate:enkel forFilePath:path];
    
    id vars = nil;
    NSError *err = nil;
    BOOL success = [enkel render:vars toStream:_output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);

    NSString *res = [self outputString];
    TDEqualObjects(@"<html><head>foo</head><body>bar baz</body></html>", res);
}

@end
