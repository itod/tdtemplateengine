//
//  TDTrimTagTests.m
//  TDTemplateEngineTests
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDTestScaffold.h"

@interface TDTrimTagTests : XCTestCase
@property (nonatomic, retain) TDTemplateEngine *engine;
@property (nonatomic, retain) NSOutputStream *output;
@end

@implementation TDTrimTagTests

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

- (void)testTrimF {
    NSString *input =
    @"{% trim %}\n"
    @"f\n"
    @"{% endtrim %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [_engine processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"f\n", res);
}

- (void)testTrimFSpace {
    NSString *input =
    @"{% trim %}\n"
    @"    f    \n"
    @"{% endtrim %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [_engine processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"f\n", res);
}

- (void)testTrimNestedVar {
    NSString *input =
    @"{% trim %}\n"
    @"{{foo}}\n"
    @"{% endtrim %}";
    id vars = @{@"foo": @"bar"};
    
    NSError *err = nil;
    BOOL success = [_engine processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"bar\n", res);
}

- (void)testTrimNestedVarSpace {
    NSString *input =
    @"{% trim %}\n"
    @"  {{foo}}\n"
    @"{% endtrim %}";
    id vars = @{@"foo": @"bar"};
    
    NSError *err = nil;
    BOOL success = [_engine processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"bar\n", res);
}

- (void)testTrimNestedVarsSpace {
    NSString *input =
    @"{% trim %}\n"
    @"  {{foo}}\n"
    @"  {{foo}}\n"
    @"{% endtrim %}";
    id vars = @{@"foo": @"bar"};
    
    NSError *err = nil;
    BOOL success = [_engine processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"bar\nbar\n", res);
}

- (void)testTrimNestedVarsSpaceLines {
    NSString *input =
    @"{% trim %}\n"
    @"  {{foo}}\n"
    @"  \n"
    @"  {{foo}}\n"
    @"{% endtrim %}";
    id vars = @{@"foo": @"bar"};
    
    NSError *err = nil;
    BOOL success = [_engine processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"bar\n\nbar\n", res);
}

- (void)testTrimNestedVarsSpace2Lines {
    NSString *input =
    @"{% trim %}\n"
    @"  {{foo}}\n"
    @"  \n"
    @"  \n"
    @"  {{foo}}\n"
    @"{% endtrim %}";
    id vars = @{@"foo": @"bar"};
    
    NSError *err = nil;
    BOOL success = [_engine processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"bar\n\n\nbar\n", res);
}

- (void)testTrimNestedVarSpacesSemi {
    NSString *input =
    @"{% trim %}\n"
    @"    {{foo}};\n"
    @"{% endtrim %}";
    id vars = @{@"foo": @"bar"};
    
    NSError *err = nil;
    BOOL success = [_engine processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"bar;\n", res);
}

- (void)testTrimNestedVars {
    NSString *input =
    @"{% trim %}\n"
    @"{{foo}}, {{foo}}\n"
    @"{% endtrim %}";
    id vars = @{@"foo": @"bar"};
    
    NSError *err = nil;
    BOOL success = [_engine processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"bar, bar\n", res);
}

- (void)testTrimNestedVarsSemi {
    NSString *input =
    @"{% trim %}\n"
    @"{{foo}}, {{foo}};\n"
    @"{% endtrim %}";
    id vars = @{@"foo": @"bar"};
    
    NSError *err = nil;
    BOOL success = [_engine processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"bar, bar;\n", res);
}

- (void)testTrimNestedVarsSpacesSemi {
    NSString *input =
    @"{% trim %}\n"
    @"    {{foo}}, {{foo}};   \n"
    @"{% endtrim %}";
    id vars = @{@"foo": @"bar"};
    
    NSError *err = nil;
    BOOL success = [_engine processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"bar, bar;\n", res);
}

