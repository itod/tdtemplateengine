//
//  TDIndentTagTests.m
//  TDTemplateEngineTests
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDBaseTestCase.h"

@interface TDIndentTagTests : TDBaseTestCase

@end

@implementation TDIndentTagTests

- (void)testTrimF {
    NSString *input =
    @"{% trim %}\n"
    @"    {% indent %}\n"
    @"f\n"
    @"    {% endindent %}"
    @"{% endtrim %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"    f\n", res);
}

- (void)testTrimF2 {
    NSString *input =
    @"{% trim %}\n"
    @"    {% indent %}\n"
    @"f\n"
    @"    f\n"
    @"f\n"
    @"    {% endindent %}"
    @"{% endtrim %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"    f\n    f\n    f\n", res);
}

- (void)testTrimF2Times {
    NSString *input =
    @"{% trim %}\n"
    @"    {% indent 2 %}\n"
    @"f\n"
    @"    f\n"
    @"f\n"
    @"    {% endindent %}"
    @"{% endtrim %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [self processTemplateString:input withVariables:vars toStream:self.output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"        f\n        f\n        f\n", res);
}

@end
