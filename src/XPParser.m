#import "XPParser.h"
#import <PEGKit/PEGKit.h>
    
#import <TDTemplateEngine/XPBooleanValue.h>
#import <TDTemplateEngine/XPNumericValue.h>
#import <TDTemplateEngine/XPStringValue.h>

#define LT(i) [self LT:(i)]
#define LA(i) [self LA:(i)]
#define LS(i) [self LS:(i)]
#define LF(i) [self LD:(i)]

#define POP()            [self.assembly pop]
#define POP_STR()        [self popString]
#define POP_QUOTED_STR() [self popQuotedString]
#define POP_TOK()        [self popToken]
#define POP_BOOL()       [self popBool]
#define POP_INT()        [self popInteger]
#define POP_UINT()       [self popUnsignedInteger]
#define POP_FLOAT()      [self popFloat]
#define POP_DOUBLE()     [self popDouble]

#define PUSH(obj)      [self.assembly push:(id)(obj)]
#define PUSH_BOOL(yn)  [self pushBool:(BOOL)(yn)]
#define PUSH_INT(i)    [self pushInteger:(NSInteger)(i)]
#define PUSH_UINT(u)   [self pushUnsignedInteger:(NSUInteger)(u)]
#define PUSH_FLOAT(f)  [self pushFloat:(float)(f)]
#define PUSH_DOUBLE(d) [self pushDouble:(double)(d)]

#define EQ(a, b) [(a) isEqual:(b)]
#define NE(a, b) (![(a) isEqual:(b)])
#define EQ_IGNORE_CASE(a, b) (NSOrderedSame == [(a) compare:(b)])

#define MATCHES(pattern, str)               ([[NSRegularExpression regularExpressionWithPattern:(pattern) options:0                                  error:nil] numberOfMatchesInString:(str) options:0 range:NSMakeRange(0, [(str) length])] > 0)
#define MATCHES_IGNORE_CASE(pattern, str)   ([[NSRegularExpression regularExpressionWithPattern:(pattern) options:NSRegularExpressionCaseInsensitive error:nil] numberOfMatchesInString:(str) options:0 range:NSMakeRange(0, [(str) length])] > 0)

#define ABOVE(fence) [self.assembly objectsAbove:(fence)]
#define EMPTY() [self.assembly isStackEmpty]

#define LOG(obj) do { NSLog(@"%@", (obj)); } while (0);
#define PRINT(str) do { printf("%s\n", (str)); } while (0);

@interface PKParser ()
@property (nonatomic, retain) NSMutableDictionary *tokenKindTab;
@property (nonatomic, retain) NSMutableArray *tokenKindNameTab;
@property (nonatomic, retain) NSString *startRuleName;
@property (nonatomic, retain) NSString *statementTerminator;
@property (nonatomic, retain) NSString *singleLineCommentMarker;
@property (nonatomic, retain) NSString *blockStartMarker;
@property (nonatomic, retain) NSString *blockEndMarker;
@property (nonatomic, retain) NSString *braces;

- (BOOL)popBool;
- (NSInteger)popInteger;
- (double)popDouble;
- (PKToken *)popToken;
- (NSString *)popString;
- (NSString *)popQuotedString;

- (void)pushBool:(BOOL)yn;
- (void)pushInteger:(NSInteger)i;
- (void)pushDouble:(double)d;
@end

@interface XPParser ()
    
@property (nonatomic, retain) PKToken *openParen;

@end

@implementation XPParser { }

