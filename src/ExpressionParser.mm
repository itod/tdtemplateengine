#import "ExpressionParser.hpp"
    
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
#import "EXToken.h"

#import <ParseKitCPP/ModalTokenizer.hpp>
#import <ParseKitCPP/DefaultTokenizerMode.hpp>

#define COLON @"COLON"
#define OPEN_PAREN @"OPEN_PAREN"

#define REV(a)                reversedArray(a)
#define OBJS_ABOVE(obj)       objectsAbove((obj))

#define PUSH_OBJ(obj)         _assembly->push_object((obj))
#define PUSH_ALL_OBJS(a)      pushAll((a))

#define POP_OBJ()             _assembly->pop_object()

#define POP_TOK()             _assembly->pop_token()
#define POP_TOK_STR()         [NSString stringWithUTF8String:_assembly->string_for_token(POP_TOK()).c_str()]
#define POP_TOK_QUOTED_STR()  stringByTrimmingQuotes(POP_TOK_STR())
#define POP_TOK_DOUBLE()      _assembly->float_for_token(_assembly->pop_token())

using namespace parsekit;
namespace templateengine {

Tokenizer *ExpressionParser::tokenizer() {
    static Tokenizer *t = nullptr;
    if (!t) {
        DefaultTokenizerModePtr mode(new DefaultTokenizerMode());
        t = new ModalTokenizer(mode);
        
        mode->getSymbolState()->add("==");
        mode->getSymbolState()->add("!=");
        mode->getSymbolState()->add("<=");
        mode->getSymbolState()->add(">=");
        mode->getSymbolState()->add("&&");
        mode->getSymbolState()->add("||");
        
        mode->set_tokenizer_state(mode->getSymbolState(), '-', '-');
        mode->getWordState()->setWordChars(false, '\'', '\'');
    }
    
    assert(t);
    return t;
}

const EXTokenTable& ExpressionParser::tokenTable() {
    static EXTokenTable tokenTab = {
        {"gt", EXTokenType_GT},
        {">=", EXTokenType_GE_SYM},
        {"&&", EXTokenType_DOUBLE_AMPERSAND},
        {"|", EXTokenType_PIPE},
        {"true", EXTokenType_TRUE},
        {"!=", EXTokenType_NOT_EQUAL},
        {"!", EXTokenType_BANG},
        {":", EXTokenType_COLON},
        {"<", EXTokenType_LT_SYM},
        {"%", EXTokenType_MOD},
        {"le", EXTokenType_LE},
        {">", EXTokenType_GT_SYM},
        {"lt", EXTokenType_LT},
        {"(", EXTokenType_OPEN_PAREN},
        {")", EXTokenType_CLOSE_PAREN},
        {"eq", EXTokenType_EQ},
        {"ne", EXTokenType_NE},
        {"or", EXTokenType_OR},
        {"not", EXTokenType_NOT},
        {"*", EXTokenType_TIMES},
        {"+", EXTokenType_PLUS},
        {"||", EXTokenType_DOUBLE_PIPE},
        {",", EXTokenType_COMMA},
        {"and", EXTokenType_AND},
        {"YES", EXTokenType_YES_UPPER},
        {"-", EXTokenType_MINUS},
        {"in", EXTokenType_IN},
        {".", EXTokenType_DOT},
        {"/", EXTokenType_DIV},
        {"by", EXTokenType_BY},
        {"false", EXTokenType_FALSE},
        {"<=", EXTokenType_LE_SYM},
        {"to", EXTokenType_TO},
        {"ge", EXTokenType_GE},
        {"NO", EXTokenType_NO_UPPER},
        {"==", EXTokenType_DOUBLE_EQUALS},
        {"null", EXTokenType_NULL},
    };
    return tokenTab;
}

NSArray *ExpressionParser::reversedArray(NSArray *inArray) {
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:inArray.count];
    for (id obj in [inArray reverseObjectEnumerator]) {
        [result addObject:obj];
    }
    return result;
}

