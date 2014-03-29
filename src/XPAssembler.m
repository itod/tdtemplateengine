// The MIT License (MIT)
//
// Copyright (c) 2014 Todd Ditchendorf
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "XPAssembler.h"
#import <PEGKit/PKParser.h>
#import <PEGKit/PKAssembly.h>
#import <PEGKit/PKToken.h>
#import <TDTemplateEngine/XPBooleanValue.h>
#import <TDTemplateEngine/XPNumericValue.h>
#import <TDTemplateEngine/XPStringValue.h>

@interface XPAssembler ()
@property (nonatomic, retain) PKToken *openParen;
@end

@implementation XPAssembler

- (instancetype)init {
    self = [super init];
    if (self) {
        self.openParen = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"(" doubleValue:0.0];
    }
    return self;
}


- (void)dealloc {
    self.openParen = nil;
    [super dealloc];
}


- (void)parser:(PKParser *)p didMatchSubExpr:(PKAssembly *)a {
    //NSLog(@"%s", __PRETTY_FUNCTION__);
    
    NSArray *objs = [a objectsAbove:_openParen];
    [a pop]; // discard `(`
    for (id obj in [objs reverseObjectEnumerator]) {
        [a push:obj];
    }
}


- (void)parser:(PKParser *)p didMatchStr:(PKAssembly *)a {
    //NSLog(@"%s", __PRETTY_FUNCTION__);
    
    PKToken *tok = [a pop];
    NSString *str = tok.stringValue;
    str = [str substringWithRange:NSMakeRange(1, [str length]-2)];
    XPValue *val = [XPStringValue stringValueWithString:str];
    [a push:val];
}


- (void)parser:(PKParser *)p didMatchNum:(PKAssembly *)a {
    //NSLog(@"%s", __PRETTY_FUNCTION__);
    
    PKToken *tok = [a pop];
    XPValue *val = [XPNumericValue numericValueWithNumber:tok.doubleValue];
    [a push:val];
}


- (void)parser:(PKParser *)p didMatchTrue:(PKAssembly *)a {
    //NSLog(@"%s", __PRETTY_FUNCTION__);
    
    XPValue *val = [XPBooleanValue booleanValueWithBoolean:YES];
    [a push:val];
}


- (void)parser:(PKParser *)p didMatchFalse:(PKAssembly *)a {
    //NSLog(@"%s", __PRETTY_FUNCTION__);
    
    XPValue *val = [XPBooleanValue booleanValueWithBoolean:NO];
    [a push:val];
}

@end
