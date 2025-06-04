//
//  TDBaseTestCase.h
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 6/4/25.
//  Copyright © 2025 Todd Ditchendorf. All rights reserved.
//

#import <XCTest/XCTest.h>
//#import <OCMock/OCMock.h>
#import <TDTemplateEngine/TDTemplateEngine.h>
#import <TDTemplateEngine/TDTemplateContext.h>
#import <TDTemplateEngine/TDTemplateException.h>
#import "TDTemplateEngine+ParserSupport.h"

//#define VERIFY()     @try { [_mock verify]; } @catch (NSException *ex) { NSString *msg = [ex reason]; XCTAssertTrue(0, @"%@", msg); }

@interface TDBaseTestCase : XCTestCase

- (BOOL)processTemplateFile:(NSString *)path encoding:(NSStringEncoding)enc withVariables:(NSDictionary *)vars toStream:(NSOutputStream *)output error:(NSError **)err;
- (BOOL)processTemplateString:(NSString *)str withVariables:(NSDictionary *)vars toStream:(NSOutputStream *)output error:(NSError **)outError;

- (NSString *)outputString;

@property (nonatomic, retain) TDTemplateEngine *engine;
@property (nonatomic, retain) NSOutputStream *output;
@end