void ExpressionParser::pushAll(NSArray *a) {
    for (id obj in a) {
        _assembly->push_object(obj);
    }
}

NSArray *ExpressionParser::objectsAbove(id fence) {
    NSMutableArray *result = [NSMutableArray array];
    
    while (!_assembly->is_object_stack_empty()) {
        id obj = _assembly->pop_object();
        
        if ([obj isEqual:fence]) {
            _assembly->push_object(obj);
            break;
        } else {
            [result addObject:obj];
        }
    }
    
    return result;
}

NSString *ExpressionParser::stringByTrimmingQuotes(NSString *inStr) {
    NSUInteger len = [inStr length];
    
    if (len < 2) {
        return inStr;
    }
    
    NSRange r = NSMakeRange(0, len);
    
    unichar c = [inStr characterAtIndex:0];
    if (!isalnum(c)) {
        unichar quoteChar = c;
        r.location = 1;
        r.length -= 1;

        c = [inStr characterAtIndex:len - 1];
        if (c == quoteChar) {
            r.length -= 1;
        }
        return [inStr substringWithRange:r];
    } else {
        return inStr;
    }
}

ExpressionParser::ExpressionParser() :
    BaseParser(tokenizer()),
    _engine(nullptr)
{}

ExpressionParser::ExpressionParser(TDTemplateEngine *engine) :
    BaseParser(tokenizer()),
    _engine(engine)
{}

TDExpression *ExpressionParser::parse(Reader *r) {
    TokenList lookahead;
    _lookahead = &lookahead;
    
    IntStack markers;
    _markers = &markers;
    
    TokenList token_stack;
    TokenList consumed;
    ExpressionAssembly a(r, &token_stack, &consumed);
    _assembly = &a;

    _p = 0;
    
    TDExpression *expr = nil;
    try {
        _expr();
        match(TokenType_EOF);
        
        expr = POP_OBJ();
    } catch (std::exception& ex) {
        assert(0);
    }

    _assembly = nullptr;
    _markers = nullptr;
    _lookahead = nullptr;

    return expr;
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
    if (!isSpeculating()) {
        id enumExpr = POP_OBJ();
        id vars = POP_OBJ();
        PUSH_OBJ([TDLoopExpression loopExpressionWithVariables:vars enumeration:enumExpr]);
    }

}

void ExpressionParser::_identifiers() {
    
    if (!isSpeculating()) {
        PUSH_OBJ(OPEN_PAREN);
    }
    _identifier();
    if (predicts(EXTokenType_COMMA, 0)) {
        match(EXTokenType_COMMA, true);
        _identifier();
    }
    if (!isSpeculating()) {
        id strs = REV(OBJS_ABOVE(OPEN_PAREN));
        POP_OBJ(); // discard `(`
        PUSH_OBJ(strs);
    }

}

void ExpressionParser::_enumExpr() {
    
    if (speculate([&]{ _rangeExpr(); })) {
        _rangeExpr();
    } else if (speculate([&]{ _collectionExpr(); })) {
        _collectionExpr();
    } else {
        raise("No viable alternative found in rule 'enumExpr'.");
    }

}

void ExpressionParser::_collectionExpr() {
    
    _primaryExpr();
    if (!isSpeculating()) {
        id expr = POP_OBJ();
        PUSH_OBJ([TDCollectionExpression collectionExpressionWithExpression:expr]);
    }

}

void ExpressionParser::_rangeExpr() {
    
    _unaryExpr();
    match(EXTokenType_TO, true);
    _unaryExpr();
    _optBy();
    if (!isSpeculating()) {
        id by = POP_OBJ();
        id stop = POP_OBJ();
        id start = POP_OBJ();
        PUSH_OBJ([TDRangeExpression rangeExpressionWithStart:start stop:stop by:by]);
    }

}