//- (void)testTrimNestedVarNewline {
//    NSString *input = @"{% trim %} {{foo}}\n{% endtrim %}";
//    id vars = @{@"foo": @"bar"};
//    
//    NSError *err = nil;
//    BOOL success = [_engine processTemplateString:input withVariables:vars toStream:_output error:&err];
//    TDTrue(success);
//    TDNil(err);
//    NSString *res = [self outputString];
//    TDEqualObjects(@"bar", res);
//}
//
//- (void)testTrimNestedNewlineVarNewline {
//    NSString *input = @"{% trim %}\n {{foo}}\n{% endtrim %}";
//    id vars = @{@"foo": @"bar"};
//    
//    NSError *err = nil;
//    BOOL success = [_engine processTemplateString:input withVariables:vars toStream:_output error:&err];
//    TDTrue(success);
//    TDNil(err);
//    NSString *res = [self outputString];
//    TDEqualObjects(@"bar", res);
//}
//
//- (void)testTrimNestedVarSpace {
//    NSString *input = @"{% trim %} foo {% endtrim %}";
//    id vars = nil;
//    
//    NSError *err = nil;
//    BOOL success = [_engine processTemplateString:input withVariables:vars toStream:_output error:&err];
//    TDTrue(success);
//    TDNil(err);
//    NSString *res = [self outputString];
//    TDEqualObjects(@"foo", res);
//}
//
//- (void)testTrimNestedIfTagSpace {
//    NSString *input = @"{% trim %}{% if 1 %}  HI!  {% endif %}{% endtrim %}";
//    id vars = nil;
//    
//    NSError *err = nil;
//    BOOL success = [_engine processTemplateString:input withVariables:vars toStream:_output error:&err];
//    TDTrue(success);
//    TDNil(err);
//    NSString *res = [self outputString];
//    TDEqualObjects(@"HI!", res);
//}
//
//- (void)testTrimNestedIfTag {
//    NSString *input = @"{% trim %}   {%if 1%}HI!{%endif%}   {% endtrim %}";
//    id vars = nil;
//    
//    NSError *err = nil;
//    BOOL success = [_engine processTemplateString:input withVariables:vars toStream:_output error:&err];
//    TDTrue(success);
//    TDNil(err);
//    NSString *res = [self outputString];
//    TDEqualObjects(@"HI!", res);
//}
//
//- (void)testTrimNestedTrimNoTag {
//    NSString *input = @"{% trim %}   {% trim NO %} HI! {%endtrim%}   {% endtrim %}";
//    id vars = nil;
//    
//    NSError *err = nil;
//    BOOL success = [_engine processTemplateString:input withVariables:vars toStream:_output error:&err];
//    TDTrue(success);
//    TDNil(err);
//    NSString *res = [self outputString];
//    TDEqualObjects(@" HI! ", res);
//}
//
//- (void)testTrimNestedTrimFalseTag {
//    NSString *input = @"{% trim %}   {% trim false %} HI! {%endtrim%}   {% endtrim %}";
//    id vars = nil;
//    
//    NSError *err = nil;
//    BOOL success = [_engine processTemplateString:input withVariables:vars toStream:_output error:&err];
//    TDTrue(success);
//    TDNil(err);
//    NSString *res = [self outputString];
//    TDEqualObjects(@" HI! ", res);
//}
//
//- (void)testTrimNestedTrim1Tag {
//    NSString *input = @"{% trim %}   {% trim 1 %} HI! {%endtrim%}   {% endtrim %}";
//    id vars = nil;
//    
//    NSError *err = nil;
//    BOOL success = [_engine processTemplateString:input withVariables:vars toStream:_output error:&err];
//    TDTrue(success);
//    TDNil(err);
//    NSString *res = [self outputString];
//    TDEqualObjects(@"HI!", res);
//}
//
//- (void)testTrimNestedTrimYesTag {
//    NSString *input = @"{% trim %}   {% trim YES %} HI! {%endtrim%}   {% endtrim %}";
//    id vars = nil;
//    
//    NSError *err = nil;
//    BOOL success = [_engine processTemplateString:input withVariables:vars toStream:_output error:&err];
//    TDTrue(success);
//    TDNil(err);
//    NSString *res = [self outputString];
//    TDEqualObjects(@"HI!", res);
//}

@end
