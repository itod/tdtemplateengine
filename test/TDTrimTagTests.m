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
    NSString *input = @"{% trim %}f{% /trim %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [_engine processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"f", res);
}

- (void)testTrimNestedVar {
    NSString *input = @"{% trim %}{{foo}}{% /trim %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [_engine processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"", res);
}

- (void)testTrimNestedVars {
    NSString *input = @"{% trim %}{{foo}}, {{foo}}{% /trim %}";
    id vars = @{@"foo": @"bar"};
    
    NSError *err = nil;
    BOOL success = [_engine processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"bar, bar", res);
}

- (void)testTrimLinesNestedVars {
    NSString *input = @"{% trimlines %}{{foo}} {{foo}}{% /trimlines %}";
    id vars = @{@"foo": @"bar"};
    
    NSError *err = nil;
    BOOL success = [_engine processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"bar bar", res);
}

- (void)testTrimNestedVarNewline {
    NSString *input = @"{% trim %} {{foo}}\n{% /trim %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [_engine processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"", res);
}

- (void)testTrimNestedVarSpace {
    NSString *input = @"{% trim %} foo {% /trim %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [_engine processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"foo", res);
}

- (void)testTrimNestedIfTagSpace {
    NSString *input = @"{% trim %}{% if 1 %}  HI!  {% /if %}{% /trim %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [_engine processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"HI!", res);
}

- (void)testTrimNestedIfTag {
    NSString *input = @"{% trim %}   {%if 1%}HI!{%/if%}   {% /trim %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [_engine processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"HI!", res);
}

- (void)testTrimNestedTrimNoTag {
    NSString *input = @"{% trim %}   {% trim NO %} HI! {%/trim%}   {% /trim %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [_engine processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@" HI! ", res);
}

- (void)testTrimNestedTrimFalseTag {
    NSString *input = @"{% trim %}   {% trim false %} HI! {%/trim%}   {% /trim %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [_engine processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@" HI! ", res);
}

- (void)testTrimNestedTrim1Tag {
    NSString *input = @"{% trim %}   {% trim 1 %} HI! {%/trim%}   {% /trim %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [_engine processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"HI!", res);
}

- (void)testTrimNestedTrimYesTag {
    NSString *input = @"{% trim %}   {% trim YES %} HI! {%/trim%}   {% /trim %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [_engine processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"HI!", res);
}

- (void)testTrimLinesF {
    NSString *input = @"{% trimlines %}f{% /trimlines %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [_engine processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"f", res);
}

- (void)testTrimLinesNestedVar {
    NSString *input = @"{% trimlines %}{{foo}}{% /trimlines %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [_engine processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"", res);
}

- (void)testTrimLinesNestedVarNewline {
    NSString *input = @"{% trimlines %} {{foo}}\n{% /trimlines %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [_engine processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@" ", res);
}

- (void)testTrimLinesNestedVarSpace {
    NSString *input = @"{% trimlines %} foo {% /trimlines %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [_engine processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@" foo ", res);
}

- (void)testTrimLinesNestedIfTagSpace {
    NSString *input = @"{% trimlines %}{% if 1 %}\nHI!  {% /if %}{% /trimlines %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [_engine processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"HI!  ", res);
}

- (void)testTrimLinesNestedIfTag {
    NSString *input = @"{% trimlines %}\n\n{%if 1%}HI!{%/if%}\n{% /trimlines %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [_engine processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"HI!", res);
}

- (void)testTrimLinesNestedTrimLinesNoTag {
    NSString *input = @"{% trimlines %}\n{% trimlines NO %}\nHI!\n{%/trimlines%}\n{% /trimlines %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [_engine processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"\nHI!\n", res);
}

- (void)testTrimLinesNestedTrimLinesFalseTag {
    NSString *input = @"{% trimlines %}\n{% trimlines false %}\nHI!\n{%/trimlines%}\n{% /trimlines %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [_engine processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"\nHI!\n", res);
}

- (void)testTrimLinesNestedTrimLines1Tag {
    NSString *input = @"{% trimlines %}\n{% trimlines 1 %}\nHI!\n{%/trimlines%}\n{% /trimlines %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [_engine processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"HI!", res);
}

- (void)testTrimLinesNestedTrimLinesYesTag {
    NSString *input = @"{% trimlines %}\n{% trimlines YES %}\nHI!\n{%/trimlines%}\n{% /trimlines %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [_engine processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"HI!", res);
}

- (void)testTrimSpacesF {
    NSString *input = @"{% trimspaces %}f{% /trimspaces %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [_engine processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"f", res);
}

- (void)testTrimSpacesNestedVar {
    NSString *input = @"{% trimspaces %}{{foo}}{% /trimspaces %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [_engine processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"", res);
}

- (void)testTrimSpacesNestedVarNewline {
    NSString *input = @"{% trimspaces %} {{foo}}\n{% /trimspaces %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [_engine processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"\n", res);
}

- (void)testTrimSpacesNestedVarSpace {
    NSString *input = @"{% trimspaces %} foo {% /trimspaces %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [_engine processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"foo", res);
}

- (void)testTrimSpacesNestedIfTagSpace {
    NSString *input = @"{% trimspaces %}{% if 1 %}\nHI!  {% /if %}{% /trimspaces %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [_engine processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"\nHI!", res);
}

- (void)testTrimSpacesNestedIfTag {
    NSString *input = @"{% trimspaces %}\n\n{%if 1%}HI!{%/if%}\n{% /trimspaces %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [_engine processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"\n\nHI!\n", res);
}

- (void)testTrimSpacesNestedTrimSpacesNoTag {
    NSString *input = @"{% trimspaces %}   {% trimspaces NO %} HI! {%/trimspaces%}   {% /trimspaces %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [_engine processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@" HI! ", res);
}

- (void)testTrimSpacesNestedTrimSpacesFalseTag {
    NSString *input = @"{% trimspaces %}   {% trimspaces NO %} HI! {%/trimspaces%}   {% /trimspaces %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [_engine processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@" HI! ", res);
}

- (void)testTrimSpacesNestedTrimSpaces1Tag {
    NSString *input = @"{% trimspaces %}   {% trimspaces 1 %} HI! {%/trimspaces%}   {% /trimspaces %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [_engine processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"HI!", res);
}

- (void)testTrimSpacesNestedTrimSpacesYesTag {
    NSString *input = @"{% trimspaces %}   {% trimspaces YES %} HI! {%/trimspaces%}   {% /trimspaces %}";
    id vars = nil;
    
    NSError *err = nil;
    BOOL success = [_engine processTemplateString:input withVariables:vars toStream:_output error:&err];
    TDTrue(success);
    TDNil(err);
    NSString *res = [self outputString];
    TDEqualObjects(@"HI!", res);
}

@end