void ExpressionParser::_optBy() {
    
    if (predicts(EXTokenType_BY, 0)) {
        match(EXTokenType_BY, true);
        _unaryExpr();
    } else {
        //[self matchEmpty:NO];
        if (!isSpeculating()) {
            PUSH_OBJ([TDNumericValue numericValueWithNumber:0.0]);
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
        if (!isSpeculating()) {
            TDValue *rhs = POP_OBJ();
            TDValue *lhs = POP_OBJ();
            PUSH_OBJ([TDBooleanExpression booleanExpressionWithOperand:lhs operator:EXTokenType_OR operand:rhs]);
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
        if (!isSpeculating()) {
            TDValue *rhs = POP_OBJ();
            TDValue *lhs = POP_OBJ();
            PUSH_OBJ([TDBooleanExpression booleanExpressionWithOperand:lhs operator:EXTokenType_AND operand:rhs]);
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
    if (!isSpeculating()) {
        PUSH_OBJ(@(EXTokenType_EQ));
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
    if (!isSpeculating()) {
        PUSH_OBJ(@(EXTokenType_NE));
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
        if (!isSpeculating()) {
            TDValue *rhs = POP_OBJ();
            NSInteger op = [POP_OBJ() integerValue];
            TDValue *lhs = POP_OBJ();
            PUSH_OBJ([TDRelationalExpression relationalExpressionWithOperand:lhs operator:op operand:rhs]);
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
    if (!isSpeculating()) {
        PUSH_OBJ(@(EXTokenType_LT));
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
    if (!isSpeculating()) {
        PUSH_OBJ(@(EXTokenType_GT));
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
    if (!isSpeculating()) {
        PUSH_OBJ(@(EXTokenType_LE));
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
        PUSH_OBJ(@(EXTokenType_GE));
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
        if (!isSpeculating()) {
            TDValue *rhs = POP_OBJ();
            NSInteger op = [POP_OBJ() integerValue];;
            TDValue *lhs = POP_OBJ();
            PUSH_OBJ([TDRelationalExpression relationalExpressionWithOperand:lhs operator:op operand:rhs]);
        }
    }

}

void ExpressionParser::_plus() {
    
    match(EXTokenType_PLUS, true);
    if (!isSpeculating()) {
        PUSH_OBJ(@(EXTokenType_PLUS));
    }

}

void ExpressionParser::_minus() {
    
    match(EXTokenType_MINUS, true);
    if (!isSpeculating()) {
        PUSH_OBJ(@(EXTokenType_MINUS));
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
        if (!isSpeculating()) {
            TDValue *rhs = POP_OBJ();
            NSInteger op = [POP_OBJ() integerValue];;
            TDValue *lhs = POP_OBJ();
            PUSH_OBJ([TDArithmeticExpression arithmeticExpressionWithOperand:lhs operator:op operand:rhs]);
        }
    }

}

void ExpressionParser::_times() {
    
    match(EXTokenType_TIMES, true);
    if (!isSpeculating()) {
        PUSH_OBJ(@(EXTokenType_TIMES));
    }

}

void ExpressionParser::_div() {
    
    match(EXTokenType_DIV, true);
    if (!isSpeculating()) {
        PUSH_OBJ(@(EXTokenType_DIV));
    }

}

void ExpressionParser::_mod() {
    
    match(EXTokenType_MOD, true);
    if (!isSpeculating()) {
        PUSH_OBJ(@(EXTokenType_MOD));
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
        if (!isSpeculating()) {
            TDValue *rhs = POP_OBJ();
            NSInteger op = [POP_OBJ() integerValue];;
            TDValue *lhs = POP_OBJ();
            PUSH_OBJ([TDArithmeticExpression arithmeticExpressionWithOperand:lhs operator:op operand:rhs]);
        }
    }

}

void ExpressionParser::_unaryExpr() {
    
    if (predicts(EXTokenType_BANG, EXTokenType_NOT, 0)) {
        _negatedUnary();
    } else if (predicts(TokenType_NUMBER, TokenType_QUOTED_STRING, TokenType_WORD, EXTokenType_FALSE, EXTokenType_MINUS, EXTokenType_NO_UPPER, EXTokenType_OPEN_PAREN, EXTokenType_TRUE, EXTokenType_YES_UPPER, EXTokenType_NULL, 0)) {
        _unary();
    } else {
        raise("No viable alternative found in rule 'unaryExpr'.");
    }

}

void ExpressionParser::_negatedUnary() {
    
    if (!isSpeculating()) {
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
        if (!isSpeculating()) {
         _negation = !_negation;
        }
    } while (predicts(EXTokenType_BANG, EXTokenType_NOT, 0));
    _unary();
    if (!isSpeculating()) {
        if (_negation) {
            PUSH_OBJ([TDNegationExpression negationExpressionWithExpression:POP_OBJ()]);
        }
    }

}

void ExpressionParser::_unary() {
    
    if (predicts(EXTokenType_MINUS, 0)) {
        _signedFilterExpr();
    } else if (predicts(TokenType_NUMBER, TokenType_QUOTED_STRING, TokenType_WORD, EXTokenType_FALSE, EXTokenType_NO_UPPER, EXTokenType_OPEN_PAREN, EXTokenType_TRUE, EXTokenType_YES_UPPER, EXTokenType_NULL, 0)) {
        _filterExpr();
    } else {
        raise("No viable alternative found in rule 'unary'.");
    }

}

void ExpressionParser::_signedFilterExpr() {
    
    if (!isSpeculating()) {
        _negative = NO;
    }
    do {
        match(EXTokenType_MINUS, true);
        if (!isSpeculating()) {
            _negative = !_negative;
        }
    } while (predicts(EXTokenType_MINUS, 0));
    _filterExpr();
    if (!isSpeculating()) {
        if (_negative) {
            PUSH_OBJ([TDUnaryExpression unaryExpressionWithExpression:POP_OBJ()]);
        }
    }

}

void ExpressionParser::_filterExpr() {
    
    _primaryExpr();
    while (predicts(EXTokenType_PIPE, 0)) {
        _filter();
        if (!isSpeculating()) {
            NSArray *args = POP_OBJ();
            NSString *filterName = POP_OBJ();
            id expr = POP_OBJ();
            assert(_engine);
            TDFilter *filter = nil;
            @try {
                filter = [_engine makeFilterForName:filterName];
            } @catch (NSException *ex) {
                raise([[ex reason] UTF8String]);
            }
            assert(filter);
            PUSH_OBJ([TDFilterExpression filterExpressionWithExpression:expr filter:filter arguments:args]);
        }
    }

}

void ExpressionParser::_filter() {
    
    match(EXTokenType_PIPE, true);
    _identifier();
    _filterArgs();

}

void ExpressionParser::_filterArgs() {
    
    if (predicts(EXTokenType_COLON, 0)) {
        match(EXTokenType_COLON, true);
        PUSH_OBJ(COLON);
        _filterArg();
        while (predicts(EXTokenType_COMMA, 0)) {
            match(EXTokenType_COMMA, true);
            _filterArg();
        }
        if (!isSpeculating()) {
            id args = OBJS_ABOVE(COLON);
            POP_OBJ(); // POP COLON
            args = REV(args);
            PUSH_OBJ(args);
        }
    } else {
        // empty
        if (!isSpeculating()) {
            PUSH_OBJ(@[]);
        }
    }

}

void ExpressionParser::_filterArg() {
    
    if (predicts(TokenType_QUOTED_STRING, 0)) {
        _str();
        TDStringValue *str = POP_OBJ();
        PUSH_OBJ([EXToken tokenWithTokenType:TokenType_QUOTED_STRING stringValue:str.stringValue doubleValue:0]);
    } else if (predicts(TokenType_WORD, 0)) {
        _identifier();
        id str = POP_OBJ();
        PUSH_OBJ([EXToken tokenWithTokenType:TokenType_WORD stringValue:str doubleValue:0]);
    } else if (predicts(TokenType_NUMBER, 0)) {
        _num();
        id num = POP_OBJ();
        PUSH_OBJ([EXToken tokenWithTokenType:TokenType_NUMBER stringValue:nil doubleValue:[num doubleValue]]);
    } else {
        raise("No viable alternative found in rule 'filterArg'.");
    }

}

void ExpressionParser::_primaryExpr() {
    
    if (predicts(TokenType_NUMBER, TokenType_QUOTED_STRING, TokenType_WORD, EXTokenType_FALSE, EXTokenType_NO_UPPER, EXTokenType_TRUE, EXTokenType_YES_UPPER, EXTokenType_NULL, 0)) {
        _atom();
    } else if (predicts(EXTokenType_OPEN_PAREN, 0)) {
        _subExpr();
    } else {
        raise("No viable alternative found in rule 'primaryExpr'.");
    }

}

void ExpressionParser::_subExpr() {
    
    match(EXTokenType_OPEN_PAREN, true);
    if (!isSpeculating()) {
        PUSH_OBJ(OPEN_PAREN);
    }
    _expr();
    match(EXTokenType_CLOSE_PAREN, true);
    if (!isSpeculating()) {
        id objs = OBJS_ABOVE(OPEN_PAREN);
        POP_OBJ(); // discard `(`
        PUSH_ALL_OBJS(REV(objs));
    }

}

void ExpressionParser::_atom() {
    
    if (predicts(TokenType_NUMBER, TokenType_QUOTED_STRING, EXTokenType_FALSE, EXTokenType_NO_UPPER, EXTokenType_TRUE, EXTokenType_YES_UPPER, EXTokenType_NULL, 0)) {
        _literal();
    } else if (predicts(TokenType_WORD, 0)) {
        _pathExpr();
    } else {
        raise("No viable alternative found in rule 'atom'.");
    }

}

void ExpressionParser::_pathExpr() {
    
    if (!isSpeculating()) {
        PUSH_OBJ(OPEN_PAREN);
    }
    _identifier();
    while (predicts(EXTokenType_DOT, 0)) {
        match(EXTokenType_DOT, true);
        _step();
    }
    if (!isSpeculating()) {
        id toks = REV(OBJS_ABOVE(OPEN_PAREN));
        POP_OBJ(); // discard `OPEN_PAREN`
        PUSH_OBJ([TDPathExpression pathExpressionWithSteps:toks]);
    }

}

void ExpressionParser::_step() {
    
    if (predicts(TokenType_WORD, 0)) {
        _identifier();
    } else if (predicts(TokenType_NUMBER, 0)) {
        _num();
    } else {
        raise("No viable alternative found in rule 'step'.");
    }

}

void ExpressionParser::_identifier() {
    
    match(TokenType_WORD, false);
    if (!isSpeculating()) {
        PUSH_OBJ(POP_TOK_STR());
    }

}

void ExpressionParser::_literal() {
    
    if (predicts(TokenType_QUOTED_STRING, 0)) {
        _str();
    } else if (predicts(TokenType_NUMBER, 0)) {
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
        if (!isSpeculating()) {
            PUSH_OBJ([TDBooleanValue booleanValueWithBoolean:YES]);
        }
    } else if (predicts(EXTokenType_FALSE, EXTokenType_NO_UPPER, 0)) {
        _false();
        if (!isSpeculating()) {
            PUSH_OBJ([TDBooleanValue booleanValueWithBoolean:NO]);
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
    if (!isSpeculating()) {
        PUSH_OBJ([TDNumericValue numericValueWithNumber:POP_TOK_DOUBLE()]);
    }

}

void ExpressionParser::_str() {
    
    match(TokenType_QUOTED_STRING, false);
    if (!isSpeculating()) {
        PUSH_OBJ([TDStringValue stringValueWithString:POP_TOK_QUOTED_STR()]);
    }

}

void ExpressionParser::_null() {
    
    match(EXTokenType_NULL, true);
    if (!isSpeculating()) {
        PUSH_OBJ([TDObjectValue objectValueWithObject:[NSNull null]]);
    }

}

}
