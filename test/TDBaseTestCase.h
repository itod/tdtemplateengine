//
//  TDBaseTestCase.h
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 6/4/25.
//  Copyright © 2025 Todd Ditchendorf. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <TDTemplateEngine/TDTemplateEngine.h>
//#import <OCMock/OCMock.h>
#import <TDTemplateEngine/TDTemplateContext.h>
#import <TDTemplateEngine/TDTemplateException.h>
#import "TDTemplateEngine+ParserSupport.h"

#define TDTrue(e) XCTAssertTrue((e), @"")
#define TDFalse(e) XCTAssertFalse((e), @"")
#define TDNil(e) XCTAssertNil((e), @"")
#define TDNotNil(e) XCTAssertNotNil((e), @"")
#define TDEquals(e1, e2) XCTAssertEqual((e1), (e2), @"")
#define TDEqualObjects(e1, e2) XCTAssertEqualObjects((e1), (e2), @"")

//#define VERIFY()     @try { [_mock verify]; } @catch (NSException *ex) { NSString *msg = [ex reason]; XCTAssertTrue(0, @"%@", msg); }


@interface TDBaseTestCase : XCTestCase

- (BOOL)processTemplateFile:(NSString *)path encoding:(NSStringEncoding)enc withVariables:(NSDictionary *)vars toStream:(NSOutputStream *)output error:(NSError **)err;
- (BOOL)processTemplateString:(NSString *)str withVariables:(NSDictionary *)vars toStream:(NSOutputStream *)output error:(NSError **)outError;

@property (nonatomic, retain) TDTemplateEngine *engine;

@end
