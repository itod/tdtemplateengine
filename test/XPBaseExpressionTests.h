//
//  XPBaseExpressionTests.m
//  TDTemplateEngineTests
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDTestScaffold.h"
#import "XPExpression.h"
#import "XPParser.h"

@interface XPBaseExpressionTests : XCTestCase
- (NSArray *)tokenize:(NSString *)input;

@property (nonatomic, retain) TDTemplateEngine *eng;
@property (nonatomic, retain) XPExpression *expr;
@property (nonatomic, retain) PKTokenizer *t;
@end