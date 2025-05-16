//
//  TDExtendsTests.m
//  TDTemplateEngineTests
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDTestScaffold.h"

@interface TDTemplateEngine ()
- (TDTemplate *)_cachedTemplateForPath:(NSString *)path;
- (void)_setCachedTemplate:(TDTemplate *)tmpl forPath:(NSString *)path;
- (TDTemplate *)_templateFromString:(NSString *)str filePath:(NSString *)path error:(NSError **)err;
@end

@interface TDExtendsTests : XCTestCase
@property (nonatomic, retain) TDTemplateEngine *engine;
@property (nonatomic, retain) NSOutputStream *output;
@end

@implementation TDExtendsTests

- (void)setUp {
    [super setUp];
    
    self.engine = [TDTemplateEngine templateEngine];
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
    NSString *childStr = @"{% extends 'parent.html' %}\n{% block body %}bar{% endblock %}";
    NSString *enkelStr = @"{% extends 'child.html' %}\n{% block head %}foo{% endblock %}";

    NSError *err = nil;
    
    TDTemplate *parent = [_engine _templateFromString:parentStr filePath:nil error:&err];
    XCTAssert(parent);
    XCTAssertNil(err);
    [_engine _setCachedTemplate:parent forPath:@"parent.html"];

    TDTemplate *child = [_engine _templateFromString:childStr filePath:nil error:&err];
    XCTAssert(child);
    XCTAssertNil(err);
    [_engine _setCachedTemplate:child forPath:@"child.html"];

    TDTemplate *enkel = [_engine _templateFromString:enkelStr filePath:nil error:&err];
    XCTAssert(enkel);
    XCTAssertNil(err);
    [_engine _setCachedTemplate:enkel forPath:@"enkel.html"];
    
    id vars = nil;
    BOOL success = [enkel render:vars toStream:_output error:&err];
    XCTAssertTrue(success);
    XCTAssertNil(err);

    NSString *res = [self outputString];
    TDEqualObjects(@"<html><head>foo</head><body>bar</body></html>", res);
}

@end
