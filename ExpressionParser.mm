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
    match(EXTokenType_IN, true);
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
    if (predicts(EXTokenType_COMMA, 0)) {
        match(EXTokenType_COMMA, true);
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
    match(EXTokenType_TO, true);
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
    
    if (predicts(EXTokenType_BY, 0)) {
        match(EXTokenType_BY, true);
        _unaryExpr();
    } else {
        //[self matchEmpty:NO];
        {
         PUSH([TDNumericValue numericValueWithNumber:0.0]);
        }
    }

}

void ExpressionParser::_orOp() {
    
    if (predicts(EXTokenType_OR, 0)) {
        match(EXTokenType_OR, true);
    } else if (predicts(EXTokenType_DOUBLE_PIPE, 0)) {
        match(EXTokenType_DOUBLE_PIPE, true);
    } else {
        raise("No viable alternative found in rule 'orOp'.");
    }

}

void ExpressionParser::_orExpr() {
    
    _andExpr();
    while (predicts(EXTokenType_OR, EXTokenType_DOUBLE_PIPE, 0)) {
        _orOp();
        _andExpr();
        {
        
    TDValue *rhs = POP();
    TDValue *lhs = POP();
    PUSH([TDBooleanExpression booleanExpressionWithOperand:lhs operator:EXTokenType_OR operand:rhs]);

        }
    }

}

void ExpressionParser::_andOp() {
    
    if (predicts(EXTokenType_AND, 0)) {
        match(EXTokenType_AND, true);
    } else if (predicts(EXTokenType_DOUBLE_AMPERSAND, 0)) {
        match(EXTokenType_DOUBLE_AMPERSAND, true);
    } else {
        raise("No viable alternative found in rule 'andOp'.");
    }

}

void ExpressionParser::_andExpr() {
    
    _equalityExpr();
    while (predicts(EXTokenType_AND, EXTokenType_DOUBLE_AMPERSAND, 0)) {
        _andOp();
        _equalityExpr();
        {
        
    TDValue *rhs = POP();
    TDValue *lhs = POP();
    PUSH([TDBooleanExpression booleanExpressionWithOperand:lhs operator:EXTokenType_AND operand:rhs]);

        }
    }

}

void ExpressionParser::_eqOp() {
    
    if (predicts(EXTokenType_DOUBLE_EQUALS, 0)) {
        match(EXTokenType_DOUBLE_EQUALS, true);
    } else if (predicts(EXTokenType_EQ, 0)) {
        match(EXTokenType_EQ, true);
    } else {
        raise("No viable alternative found in rule 'eqOp'.");
    }
    {
     PUSH(@(EXTokenType_EQ));
    }

}

void ExpressionParser::_neOp() {
    
    if (predicts(EXTokenType_NOT_EQUAL, 0)) {
        match(EXTokenType_NOT_EQUAL, true);
    } else if (predicts(EXTokenType_NE, 0)) {
        match(EXTokenType_NE, true);
    } else {
        raise("No viable alternative found in rule 'neOp'.");
    }
    {
     PUSH(@(EXTokenType_NE));
    }

}

