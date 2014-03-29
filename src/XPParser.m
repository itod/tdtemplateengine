#import "XPParser.h"
#import <PEGKit/PEGKit.h>
    
#import <TDTemplateEngine/XPBooleanValue.h>
#import <TDTemplateEngine/XPNumericValue.h>
#import <TDTemplateEngine/XPStringValue.h>
#import <TDTemplateEngine/XPBooleanExpression.h>
#import <TDTemplateEngine/XPRelationalExpression.h>
#import <TDTemplateEngine/XPArithmeticExpression.h>

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
        self.tokenKindTab[@"ge"] = @(XP_TOKEN_KIND_GE);
        self.tokenKindTab[@"-"] = @(XP_TOKEN_KIND_MINUS);
        self.tokenKindTab[@">="] = @(XP_TOKEN_KIND_GE_SYM);
        self.tokenKindTab[@"&&"] = @(XP_TOKEN_KIND_DOUBLE_AMPERSAND);
        self.tokenKindTab[@"true"] = @(XP_TOKEN_KIND_TRUE);
        self.tokenKindTab[@"<"] = @(XP_TOKEN_KIND_LT_SYM);
        self.tokenKindTab[@"!="] = @(XP_TOKEN_KIND_NOT_EQUAL);
        self.tokenKindTab[@"/"] = @(XP_TOKEN_KIND_DIV);
        self.tokenKindTab[@"="] = @(XP_TOKEN_KIND_EQUALS);
        self.tokenKindTab[@"YES"] = @(XP_TOKEN_KIND_YES_UPPER);
        self.tokenKindTab[@"or"] = @(XP_TOKEN_KIND_OR);
        self.tokenKindTab[@">"] = @(XP_TOKEN_KIND_GT_SYM);
        self.tokenKindTab[@"ne"] = @(XP_TOKEN_KIND_NE);
        self.tokenKindTab[@"<="] = @(XP_TOKEN_KIND_LE_SYM);
        self.tokenKindTab[@"and"] = @(XP_TOKEN_KIND_AND);
        self.tokenKindTab[@"%"] = @(XP_TOKEN_KIND_MOD);
        self.tokenKindTab[@"lt"] = @(XP_TOKEN_KIND_LT);
        self.tokenKindTab[@"false"] = @(XP_TOKEN_KIND_FALSE);
        self.tokenKindTab[@"le"] = @(XP_TOKEN_KIND_LE);
        self.tokenKindTab[@"("] = @(XP_TOKEN_KIND_OPEN_PAREN);
        self.tokenKindTab[@"=="] = @(XP_TOKEN_KIND_DOUBLE_EQUALS);
        self.tokenKindTab[@"eq"] = @(XP_TOKEN_KIND_EQ);
        self.tokenKindTab[@"gt"] = @(XP_TOKEN_KIND_GT);
        self.tokenKindTab[@")"] = @(XP_TOKEN_KIND_CLOSE_PAREN);
        self.tokenKindTab[@"*"] = @(XP_TOKEN_KIND_TIMES);
        self.tokenKindTab[@"NO"] = @(XP_TOKEN_KIND_NO_UPPER);
        self.tokenKindTab[@"+"] = @(XP_TOKEN_KIND_PLUS);
        self.tokenKindTab[@"||"] = @(XP_TOKEN_KIND_DOUBLE_PIPE);

        self.tokenKindNameTab[XP_TOKEN_KIND_GE] = @"ge";
        self.tokenKindNameTab[XP_TOKEN_KIND_MINUS] = @"-";
        self.tokenKindNameTab[XP_TOKEN_KIND_GE_SYM] = @">=";
        self.tokenKindNameTab[XP_TOKEN_KIND_DOUBLE_AMPERSAND] = @"&&";
        self.tokenKindNameTab[XP_TOKEN_KIND_TRUE] = @"true";
        self.tokenKindNameTab[XP_TOKEN_KIND_LT_SYM] = @"<";
        self.tokenKindNameTab[XP_TOKEN_KIND_NOT_EQUAL] = @"!=";
        self.tokenKindNameTab[XP_TOKEN_KIND_DIV] = @"/";
        self.tokenKindNameTab[XP_TOKEN_KIND_EQUALS] = @"=";
        self.tokenKindNameTab[XP_TOKEN_KIND_YES_UPPER] = @"YES";
        self.tokenKindNameTab[XP_TOKEN_KIND_OR] = @"or";
        self.tokenKindNameTab[XP_TOKEN_KIND_GT_SYM] = @">";
        self.tokenKindNameTab[XP_TOKEN_KIND_NE] = @"ne";
        self.tokenKindNameTab[XP_TOKEN_KIND_LE_SYM] = @"<=";
        self.tokenKindNameTab[XP_TOKEN_KIND_AND] = @"and";
        self.tokenKindNameTab[XP_TOKEN_KIND_MOD] = @"%";
        self.tokenKindNameTab[XP_TOKEN_KIND_LT] = @"lt";
        self.tokenKindNameTab[XP_TOKEN_KIND_FALSE] = @"false";
        self.tokenKindNameTab[XP_TOKEN_KIND_LE] = @"le";
        self.tokenKindNameTab[XP_TOKEN_KIND_OPEN_PAREN] = @"(";
        self.tokenKindNameTab[XP_TOKEN_KIND_DOUBLE_EQUALS] = @"==";
        self.tokenKindNameTab[XP_TOKEN_KIND_EQ] = @"eq";
        self.tokenKindNameTab[XP_TOKEN_KIND_GT] = @"gt";
        self.tokenKindNameTab[XP_TOKEN_KIND_CLOSE_PAREN] = @")";
        self.tokenKindNameTab[XP_TOKEN_KIND_TIMES] = @"*";
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

