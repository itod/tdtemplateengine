//
//  TDExtendsTests.m
//  TDTemplateEngineTests
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDBaseTestCase.h"

@interface TDTemplateEngine ()
- (TDTemplate *)_cachedTemplateForFilePath:(NSString *)path;
- (void)_setCachedTemplate:(TDTemplate *)tmpl forFilePath:(NSString *)path;
- (TDTemplate *)_templateFromString:(NSString *)str filePath:(NSString *)path context:(TDTemplateContext *)ctx;
@end

@interface TDExtendsTests : TDBaseTestCase

@end

@implementation TDExtendsTests

- (void)testInheritance {
    self.engine.cacheTemplates = YES;
    //return;
    NSString *parentStr = @"<html><head>{% block head %}{% endblock %}</head><body>{% block body %}{% endblock %}</body></html>";
    NSString *cousinStr = @"baz";
    NSString *childStr  = @"{% extends 'parent.html' %}\n{% block body %}bar {% include 'cousin.html' %}{% endblock %}";
    NSString *enkelStr  = @"{% extends 'child.html' %}\n{% block head %}foo{% endblock %}";

    NSString *path = @"parent.html";
    TDTemplate *parent = [self.engine _templateFromString:parentStr filePath:path context:nil];
    XCTAssert(parent);
    [self.engine _setCachedTemplate:parent forFilePath:path];
    
    path = @"cousin.html";
    TDTemplate *cousin = [self.engine _templateFromString:cousinStr filePath:path context:nil];
    XCTAssert(cousin);
    [self.engine _setCachedTemplate:cousin forFilePath:path];

    path = @"child.html";
    TDTemplate *child = [self.engine _templateFromString:childStr filePath:path context:nil];
    XCTAssert(child);
    [self.engine _setCachedTemplate:child forFilePath:path];

    path = @"enkel.html";
    TDTemplate *enkel = [self.engine _templateFromString:enkelStr filePath:path context:nil];
    XCTAssert(enkel);
    [self.engine _setCachedTemplate:enkel forFilePath:path];
    
    id vars = nil;
    NSError *err = nil;
    BOOL success = [enkel render:vars toStream:self.output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);

    NSString *res = [self outputString];
    TDEqualObjects(@"<html><head>foo</head><body>bar baz</body></html>", res);
}

@end