- (id)initWithDelegate:(id)d {
    self = [super initWithDelegate:d];
    if (self) {
            
    self.openParen = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"(" doubleValue:0.0];

        self.startRuleName = @"expr";
        self.tokenKindTab[@">="] = @(XP_XP_TOKEN_KIND_GE);
        self.tokenKindTab[@"-"] = @(XP_TOKEN_KIND_MINUS);
        self.tokenKindTab[@">="] = @(XP_XP_TOKEN_KIND_GE);
        self.tokenKindTab[@"&&"] = @(XP_TOKEN_KIND_DOUBLE_AMPERSAND);
        self.tokenKindTab[@"true"] = @(XP_TOKEN_KIND_TRUE);
        self.tokenKindTab[@"<"] = @(XP_XP_TOKEN_KIND_LT);
        self.tokenKindTab[@"!="] = @(XP_XP_TOKEN_KIND_NE);
        self.tokenKindTab[@"/"] = @(XP_TOKEN_KIND_FORWARD_SLASH);
        self.tokenKindTab[@"="] = @(XP_TOKEN_KIND_EQUALS);
        self.tokenKindTab[@"YES"] = @(XP_TOKEN_KIND_YES_UPPER);
        self.tokenKindTab[@"or"] = @(XP_TOKEN_KIND_OR);
        self.tokenKindTab[@">"] = @(XP_XP_TOKEN_KIND_GT);
        self.tokenKindTab[@"!="] = @(XP_XP_TOKEN_KIND_NE);
        self.tokenKindTab[@"<="] = @(XP_XP_TOKEN_KIND_LE);
        self.tokenKindTab[@"and"] = @(XP_TOKEN_KIND_AND);
        self.tokenKindTab[@"%"] = @(XP_TOKEN_KIND_PERCENT);
        self.tokenKindTab[@"<"] = @(XP_XP_TOKEN_KIND_LT);
        self.tokenKindTab[@"false"] = @(XP_TOKEN_KIND_FALSE);
        self.tokenKindTab[@"<="] = @(XP_XP_TOKEN_KIND_LE);
        self.tokenKindTab[@"("] = @(XP_TOKEN_KIND_OPEN_PAREN);
        self.tokenKindTab[@"=="] = @(XP_TOKEN_KIND_DOUBLE_EQUALS);
        self.tokenKindTab[@"eq"] = @(XP_TOKEN_KIND_EQ);
        self.tokenKindTab[@">"] = @(XP_XP_TOKEN_KIND_GT);
        self.tokenKindTab[@")"] = @(XP_TOKEN_KIND_CLOSE_PAREN);
        self.tokenKindTab[@"*"] = @(XP_TOKEN_KIND_STAR);
        self.tokenKindTab[@"NO"] = @(XP_TOKEN_KIND_NO_UPPER);
        self.tokenKindTab[@"+"] = @(XP_TOKEN_KIND_PLUS);
        self.tokenKindTab[@"||"] = @(XP_TOKEN_KIND_DOUBLE_PIPE);

        self.tokenKindNameTab[XP_XP_TOKEN_KIND_GE] = @">=";
        self.tokenKindNameTab[XP_TOKEN_KIND_MINUS] = @"-";
        self.tokenKindNameTab[XP_XP_TOKEN_KIND_GE] = @">=";
        self.tokenKindNameTab[XP_TOKEN_KIND_DOUBLE_AMPERSAND] = @"&&";
        self.tokenKindNameTab[XP_TOKEN_KIND_TRUE] = @"true";
        self.tokenKindNameTab[XP_XP_TOKEN_KIND_LT] = @"<";
        self.tokenKindNameTab[XP_XP_TOKEN_KIND_NE] = @"!=";
        self.tokenKindNameTab[XP_TOKEN_KIND_FORWARD_SLASH] = @"/";
        self.tokenKindNameTab[XP_TOKEN_KIND_EQUALS] = @"=";
        self.tokenKindNameTab[XP_TOKEN_KIND_YES_UPPER] = @"YES";
        self.tokenKindNameTab[XP_TOKEN_KIND_OR] = @"or";
        self.tokenKindNameTab[XP_XP_TOKEN_KIND_GT] = @">";
        self.tokenKindNameTab[XP_XP_TOKEN_KIND_NE] = @"!=";
        self.tokenKindNameTab[XP_XP_TOKEN_KIND_LE] = @"<=";
        self.tokenKindNameTab[XP_TOKEN_KIND_AND] = @"and";
        self.tokenKindNameTab[XP_TOKEN_KIND_PERCENT] = @"%";
        self.tokenKindNameTab[XP_XP_TOKEN_KIND_LT] = @"<";
        self.tokenKindNameTab[XP_TOKEN_KIND_FALSE] = @"false";
        self.tokenKindNameTab[XP_XP_TOKEN_KIND_LE] = @"<=";
        self.tokenKindNameTab[XP_TOKEN_KIND_OPEN_PAREN] = @"(";
        self.tokenKindNameTab[XP_TOKEN_KIND_DOUBLE_EQUALS] = @"==";
        self.tokenKindNameTab[XP_TOKEN_KIND_EQ] = @"eq";
        self.tokenKindNameTab[XP_XP_TOKEN_KIND_GT] = @">";
        self.tokenKindNameTab[XP_TOKEN_KIND_CLOSE_PAREN] = @")";
        self.tokenKindNameTab[XP_TOKEN_KIND_STAR] = @"*";
        self.tokenKindNameTab[XP_TOKEN_KIND_NO_UPPER] = @"NO";
        self.tokenKindNameTab[XP_TOKEN_KIND_PLUS] = @"+";
        self.tokenKindNameTab[XP_TOKEN_KIND_DOUBLE_PIPE] = @"||";

    }
    return self;
}

