#import "XPParser.h"
#import <PEGKit/PEGKit.h>
    
#import <TDTemplateEngine/XPBooleanValue.h>
#import <TDTemplateEngine/XPNumericValue.h>
#import <TDTemplateEngine/XPStringValue.h>
#import <TDTemplateEngine/XPBooleanExpression.h>
#import <TDTemplateEngine/XPRelationalExpression.h>
#import <TDTemplateEngine/XPArithmeticExpression.h>
#import <TDTemplateEngine/XPPathExpression.h>


@interface XPParser ()
    
@property (nonatomic, retain) PKToken *openParen;
@property (nonatomic, retain) PKToken *minus;
@property (nonatomic, assign) BOOL negative;

@end

@implementation XPParser { }
    
+ (PKTokenizer *)makeTokenizer {
    PKTokenizer *t = [PKTokenizer tokenizer];
    [t.symbolState add:@"=="];
    [t.symbolState add:@"!="];
    [t.symbolState add:@"<="];
    [t.symbolState add:@">="];
    [t.symbolState add:@"&&"];
    [t.symbolState add:@"||"];
	
	[t setTokenizerState:t.symbolState from:'-' to:'-'];
	return t;
}


- (id)initWithDelegate:(id)d {
    self = [super initWithDelegate:d];
    if (self) {
            
	self.tokenizer = [[self class] makeTokenizer];
    self.openParen = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"(" doubleValue:0.0];
    self.minus = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"-" doubleValue:0.0];

        self.startRuleName = @"expr";
        self.tokenKindTab[@"ge"] = @(XP_TOKEN_KIND_GE);
        self.tokenKindTab[@"-"] = @(XP_TOKEN_KIND_MINUS);
        self.tokenKindTab[@">="] = @(XP_TOKEN_KIND_GE_SYM);
        self.tokenKindTab[@"&&"] = @(XP_TOKEN_KIND_DOUBLE_AMPERSAND);
        self.tokenKindTab[@"."] = @(XP_TOKEN_KIND_DOT);
        self.tokenKindTab[@"<"] = @(XP_TOKEN_KIND_LT_SYM);
        self.tokenKindTab[@"!="] = @(XP_TOKEN_KIND_NOT_EQUAL);
        self.tokenKindTab[@"/"] = @(XP_TOKEN_KIND_DIV);
        self.tokenKindTab[@"="] = @(XP_TOKEN_KIND_EQUALS);
        self.tokenKindTab[@"true"] = @(XP_TOKEN_KIND_TRUE);
        self.tokenKindTab[@"or"] = @(XP_TOKEN_KIND_OR);
        self.tokenKindTab[@">"] = @(XP_TOKEN_KIND_GT_SYM);
        self.tokenKindTab[@"YES"] = @(XP_TOKEN_KIND_YES_UPPER);
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
        self.tokenKindNameTab[XP_TOKEN_KIND_DOT] = @".";
        self.tokenKindNameTab[XP_TOKEN_KIND_LT_SYM] = @"<";
        self.tokenKindNameTab[XP_TOKEN_KIND_NOT_EQUAL] = @"!=";
        self.tokenKindNameTab[XP_TOKEN_KIND_DIV] = @"/";
        self.tokenKindNameTab[XP_TOKEN_KIND_EQUALS] = @"=";
        self.tokenKindNameTab[XP_TOKEN_KIND_TRUE] = @"true";
        self.tokenKindNameTab[XP_TOKEN_KIND_OR] = @"or";
        self.tokenKindNameTab[XP_TOKEN_KIND_GT_SYM] = @">";
        self.tokenKindNameTab[XP_TOKEN_KIND_YES_UPPER] = @"YES";
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
	self.minus = nil;


    [super dealloc];
}

- (void)start {

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
    
    if ([self predicts:XP_TOKEN_KIND_NOT_EQUAL, 0]) {
        [self match:XP_TOKEN_KIND_NOT_EQUAL discard:YES]; 
    } else if ([self predicts:XP_TOKEN_KIND_NE, 0]) {
        [self match:XP_TOKEN_KIND_NE discard:YES]; 
    } else {
        [self raise:@"No viable alternative found in rule 'neOp'."];
    }
    [self execute:^{
     PUSH(@(XP_TOKEN_KIND_NE)); 
    }];

    [self fireDelegateSelector:@selector(parser:didMatchNeOp:)];
}

- (void)eqExpr_ {
    
    [self eqOp_]; 
    [self relationalExpr_]; 

    [self fireDelegateSelector:@selector(parser:didMatchEqExpr:)];
}

- (void)neExpr_ {
    
    [self neOp_]; 
    [self relationalExpr_]; 

    [self fireDelegateSelector:@selector(parser:didMatchNeExpr:)];
}

