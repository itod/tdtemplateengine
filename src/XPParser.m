#import "XPParser.h"
#import <PEGKit/PEGKit.h>
    
#import <TDTemplateEngine/XPBooleanValue.h>
#import <TDTemplateEngine/XPNumericValue.h>
#import <TDTemplateEngine/XPStringValue.h>
#import <TDTemplateEngine/XPNegationExpression.h>
#import <TDTemplateEngine/XPBooleanExpression.h>
#import <TDTemplateEngine/XPRelationalExpression.h>
#import <TDTemplateEngine/XPArithmeticExpression.h>
#import <TDTemplateEngine/XPLoopExpression.h>
#import <TDTemplateEngine/XPCollectionExpression.h>
#import <TDTemplateEngine/XPRangeExpression.h>
#import <TDTemplateEngine/XPPathExpression.h>
#import <TDTemplateEngine/XPFilterExpression.h>


@interface XPParser ()
    
@property (nonatomic, retain) PKToken *openParen;
@property (nonatomic, retain) PKToken *minus;
@property (nonatomic, assign) BOOL negation;
@property (nonatomic, assign) BOOL negative;

@property (nonatomic, retain) NSMutableDictionary *expr_memo;
@property (nonatomic, retain) NSMutableDictionary *loopExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *identifiers_memo;
@property (nonatomic, retain) NSMutableDictionary *enumExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *collectionExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *rangeExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *optBy_memo;
@property (nonatomic, retain) NSMutableDictionary *orOp_memo;
@property (nonatomic, retain) NSMutableDictionary *orExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *andOp_memo;
@property (nonatomic, retain) NSMutableDictionary *andExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *eqOp_memo;
@property (nonatomic, retain) NSMutableDictionary *neOp_memo;
@property (nonatomic, retain) NSMutableDictionary *equalityExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *ltOp_memo;
@property (nonatomic, retain) NSMutableDictionary *gtOp_memo;
@property (nonatomic, retain) NSMutableDictionary *leOp_memo;
@property (nonatomic, retain) NSMutableDictionary *geOp_memo;
@property (nonatomic, retain) NSMutableDictionary *relationalExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *plus_memo;
@property (nonatomic, retain) NSMutableDictionary *minus_memo;
@property (nonatomic, retain) NSMutableDictionary *additiveExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *times_memo;
@property (nonatomic, retain) NSMutableDictionary *div_memo;
@property (nonatomic, retain) NSMutableDictionary *mod_memo;
@property (nonatomic, retain) NSMutableDictionary *multiplicativeExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *unaryExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *negatedUnary_memo;
@property (nonatomic, retain) NSMutableDictionary *unary_memo;
@property (nonatomic, retain) NSMutableDictionary *signedFilterExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *filterExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *primaryExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *subExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *atom_memo;
@property (nonatomic, retain) NSMutableDictionary *pathExpr_memo;
@property (nonatomic, retain) NSMutableDictionary *step_memo;
@property (nonatomic, retain) NSMutableDictionary *identifier_memo;
@property (nonatomic, retain) NSMutableDictionary *literal_memo;
@property (nonatomic, retain) NSMutableDictionary *bool_memo;
@property (nonatomic, retain) NSMutableDictionary *true_memo;
@property (nonatomic, retain) NSMutableDictionary *false_memo;
@property (nonatomic, retain) NSMutableDictionary *num_memo;
@property (nonatomic, retain) NSMutableDictionary *str_memo;
@end

@implementation XPParser { }
    
+ (PKTokenizer *)tokenizer {
    PKTokenizer *t = [PKTokenizer tokenizer];
    [t.symbolState add:@"=="];
    [t.symbolState add:@"!="];
    [t.symbolState add:@"<="];
    [t.symbolState add:@">="];
    [t.symbolState add:@"&&"];
    [t.symbolState add:@"||"];
    
    [t setTokenizerState:t.symbolState from:'-' to:'-'];
	[t.wordState setWordChars:NO from:'\'' to:'\''];
    return t;
}