- (void)dealloc {
        
    self.openParen = nil;


    [super dealloc];
}

- (void)start {
    [self execute:^{
    
    PKTokenizer *t = self.tokenizer;
    [t.symbolState add:@"=="];
    [t.symbolState add:@"!="];
    [t.symbolState add:@"<="];
    [t.symbolState add:@">="];

    }];

    [self expr_]; 
    [self matchEOF:YES]; 

}

- (void)expr_ {
    
    [self orExpr_]; 

    [self fireDelegateSelector:@selector(parser:didMatchExpr:)];
}

- (void)orExpr_ {
    
    [self andExpr_]; 
    while ([self speculate:^{ [self orOp_]; [self andExpr_]; }]) {
        [self orOp_]; 
        [self andExpr_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchOrExpr:)];
}

- (void)andExpr_ {
    
    [self equalityExpr_]; 
    while ([self speculate:^{ [self andOp_]; [self equalityExpr_]; }]) {
        [self andOp_]; 
        [self equalityExpr_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchAndExpr:)];
}

- (void)orOp_ {
    
    if ([self predicts:XP_TOKEN_KIND_OR, 0]) {
        [self match:XP_TOKEN_KIND_OR discard:YES]; 
    } else if ([self predicts:XP_TOKEN_KIND_DOUBLE_PIPE, 0]) {
        [self match:XP_TOKEN_KIND_DOUBLE_PIPE discard:YES]; 
    } else {
        [self raise:@"No viable alternative found in rule 'orOp'."];
    }
    [self execute:^{
     PUSH(@"or"); 
    }];

    [self fireDelegateSelector:@selector(parser:didMatchOrOp:)];
}

- (void)andOp_ {
    
    if ([self predicts:XP_TOKEN_KIND_AND, 0]) {
        [self match:XP_TOKEN_KIND_AND discard:YES]; 
    } else if ([self predicts:XP_TOKEN_KIND_DOUBLE_AMPERSAND, 0]) {
        [self match:XP_TOKEN_KIND_DOUBLE_AMPERSAND discard:YES]; 
    } else {
        [self raise:@"No viable alternative found in rule 'andOp'."];
    }
    [self execute:^{
     PUSH(@"and"); 
    }];

    [self fireDelegateSelector:@selector(parser:didMatchAndOp:)];
}

- (void)equalityExpr_ {
    
    [self relationalExpr_]; 
    while ([self speculate:^{ if ([self predicts:XP_TOKEN_KIND_DOUBLE_EQUALS, XP_TOKEN_KIND_EQ, XP_TOKEN_KIND_EQUALS, 0]) {[self eqOp_]; } else if ([self predicts:XP_XP_TOKEN_KIND_NE, 0]) {[self neOp_]; } else {[self raise:@"No viable alternative found in rule 'equalityExpr'."];}[self relationalExpr_]; }]) {
        if ([self predicts:XP_TOKEN_KIND_DOUBLE_EQUALS, XP_TOKEN_KIND_EQ, XP_TOKEN_KIND_EQUALS, 0]) {
            [self eqOp_]; 
        } else if ([self predicts:XP_XP_TOKEN_KIND_NE, 0]) {
            [self neOp_]; 
        } else {
            [self raise:@"No viable alternative found in rule 'equalityExpr'."];
        }
        [self relationalExpr_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchEqualityExpr:)];
}