- (void)orOp_ {
    
    if ([self predicts:XP_TOKEN_KIND_OR, 0]) {
        [self match:XP_TOKEN_KIND_OR discard:YES]; 
    } else if ([self predicts:XP_TOKEN_KIND_DOUBLE_PIPE, 0]) {
        [self match:XP_TOKEN_KIND_DOUBLE_PIPE discard:YES]; 
    } else {
        [self raise:@"No viable alternative found in rule 'orOp'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchOrOp:)];
}

- (void)orExpr_ {
    
    [self andExpr_]; 
    while ([self speculate:^{ [self orOp_]; [self andExpr_]; }]) {
        [self orOp_]; 
        [self andExpr_]; 
        [self execute:^{
        
	XPValue *rhs = POP();
	XPValue *lhs = POP();
    PUSH([XPBooleanExpression booleanExpressionWithOperand:lhs operator:XP_TOKEN_KIND_OR operand:rhs]);

        }];
    }

    [self fireDelegateSelector:@selector(parser:didMatchOrExpr:)];
}

- (void)andOp_ {
    
    if ([self predicts:XP_TOKEN_KIND_AND, 0]) {
        [self match:XP_TOKEN_KIND_AND discard:YES]; 
    } else if ([self predicts:XP_TOKEN_KIND_DOUBLE_AMPERSAND, 0]) {
        [self match:XP_TOKEN_KIND_DOUBLE_AMPERSAND discard:YES]; 
    } else {
        [self raise:@"No viable alternative found in rule 'andOp'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchAndOp:)];
}

- (void)andExpr_ {
    
    [self equalityExpr_]; 
    while ([self speculate:^{ [self andOp_]; [self equalityExpr_]; }]) {
        [self andOp_]; 
        [self equalityExpr_]; 
        [self execute:^{
        
	XPValue *rhs = POP();
	XPValue *lhs = POP();
    PUSH([XPBooleanExpression booleanExpressionWithOperand:lhs operator:XP_TOKEN_KIND_AND operand:rhs]);

        }];
    }

    [self fireDelegateSelector:@selector(parser:didMatchAndExpr:)];
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
     PUSH(@(XP_TOKEN_KIND_EQ)); 
    }];

    [self fireDelegateSelector:@selector(parser:didMatchEqOp:)];
}

- (void)neOp_ {
    
    if ([self speculate:^{ [self match:XP_TOKEN_KIND_NOT_EQUAL discard:YES]; }]) {
        [self match:XP_TOKEN_KIND_NOT_EQUAL discard:YES]; 
    } else if ([self speculate:^{ [self match:XP_TOKEN_KIND_NOT_EQUAL discard:YES]; }]) {
        [self match:XP_TOKEN_KIND_NOT_EQUAL discard:YES]; 
    } else if ([self speculate:^{ [self match:XP_TOKEN_KIND_NE discard:YES]; }]) {
        [self match:XP_TOKEN_KIND_NE discard:YES]; 
    } else {
        [self raise:@"No viable alternative found in rule 'neOp'."];
    }
    [self execute:^{
     PUSH(@(XP_TOKEN_KIND_NE)); 
    }];

    [self fireDelegateSelector:@selector(parser:didMatchNeOp:)];
}

- (void)equalityExpr_ {
    
    [self relationalExpr_]; 
    while ([self speculate:^{ if ([self predicts:XP_TOKEN_KIND_DOUBLE_EQUALS, XP_TOKEN_KIND_EQ, XP_TOKEN_KIND_EQUALS, 0]) {[self eqOp_]; } else if ([self predicts:XP_TOKEN_KIND_NE, XP_TOKEN_KIND_NOT_EQUAL, 0]) {[self neOp_]; } else {[self raise:@"No viable alternative found in rule 'equalityExpr'."];}[self relationalExpr_]; }]) {
        if ([self predicts:XP_TOKEN_KIND_DOUBLE_EQUALS, XP_TOKEN_KIND_EQ, XP_TOKEN_KIND_EQUALS, 0]) {
            [self eqOp_]; 
        } else if ([self predicts:XP_TOKEN_KIND_NE, XP_TOKEN_KIND_NOT_EQUAL, 0]) {
            [self neOp_]; 
        } else {
            [self raise:@"No viable alternative found in rule 'equalityExpr'."];
        }
        [self relationalExpr_]; 
        [self execute:^{
        
	XPValue *rhs = POP();
	NSInteger op = POP_INT();
	XPValue *lhs = POP();
    PUSH([XPRelationalExpression relationalExpressionWithOperand:lhs operator:op operand:rhs]);

        }];
    }

    [self fireDelegateSelector:@selector(parser:didMatchEqualityExpr:)];
}

- (void)ltOp_ {
    
    if ([self predicts:XP_TOKEN_KIND_LT_SYM, 0]) {
        [self match:XP_TOKEN_KIND_LT_SYM discard:YES]; 
    } else if ([self predicts:XP_TOKEN_KIND_LT, 0]) {
        [self match:XP_TOKEN_KIND_LT discard:YES]; 
    } else {
        [self raise:@"No viable alternative found in rule 'ltOp'."];
    }
    [self execute:^{
     PUSH(@(XP_TOKEN_KIND_LT)); 
    }];

    [self fireDelegateSelector:@selector(parser:didMatchLtOp:)];
}

- (void)gtOp_ {
    
    if ([self predicts:XP_TOKEN_KIND_GT_SYM, 0]) {
        [self match:XP_TOKEN_KIND_GT_SYM discard:YES]; 
    } else if ([self predicts:XP_TOKEN_KIND_GT, 0]) {
        [self match:XP_TOKEN_KIND_GT discard:YES]; 
    } else {
        [self raise:@"No viable alternative found in rule 'gtOp'."];
    }
    [self execute:^{
     PUSH(@(XP_TOKEN_KIND_GT)); 
    }];

    [self fireDelegateSelector:@selector(parser:didMatchGtOp:)];
}

- (void)leOp_ {
    
    if ([self predicts:XP_TOKEN_KIND_LE_SYM, 0]) {
        [self match:XP_TOKEN_KIND_LE_SYM discard:YES]; 
    } else if ([self predicts:XP_TOKEN_KIND_LE, 0]) {
        [self match:XP_TOKEN_KIND_LE discard:YES]; 
    } else {
        [self raise:@"No viable alternative found in rule 'leOp'."];
    }
    [self execute:^{
     PUSH(@(XP_TOKEN_KIND_LE)); 
    }];

    [self fireDelegateSelector:@selector(parser:didMatchLeOp:)];
}

- (void)geOp_ {
    
    if ([self predicts:XP_TOKEN_KIND_GE_SYM, 0]) {
        [self match:XP_TOKEN_KIND_GE_SYM discard:YES]; 
    } else if ([self predicts:XP_TOKEN_KIND_GE, 0]) {
        [self match:XP_TOKEN_KIND_GE discard:YES]; 
    } else {
        [self raise:@"No viable alternative found in rule 'geOp'."];
    }
    [self execute:^{
     PUSH(@(XP_TOKEN_KIND_GE)); 
    }];

    [self fireDelegateSelector:@selector(parser:didMatchGeOp:)];
}

- (void)relationalExpr_ {
    
    [self additiveExpr_]; 
    while ([self speculate:^{ if ([self predicts:XP_TOKEN_KIND_LT, XP_TOKEN_KIND_LT_SYM, 0]) {[self ltOp_]; } else if ([self predicts:XP_TOKEN_KIND_GT, XP_TOKEN_KIND_GT_SYM, 0]) {[self gtOp_]; } else if ([self predicts:XP_TOKEN_KIND_LE, XP_TOKEN_KIND_LE_SYM, 0]) {[self leOp_]; } else if ([self predicts:XP_TOKEN_KIND_GE, XP_TOKEN_KIND_GE_SYM, 0]) {[self geOp_]; } else {[self raise:@"No viable alternative found in rule 'relationalExpr'."];}[self additiveExpr_]; }]) {
        if ([self predicts:XP_TOKEN_KIND_LT, XP_TOKEN_KIND_LT_SYM, 0]) {
            [self ltOp_]; 
        } else if ([self predicts:XP_TOKEN_KIND_GT, XP_TOKEN_KIND_GT_SYM, 0]) {
            [self gtOp_]; 
        } else if ([self predicts:XP_TOKEN_KIND_LE, XP_TOKEN_KIND_LE_SYM, 0]) {
            [self leOp_]; 
        } else if ([self predicts:XP_TOKEN_KIND_GE, XP_TOKEN_KIND_GE_SYM, 0]) {
            [self geOp_]; 
        } else {
            [self raise:@"No viable alternative found in rule 'relationalExpr'."];
        }
        [self additiveExpr_]; 
        [self execute:^{
        
	XPValue *rhs = POP();
	NSInteger op = POP_INT();
	XPValue *lhs = POP();
    PUSH([XPRelationalExpression relationalExpressionWithOperand:lhs operator:op operand:rhs]);

        }];
    }

    [self fireDelegateSelector:@selector(parser:didMatchRelationalExpr:)];
}

- (void)plus_ {
    
    [self match:XP_TOKEN_KIND_PLUS discard:YES]; 
    [self execute:^{
     PUSH(@(XP_TOKEN_KIND_PLUS)); 
    }];

    [self fireDelegateSelector:@selector(parser:didMatchPlus:)];
}

- (void)minus_ {
    
    [self match:XP_TOKEN_KIND_MINUS discard:YES]; 
    [self execute:^{
     PUSH(@(XP_TOKEN_KIND_MINUS)); 
    }];

    [self fireDelegateSelector:@selector(parser:didMatchMinus:)];
}

- (void)additiveExpr_ {
    
    [self multiplicativeExpr_]; 
    while ([self speculate:^{ if ([self predicts:XP_TOKEN_KIND_PLUS, 0]) {[self plus_]; } else if ([self predicts:XP_TOKEN_KIND_MINUS, 0]) {[self minus_]; } else {[self raise:@"No viable alternative found in rule 'additiveExpr'."];}[self multiplicativeExpr_]; }]) {
        if ([self predicts:XP_TOKEN_KIND_PLUS, 0]) {
            [self plus_]; 
        } else if ([self predicts:XP_TOKEN_KIND_MINUS, 0]) {
            [self minus_]; 
        } else {
            [self raise:@"No viable alternative found in rule 'additiveExpr'."];
        }
        [self multiplicativeExpr_]; 
        [self execute:^{
        
	XPValue *rhs = POP();
	NSInteger op = POP_INT();
	XPValue *lhs = POP();
    PUSH([XPArithmeticExpression arithmeticExpressionWithOperand:lhs operator:op operand:rhs]);

        }];
    }

    [self fireDelegateSelector:@selector(parser:didMatchAdditiveExpr:)];
}

- (void)times_ {
    
    [self match:XP_TOKEN_KIND_TIMES discard:YES]; 
    [self execute:^{
     PUSH(@(XP_TOKEN_KIND_TIMES)); 
    }];

    [self fireDelegateSelector:@selector(parser:didMatchTimes:)];
}

- (void)div_ {
    
    [self match:XP_TOKEN_KIND_DIV discard:YES]; 
    [self execute:^{
     PUSH(@(XP_TOKEN_KIND_DIV)); 
    }];

    [self fireDelegateSelector:@selector(parser:didMatchDiv:)];
}

- (void)mod_ {
    
    [self match:XP_TOKEN_KIND_MOD discard:YES]; 
    [self execute:^{
     PUSH(@(XP_TOKEN_KIND_MOD)); 
    }];

    [self fireDelegateSelector:@selector(parser:didMatchMod:)];
}

- (void)multiplicativeExpr_ {
    
    [self unaryExpr_]; 
    while ([self speculate:^{ if ([self predicts:XP_TOKEN_KIND_TIMES, 0]) {[self times_]; } else if ([self predicts:XP_TOKEN_KIND_DIV, 0]) {[self div_]; } else if ([self predicts:XP_TOKEN_KIND_MOD, 0]) {[self mod_]; } else {[self raise:@"No viable alternative found in rule 'multiplicativeExpr'."];}[self unaryExpr_]; }]) {
        if ([self predicts:XP_TOKEN_KIND_TIMES, 0]) {
            [self times_]; 
        } else if ([self predicts:XP_TOKEN_KIND_DIV, 0]) {
            [self div_]; 
        } else if ([self predicts:XP_TOKEN_KIND_MOD, 0]) {
            [self mod_]; 
        } else {
            [self raise:@"No viable alternative found in rule 'multiplicativeExpr'."];
        }
        [self unaryExpr_]; 
        [self execute:^{
        
	XPValue *rhs = POP();
	NSInteger op = POP_INT();
	XPValue *lhs = POP();
    PUSH([XPArithmeticExpression arithmeticExpressionWithOperand:lhs operator:op operand:rhs]);

        }];
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