- (id)initWithDelegate:(id)d {
    self = [super initWithDelegate:d];
    if (self) {
            
    self.tokenizer = [[self class] tokenizer];
    self.openParen = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"(" doubleValue:0.0];
    self.minus = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"-" doubleValue:0.0];

        self.startRuleName = @"expr";
        self.tokenKindTab[@"gt"] = @(XP_TOKEN_KIND_GT);
        self.tokenKindTab[@">="] = @(XP_TOKEN_KIND_GE_SYM);
        self.tokenKindTab[@"&&"] = @(XP_TOKEN_KIND_DOUBLE_AMPERSAND);
        self.tokenKindTab[@"|"] = @(XP_TOKEN_KIND_PIPE);
        self.tokenKindTab[@"true"] = @(XP_TOKEN_KIND_TRUE);
        self.tokenKindTab[@"!="] = @(XP_TOKEN_KIND_NOT_EQUAL);
        self.tokenKindTab[@"!"] = @(XP_TOKEN_KIND_BANG);
        self.tokenKindTab[@"<"] = @(XP_TOKEN_KIND_LT_SYM);
        self.tokenKindTab[@"%"] = @(XP_TOKEN_KIND_MOD);
        self.tokenKindTab[@"le"] = @(XP_TOKEN_KIND_LE);
        self.tokenKindTab[@">"] = @(XP_TOKEN_KIND_GT_SYM);
        self.tokenKindTab[@"lt"] = @(XP_TOKEN_KIND_LT);
        self.tokenKindTab[@"("] = @(XP_TOKEN_KIND_OPEN_PAREN);
        self.tokenKindTab[@")"] = @(XP_TOKEN_KIND_CLOSE_PAREN);
        self.tokenKindTab[@"eq"] = @(XP_TOKEN_KIND_EQ);
        self.tokenKindTab[@"YES"] = @(XP_TOKEN_KIND_YES_UPPER);
        self.tokenKindTab[@"or"] = @(XP_TOKEN_KIND_OR);
        self.tokenKindTab[@"ne"] = @(XP_TOKEN_KIND_NE);
        self.tokenKindTab[@"not"] = @(XP_TOKEN_KIND_NOT);
        self.tokenKindTab[@"*"] = @(XP_TOKEN_KIND_TIMES);
        self.tokenKindTab[@"+"] = @(XP_TOKEN_KIND_PLUS);
        self.tokenKindTab[@","] = @(XP_TOKEN_KIND_COMMA);
        self.tokenKindTab[@"and"] = @(XP_TOKEN_KIND_AND);
        self.tokenKindTab[@"||"] = @(XP_TOKEN_KIND_DOUBLE_PIPE);
        self.tokenKindTab[@"-"] = @(XP_TOKEN_KIND_MINUS);
        self.tokenKindTab[@"in"] = @(XP_TOKEN_KIND_IN);
        self.tokenKindTab[@"."] = @(XP_TOKEN_KIND_DOT);
        self.tokenKindTab[@"/"] = @(XP_TOKEN_KIND_DIV);
        self.tokenKindTab[@"by"] = @(XP_TOKEN_KIND_BY);
        self.tokenKindTab[@"false"] = @(XP_TOKEN_KIND_FALSE);
        self.tokenKindTab[@"<="] = @(XP_TOKEN_KIND_LE_SYM);
        self.tokenKindTab[@"to"] = @(XP_TOKEN_KIND_TO);
        self.tokenKindTab[@"ge"] = @(XP_TOKEN_KIND_GE);
        self.tokenKindTab[@"NO"] = @(XP_TOKEN_KIND_NO_UPPER);
        self.tokenKindTab[@"=="] = @(XP_TOKEN_KIND_DOUBLE_EQUALS);

        self.tokenKindNameTab[XP_TOKEN_KIND_GT] = @"gt";
        self.tokenKindNameTab[XP_TOKEN_KIND_GE_SYM] = @">=";
        self.tokenKindNameTab[XP_TOKEN_KIND_DOUBLE_AMPERSAND] = @"&&";
        self.tokenKindNameTab[XP_TOKEN_KIND_PIPE] = @"|";
        self.tokenKindNameTab[XP_TOKEN_KIND_TRUE] = @"true";
        self.tokenKindNameTab[XP_TOKEN_KIND_NOT_EQUAL] = @"!=";
        self.tokenKindNameTab[XP_TOKEN_KIND_BANG] = @"!";
        self.tokenKindNameTab[XP_TOKEN_KIND_LT_SYM] = @"<";
        self.tokenKindNameTab[XP_TOKEN_KIND_MOD] = @"%";
        self.tokenKindNameTab[XP_TOKEN_KIND_LE] = @"le";
        self.tokenKindNameTab[XP_TOKEN_KIND_GT_SYM] = @">";
        self.tokenKindNameTab[XP_TOKEN_KIND_LT] = @"lt";
        self.tokenKindNameTab[XP_TOKEN_KIND_OPEN_PAREN] = @"(";
        self.tokenKindNameTab[XP_TOKEN_KIND_CLOSE_PAREN] = @")";
        self.tokenKindNameTab[XP_TOKEN_KIND_EQ] = @"eq";
        self.tokenKindNameTab[XP_TOKEN_KIND_YES_UPPER] = @"YES";
        self.tokenKindNameTab[XP_TOKEN_KIND_OR] = @"or";
        self.tokenKindNameTab[XP_TOKEN_KIND_NE] = @"ne";
        self.tokenKindNameTab[XP_TOKEN_KIND_NOT] = @"not";
        self.tokenKindNameTab[XP_TOKEN_KIND_TIMES] = @"*";
        self.tokenKindNameTab[XP_TOKEN_KIND_PLUS] = @"+";
        self.tokenKindNameTab[XP_TOKEN_KIND_COMMA] = @",";
        self.tokenKindNameTab[XP_TOKEN_KIND_AND] = @"and";
        self.tokenKindNameTab[XP_TOKEN_KIND_DOUBLE_PIPE] = @"||";
        self.tokenKindNameTab[XP_TOKEN_KIND_MINUS] = @"-";
        self.tokenKindNameTab[XP_TOKEN_KIND_IN] = @"in";
        self.tokenKindNameTab[XP_TOKEN_KIND_DOT] = @".";
        self.tokenKindNameTab[XP_TOKEN_KIND_DIV] = @"/";
        self.tokenKindNameTab[XP_TOKEN_KIND_BY] = @"by";
        self.tokenKindNameTab[XP_TOKEN_KIND_FALSE] = @"false";
        self.tokenKindNameTab[XP_TOKEN_KIND_LE_SYM] = @"<=";
        self.tokenKindNameTab[XP_TOKEN_KIND_TO] = @"to";
        self.tokenKindNameTab[XP_TOKEN_KIND_GE] = @"ge";
        self.tokenKindNameTab[XP_TOKEN_KIND_NO_UPPER] = @"NO";
        self.tokenKindNameTab[XP_TOKEN_KIND_DOUBLE_EQUALS] = @"==";

        self.expr_memo = [NSMutableDictionary dictionary];
        self.loopExpr_memo = [NSMutableDictionary dictionary];
        self.identifiers_memo = [NSMutableDictionary dictionary];
        self.enumExpr_memo = [NSMutableDictionary dictionary];
        self.collectionExpr_memo = [NSMutableDictionary dictionary];
        self.rangeExpr_memo = [NSMutableDictionary dictionary];
        self.optBy_memo = [NSMutableDictionary dictionary];
        self.orOp_memo = [NSMutableDictionary dictionary];
        self.orExpr_memo = [NSMutableDictionary dictionary];
        self.andOp_memo = [NSMutableDictionary dictionary];
        self.andExpr_memo = [NSMutableDictionary dictionary];
        self.eqOp_memo = [NSMutableDictionary dictionary];
        self.neOp_memo = [NSMutableDictionary dictionary];
        self.equalityExpr_memo = [NSMutableDictionary dictionary];
        self.ltOp_memo = [NSMutableDictionary dictionary];
        self.gtOp_memo = [NSMutableDictionary dictionary];
        self.leOp_memo = [NSMutableDictionary dictionary];
        self.geOp_memo = [NSMutableDictionary dictionary];
        self.relationalExpr_memo = [NSMutableDictionary dictionary];
        self.plus_memo = [NSMutableDictionary dictionary];
        self.minus_memo = [NSMutableDictionary dictionary];
        self.additiveExpr_memo = [NSMutableDictionary dictionary];
        self.times_memo = [NSMutableDictionary dictionary];
        self.div_memo = [NSMutableDictionary dictionary];
        self.mod_memo = [NSMutableDictionary dictionary];
        self.multiplicativeExpr_memo = [NSMutableDictionary dictionary];
        self.unaryExpr_memo = [NSMutableDictionary dictionary];
        self.negatedUnary_memo = [NSMutableDictionary dictionary];
        self.unary_memo = [NSMutableDictionary dictionary];
        self.signedFilterExpr_memo = [NSMutableDictionary dictionary];
        self.filterExpr_memo = [NSMutableDictionary dictionary];
        self.primaryExpr_memo = [NSMutableDictionary dictionary];
        self.subExpr_memo = [NSMutableDictionary dictionary];
        self.atom_memo = [NSMutableDictionary dictionary];
        self.pathExpr_memo = [NSMutableDictionary dictionary];
        self.step_memo = [NSMutableDictionary dictionary];
        self.identifier_memo = [NSMutableDictionary dictionary];
        self.literal_memo = [NSMutableDictionary dictionary];
        self.bool_memo = [NSMutableDictionary dictionary];
        self.true_memo = [NSMutableDictionary dictionary];
        self.false_memo = [NSMutableDictionary dictionary];
        self.num_memo = [NSMutableDictionary dictionary];
        self.str_memo = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)dealloc {
        
    self.openParen = nil;
    self.minus = nil;

    self.expr_memo = nil;
    self.loopExpr_memo = nil;
    self.identifiers_memo = nil;
    self.enumExpr_memo = nil;
    self.collectionExpr_memo = nil;
    self.rangeExpr_memo = nil;
    self.optBy_memo = nil;
    self.orOp_memo = nil;
    self.orExpr_memo = nil;
    self.andOp_memo = nil;
    self.andExpr_memo = nil;
    self.eqOp_memo = nil;
    self.neOp_memo = nil;
    self.equalityExpr_memo = nil;
    self.ltOp_memo = nil;
    self.gtOp_memo = nil;
    self.leOp_memo = nil;
    self.geOp_memo = nil;
    self.relationalExpr_memo = nil;
    self.plus_memo = nil;
    self.minus_memo = nil;
    self.additiveExpr_memo = nil;
    self.times_memo = nil;
    self.div_memo = nil;
    self.mod_memo = nil;
    self.multiplicativeExpr_memo = nil;
    self.unaryExpr_memo = nil;
    self.negatedUnary_memo = nil;
    self.unary_memo = nil;
    self.signedFilterExpr_memo = nil;
    self.filterExpr_memo = nil;
    self.primaryExpr_memo = nil;
    self.subExpr_memo = nil;
    self.atom_memo = nil;
    self.pathExpr_memo = nil;
    self.step_memo = nil;
    self.identifier_memo = nil;
    self.literal_memo = nil;
    self.bool_memo = nil;
    self.true_memo = nil;
    self.false_memo = nil;
    self.num_memo = nil;
    self.str_memo = nil;

    [super dealloc];
}

