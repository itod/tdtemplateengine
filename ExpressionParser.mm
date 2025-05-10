#import "ExpressionParser.h"
    
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

#import <ParseKitCPP/ModalTokenizer.hpp>
#import <ParseKitCPP/DefaultTokenizerMode.hpp>

#define PUSH(obj) _assembly->push_object((obj))
#define POP(obj) _assembly->pop_object((obj))

namespace parsekit {

//@interface ExpressionParser ()
//
//@property (nonatomic, retain) PKToken *openParen;
//@property (nonatomic, retain) PKToken *minus;
//@property (nonatomic, retain) PKToken *colon;
//@property (nonatomic, assign) BOOL negation;
//@property (nonatomic, assign) BOOL negative;
//
//@end
    

ExpressionParser::ExpressionParser() :
    _tokenizer(nullptr)
{
    DefaultTokenizerModePtr mode(new DefaultTokenizerMode());
    _tokenizer = ModalTokenizerPtr(new ModalTokenizer(mode));
    
    mode->getSymbolState()->add("==");
    mode->getSymbolState()->add("!=");
    mode->getSymbolState()->add("<=");
    mode->getSymbolState()->add(">=");
    mode->getSymbolState()->add("&&");
    mode->getSymbolState()->add("||");
    
    mode->set_tokenizer_state(mode->getSymbolState(), '-', '-');
    mode->getWordState()->setWordChars(false, '\'', '\'');

}

void ExpressionParser::start() {

    _expr();
    match(TokenType_EOF);

}

void ExpressionParser::_expr() {
    
    if (_doLoopExpr) {
        _loopExpr();
    } else {
        _orExpr();
    }

}

void ExpressionParser::_loopExpr() {
    
    _identifiers();
    match(TD_TOKEN_KIND_IN, true);
    _enumExpr();
    {
    
    id enumExpr = POP();
    id vars = POP();
    PUSH([TDLoopExpression loopExpressionWithVariables:vars enumeration:enumExpr]);

    }

}

void ExpressionParser::_identifiers() {
    
    {
     PUSH(_openParen);
    }
    _identifier();
    if (predicts(TD_TOKEN_KIND_COMMA, 0)) {
        match(TD_TOKEN_KIND_COMMA, true);
        _identifier();
    }
    {
    
    id strs = REV(ABOVE(_openParen));
    POP(); // discard `(`
    PUSH(strs);

    }

}

void ExpressionParser::_enumExpr() {
    
    if ([self speculate:^{ _rangeExpr(); }]) {
        _rangeExpr();
    } else if ([self speculate:^{ _collectionExpr(); }]) {
        _collectionExpr();
    } else {
        raise("No viable alternative found in rule 'enumExpr'.");
    }

}

void ExpressionParser::_collectionExpr() {
    
    _primaryExpr();
    {
    
    id expr = POP();
    PUSH([TDCollectionExpression collectionExpressionWithExpression:expr]);

    }

}

void ExpressionParser::_rangeExpr() {
    
    _unaryExpr();
    match(TD_TOKEN_KIND_TO, true);
    _unaryExpr();
    _optBy();
    {
    
    id by = POP();
    id stop = POP();
    id start = POP();
    PUSH([TDRangeExpression rangeExpressionWithStart:start stop:stop by:by]);

    }

}

void ExpressionParser::_optBy() {
    
    if (predicts(TD_TOKEN_KIND_BY, 0)) {
        match(TD_TOKEN_KIND_BY, true);
        _unaryExpr();
    } else {
        //[self matchEmpty:NO];
        {
         PUSH([TDNumericValue numericValueWithNumber:0.0]);
        }
    }

}

void ExpressionParser::_orOp() {
    
    if (predicts(TD_TOKEN_KIND_OR, 0)) {
        match(TD_TOKEN_KIND_OR, true);
    } else if (predicts(TD_TOKEN_KIND_DOUBLE_PIPE, 0)) {
        match(TD_TOKEN_KIND_DOUBLE_PIPE, true);
    } else {
        raise("No viable alternative found in rule 'orOp'.");
    }

}

void ExpressionParser::_orExpr() {
    
    _andExpr();
    while (predicts(TD_TOKEN_KIND_OR, TD_TOKEN_KIND_DOUBLE_PIPE, 0)) {
        _orOp();
        _andExpr();
        {
        
    TDValue *rhs = POP();
    TDValue *lhs = POP();
    PUSH([TDBooleanExpression booleanExpressionWithOperand:lhs operator:TD_TOKEN_KIND_OR operand:rhs]);

        }
    }

}

void ExpressionParser::_andOp() {
    
    if (predicts(TD_TOKEN_KIND_AND, 0)) {
        match(TD_TOKEN_KIND_AND, true);
    } else if (predicts(TD_TOKEN_KIND_DOUBLE_AMPERSAND, 0)) {
        match(TD_TOKEN_KIND_DOUBLE_AMPERSAND, true);
    } else {
        raise("No viable alternative found in rule 'andOp'.");
    }

}

void ExpressionParser::_andExpr() {
    
    _equalityExpr();
    while (predicts(TD_TOKEN_KIND_AND, TD_TOKEN_KIND_DOUBLE_AMPERSAND, 0)) {
        _andOp();
        _equalityExpr();
        {
        
    TDValue *rhs = POP();
    TDValue *lhs = POP();
    PUSH([TDBooleanExpression booleanExpressionWithOperand:lhs operator:TD_TOKEN_KIND_AND operand:rhs]);

        }
    }

}

void ExpressionParser::_eqOp() {
    
    if (predicts(TD_TOKEN_KIND_DOUBLE_EQUALS, 0)) {
        match(TD_TOKEN_KIND_DOUBLE_EQUALS, true);
    } else if (predicts(TD_TOKEN_KIND_EQ, 0)) {
        match(TD_TOKEN_KIND_EQ, true);
    } else {
        raise("No viable alternative found in rule 'eqOp'.");
    }
    {
     PUSH(@(TD_TOKEN_KIND_EQ));
    }

}

void ExpressionParser::_neOp() {
    
    if (predicts(TD_TOKEN_KIND_NOT_EQUAL, 0)) {
        match(TD_TOKEN_KIND_NOT_EQUAL, true);
    } else if (predicts(TD_TOKEN_KIND_NE, 0)) {
        match(TD_TOKEN_KIND_NE, true);
    } else {
        raise("No viable alternative found in rule 'neOp'.");
    }
    {
     PUSH(@(TD_TOKEN_KIND_NE));
    }

}

void ExpressionParser::_equalityExpr() {
    
    _relationalExpr();
    while (predicts(TD_TOKEN_KIND_DOUBLE_EQUALS, TD_TOKEN_KIND_EQ, TD_TOKEN_KIND_NE, TD_TOKEN_KIND_NOT_EQUAL, 0)) {
        if (predicts(TD_TOKEN_KIND_DOUBLE_EQUALS, TD_TOKEN_KIND_EQ, 0)) {
            _eqOp();
        } else if (predicts(TD_TOKEN_KIND_NE, TD_TOKEN_KIND_NOT_EQUAL, 0)) {
            _neOp();
        } else {
            raise("No viable alternative found in rule 'equalityExpr'.");
        }
        _relationalExpr();
        {
        
    TDValue *rhs = POP();
    NSInteger op = POP_INT();
    TDValue *lhs = POP();
    PUSH([TDRelationalExpression relationalExpressionWithOperand:lhs operator:op operand:rhs]);

        }
    }

}

void ExpressionParser::_ltOp() {
    
    if (predicts(TD_TOKEN_KIND_LT_SYM, 0)) {
        match(TD_TOKEN_KIND_LT_SYM, true);
    } else if (predicts(TD_TOKEN_KIND_LT, 0)) {
        match(TD_TOKEN_KIND_LT, true);
    } else {
        raise("No viable alternative found in rule 'ltOp'.");
    }
    {
     PUSH(@(TD_TOKEN_KIND_LT));
    }

}

void ExpressionParser::_gtOp() {
    
    if (predicts(TD_TOKEN_KIND_GT_SYM, 0)) {
        match(TD_TOKEN_KIND_GT_SYM, true);
    } else if (predicts(TD_TOKEN_KIND_GT, 0)) {
        match(TD_TOKEN_KIND_GT, true);
    } else {
        raise("No viable alternative found in rule 'gtOp'.");
    }
    {
     PUSH(@(TD_TOKEN_KIND_GT));
    }

}

void ExpressionParser::_leOp() {
    
    if (predicts(TD_TOKEN_KIND_LE_SYM, 0)) {
        match(TD_TOKEN_KIND_LE_SYM, true);
    } else if (predicts(TD_TOKEN_KIND_LE, 0)) {
        match(TD_TOKEN_KIND_LE, true);
    } else {
        raise("No viable alternative found in rule 'leOp'.");
    }
    {
     PUSH(@(TD_TOKEN_KIND_LE));
    }

}

void ExpressionParser::_geOp() {
    
    if (predicts(TD_TOKEN_KIND_GE_SYM, 0)) {
        match(TD_TOKEN_KIND_GE_SYM, true);
    } else if (predicts(TD_TOKEN_KIND_GE, 0)) {
        match(TD_TOKEN_KIND_GE, true);
    } else {
        raise("No viable alternative found in rule 'geOp'.");
    }
    {
     PUSH(@(TD_TOKEN_KIND_GE));
    }

}

void ExpressionParser::_relationalExpr() {
    
    _additiveExpr();
    while (predicts(TD_TOKEN_KIND_LT, TD_TOKEN_KIND_LT_SYM, TD_TOKEN_KIND_GT, TD_TOKEN_KIND_GT_SYM, TD_TOKEN_KIND_LE, TD_TOKEN_KIND_LE_SYM, TD_TOKEN_KIND_GE, TD_TOKEN_KIND_GE_SYM, 0)) {
        if (predicts(TD_TOKEN_KIND_LT, TD_TOKEN_KIND_LT_SYM, 0)) {
            _ltOp();
        } else if (predicts(TD_TOKEN_KIND_GT, TD_TOKEN_KIND_GT_SYM, 0)) {
            _gtOp();
        } else if (predicts(TD_TOKEN_KIND_LE, TD_TOKEN_KIND_LE_SYM, 0)) {
            _leOp();
        } else if (predicts(TD_TOKEN_KIND_GE, TD_TOKEN_KIND_GE_SYM, 0)) {
            _geOp();
        } else {
            raise("No viable alternative found in rule 'relationalExpr'.");
        }
        _additiveExpr();
        {
        
    TDValue *rhs = POP();
    NSInteger op = POP_INT();
    TDValue *lhs = POP();
    PUSH([TDRelationalExpression relationalExpressionWithOperand:lhs operator:op operand:rhs]);

        }
    }

}

void ExpressionParser::_plus() {
    
    match(TD_TOKEN_KIND_PLUS, true);
    {
     PUSH(@(TD_TOKEN_KIND_PLUS));
    }

}

void ExpressionParser::_minus() {
    
    match(TD_TOKEN_KIND_MINUS, true);
    {
     PUSH(@(TD_TOKEN_KIND_MINUS));
    }

}

void ExpressionParser::_additiveExpr() {
    
    _multiplicativeExpr();
    while (predicts(TD_TOKEN_KIND_PLUS, TD_TOKEN_KIND_MINUS, 0)) {
        if (predicts(TD_TOKEN_KIND_PLUS, 0)) {
            _plus();
        } else if (predicts(TD_TOKEN_KIND_MINUS, 0)) {
            _minus();
        } else {
            raise("No viable alternative found in rule 'additiveExpr'.");
        }
        _multiplicativeExpr();
        {
        
    TDValue *rhs = POP();
    NSInteger op = POP_INT();
    TDValue *lhs = POP();
    PUSH([TDArithmeticExpression arithmeticExpressionWithOperand:lhs operator:op operand:rhs]);

        }
    }

}

void ExpressionParser::_times() {
    
    match(TD_TOKEN_KIND_TIMES, true);
    {
     PUSH(@(TD_TOKEN_KIND_TIMES));
    }

}

void ExpressionParser::_div() {
    
    match(TD_TOKEN_KIND_DIV, true);
    {
     PUSH(@(TD_TOKEN_KIND_DIV));
    }

}

void ExpressionParser::_mod() {
    
    match(TD_TOKEN_KIND_MOD, true);
    {
     PUSH(@(TD_TOKEN_KIND_MOD));
    }

}

void ExpressionParser::_multiplicativeExpr() {
    
    _unaryExpr();
    while (predicts(TD_TOKEN_KIND_TIMES, TD_TOKEN_KIND_DIV, TD_TOKEN_KIND_MOD, 0)) {
        if (predicts(TD_TOKEN_KIND_TIMES, 0)) {
            _times();
        } else if (predicts(TD_TOKEN_KIND_DIV, 0)) {
            _div();
        } else if (predicts(TD_TOKEN_KIND_MOD, 0)) {
            _mod();
        } else {
            raise("No viable alternative found in rule 'multiplicativeExpr'.");
        }
        _unaryExpr();
        {
        
    TDValue *rhs = POP();
    NSInteger op = POP_INT();
    TDValue *lhs = POP();
    PUSH([TDArithmeticExpression arithmeticExpressionWithOperand:lhs operator:op operand:rhs]);

        }
    }

}

void ExpressionParser::_unaryExpr() {
    
    if (predicts(TD_TOKEN_KIND_BANG, TD_TOKEN_KIND_NOT, 0)) {
        _negatedUnary();
    } else if (predicts(TOKEN_KIND_BUILTIN_NUMBER, TOKEN_KIND_BUILTIN_QUOTEDSTRING, TOKEN_KIND_BUILTIN_WORD, TD_TOKEN_KIND_FALSE, TD_TOKEN_KIND_MINUS, TD_TOKEN_KIND_NO_UPPER, TD_TOKEN_KIND_OPEN_PAREN, TD_TOKEN_KIND_TRUE, TD_TOKEN_KIND_YES_UPPER, TD_TOKEN_KIND_NULL, 0)) {
        _unary();
    } else {
        raise("No viable alternative found in rule 'unaryExpr'.");
    }

}

void ExpressionParser::_negatedUnary() {
    
    {
     _negation = NO;
    }
    do {
        if (predicts(TD_TOKEN_KIND_NOT, 0)) {
            match(TD_TOKEN_KIND_NOT, true);
        } else if (predicts(TD_TOKEN_KIND_BANG, 0)) {
            match(TD_TOKEN_KIND_BANG, true);
        } else {
            raise("No viable alternative found in rule 'negatedUnary'.");
        }
        {
         _negation = !_negation;
        }
    } while (predicts(TD_TOKEN_KIND_BANG, TD_TOKEN_KIND_NOT, 0]);
    _unary();
    {
    

    }
    {
    
    if (_negation)
        PUSH([TDNegationExpression negationExpressionWithExpression:POP()]);

    }

}

void ExpressionParser::_unary() {
    
    if (predicts(TD_TOKEN_KIND_MINUS, 0)) {
        _signedFilterExpr();
    } else if (predicts(TOKEN_KIND_BUILTIN_NUMBER, TOKEN_KIND_BUILTIN_QUOTEDSTRING, TOKEN_KIND_BUILTIN_WORD, TD_TOKEN_KIND_FALSE, TD_TOKEN_KIND_NO_UPPER, TD_TOKEN_KIND_OPEN_PAREN, TD_TOKEN_KIND_TRUE, TD_TOKEN_KIND_YES_UPPER, TD_TOKEN_KIND_NULL, 0)) {
        _filterExpr();
    } else {
        raise("No viable alternative found in rule 'unary'.");
    }

}

void ExpressionParser::_signedFilterExpr() {
    
    {
    
    _negative = NO;

    }
    do {
        match(TD_TOKEN_KIND_MINUS, true);
        {
         _negative = !_negative;
        }
    } while (predicts(TD_TOKEN_KIND_MINUS, 0]);
    _filterExpr();
    {
    
    if (_negative)
        PUSH([TDUnaryExpression unaryExpressionWithExpression:POP()]);

    }

}

void ExpressionParser::_filterExpr() {
    
    _primaryExpr();
    while (predicts(TD_TOKEN_KIND_PIPE, 0)) {
        _filter();
        {
        
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
            
        }
    }

}

void ExpressionParser::_filter() {
    
    match(TD_TOKEN_KIND_PIPE, true);
    [self matchWord:NO];
    _filterArgs();

}

void ExpressionParser::_filterArgs() {
    
    if (predicts(TD_TOKEN_KIND_COLON, 0)) {
        match(TD_TOKEN_KIND_COLON, false);
        _filterArg();
        while (predicts(TD_TOKEN_KIND_COMMA, 0)) {
            match(TD_TOKEN_KIND_COMMA, true);
            _filterArg();
        }
        {
         id toks = ABOVE(_colon); POP(); PUSH(REV(toks));
        }
    } else {
        [self matchEmpty:NO];
        {
         PUSH(@[]);
        }
    }

}

void ExpressionParser::_filterArg() {
    
    if (predicts(TOKEN_KIND_BUILTIN_QUOTEDSTRING, 0)) {
        [self matchQuotedString:NO];
    } else if (predicts(TOKEN_KIND_BUILTIN_WORD, 0)) {
        [self matchWord:NO];
    } else if (predicts(TOKEN_KIND_BUILTIN_NUMBER, 0)) {
        [self matchNumber:NO];
    } else {
        raise("No viable alternative found in rule 'filterArg'.");
    }

}

void ExpressionParser::_primaryExpr() {
    
    if (predicts(TOKEN_KIND_BUILTIN_NUMBER, TOKEN_KIND_BUILTIN_QUOTEDSTRING, TOKEN_KIND_BUILTIN_WORD, TD_TOKEN_KIND_FALSE, TD_TOKEN_KIND_NO_UPPER, TD_TOKEN_KIND_TRUE, TD_TOKEN_KIND_YES_UPPER, TD_TOKEN_KIND_NULL, 0)) {
        _atom();
    } else if (predicts(TD_TOKEN_KIND_OPEN_PAREN, 0)) {
        _subExpr();
    } else {
        raise("No viable alternative found in rule 'primaryExpr'.");
    }

}

void ExpressionParser::_subExpr() {
    
    match(TD_TOKEN_KIND_OPEN_PAREN, false);
    _expr();
    match(TD_TOKEN_KIND_CLOSE_PAREN, true);
    {
    
    id objs = ABOVE(_openParen);
    POP(); // discard `(`
    PUSH_ALL(REV(objs));

    }

}

void ExpressionParser::_atom() {
    
    if (predicts(TOKEN_KIND_BUILTIN_NUMBER, TOKEN_KIND_BUILTIN_QUOTEDSTRING, TD_TOKEN_KIND_FALSE, TD_TOKEN_KIND_NO_UPPER, TD_TOKEN_KIND_TRUE, TD_TOKEN_KIND_YES_UPPER, TD_TOKEN_KIND_NULL, 0)) {
        _literal();
    } else if (predicts(TOKEN_KIND_BUILTIN_WORD, 0)) {
        _pathExpr();
    } else {
        raise("No viable alternative found in rule 'atom'.");
    }

}

void ExpressionParser::_pathExpr() {
    
    {
    
    PUSH(_openParen);

    }
    _identifier();
    while (predicts(TD_TOKEN_KIND_DOT, 0)) {
        match(TD_TOKEN_KIND_DOT, true);
        _step();
    }
    {
    
    id toks = REV(ABOVE(_openParen));
    POP(); // discard `_openParen`
    PUSH([TDPathExpression pathExpressionWithSteps:toks]);

    }

}

void ExpressionParser::_step() {
    
    if (predicts(TOKEN_KIND_BUILTIN_WORD, 0)) {
        _identifier();
    } else if (predicts(TOKEN_KIND_BUILTIN_NUMBER, 0)) {
        _num();
    } else {
        raise("No viable alternative found in rule 'step'.");
    }

}

void ExpressionParser::_identifier() {
    
    [self matchWord:NO];
    {
     PUSH(POP_STR());
    }

}

void ExpressionParser::_literal() {
    
    if (predicts(TOKEN_KIND_BUILTIN_QUOTEDSTRING, 0)) {
        _str();
    } else if (predicts(TOKEN_KIND_BUILTIN_NUMBER, 0)) {
        _num();
    } else if (predicts(TD_TOKEN_KIND_FALSE, TD_TOKEN_KIND_NO_UPPER, TD_TOKEN_KIND_TRUE, TD_TOKEN_KIND_YES_UPPER, 0)) {
        _bool();
    } else if (predicts(TD_TOKEN_KIND_NULL, 0)) {
        _null();
    } else {
        raise("No viable alternative found in rule 'literal'.");
    }

}

void ExpressionParser::_bool() {
    
    if (predicts(TD_TOKEN_KIND_TRUE, TD_TOKEN_KIND_YES_UPPER, 0)) {
        _true();
        {
         PUSH([TDBooleanValue booleanValueWithBoolean:YES]);
        }
    } else if (predicts(TD_TOKEN_KIND_FALSE, TD_TOKEN_KIND_NO_UPPER, 0)) {
        _false();
        {
         PUSH([TDBooleanValue booleanValueWithBoolean:NO]);
        }
    } else {
        raise("No viable alternative found in rule 'bool'.");
    }

}

void ExpressionParser::_true() {
    
    if (predicts(TD_TOKEN_KIND_TRUE, 0)) {
        match(TD_TOKEN_KIND_TRUE, true);
    } else if (predicts(TD_TOKEN_KIND_YES_UPPER, 0)) {
        match(TD_TOKEN_KIND_YES_UPPER, true);
    } else {
        raise("No viable alternative found in rule 'true'.");
    }

}

void ExpressionParser::_false() {
    
    if (predicts(TD_TOKEN_KIND_FALSE, 0)) {
        match(TD_TOKEN_KIND_FALSE, true);
    } else if (predicts(TD_TOKEN_KIND_NO_UPPER, 0)) {
        match(TD_TOKEN_KIND_NO_UPPER, true);
    } else {
        raise("No viable alternative found in rule 'false'.");
    }

}

void ExpressionParser::_num() {
    
    [self matchNumber:NO];
    {
    
    PUSH([TDNumericValue numericValueWithNumber:POP_DOUBLE()]);

    }

}

void ExpressionParser::_str() {
    
    [self matchQuotedString:NO];
    {
    
    PUSH([TDStringValue stringValueWithString:POP_QUOTED_STR()]);

    }

}

void ExpressionParser::_null() {
    
    match(TD_TOKEN_KIND_NULL discard:YES];
    {
    
    PUSH([TDObjectValue objectValueWithObject:[NSNull null]]);

    }

}

}
