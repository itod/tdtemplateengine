#import "TDParser.h"
#import <PEGKit/PEGKit.h>
    
#import "TDTemplateEngine.h"
#import "TDBooleanValue.h"
#import "TDNumericValue.h"
#import "TDStringValue.h"
#import "TDObjectValue.h"
#import "TDUnaryExpression.h"
#import "TDNegationExpression.h"
#import "TDBooleanExpression.h"
#import "TDRelationalExpression.h"
#import "TDArithmeticExpression.h"
#import "TDLoopExpression.h"
#import "TDCollectionExpression.h"
#import "TDRangeExpression.h"
#import "TDPathExpression.h"
#import "TDFilterExpression.h"


@interface TDParser ()
    
@property (nonatomic, retain) PKToken *openParen;
@property (nonatomic, retain) PKToken *minus;
@property (nonatomic, retain) PKToken *colon;
@property (nonatomic, assign) BOOL negation;
@property (nonatomic, assign) BOOL negative;

@end

@implementation TDParser { }
    
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


- (instancetype)initWithDelegate:(id)d {
    self = [super initWithDelegate:d];
    if (self) {
            
    self.enableVerboseErrorReporting = NO;
    self.tokenizer = [[self class] tokenizer];
    self.openParen = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"(" doubleValue:0.0];
    self.minus = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"-" doubleValue:0.0];
    self.colon = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@":" doubleValue:0.0];

        self.startRuleName = @"expr";
        self.tokenKindTab[@"gt"] = @(TD_TOKEN_KIND_GT);
        self.tokenKindTab[@">="] = @(TD_TOKEN_KIND_GE_SYM);
        self.tokenKindTab[@"&&"] = @(TD_TOKEN_KIND_DOUBLE_AMPERSAND);
        self.tokenKindTab[@"|"] = @(TD_TOKEN_KIND_PIPE);
        self.tokenKindTab[@"true"] = @(TD_TOKEN_KIND_TRUE);
        self.tokenKindTab[@"!="] = @(TD_TOKEN_KIND_NOT_EQUAL);
        self.tokenKindTab[@"!"] = @(TD_TOKEN_KIND_BANG);
        self.tokenKindTab[@":"] = @(TD_TOKEN_KIND_COLON);
        self.tokenKindTab[@"<"] = @(TD_TOKEN_KIND_LT_SYM);
        self.tokenKindTab[@"%"] = @(TD_TOKEN_KIND_MOD);
        self.tokenKindTab[@"le"] = @(TD_TOKEN_KIND_LE);
        self.tokenKindTab[@">"] = @(TD_TOKEN_KIND_GT_SYM);
        self.tokenKindTab[@"lt"] = @(TD_TOKEN_KIND_LT);
        self.tokenKindTab[@"("] = @(TD_TOKEN_KIND_OPEN_PAREN);
        self.tokenKindTab[@")"] = @(TD_TOKEN_KIND_CLOSE_PAREN);
        self.tokenKindTab[@"eq"] = @(TD_TOKEN_KIND_EQ);
        self.tokenKindTab[@"ne"] = @(TD_TOKEN_KIND_NE);
        self.tokenKindTab[@"or"] = @(TD_TOKEN_KIND_OR);
        self.tokenKindTab[@"not"] = @(TD_TOKEN_KIND_NOT);
        self.tokenKindTab[@"*"] = @(TD_TOKEN_KIND_TIMES);
        self.tokenKindTab[@"+"] = @(TD_TOKEN_KIND_PLUS);
        self.tokenKindTab[@"||"] = @(TD_TOKEN_KIND_DOUBLE_PIPE);
        self.tokenKindTab[@","] = @(TD_TOKEN_KIND_COMMA);
        self.tokenKindTab[@"and"] = @(TD_TOKEN_KIND_AND);
        self.tokenKindTab[@"YES"] = @(TD_TOKEN_KIND_YES_UPPER);
        self.tokenKindTab[@"-"] = @(TD_TOKEN_KIND_MINUS);
        self.tokenKindTab[@"in"] = @(TD_TOKEN_KIND_IN);
        self.tokenKindTab[@"."] = @(TD_TOKEN_KIND_DOT);
        self.tokenKindTab[@"/"] = @(TD_TOKEN_KIND_DIV);
        self.tokenKindTab[@"by"] = @(TD_TOKEN_KIND_BY);
        self.tokenKindTab[@"false"] = @(TD_TOKEN_KIND_FALSE);
        self.tokenKindTab[@"<="] = @(TD_TOKEN_KIND_LE_SYM);
        self.tokenKindTab[@"to"] = @(TD_TOKEN_KIND_TO);
        self.tokenKindTab[@"ge"] = @(TD_TOKEN_KIND_GE);
        self.tokenKindTab[@"NO"] = @(TD_TOKEN_KIND_NO_UPPER);
        self.tokenKindTab[@"=="] = @(TD_TOKEN_KIND_DOUBLE_EQUALS);
        self.tokenKindTab[@"null"] = @(TD_TOKEN_KIND_NULL);

        self.tokenKindNameTab[TD_TOKEN_KIND_GT] = @"gt";
        self.tokenKindNameTab[TD_TOKEN_KIND_GE_SYM] = @">=";
        self.tokenKindNameTab[TD_TOKEN_KIND_DOUBLE_AMPERSAND] = @"&&";
        self.tokenKindNameTab[TD_TOKEN_KIND_PIPE] = @"|";
        self.tokenKindNameTab[TD_TOKEN_KIND_TRUE] = @"true";
        self.tokenKindNameTab[TD_TOKEN_KIND_NOT_EQUAL] = @"!=";
        self.tokenKindNameTab[TD_TOKEN_KIND_BANG] = @"!";
        self.tokenKindNameTab[TD_TOKEN_KIND_COLON] = @":";
        self.tokenKindNameTab[TD_TOKEN_KIND_LT_SYM] = @"<";
        self.tokenKindNameTab[TD_TOKEN_KIND_MOD] = @"%";
        self.tokenKindNameTab[TD_TOKEN_KIND_LE] = @"le";
        self.tokenKindNameTab[TD_TOKEN_KIND_GT_SYM] = @">";
        self.tokenKindNameTab[TD_TOKEN_KIND_LT] = @"lt";
        self.tokenKindNameTab[TD_TOKEN_KIND_OPEN_PAREN] = @"(";
        self.tokenKindNameTab[TD_TOKEN_KIND_CLOSE_PAREN] = @")";
        self.tokenKindNameTab[TD_TOKEN_KIND_EQ] = @"eq";
        self.tokenKindNameTab[TD_TOKEN_KIND_NE] = @"ne";
        self.tokenKindNameTab[TD_TOKEN_KIND_OR] = @"or";
        self.tokenKindNameTab[TD_TOKEN_KIND_NOT] = @"not";
        self.tokenKindNameTab[TD_TOKEN_KIND_TIMES] = @"*";
        self.tokenKindNameTab[TD_TOKEN_KIND_PLUS] = @"+";
        self.tokenKindNameTab[TD_TOKEN_KIND_DOUBLE_PIPE] = @"||";
        self.tokenKindNameTab[TD_TOKEN_KIND_COMMA] = @",";
        self.tokenKindNameTab[TD_TOKEN_KIND_AND] = @"and";
        self.tokenKindNameTab[TD_TOKEN_KIND_YES_UPPER] = @"YES";
        self.tokenKindNameTab[TD_TOKEN_KIND_MINUS] = @"-";
        self.tokenKindNameTab[TD_TOKEN_KIND_IN] = @"in";
        self.tokenKindNameTab[TD_TOKEN_KIND_DOT] = @".";
        self.tokenKindNameTab[TD_TOKEN_KIND_DIV] = @"/";
        self.tokenKindNameTab[TD_TOKEN_KIND_BY] = @"by";
        self.tokenKindNameTab[TD_TOKEN_KIND_FALSE] = @"false";
        self.tokenKindNameTab[TD_TOKEN_KIND_LE_SYM] = @"<=";
        self.tokenKindNameTab[TD_TOKEN_KIND_TO] = @"to";
        self.tokenKindNameTab[TD_TOKEN_KIND_GE] = @"ge";
        self.tokenKindNameTab[TD_TOKEN_KIND_NO_UPPER] = @"NO";
        self.tokenKindNameTab[TD_TOKEN_KIND_DOUBLE_EQUALS] = @"==";
        self.tokenKindNameTab[TD_TOKEN_KIND_NULL] = @"null";

    }
    return self;
}

