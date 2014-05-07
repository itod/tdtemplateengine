//
//  TDBaseExpressionTests.m
//  TDTemplateEngineTests
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDTestScaffold.h"
#import "TDExpression.h"
#import "TDParser.h"

@interface TDBaseExpressionTests : XCTestCase
- (NSArray *)tokenize:(NSString *)input;

@property (nonatomic, retain) TDTemplateEngine *eng;
@property (nonatomic, retain) TDExpression *expr;
@property (nonatomic, retain) PKTokenizer *t;
@end