- (void)relationalExpr_ {
    
    [self additiveExpr_]; 
    while ([self speculate:^{ if ([self predicts:XP_XP_TOKEN_KIND_LT, 0]) {[self ltOp_]; } else if ([self predicts:XP_XP_TOKEN_KIND_GT, 0]) {[self gtOp_]; } else if ([self predicts:XP_XP_TOKEN_KIND_LE, 0]) {[self leOp_]; } else if ([self predicts:XP_XP_TOKEN_KIND_GE, 0]) {[self geOp_]; } else {[self raise:@"No viable alternative found in rule 'relationalExpr'."];}[self additiveExpr_]; }]) {
        if ([self predicts:XP_XP_TOKEN_KIND_LT, 0]) {
            [self ltOp_]; 
        } else if ([self predicts:XP_XP_TOKEN_KIND_GT, 0]) {
            [self gtOp_]; 
        } else if ([self predicts:XP_XP_TOKEN_KIND_LE, 0]) {
            [self leOp_]; 
        } else if ([self predicts:XP_XP_TOKEN_KIND_GE, 0]) {
            [self geOp_]; 
        } else {
            [self raise:@"No viable alternative found in rule 'relationalExpr'."];
        }
        [self additiveExpr_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchRelationalExpr:)];
}

- (void)eqOp_ {
    
    if ([self predicts:XP_TOKEN_KIND_EQUALS, 0]) {
        [self match:XP_TOKEN_KIND_EQUALS discard:YES]; 
    } else if ([self predicts:XP_TOKEN_KIND_DOUBLE_EQUALS, 0]) {
        [self match:XP_TOKEN_KIND_DOUBLE_EQUALS discard:YES]; 
    } else if ([self predicts:XP_TOKEN_KIND_EQ, 0]) {
        [self match:XP_TOKEN_KIND_EQ discard:YES]; 
    } else {
        [self raise:@"No viable alternative found in rule 'eqOp'."];
    }
    [self execute:^{
     PUSH(@"eq"); 
    }];

    [self fireDelegateSelector:@selector(parser:didMatchEqOp:)];
}

- (void)neOp_ {
    
    if ([self speculate:^{ [self match:XP_XP_TOKEN_KIND_NE discard:YES]; }]) {
        [self match:XP_XP_TOKEN_KIND_NE discard:YES]; 
    } else if ([self speculate:^{ [self match:XP_XP_TOKEN_KIND_NE discard:YES]; }]) {
        [self match:XP_XP_TOKEN_KIND_NE discard:YES]; 
    } else if ([self speculate:^{ [self match:XP_XP_TOKEN_KIND_NE discard:YES]; }]) {
        [self match:XP_XP_TOKEN_KIND_NE discard:YES]; 
    } else {
        [self raise:@"No viable alternative found in rule 'neOp'."];
    }
    [self execute:^{
     PUSH(@"ne"); 
    }];

    [self fireDelegateSelector:@selector(parser:didMatchNeOp:)];
}

- (void)ltOp_ {
    
    if ([self speculate:^{ [self match:XP_XP_TOKEN_KIND_LT discard:YES]; }]) {
        [self match:XP_XP_TOKEN_KIND_LT discard:YES]; 
    } else if ([self speculate:^{ [self match:XP_XP_TOKEN_KIND_LT discard:YES]; }]) {
        [self match:XP_XP_TOKEN_KIND_LT discard:YES]; 
    } else {
        [self raise:@"No viable alternative found in rule 'ltOp'."];
    }
    [self execute:^{
     PUSH(@"lt"); 
    }];

    [self fireDelegateSelector:@selector(parser:didMatchLtOp:)];
}

- (void)gtOp_ {
    
    if ([self speculate:^{ [self match:XP_XP_TOKEN_KIND_GT discard:YES]; }]) {
        [self match:XP_XP_TOKEN_KIND_GT discard:YES]; 
    } else if ([self speculate:^{ [self match:XP_XP_TOKEN_KIND_GT discard:YES]; }]) {
        [self match:XP_XP_TOKEN_KIND_GT discard:YES]; 
    } else {
        [self raise:@"No viable alternative found in rule 'gtOp'."];
    }
    [self execute:^{
     PUSH(@"gt"); 
    }];

    [self fireDelegateSelector:@selector(parser:didMatchGtOp:)];
}