- (void)dealloc {
        
    self.engine = nil;
    self.openParen = nil;
    self.minus = nil;
    self.colon = nil;


    [super dealloc];
}

- (void)start {

    [self expr_]; 
    [self matchEOF:YES]; 

}

- (void)expr_ {
    
    if (self.doLoopExpr) {
        [self loopExpr_]; 
    } else {
        [self orExpr_]; 
    }

}

- (void)loopExpr_ {
    
    [self identifiers_]; 
    [self match:TD_TOKEN_KIND_IN discard:YES]; 
    [self enumExpr_]; 
    [self execute:^{
    
	id enumExpr = POP();
	id vars = POP();
	PUSH([TDLoopExpression loopExpressionWithVariables:vars enumeration:enumExpr]);

    }];

}

- (void)identifiers_ {
    
    [self execute:^{
     PUSH(_openParen); 
    }];
    [self identifier_]; 
    if ([self predicts:TD_TOKEN_KIND_COMMA, 0]) {
        [self match:TD_TOKEN_KIND_COMMA discard:YES]; 
        [self identifier_]; 
    }
    [self execute:^{
    
	id strs = REV(ABOVE(_openParen));
	POP(); // discard `(`
	PUSH(strs);

    }];

}

- (void)enumExpr_ {
    
    if ([self speculate:^{ [self rangeExpr_]; }]) {
        [self rangeExpr_]; 
    } else if ([self speculate:^{ [self collectionExpr_]; }]) {
        [self collectionExpr_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'enumExpr'."];
    }

}

- (void)collectionExpr_ {
    
    [self primaryExpr_]; 
    [self execute:^{
    
	id expr = POP();
	PUSH([TDCollectionExpression collectionExpressionWithExpression:expr]);

    }];

}

- (void)rangeExpr_ {
    
    [self unaryExpr_]; 
    [self match:TD_TOKEN_KIND_TO discard:YES]; 
    [self unaryExpr_]; 
    [self optBy_]; 
    [self execute:^{
    
	id by = POP();
	id stop = POP();
	id start = POP();
	PUSH([TDRangeExpression rangeExpressionWithStart:start stop:stop by:by]);

    }];

}

- (void)optBy_ {
    
    if ([self predicts:TD_TOKEN_KIND_BY, 0]) {
        [self match:TD_TOKEN_KIND_BY discard:YES]; 
        [self unaryExpr_]; 
    } else {
        [self matchEmpty:NO]; 
        [self execute:^{
         PUSH([TDNumericValue numericValueWithNumber:0.0]); 
        }];
    }

}

- (void)orOp_ {
    
    if ([self predicts:TD_TOKEN_KIND_OR, 0]) {
        [self match:TD_TOKEN_KIND_OR discard:YES]; 
    } else if ([self predicts:TD_TOKEN_KIND_DOUBLE_PIPE, 0]) {
        [self match:TD_TOKEN_KIND_DOUBLE_PIPE discard:YES]; 
    } else {
        [self raise:@"No viable alternative found in rule 'orOp'."];
    }

}

- (void)orExpr_ {
    
    [self andExpr_]; 
    while ([self predicts:TD_TOKEN_KIND_OR, TD_TOKEN_KIND_DOUBLE_PIPE, 0]) {
        [self orOp_]; 
        [self andExpr_]; 
        [self execute:^{
        
    TDValue *rhs = POP();
    TDValue *lhs = POP();
    PUSH([TDBooleanExpression booleanExpressionWithOperand:lhs operator:TD_TOKEN_KIND_OR operand:rhs]);

        }];
    }

}

- (void)andOp_ {
    
    if ([self predicts:TD_TOKEN_KIND_AND, 0]) {
        [self match:TD_TOKEN_KIND_AND discard:YES]; 
    } else if ([self predicts:TD_TOKEN_KIND_DOUBLE_AMPERSAND, 0]) {
        [self match:TD_TOKEN_KIND_DOUBLE_AMPERSAND discard:YES]; 
    } else {
        [self raise:@"No viable alternative found in rule 'andOp'."];
    }

}

- (void)andExpr_ {
    
    [self equalityExpr_]; 
    while ([self predicts:TD_TOKEN_KIND_AND, TD_TOKEN_KIND_DOUBLE_AMPERSAND, 0]) {
        [self andOp_]; 
        [self equalityExpr_]; 
        [self execute:^{
        
    TDValue *rhs = POP();
    TDValue *lhs = POP();
    PUSH([TDBooleanExpression booleanExpressionWithOperand:lhs operator:TD_TOKEN_KIND_AND operand:rhs]);

        }];
    }

}

- (void)eqOp_ {
    
    if ([self predicts:TD_TOKEN_KIND_DOUBLE_EQUALS, 0]) {
        [self match:TD_TOKEN_KIND_DOUBLE_EQUALS discard:YES]; 
    } else if ([self predicts:TD_TOKEN_KIND_EQ, 0]) {
        [self match:TD_TOKEN_KIND_EQ discard:YES]; 
    } else {
        [self raise:@"No viable alternative found in rule 'eqOp'."];
    }
    [self execute:^{
     PUSH(@(TD_TOKEN_KIND_EQ)); 
    }];

}

- (void)neOp_ {
    
    if ([self predicts:TD_TOKEN_KIND_NOT_EQUAL, 0]) {
        [self match:TD_TOKEN_KIND_NOT_EQUAL discard:YES]; 
    } else if ([self predicts:TD_TOKEN_KIND_NE, 0]) {
        [self match:TD_TOKEN_KIND_NE discard:YES]; 
    } else {
        [self raise:@"No viable alternative found in rule 'neOp'."];
    }
    [self execute:^{
     PUSH(@(TD_TOKEN_KIND_NE)); 
    }];

}

- (void)equalityExpr_ {
    
    [self relationalExpr_]; 
    while ([self predicts:TD_TOKEN_KIND_DOUBLE_EQUALS, TD_TOKEN_KIND_EQ, TD_TOKEN_KIND_NE, TD_TOKEN_KIND_NOT_EQUAL, 0]) {
        if ([self predicts:TD_TOKEN_KIND_DOUBLE_EQUALS, TD_TOKEN_KIND_EQ, 0]) {
            [self eqOp_]; 
        } else if ([self predicts:TD_TOKEN_KIND_NE, TD_TOKEN_KIND_NOT_EQUAL, 0]) {
            [self neOp_]; 
        } else {
            [self raise:@"No viable alternative found in rule 'equalityExpr'."];
        }
        [self relationalExpr_]; 
        [self execute:^{
        
    TDValue *rhs = POP();
    NSInteger op = POP_INT();
    TDValue *lhs = POP();
    PUSH([TDRelationalExpression relationalExpressionWithOperand:lhs operator:op operand:rhs]);

        }];
    }

}

- (void)ltOp_ {
    
    if ([self predicts:TD_TOKEN_KIND_LT_SYM, 0]) {
        [self match:TD_TOKEN_KIND_LT_SYM discard:YES]; 
    } else if ([self predicts:TD_TOKEN_KIND_LT, 0]) {
        [self match:TD_TOKEN_KIND_LT discard:YES]; 
    } else {
        [self raise:@"No viable alternative found in rule 'ltOp'."];
    }
    [self execute:^{
     PUSH(@(TD_TOKEN_KIND_LT)); 
    }];

}

- (void)gtOp_ {
    
    if ([self predicts:TD_TOKEN_KIND_GT_SYM, 0]) {
        [self match:TD_TOKEN_KIND_GT_SYM discard:YES]; 
    } else if ([self predicts:TD_TOKEN_KIND_GT, 0]) {
        [self match:TD_TOKEN_KIND_GT discard:YES]; 
    } else {
        [self raise:@"No viable alternative found in rule 'gtOp'."];
    }
    [self execute:^{
     PUSH(@(TD_TOKEN_KIND_GT)); 
    }];

}

- (void)leOp_ {
    
    if ([self predicts:TD_TOKEN_KIND_LE_SYM, 0]) {
        [self match:TD_TOKEN_KIND_LE_SYM discard:YES]; 
    } else if ([self predicts:TD_TOKEN_KIND_LE, 0]) {
        [self match:TD_TOKEN_KIND_LE discard:YES]; 
    } else {
        [self raise:@"No viable alternative found in rule 'leOp'."];
    }
    [self execute:^{
     PUSH(@(TD_TOKEN_KIND_LE)); 
    }];

}

- (void)geOp_ {
    
    if ([self predicts:TD_TOKEN_KIND_GE_SYM, 0]) {
        [self match:TD_TOKEN_KIND_GE_SYM discard:YES]; 
    } else if ([self predicts:TD_TOKEN_KIND_GE, 0]) {
        [self match:TD_TOKEN_KIND_GE discard:YES]; 
    } else {
        [self raise:@"No viable alternative found in rule 'geOp'."];
    }
    [self execute:^{
     PUSH(@(TD_TOKEN_KIND_GE)); 
    }];

}

- (void)relationalExpr_ {
    
    [self additiveExpr_]; 
    while ([self predicts:TD_TOKEN_KIND_LT, TD_TOKEN_KIND_LT_SYM, TD_TOKEN_KIND_GT, TD_TOKEN_KIND_GT_SYM, TD_TOKEN_KIND_LE, TD_TOKEN_KIND_LE_SYM, TD_TOKEN_KIND_GE, TD_TOKEN_KIND_GE_SYM, 0]) {
        if ([self predicts:TD_TOKEN_KIND_LT, TD_TOKEN_KIND_LT_SYM, 0]) {
            [self ltOp_]; 
        } else if ([self predicts:TD_TOKEN_KIND_GT, TD_TOKEN_KIND_GT_SYM, 0]) {
            [self gtOp_]; 
        } else if ([self predicts:TD_TOKEN_KIND_LE, TD_TOKEN_KIND_LE_SYM, 0]) {
            [self leOp_]; 
        } else if ([self predicts:TD_TOKEN_KIND_GE, TD_TOKEN_KIND_GE_SYM, 0]) {
            [self geOp_]; 
        } else {
            [self raise:@"No viable alternative found in rule 'relationalExpr'."];
        }
        [self additiveExpr_]; 
        [self execute:^{
        
    TDValue *rhs = POP();
    NSInteger op = POP_INT();
    TDValue *lhs = POP();
    PUSH([TDRelationalExpression relationalExpressionWithOperand:lhs operator:op operand:rhs]);

        }];
    }

}

- (void)plus_ {
    
    [self match:TD_TOKEN_KIND_PLUS discard:YES]; 
    [self execute:^{
     PUSH(@(TD_TOKEN_KIND_PLUS)); 
    }];

}

- (void)minus_ {
    
    [self match:TD_TOKEN_KIND_MINUS discard:YES]; 
    [self execute:^{
     PUSH(@(TD_TOKEN_KIND_MINUS)); 
    }];

}

- (void)additiveExpr_ {
    
    [self multiplicativeExpr_]; 
    while ([self predicts:TD_TOKEN_KIND_PLUS, TD_TOKEN_KIND_MINUS, 0]) {
        if ([self predicts:TD_TOKEN_KIND_PLUS, 0]) {
            [self plus_]; 
        } else if ([self predicts:TD_TOKEN_KIND_MINUS, 0]) {
            [self minus_]; 
        } else {
            [self raise:@"No viable alternative found in rule 'additiveExpr'."];
        }
        [self multiplicativeExpr_]; 
        [self execute:^{
        
    TDValue *rhs = POP();
    NSInteger op = POP_INT();
    TDValue *lhs = POP();
    PUSH([TDArithmeticExpression arithmeticExpressionWithOperand:lhs operator:op operand:rhs]);

        }];
    }

}

- (void)times_ {
    
    [self match:TD_TOKEN_KIND_TIMES discard:YES]; 
    [self execute:^{
     PUSH(@(TD_TOKEN_KIND_TIMES)); 
    }];

}

- (void)div_ {
    
    [self match:TD_TOKEN_KIND_DIV discard:YES]; 
    [self execute:^{
     PUSH(@(TD_TOKEN_KIND_DIV)); 
    }];

}

- (void)mod_ {
    
    [self match:TD_TOKEN_KIND_MOD discard:YES]; 
    [self execute:^{
     PUSH(@(TD_TOKEN_KIND_MOD)); 
    }];

}

- (void)multiplicativeExpr_ {
    
    [self unaryExpr_]; 
    while ([self predicts:TD_TOKEN_KIND_TIMES, TD_TOKEN_KIND_DIV, TD_TOKEN_KIND_MOD, 0]) {
        if ([self predicts:TD_TOKEN_KIND_TIMES, 0]) {
            [self times_]; 
        } else if ([self predicts:TD_TOKEN_KIND_DIV, 0]) {
            [self div_]; 
        } else if ([self predicts:TD_TOKEN_KIND_MOD, 0]) {
            [self mod_]; 
        } else {
            [self raise:@"No viable alternative found in rule 'multiplicativeExpr'."];
        }
        [self unaryExpr_]; 
        [self execute:^{
        
    TDValue *rhs = POP();
    NSInteger op = POP_INT();
    TDValue *lhs = POP();
    PUSH([TDArithmeticExpression arithmeticExpressionWithOperand:lhs operator:op operand:rhs]);

        }];
    }

}

- (void)unaryExpr_ {
    
    if ([self predicts:TD_TOKEN_KIND_BANG, TD_TOKEN_KIND_NOT, 0]) {
        [self negatedUnary_]; 
    } else if ([self predicts:TOKEN_KIND_BUILTIN_NUMBER, TOKEN_KIND_BUILTIN_QUOTEDSTRING, TOKEN_KIND_BUILTIN_WORD, TD_TOKEN_KIND_FALSE, TD_TOKEN_KIND_MINUS, TD_TOKEN_KIND_NO_UPPER, TD_TOKEN_KIND_OPEN_PAREN, TD_TOKEN_KIND_TRUE, TD_TOKEN_KIND_YES_UPPER, TD_TOKEN_KIND_NULL, 0]) {
        [self unary_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'unaryExpr'."];
    }

}

- (void)negatedUnary_ {
    
    [self execute:^{
     _negation = NO; 
    }];
    do {
        if ([self predicts:TD_TOKEN_KIND_NOT, 0]) {
            [self match:TD_TOKEN_KIND_NOT discard:YES]; 
        } else if ([self predicts:TD_TOKEN_KIND_BANG, 0]) {
            [self match:TD_TOKEN_KIND_BANG discard:YES]; 
        } else {
            [self raise:@"No viable alternative found in rule 'negatedUnary'."];
        }
        [self execute:^{
         _negation = !_negation; 
        }];
    } while ([self predicts:TD_TOKEN_KIND_BANG, TD_TOKEN_KIND_NOT, 0]);
    [self unary_]; 
    [self execute:^{
    

    }];
    [self execute:^{
    
    if (_negation)
		PUSH([TDNegationExpression negationExpressionWithExpression:POP()]);

    }];

}

- (void)unary_ {
    
    if ([self predicts:TD_TOKEN_KIND_MINUS, 0]) {
        [self signedFilterExpr_]; 
    } else if ([self predicts:TOKEN_KIND_BUILTIN_NUMBER, TOKEN_KIND_BUILTIN_QUOTEDSTRING, TOKEN_KIND_BUILTIN_WORD, TD_TOKEN_KIND_FALSE, TD_TOKEN_KIND_NO_UPPER, TD_TOKEN_KIND_OPEN_PAREN, TD_TOKEN_KIND_TRUE, TD_TOKEN_KIND_YES_UPPER, TD_TOKEN_KIND_NULL, 0]) {
        [self filterExpr_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'unary'."];
    }

}

- (void)signedFilterExpr_ {
    
    [self execute:^{
    
    _negative = NO; 

    }];
    do {
        [self match:TD_TOKEN_KIND_MINUS discard:YES]; 
        [self execute:^{
         _negative = !_negative; 
        }];
    } while ([self predicts:TD_TOKEN_KIND_MINUS, 0]);
    [self filterExpr_]; 
    [self execute:^{
    
    if (_negative)
		PUSH([TDUnaryExpression unaryExpressionWithExpression:POP()]);

    }];

}

- (void)filterExpr_ {
    
    [self primaryExpr_]; 
    while ([self predicts:TD_TOKEN_KIND_PIPE, 0]) {
        [self filter_]; 
        [self execute:^{
        
	NSArray *args = POP();
	NSString *filterName = POP_STR();
	id expr = POP();
    ASSERT(_engine);
    TDFilter *filter = nil;
    @try {
        filter = [_engine makeFilterForName:filterName];
    } @catch (NSException *ex) {
        [self raise:[ex reason]];
    }
    ASSERT(filter);
    PUSH([TDFilterExpression filterExpressionWithExpression:expr filter:filter arguments:args]);
            
        }];
    }

}

- (void)filter_ {
    
    [self match:TD_TOKEN_KIND_PIPE discard:YES]; 
    [self matchWord:NO]; 
    [self filterArgs_]; 

}

- (void)filterArgs_ {
    
    if ([self predicts:TD_TOKEN_KIND_COLON, 0]) {
        [self match:TD_TOKEN_KIND_COLON discard:NO]; 
        [self filterArg_]; 
        while ([self predicts:TD_TOKEN_KIND_COMMA, 0]) {
            [self match:TD_TOKEN_KIND_COMMA discard:YES]; 
            [self filterArg_]; 
        }
        [self execute:^{
         id toks = ABOVE(_colon); POP(); PUSH(REV(toks)); 
        }];
    } else {
        [self matchEmpty:NO]; 
        [self execute:^{
         PUSH(@[]); 
        }];
    }

}

- (void)filterArg_ {
    
    if ([self predicts:TOKEN_KIND_BUILTIN_QUOTEDSTRING, 0]) {
        [self matchQuotedString:NO]; 
    } else if ([self predicts:TOKEN_KIND_BUILTIN_WORD, 0]) {
        [self matchWord:NO]; 
    } else {
        [self raise:@"No viable alternative found in rule 'filterArg'."];
    }

}

- (void)primaryExpr_ {
    
    if ([self predicts:TOKEN_KIND_BUILTIN_NUMBER, TOKEN_KIND_BUILTIN_QUOTEDSTRING, TOKEN_KIND_BUILTIN_WORD, TD_TOKEN_KIND_FALSE, TD_TOKEN_KIND_NO_UPPER, TD_TOKEN_KIND_TRUE, TD_TOKEN_KIND_YES_UPPER, TD_TOKEN_KIND_NULL, 0]) {
        [self atom_]; 
    } else if ([self predicts:TD_TOKEN_KIND_OPEN_PAREN, 0]) {
        [self subExpr_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'primaryExpr'."];
    }

}

- (void)subExpr_ {
    
    [self match:TD_TOKEN_KIND_OPEN_PAREN discard:NO]; 
    [self expr_]; 
    [self match:TD_TOKEN_KIND_CLOSE_PAREN discard:YES]; 
    [self execute:^{
    
    id objs = ABOVE(_openParen);
    POP(); // discard `(`
    PUSH_ALL(REV(objs));

    }];

}

- (void)atom_ {
    
    if ([self predicts:TOKEN_KIND_BUILTIN_NUMBER, TOKEN_KIND_BUILTIN_QUOTEDSTRING, TD_TOKEN_KIND_FALSE, TD_TOKEN_KIND_NO_UPPER, TD_TOKEN_KIND_TRUE, TD_TOKEN_KIND_YES_UPPER, TD_TOKEN_KIND_NULL, 0]) {
        [self literal_]; 
    } else if ([self predicts:TOKEN_KIND_BUILTIN_WORD, 0]) {
        [self pathExpr_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'atom'."];
    }

}

- (void)pathExpr_ {
    
    [self execute:^{
    
    PUSH(_openParen);

    }];
    [self identifier_]; 
    while ([self predicts:TD_TOKEN_KIND_DOT, 0]) {
        [self match:TD_TOKEN_KIND_DOT discard:YES]; 
        [self step_]; 
    }
    [self execute:^{
    
    id toks = REV(ABOVE(_openParen));
    POP(); // discard `_openParen`
    PUSH([TDPathExpression pathExpressionWithSteps:toks]);

    }];

}

- (void)step_ {
    
    if ([self predicts:TOKEN_KIND_BUILTIN_WORD, 0]) {
        [self identifier_]; 
    } else if ([self predicts:TOKEN_KIND_BUILTIN_NUMBER, 0]) {
        [self num_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'step'."];
    }

}

- (void)identifier_ {
    
    [self matchWord:NO]; 
    [self execute:^{
     PUSH(POP_STR()); 
    }];

}

- (void)literal_ {
    
    if ([self predicts:TOKEN_KIND_BUILTIN_QUOTEDSTRING, 0]) {
        [self str_]; 
    } else if ([self predicts:TOKEN_KIND_BUILTIN_NUMBER, 0]) {
        [self num_]; 
    } else if ([self predicts:TD_TOKEN_KIND_FALSE, TD_TOKEN_KIND_NO_UPPER, TD_TOKEN_KIND_TRUE, TD_TOKEN_KIND_YES_UPPER, 0]) {
        [self bool_]; 
    } else if ([self predicts:TD_TOKEN_KIND_NULL, 0]) {
        [self null_];
    } else {
        [self raise:@"No viable alternative found in rule 'literal'."];
    }

}

- (void)bool_ {
    
    if ([self predicts:TD_TOKEN_KIND_TRUE, TD_TOKEN_KIND_YES_UPPER, 0]) {
        [self true_]; 
        [self execute:^{
         PUSH([TDBooleanValue booleanValueWithBoolean:YES]); 
        }];
    } else if ([self predicts:TD_TOKEN_KIND_FALSE, TD_TOKEN_KIND_NO_UPPER, 0]) {
        [self false_]; 
        [self execute:^{
         PUSH([TDBooleanValue booleanValueWithBoolean:NO]); 
        }];
    } else {
        [self raise:@"No viable alternative found in rule 'bool'."];
    }

}

- (void)true_ {
    
    if ([self predicts:TD_TOKEN_KIND_TRUE, 0]) {
        [self match:TD_TOKEN_KIND_TRUE discard:YES]; 
    } else if ([self predicts:TD_TOKEN_KIND_YES_UPPER, 0]) {
        [self match:TD_TOKEN_KIND_YES_UPPER discard:YES]; 
    } else {
        [self raise:@"No viable alternative found in rule 'true'."];
    }

}

- (void)false_ {
    
    if ([self predicts:TD_TOKEN_KIND_FALSE, 0]) {
        [self match:TD_TOKEN_KIND_FALSE discard:YES]; 
    } else if ([self predicts:TD_TOKEN_KIND_NO_UPPER, 0]) {
        [self match:TD_TOKEN_KIND_NO_UPPER discard:YES]; 
    } else {
        [self raise:@"No viable alternative found in rule 'false'."];
    }

}

- (void)num_ {
    
    [self matchNumber:NO]; 
    [self execute:^{
    
    PUSH([TDNumericValue numericValueWithNumber:POP_DOUBLE()]);

    }];

}

- (void)str_ {
    
    [self matchQuotedString:NO]; 
    [self execute:^{
    
    PUSH([TDStringValue stringValueWithString:POP_QUOTED_STR()]);

    }];

}

- (void)null_ {
    
    [self match:TD_TOKEN_KIND_NULL discard:YES];
    [self execute:^{
    
    PUSH([TDObjectValue objectValueWithObject:[NSNull null]]);

    }];

}

@end