- (void)equalityExpr_ {
    
    [self relationalExpr_]; 
    while ([self speculate:^{ if ([self predicts:XP_TOKEN_KIND_DOUBLE_EQUALS, XP_TOKEN_KIND_EQ, XP_TOKEN_KIND_EQUALS, 0]) {[self eqExpr_]; } else if ([self predicts:XP_TOKEN_KIND_NE, XP_TOKEN_KIND_NOT_EQUAL, 0]) {[self neExpr_]; } else {[self raise:@"No viable alternative found in rule 'equalityExpr'."];}}]) {
        if ([self predicts:XP_TOKEN_KIND_DOUBLE_EQUALS, XP_TOKEN_KIND_EQ, XP_TOKEN_KIND_EQUALS, 0]) {
            [self eqExpr_]; 
        } else if ([self predicts:XP_TOKEN_KIND_NE, XP_TOKEN_KIND_NOT_EQUAL, 0]) {
            [self neExpr_]; 
        } else {
            [self raise:@"No viable alternative found in rule 'equalityExpr'."];
        }
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
    
    if ([self predicts:XP_TOKEN_KIND_MINUS, 0]) {
        [self negPrimary_]; 
    } else if ([self predicts:TOKEN_KIND_BUILTIN_NUMBER, TOKEN_KIND_BUILTIN_QUOTEDSTRING, TOKEN_KIND_BUILTIN_WORD, XP_TOKEN_KIND_FALSE, XP_TOKEN_KIND_NO_UPPER, XP_TOKEN_KIND_OPEN_PAREN, XP_TOKEN_KIND_TRUE, XP_TOKEN_KIND_YES_UPPER, 0]) {
        [self primary_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'unaryExpr'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchUnaryExpr:)];
}

- (void)negPrimary_ {
    
    [self execute:^{
    
	_negative = NO; 

    }];
    do {
        [self match:XP_TOKEN_KIND_MINUS discard:YES]; 
        [self execute:^{
         _negative = !_negative; 
        }];
    } while ([self predicts:XP_TOKEN_KIND_MINUS, 0]);
    [self primary_]; 
    [self execute:^{
    
	double d = POP_DOUBLE();
	d = (_negative) ? -d : d;
	PUSH([XPNumericValue numericValueWithNumber:d]);

    }];

    [self fireDelegateSelector:@selector(parser:didMatchNegPrimary:)];
}

- (void)primary_ {
    
    if ([self predicts:TOKEN_KIND_BUILTIN_NUMBER, TOKEN_KIND_BUILTIN_QUOTEDSTRING, TOKEN_KIND_BUILTIN_WORD, XP_TOKEN_KIND_FALSE, XP_TOKEN_KIND_NO_UPPER, XP_TOKEN_KIND_TRUE, XP_TOKEN_KIND_YES_UPPER, 0]) {
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
    
    id objs = ABOVE(_openParen);
    POP(); // discard `(`
	PUSH_ALL(REV(objs));

    }];

    [self fireDelegateSelector:@selector(parser:didMatchSubExpr:)];
}

- (void)atom_ {
    
    if ([self predicts:TOKEN_KIND_BUILTIN_NUMBER, TOKEN_KIND_BUILTIN_QUOTEDSTRING, XP_TOKEN_KIND_FALSE, XP_TOKEN_KIND_NO_UPPER, XP_TOKEN_KIND_TRUE, XP_TOKEN_KIND_YES_UPPER, 0]) {
        [self literal_]; 
    } else if ([self predicts:TOKEN_KIND_BUILTIN_WORD, 0]) {
        [self pathExpr_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'atom'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchAtom:)];
}

- (void)pathExpr_ {
    
    [self execute:^{
    
	PUSH(_openParen);

    }];
    [self identifier_]; 
    while ([self speculate:^{ [self match:XP_TOKEN_KIND_DOT discard:YES]; [self step_]; }]) {
        [self match:XP_TOKEN_KIND_DOT discard:YES]; 
        [self step_]; 
    }
    [self execute:^{
    
	id toks = REV(ABOVE(_openParen));
	POP(); // discard `_openParen`
	PUSH([XPPathExpression pathExpressionWithSteps:toks]);

    }];

    [self fireDelegateSelector:@selector(parser:didMatchPathExpr:)];
}

- (void)step_ {
    
    if ([self predicts:TOKEN_KIND_BUILTIN_WORD, 0]) {
        [self identifier_]; 
    } else if ([self predicts:TOKEN_KIND_BUILTIN_NUMBER, 0]) {
        [self num_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'step'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchStep:)];
}

- (void)identifier_ {
    
    [self matchWord:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchIdentifier:)];
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