- (void)leOp_ {
    
    if ([self speculate:^{ [self match:XP_XP_TOKEN_KIND_LE discard:YES]; }]) {
        [self match:XP_XP_TOKEN_KIND_LE discard:YES]; 
    } else if ([self speculate:^{ [self match:XP_XP_TOKEN_KIND_LE discard:YES]; }]) {
        [self match:XP_XP_TOKEN_KIND_LE discard:YES]; 
    } else {
        [self raise:@"No viable alternative found in rule 'leOp'."];
    }
    [self execute:^{
     PUSH(@"le"); 
    }];

    [self fireDelegateSelector:@selector(parser:didMatchLeOp:)];
}

- (void)geOp_ {
    
    if ([self speculate:^{ [self match:XP_XP_TOKEN_KIND_GE discard:YES]; }]) {
        [self match:XP_XP_TOKEN_KIND_GE discard:YES]; 
    } else if ([self speculate:^{ [self match:XP_XP_TOKEN_KIND_GE discard:YES]; }]) {
        [self match:XP_XP_TOKEN_KIND_GE discard:YES]; 
    } else {
        [self raise:@"No viable alternative found in rule 'geOp'."];
    }
    [self execute:^{
     PUSH(@"ge"); 
    }];

    [self fireDelegateSelector:@selector(parser:didMatchGeOp:)];
}

- (void)additiveExpr_ {
    
    [self multiplicativeExpr_]; 
    while ([self speculate:^{ if ([self predicts:XP_TOKEN_KIND_PLUS, 0]) {[self match:XP_TOKEN_KIND_PLUS discard:NO]; } else if ([self predicts:XP_TOKEN_KIND_MINUS, 0]) {[self match:XP_TOKEN_KIND_MINUS discard:NO]; } else {[self raise:@"No viable alternative found in rule 'additiveExpr'."];}[self multiplicativeExpr_]; }]) {
        if ([self predicts:XP_TOKEN_KIND_PLUS, 0]) {
            [self match:XP_TOKEN_KIND_PLUS discard:NO]; 
        } else if ([self predicts:XP_TOKEN_KIND_MINUS, 0]) {
            [self match:XP_TOKEN_KIND_MINUS discard:NO]; 
        } else {
            [self raise:@"No viable alternative found in rule 'additiveExpr'."];
        }
        [self multiplicativeExpr_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchAdditiveExpr:)];
}

- (void)multiplicativeExpr_ {
    
    [self unaryExpr_]; 
    while ([self speculate:^{ if ([self predicts:XP_TOKEN_KIND_STAR, 0]) {[self match:XP_TOKEN_KIND_STAR discard:NO]; } else if ([self predicts:XP_TOKEN_KIND_FORWARD_SLASH, 0]) {[self match:XP_TOKEN_KIND_FORWARD_SLASH discard:NO]; } else if ([self predicts:XP_TOKEN_KIND_PERCENT, 0]) {[self match:XP_TOKEN_KIND_PERCENT discard:NO]; } else {[self raise:@"No viable alternative found in rule 'multiplicativeExpr'."];}[self unaryExpr_]; }]) {
        if ([self predicts:XP_TOKEN_KIND_STAR, 0]) {
            [self match:XP_TOKEN_KIND_STAR discard:NO]; 
        } else if ([self predicts:XP_TOKEN_KIND_FORWARD_SLASH, 0]) {
            [self match:XP_TOKEN_KIND_FORWARD_SLASH discard:NO]; 
        } else if ([self predicts:XP_TOKEN_KIND_PERCENT, 0]) {
            [self match:XP_TOKEN_KIND_PERCENT discard:NO]; 
        } else {
            [self raise:@"No viable alternative found in rule 'multiplicativeExpr'."];
        }
        [self unaryExpr_]; 
    }

    [self fireDelegateSelector:@selector(parser:didMatchMultiplicativeExpr:)];
}