void ExpressionParser::_equalityExpr() {
    
    _relationalExpr();
    while (predicts(EXTokenType_DOUBLE_EQUALS, EXTokenType_EQ, EXTokenType_NE, EXTokenType_NOT_EQUAL, 0)) {
        if (predicts(EXTokenType_DOUBLE_EQUALS, EXTokenType_EQ, 0)) {
            _eqOp();
        } else if (predicts(EXTokenType_NE, EXTokenType_NOT_EQUAL, 0)) {
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
    
    if (predicts(EXTokenType_LT_SYM, 0)) {
        match(EXTokenType_LT_SYM, true);
    } else if (predicts(EXTokenType_LT, 0)) {
        match(EXTokenType_LT, true);
    } else {
        raise("No viable alternative found in rule 'ltOp'.");
    }
    {
     PUSH(@(EXTokenType_LT));
    }

}

void ExpressionParser::_gtOp() {
    
    if (predicts(EXTokenType_GT_SYM, 0)) {
        match(EXTokenType_GT_SYM, true);
    } else if (predicts(EXTokenType_GT, 0)) {
        match(EXTokenType_GT, true);
    } else {
        raise("No viable alternative found in rule 'gtOp'.");
    }
    {
     PUSH(@(EXTokenType_GT));
    }

}

void ExpressionParser::_leOp() {
    
    if (predicts(EXTokenType_LE_SYM, 0)) {
        match(EXTokenType_LE_SYM, true);
    } else if (predicts(EXTokenType_LE, 0)) {
        match(EXTokenType_LE, true);
    } else {
        raise("No viable alternative found in rule 'leOp'.");
    }
    {
     PUSH(@(EXTokenType_LE));
    }

}

void ExpressionParser::_geOp() {
    
    if (predicts(EXTokenType_GE_SYM, 0)) {
        match(EXTokenType_GE_SYM, true);
    } else if (predicts(EXTokenType_GE, 0)) {
        match(EXTokenType_GE, true);
    } else {
        raise("No viable alternative found in rule 'geOp'.");
    }
    {
     PUSH(@(EXTokenType_GE));
    }

}

void ExpressionParser::_relationalExpr() {
    
    _additiveExpr();
    while (predicts(EXTokenType_LT, EXTokenType_LT_SYM, EXTokenType_GT, EXTokenType_GT_SYM, EXTokenType_LE, EXTokenType_LE_SYM, EXTokenType_GE, EXTokenType_GE_SYM, 0)) {
        if (predicts(EXTokenType_LT, EXTokenType_LT_SYM, 0)) {
            _ltOp();
        } else if (predicts(EXTokenType_GT, EXTokenType_GT_SYM, 0)) {
            _gtOp();
        } else if (predicts(EXTokenType_LE, EXTokenType_LE_SYM, 0)) {
            _leOp();
        } else if (predicts(EXTokenType_GE, EXTokenType_GE_SYM, 0)) {
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
    
    match(EXTokenType_PLUS, true);
    {
     PUSH(@(EXTokenType_PLUS));
    }

}

void ExpressionParser::_minus() {
    
    match(EXTokenType_MINUS, true);
    {
     PUSH(@(EXTokenType_MINUS));
    }

}

void ExpressionParser::_additiveExpr() {
    
    _multiplicativeExpr();
    while (predicts(EXTokenType_PLUS, EXTokenType_MINUS, 0)) {
        if (predicts(EXTokenType_PLUS, 0)) {
            _plus();
        } else if (predicts(EXTokenType_MINUS, 0)) {
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
    
    match(EXTokenType_TIMES, true);
    {
     PUSH(@(EXTokenType_TIMES));
    }

}

void ExpressionParser::_div() {
    
    match(EXTokenType_DIV, true);
    {
     PUSH(@(EXTokenType_DIV));
    }

}

void ExpressionParser::_mod() {
    
    match(EXTokenType_MOD, true);
    {
     PUSH(@(EXTokenType_MOD));
    }

}

void ExpressionParser::_multiplicativeExpr() {
    
    _unaryExpr();
    while (predicts(EXTokenType_TIMES, EXTokenType_DIV, EXTokenType_MOD, 0)) {
        if (predicts(EXTokenType_TIMES, 0)) {
            _times();
        } else if (predicts(EXTokenType_DIV, 0)) {
            _div();
        } else if (predicts(EXTokenType_MOD, 0)) {
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
    
    if (predicts(EXTokenType_BANG, EXTokenType_NOT, 0)) {
        _negatedUnary();
    } else if (predicts(TOKEN_KIND_BUILTIN_NUMBER, TOKEN_KIND_BUILTIN_QUOTEDSTRING, TOKEN_KIND_BUILTIN_WORD, EXTokenType_FALSE, EXTokenType_MINUS, EXTokenType_NO_UPPER, EXTokenType_OPEN_PAREN, EXTokenType_TRUE, EXTokenType_YES_UPPER, EXTokenType_NULL, 0)) {
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
        if (predicts(EXTokenType_NOT, 0)) {
            match(EXTokenType_NOT, true);
        } else if (predicts(EXTokenType_BANG, 0)) {
            match(EXTokenType_BANG, true);
        } else {
            raise("No viable alternative found in rule 'negatedUnary'.");
        }
        {
         _negation = !_negation;
        }
    } while (predicts(EXTokenType_BANG, EXTokenType_NOT, 0]);
    _unary();
    {
    

    }
    {
    
    if (_negation)
        PUSH([TDNegationExpression negationExpressionWithExpression:POP()]);

    }

}

void ExpressionParser::_unary() {
    
    if (predicts(EXTokenType_MINUS, 0)) {
        _signedFilterExpr();
    } else if (predicts(TOKEN_KIND_BUILTIN_NUMBER, TOKEN_KIND_BUILTIN_QUOTEDSTRING, TOKEN_KIND_BUILTIN_WORD, EXTokenType_FALSE, EXTokenType_NO_UPPER, EXTokenType_OPEN_PAREN, EXTokenType_TRUE, EXTokenType_YES_UPPER, EXTokenType_NULL, 0)) {
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
        match(EXTokenType_MINUS, true);
        {
         _negative = !_negative;
        }
    } while (predicts(EXTokenType_MINUS, 0]);
    _filterExpr();
    {
    
    if (_negative)
        PUSH([TDUnaryExpression unaryExpressionWithExpression:POP()]);

    }

}

void ExpressionParser::_filterExpr() {
    
    _primaryExpr();
    while (predicts(EXTokenType_PIPE, 0)) {
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
    
    match(EXTokenType_PIPE, true);
    [self matchWord:NO];
    _filterArgs();

}

void ExpressionParser::_filterArgs() {
    
    if (predicts(EXTokenType_COLON, 0)) {
        match(EXTokenType_COLON, false);
        _filterArg();
        while (predicts(EXTokenType_COMMA, 0)) {
            match(EXTokenType_COMMA, true);
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
    
    if (predicts(TOKEN_KIND_BUILTIN_NUMBER, TOKEN_KIND_BUILTIN_QUOTEDSTRING, TOKEN_KIND_BUILTIN_WORD, EXTokenType_FALSE, EXTokenType_NO_UPPER, EXTokenType_TRUE, EXTokenType_YES_UPPER, EXTokenType_NULL, 0)) {
        _atom();
    } else if (predicts(EXTokenType_OPEN_PAREN, 0)) {
        _subExpr();
    } else {
        raise("No viable alternative found in rule 'primaryExpr'.");
    }

}

void ExpressionParser::_subExpr() {
    
    match(EXTokenType_OPEN_PAREN, false);
    _expr();
    match(EXTokenType_CLOSE_PAREN, true);
    {
    
    id objs = ABOVE(_openParen);
    POP(); // discard `(`
    PUSH_ALL(REV(objs));

    }

}

void ExpressionParser::_atom() {
    
    if (predicts(TOKEN_KIND_BUILTIN_NUMBER, TOKEN_KIND_BUILTIN_QUOTEDSTRING, EXTokenType_FALSE, EXTokenType_NO_UPPER, EXTokenType_TRUE, EXTokenType_YES_UPPER, EXTokenType_NULL, 0)) {
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
    while (predicts(EXTokenType_DOT, 0)) {
        match(EXTokenType_DOT, true);
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
    } else if (predicts(EXTokenType_FALSE, EXTokenType_NO_UPPER, EXTokenType_TRUE, EXTokenType_YES_UPPER, 0)) {
        _bool();
    } else if (predicts(EXTokenType_NULL, 0)) {
        _null();
    } else {
        raise("No viable alternative found in rule 'literal'.");
    }

}

void ExpressionParser::_bool() {
    
    if (predicts(EXTokenType_TRUE, EXTokenType_YES_UPPER, 0)) {
        _true();
        {
         PUSH([TDBooleanValue booleanValueWithBoolean:YES]);
        }
    } else if (predicts(EXTokenType_FALSE, EXTokenType_NO_UPPER, 0)) {
        _false();
        {
         PUSH([TDBooleanValue booleanValueWithBoolean:NO]);
        }
    } else {
        raise("No viable alternative found in rule 'bool'.");
    }

}

void ExpressionParser::_true() {
    
    if (predicts(EXTokenType_TRUE, 0)) {
        match(EXTokenType_TRUE, true);
    } else if (predicts(EXTokenType_YES_UPPER, 0)) {
        match(EXTokenType_YES_UPPER, true);
    } else {
        raise("No viable alternative found in rule 'true'.");
    }

}

void ExpressionParser::_false() {
    
    if (predicts(EXTokenType_FALSE, 0)) {
        match(EXTokenType_FALSE, true);
    } else if (predicts(EXTokenType_NO_UPPER, 0)) {
        match(EXTokenType_NO_UPPER, true);
    } else {
        raise("No viable alternative found in rule 'false'.");
    }

}

void ExpressionParser::_num() {
    
    match(TokenType_NUMBER, false);
    {
    
    PUSH([TDNumericValue numericValueWithNumber:POP_DOUBLE()]);

    }

}

void ExpressionParser::_str() {
    
    match(TokenType_QUOTED_STRING, false);
    {
    
    PUSH([TDStringValue stringValueWithString:POP_QUOTED_STR()]);

    }

}

void ExpressionParser::_null() {
    
    match(EXTokenType_NULL discard:YES];
    {
    
    PUSH([TDObjectValue objectValueWithObject:[NSNull null]]);

    }

}

}