- (void)clearMemo {
    [_expr_memo removeAllObjects];
    [_loopExpr_memo removeAllObjects];
    [_identifiers_memo removeAllObjects];
    [_enumExpr_memo removeAllObjects];
    [_collectionExpr_memo removeAllObjects];
    [_rangeExpr_memo removeAllObjects];
    [_optBy_memo removeAllObjects];
    [_orOp_memo removeAllObjects];
    [_orExpr_memo removeAllObjects];
    [_andOp_memo removeAllObjects];
    [_andExpr_memo removeAllObjects];
    [_eqOp_memo removeAllObjects];
    [_neOp_memo removeAllObjects];
    [_equalityExpr_memo removeAllObjects];
    [_ltOp_memo removeAllObjects];
    [_gtOp_memo removeAllObjects];
    [_leOp_memo removeAllObjects];
    [_geOp_memo removeAllObjects];
    [_relationalExpr_memo removeAllObjects];
    [_plus_memo removeAllObjects];
    [_minus_memo removeAllObjects];
    [_additiveExpr_memo removeAllObjects];
    [_times_memo removeAllObjects];
    [_div_memo removeAllObjects];
    [_mod_memo removeAllObjects];
    [_multiplicativeExpr_memo removeAllObjects];
    [_unaryExpr_memo removeAllObjects];
    [_negatedUnary_memo removeAllObjects];
    [_unary_memo removeAllObjects];
    [_signedFilterExpr_memo removeAllObjects];
    [_filterExpr_memo removeAllObjects];
    [_primaryExpr_memo removeAllObjects];
    [_subExpr_memo removeAllObjects];
    [_atom_memo removeAllObjects];
    [_pathExpr_memo removeAllObjects];
    [_step_memo removeAllObjects];
    [_identifier_memo removeAllObjects];
    [_literal_memo removeAllObjects];
    [_bool_memo removeAllObjects];
    [_true_memo removeAllObjects];
    [_false_memo removeAllObjects];
    [_num_memo removeAllObjects];
    [_str_memo removeAllObjects];
}