- (void)unaryExpr_ {
    
    while ([self predicts:XP_TOKEN_KIND_MINUS, 0]) {
        [self match:XP_TOKEN_KIND_MINUS discard:NO]; 
    }
    [self primary_]; 

    [self fireDelegateSelector:@selector(parser:didMatchUnaryExpr:)];
}

- (void)primary_ {
    
    if ([self predicts:TOKEN_KIND_BUILTIN_NUMBER, TOKEN_KIND_BUILTIN_QUOTEDSTRING, XP_TOKEN_KIND_FALSE, XP_TOKEN_KIND_NO_UPPER, XP_TOKEN_KIND_TRUE, XP_TOKEN_KIND_YES_UPPER, 0]) {
        [self atom_]; 
    } else if ([self predicts:XP_TOKEN_KIND_OPEN_PAREN, 0]) {
        [self subExpr_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'primary'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchPrimary:)];
}

- (void)subExpr_ {
    
    [self match:XP_TOKEN_KIND_OPEN_PAREN discard:NO]; 
    [self expr_]; 
    [self match:XP_TOKEN_KIND_CLOSE_PAREN discard:YES]; 
    [self execute:^{
    
    NSArray *objs = ABOVE(_openParen);
    POP(); // discard `(`
    for (id obj in [objs reverseObjectEnumerator]) {
        PUSH(obj);
    }

    }];

    [self fireDelegateSelector:@selector(parser:didMatchSubExpr:)];
}

- (void)atom_ {
    
    [self literal_]; 

    [self fireDelegateSelector:@selector(parser:didMatchAtom:)];
}

- (void)literal_ {
    
    if ([self predicts:TOKEN_KIND_BUILTIN_QUOTEDSTRING, 0]) {
        [self str_]; 
    } else if ([self predicts:TOKEN_KIND_BUILTIN_NUMBER, 0]) {
        [self num_]; 
    } else if ([self predicts:XP_TOKEN_KIND_FALSE, XP_TOKEN_KIND_NO_UPPER, XP_TOKEN_KIND_TRUE, XP_TOKEN_KIND_YES_UPPER, 0]) {
        [self bool_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'literal'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchLiteral:)];
}

- (void)bool_ {
    
    if ([self predicts:XP_TOKEN_KIND_TRUE, XP_TOKEN_KIND_YES_UPPER, 0]) {
        [self true_]; 
        [self execute:^{
         PUSH([XPBooleanValue booleanValueWithBoolean:YES]); 
        }];
    } else if ([self predicts:XP_TOKEN_KIND_FALSE, XP_TOKEN_KIND_NO_UPPER, 0]) {
        [self false_]; 
        [self execute:^{
         PUSH([XPBooleanValue booleanValueWithBoolean:NO]); 
        }];
    } else {
        [self raise:@"No viable alternative found in rule 'bool'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchBool:)];
}

- (void)true_ {
    
    if ([self predicts:XP_TOKEN_KIND_TRUE, 0]) {
        [self match:XP_TOKEN_KIND_TRUE discard:YES]; 
    } else if ([self predicts:XP_TOKEN_KIND_YES_UPPER, 0]) {
        [self match:XP_TOKEN_KIND_YES_UPPER discard:YES]; 
    } else {
        [self raise:@"No viable alternative found in rule 'true'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchTrue:)];
}

- (void)false_ {
    
    if ([self predicts:XP_TOKEN_KIND_FALSE, 0]) {
        [self match:XP_TOKEN_KIND_FALSE discard:YES]; 
    } else if ([self predicts:XP_TOKEN_KIND_NO_UPPER, 0]) {
        [self match:XP_TOKEN_KIND_NO_UPPER discard:YES]; 
    } else {
        [self raise:@"No viable alternative found in rule 'false'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchFalse:)];
}

- (void)num_ {
    
    [self matchNumber:NO]; 
    [self execute:^{
    
    PUSH([XPNumericValue numericValueWithNumber:POP_DOUBLE()]);

    }];

    [self fireDelegateSelector:@selector(parser:didMatchNum:)];
}

- (void)str_ {
    
    [self matchQuotedString:NO]; 
    [self execute:^{
    
    PUSH([XPStringValue stringValueWithString:POP_QUOTED_STR()]);

    }];

    [self fireDelegateSelector:@selector(parser:didMatchStr:)];
}

@end