- (void)start {

    [self expr_]; 
    [self matchEOF:YES]; 

}

- (void)__expr {
    
    if ([self speculate:^{ [self loopExpr_]; }]) {
        [self loopExpr_]; 
    } else if ([self speculate:^{ [self orExpr_]; }]) {
        [self orExpr_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'expr'."];
    }

}

- (void)expr_ {
    [self parseRule:@selector(__expr) withMemo:_expr_memo];
}

- (void)__loopExpr {
    
    [self identifiers_]; 
    [self match:XP_TOKEN_KIND_IN discard:YES]; 
    [self enumExpr_]; 
    [self execute:^{
    
	id enumExpr = POP();
	id vars = POP();
	PUSH([XPLoopExpression loopExpressionWithVariables:vars enumeration:enumExpr]);

    }];

}

- (void)loopExpr_ {
    [self parseRule:@selector(__loopExpr) withMemo:_loopExpr_memo];
}

- (void)__identifiers {
    
    [self execute:^{
     PUSH(_openParen); 
    }];
    [self identifier_]; 
    if ([self speculate:^{ [self match:XP_TOKEN_KIND_COMMA discard:YES]; [self identifier_]; }]) {
        [self match:XP_TOKEN_KIND_COMMA discard:YES]; 
        [self identifier_]; 
    }
    [self execute:^{
    
	id strs = REV(ABOVE(_openParen));
	POP(); // discard `(`
	PUSH(strs);

    }];

}

- (void)identifiers_ {
    [self parseRule:@selector(__identifiers) withMemo:_identifiers_memo];
}

- (void)__enumExpr {
    
    if ([self speculate:^{ [self rangeExpr_]; }]) {
        [self rangeExpr_]; 
    } else if ([self speculate:^{ [self collectionExpr_]; }]) {
        [self collectionExpr_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'enumExpr'."];
    }

}

- (void)enumExpr_ {
    [self parseRule:@selector(__enumExpr) withMemo:_enumExpr_memo];
}

- (void)__collectionExpr {
    
    [self identifier_]; 
    [self execute:^{
    
	id var = POP_STR();
	PUSH([XPCollectionExpression collectionExpressionWithVariable:var]);

    }];

}

- (void)collectionExpr_ {
    [self parseRule:@selector(__collectionExpr) withMemo:_collectionExpr_memo];
}

- (void)__rangeExpr {
    
    [self unaryExpr_]; 
    [self match:XP_TOKEN_KIND_TO discard:YES]; 
    [self unaryExpr_]; 
    [self optBy_]; 
    [self execute:^{
    
	id by = POP();
	id stop = POP();
	id start = POP();
	PUSH([XPRangeExpression rangeExpressionWithStart:start stop:stop by:by]);

    }];

}

- (void)rangeExpr_ {
    [self parseRule:@selector(__rangeExpr) withMemo:_rangeExpr_memo];
}

- (void)__optBy {
    
    if ([self predicts:XP_TOKEN_KIND_BY, 0]) {
        [self match:XP_TOKEN_KIND_BY discard:YES]; 
        [self unaryExpr_]; 
    } else {
        [self matchEmpty:NO]; 
        [self execute:^{
         PUSH([XPNumericValue numericValueWithNumber:0.0]); 
        }];
    }

}

- (void)optBy_ {
    [self parseRule:@selector(__optBy) withMemo:_optBy_memo];
}

- (void)__orOp {
    
    if ([self predicts:XP_TOKEN_KIND_OR, 0]) {
        [self match:XP_TOKEN_KIND_OR discard:YES]; 
    } else if ([self predicts:XP_TOKEN_KIND_DOUBLE_PIPE, 0]) {
        [self match:XP_TOKEN_KIND_DOUBLE_PIPE discard:YES]; 
    } else {
        [self raise:@"No viable alternative found in rule 'orOp'."];
    }

}

- (void)orOp_ {
    [self parseRule:@selector(__orOp) withMemo:_orOp_memo];
}

- (void)__orExpr {
    
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

}

- (void)orExpr_ {
    [self parseRule:@selector(__orExpr) withMemo:_orExpr_memo];
}

- (void)__andOp {
    
    if ([self predicts:XP_TOKEN_KIND_AND, 0]) {
        [self match:XP_TOKEN_KIND_AND discard:YES]; 
    } else if ([self predicts:XP_TOKEN_KIND_DOUBLE_AMPERSAND, 0]) {
        [self match:XP_TOKEN_KIND_DOUBLE_AMPERSAND discard:YES]; 
    } else {
        [self raise:@"No viable alternative found in rule 'andOp'."];
    }

}

- (void)andOp_ {
    [self parseRule:@selector(__andOp) withMemo:_andOp_memo];
}

- (void)__andExpr {
    
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

}

- (void)andExpr_ {
    [self parseRule:@selector(__andExpr) withMemo:_andExpr_memo];
}

- (void)__eqOp {
    
    if ([self predicts:XP_TOKEN_KIND_DOUBLE_EQUALS, 0]) {
        [self match:XP_TOKEN_KIND_DOUBLE_EQUALS discard:YES]; 
    } else if ([self predicts:XP_TOKEN_KIND_EQ, 0]) {
        [self match:XP_TOKEN_KIND_EQ discard:YES]; 
    } else {
        [self raise:@"No viable alternative found in rule 'eqOp'."];
    }
    [self execute:^{
     PUSH(@(XP_TOKEN_KIND_EQ)); 
    }];

}

- (void)eqOp_ {
    [self parseRule:@selector(__eqOp) withMemo:_eqOp_memo];
}

- (void)__neOp {
    
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

}

- (void)neOp_ {
    [self parseRule:@selector(__neOp) withMemo:_neOp_memo];
}

- (void)__equalityExpr {
    
    [self relationalExpr_]; 
    while ([self speculate:^{ if ([self predicts:XP_TOKEN_KIND_DOUBLE_EQUALS, XP_TOKEN_KIND_EQ, 0]) {[self eqOp_]; } else if ([self predicts:XP_TOKEN_KIND_NE, XP_TOKEN_KIND_NOT_EQUAL, 0]) {[self neOp_]; } else {[self raise:@"No viable alternative found in rule 'equalityExpr'."];}[self relationalExpr_]; }]) {
        if ([self predicts:XP_TOKEN_KIND_DOUBLE_EQUALS, XP_TOKEN_KIND_EQ, 0]) {
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

}

- (void)equalityExpr_ {
    [self parseRule:@selector(__equalityExpr) withMemo:_equalityExpr_memo];
}

- (void)__ltOp {
    
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

}

- (void)ltOp_ {
    [self parseRule:@selector(__ltOp) withMemo:_ltOp_memo];
}

- (void)__gtOp {
    
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

}

- (void)gtOp_ {
    [self parseRule:@selector(__gtOp) withMemo:_gtOp_memo];
}

- (void)__leOp {
    
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

}

- (void)leOp_ {
    [self parseRule:@selector(__leOp) withMemo:_leOp_memo];
}

- (void)__geOp {
    
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

}

- (void)geOp_ {
    [self parseRule:@selector(__geOp) withMemo:_geOp_memo];
}

- (void)__relationalExpr {
    
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

}

- (void)relationalExpr_ {
    [self parseRule:@selector(__relationalExpr) withMemo:_relationalExpr_memo];
}

- (void)__plus {
    
    [self match:XP_TOKEN_KIND_PLUS discard:YES]; 
    [self execute:^{
     PUSH(@(XP_TOKEN_KIND_PLUS)); 
    }];

}

- (void)plus_ {
    [self parseRule:@selector(__plus) withMemo:_plus_memo];
}

- (void)__minus {
    
    [self match:XP_TOKEN_KIND_MINUS discard:YES]; 
    [self execute:^{
     PUSH(@(XP_TOKEN_KIND_MINUS)); 
    }];

}

- (void)minus_ {
    [self parseRule:@selector(__minus) withMemo:_minus_memo];
}

- (void)__additiveExpr {
    
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

}

- (void)additiveExpr_ {
    [self parseRule:@selector(__additiveExpr) withMemo:_additiveExpr_memo];
}

- (void)__times {
    
    [self match:XP_TOKEN_KIND_TIMES discard:YES]; 
    [self execute:^{
     PUSH(@(XP_TOKEN_KIND_TIMES)); 
    }];

}

- (void)times_ {
    [self parseRule:@selector(__times) withMemo:_times_memo];
}

- (void)__div {
    
    [self match:XP_TOKEN_KIND_DIV discard:YES]; 
    [self execute:^{
     PUSH(@(XP_TOKEN_KIND_DIV)); 
    }];

}

- (void)div_ {
    [self parseRule:@selector(__div) withMemo:_div_memo];
}

- (void)__mod {
    
    [self match:XP_TOKEN_KIND_MOD discard:YES]; 
    [self execute:^{
     PUSH(@(XP_TOKEN_KIND_MOD)); 
    }];

}

- (void)mod_ {
    [self parseRule:@selector(__mod) withMemo:_mod_memo];
}

- (void)__multiplicativeExpr {
    
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

}

- (void)multiplicativeExpr_ {
    [self parseRule:@selector(__multiplicativeExpr) withMemo:_multiplicativeExpr_memo];
}

- (void)__unaryExpr {
    
    if ([self predicts:XP_TOKEN_KIND_BANG, XP_TOKEN_KIND_NOT, 0]) {
        [self negatedUnary_]; 
    } else if ([self predicts:TOKEN_KIND_BUILTIN_NUMBER, TOKEN_KIND_BUILTIN_QUOTEDSTRING, TOKEN_KIND_BUILTIN_WORD, XP_TOKEN_KIND_FALSE, XP_TOKEN_KIND_MINUS, XP_TOKEN_KIND_NO_UPPER, XP_TOKEN_KIND_OPEN_PAREN, XP_TOKEN_KIND_TRUE, XP_TOKEN_KIND_YES_UPPER, 0]) {
        [self unary_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'unaryExpr'."];
    }

}

- (void)unaryExpr_ {
    [self parseRule:@selector(__unaryExpr) withMemo:_unaryExpr_memo];
}

- (void)__negatedUnary {
    
    [self execute:^{
     _negation = NO; 
    }];
    do {
        if ([self predicts:XP_TOKEN_KIND_NOT, 0]) {
            [self match:XP_TOKEN_KIND_NOT discard:YES]; 
        } else if ([self predicts:XP_TOKEN_KIND_BANG, 0]) {
            [self match:XP_TOKEN_KIND_BANG discard:YES]; 
        } else {
            [self raise:@"No viable alternative found in rule 'negatedUnary'."];
        }
        [self execute:^{
         _negation = !_negation; 
        }];
    } while ([self predicts:XP_TOKEN_KIND_BANG, XP_TOKEN_KIND_NOT, 0]);
    [self unary_]; 
    [self execute:^{
    

    }];
    [self execute:^{
    
    if (_negation)
		PUSH([XPNegationExpression negationExpressionWithExpression:POP()]);

    }];

}

- (void)negatedUnary_ {
    [self parseRule:@selector(__negatedUnary) withMemo:_negatedUnary_memo];
}

- (void)__unary {
    
    if ([self predicts:XP_TOKEN_KIND_MINUS, 0]) {
        [self signedFilterExpr_]; 
    } else if ([self predicts:TOKEN_KIND_BUILTIN_NUMBER, TOKEN_KIND_BUILTIN_QUOTEDSTRING, TOKEN_KIND_BUILTIN_WORD, XP_TOKEN_KIND_FALSE, XP_TOKEN_KIND_NO_UPPER, XP_TOKEN_KIND_OPEN_PAREN, XP_TOKEN_KIND_TRUE, XP_TOKEN_KIND_YES_UPPER, 0]) {
        [self filterExpr_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'unary'."];
    }

}

- (void)unary_ {
    [self parseRule:@selector(__unary) withMemo:_unary_memo];
}

- (void)__signedFilterExpr {
    
    [self execute:^{
    
    _negative = NO; 

    }];
    do {
        [self match:XP_TOKEN_KIND_MINUS discard:YES]; 
        [self execute:^{
         _negative = !_negative; 
        }];
    } while ([self predicts:XP_TOKEN_KIND_MINUS, 0]);
    [self filterExpr_]; 
    [self execute:^{
    
    double d = POP_DOUBLE();
    d = (_negative) ? -d : d;
    PUSH([XPNumericValue numericValueWithNumber:d]);

    }];

}

- (void)signedFilterExpr_ {
    [self parseRule:@selector(__signedFilterExpr) withMemo:_signedFilterExpr_memo];
}

- (void)__filterExpr {
    
    [self primaryExpr_]; 
    if ([self speculate:^{ [self match:XP_TOKEN_KIND_PIPE discard:YES]; [self matchWord:NO]; }]) {
        [self match:XP_TOKEN_KIND_PIPE discard:YES]; 
        [self matchWord:NO]; 
        [self execute:^{
        
	NSString *filterName = POP_STR();
	id expr = POP();
	PUSH([XPFilterExpression filterExpressionWithExpression:expr filterName:filterName]);

        }];
    }

}

- (void)filterExpr_ {
    [self parseRule:@selector(__filterExpr) withMemo:_filterExpr_memo];
}

- (void)__primaryExpr {
    
    if ([self predicts:TOKEN_KIND_BUILTIN_NUMBER, TOKEN_KIND_BUILTIN_QUOTEDSTRING, TOKEN_KIND_BUILTIN_WORD, XP_TOKEN_KIND_FALSE, XP_TOKEN_KIND_NO_UPPER, XP_TOKEN_KIND_TRUE, XP_TOKEN_KIND_YES_UPPER, 0]) {
        [self atom_]; 
    } else if ([self predicts:XP_TOKEN_KIND_OPEN_PAREN, 0]) {
        [self subExpr_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'primaryExpr'."];
    }

}

- (void)primaryExpr_ {
    [self parseRule:@selector(__primaryExpr) withMemo:_primaryExpr_memo];
}

- (void)__subExpr {
    
    [self match:XP_TOKEN_KIND_OPEN_PAREN discard:NO]; 
    [self expr_]; 
    [self match:XP_TOKEN_KIND_CLOSE_PAREN discard:YES]; 
    [self execute:^{
    
    id objs = ABOVE(_openParen);
    POP(); // discard `(`
    PUSH_ALL(REV(objs));

    }];

}

- (void)subExpr_ {
    [self parseRule:@selector(__subExpr) withMemo:_subExpr_memo];
}

- (void)__atom {
    
    if ([self predicts:TOKEN_KIND_BUILTIN_NUMBER, TOKEN_KIND_BUILTIN_QUOTEDSTRING, XP_TOKEN_KIND_FALSE, XP_TOKEN_KIND_NO_UPPER, XP_TOKEN_KIND_TRUE, XP_TOKEN_KIND_YES_UPPER, 0]) {
        [self literal_]; 
    } else if ([self predicts:TOKEN_KIND_BUILTIN_WORD, 0]) {
        [self pathExpr_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'atom'."];
    }

}

- (void)atom_ {
    [self parseRule:@selector(__atom) withMemo:_atom_memo];
}

- (void)__pathExpr {
    
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

}

- (void)pathExpr_ {
    [self parseRule:@selector(__pathExpr) withMemo:_pathExpr_memo];
}

- (void)__step {
    
    if ([self predicts:TOKEN_KIND_BUILTIN_WORD, 0]) {
        [self identifier_]; 
    } else if ([self predicts:TOKEN_KIND_BUILTIN_NUMBER, 0]) {
        [self num_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'step'."];
    }

}

- (void)step_ {
    [self parseRule:@selector(__step) withMemo:_step_memo];
}

- (void)__identifier {
    
    [self matchWord:NO]; 
    [self execute:^{
     PUSH(POP_STR()); 
    }];

}

- (void)identifier_ {
    [self parseRule:@selector(__identifier) withMemo:_identifier_memo];
}

- (void)__literal {
    
    if ([self predicts:TOKEN_KIND_BUILTIN_QUOTEDSTRING, 0]) {
        [self str_]; 
    } else if ([self predicts:TOKEN_KIND_BUILTIN_NUMBER, 0]) {
        [self num_]; 
    } else if ([self predicts:XP_TOKEN_KIND_FALSE, XP_TOKEN_KIND_NO_UPPER, XP_TOKEN_KIND_TRUE, XP_TOKEN_KIND_YES_UPPER, 0]) {
        [self bool_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'literal'."];
    }

}

- (void)literal_ {
    [self parseRule:@selector(__literal) withMemo:_literal_memo];
}

- (void)__bool {
    
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

}

- (void)bool_ {
    [self parseRule:@selector(__bool) withMemo:_bool_memo];
}

- (void)__true {
    
    if ([self predicts:XP_TOKEN_KIND_TRUE, 0]) {
        [self match:XP_TOKEN_KIND_TRUE discard:YES]; 
    } else if ([self predicts:XP_TOKEN_KIND_YES_UPPER, 0]) {
        [self match:XP_TOKEN_KIND_YES_UPPER discard:YES]; 
    } else {
        [self raise:@"No viable alternative found in rule 'true'."];
    }

}

- (void)true_ {
    [self parseRule:@selector(__true) withMemo:_true_memo];
}

- (void)__false {
    
    if ([self predicts:XP_TOKEN_KIND_FALSE, 0]) {
        [self match:XP_TOKEN_KIND_FALSE discard:YES]; 
    } else if ([self predicts:XP_TOKEN_KIND_NO_UPPER, 0]) {
        [self match:XP_TOKEN_KIND_NO_UPPER discard:YES]; 
    } else {
        [self raise:@"No viable alternative found in rule 'false'."];
    }

}

- (void)false_ {
    [self parseRule:@selector(__false) withMemo:_false_memo];
}

- (void)__num {
    
    [self matchNumber:NO]; 
    [self execute:^{
    
    PUSH([XPNumericValue numericValueWithNumber:POP_DOUBLE()]);

    }];

}

- (void)num_ {
    [self parseRule:@selector(__num) withMemo:_num_memo];
}

- (void)__str {
    
    [self matchQuotedString:NO]; 
    [self execute:^{
    
    PUSH([XPStringValue stringValueWithString:POP_QUOTED_STR()]);

    }];

}

- (void)str_ {
    [self parseRule:@selector(__str) withMemo:_str_memo];
}

@end