#import "TagParser.hpp"
    
#import "TDTemplateEngine.h"
#import "TDTemplateEngine+ParserSupport.h"
#import "TDTag.h"
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
#import "EXToken.h" // TODO remove

#import "TDArgListTag.h"
#import "TDIncludeTag.h"
#import "TDLoadTag.h"
#import "TDCycleTag.h"

#import <ParseKitCPP/ModalTokenizer.hpp>
#import <ParseKitCPP/DefaultTokenizerMode.hpp>

#define COLON @"COLON"
#define OPEN_PAREN @"OPEN_PAREN"

#define REV(a)                reversedArray(a)
#define OBJS_ABOVE(obj)       objectsAbove((obj))

#define PUSH_OBJ(obj)         _assembly->push_object((obj))
#define PUSH_ALL_OBJS(a)      pushAll((a))

#define POP_OBJ()             _assembly->pop_object()
#define PEEK_OBJ()            _assembly->peek_object()

#define POP_TOK()             _assembly->pop_token()
#define POP_TOK_STR()         [NSString stringWithUTF8String:_assembly->cpp_string_for_token(POP_TOK()).c_str()]
#define POP_TOK_QUOTED_STR()  stringByTrimmingQuotes(POP_TOK_STR())
#define POP_TOK_DOUBLE()      _assembly->float_for_token(_assembly->pop_token())

using namespace parsekit;
namespace templateengine {

Tokenizer *TagParser::tokenizer() {
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

const EXTokenTable& TagParser::tokenTable() {
    static EXTokenTable tokenTab = {
        {"gt", TDTokenType_GT},
        {">=", TDTokenType_GE_SYM},
        {"&&", TDTokenType_DOUBLE_AMPERSAND},
        {"|", TDTokenType_PIPE},
        {"true", TDTokenType_TRUE},
        {"!=", TDTokenType_NOT_EQUAL},
        {"!", TDTokenType_BANG},
        {":", TDTokenType_COLON},
        {"<", TDTokenType_LT_SYM},
        {"%", TDTokenType_MOD},
        {"le", TDTokenType_LE},
        {">", TDTokenType_GT_SYM},
        {"lt", TDTokenType_LT},
        {"(", TDTokenType_OPEN_PAREN},
        {")", TDTokenType_CLOSE_PAREN},
        {"eq", TDTokenType_EQ},
        {"ne", TDTokenType_NE},
        {"or", TDTokenType_OR},
        {"not", TDTokenType_NOT},
        {"*", TDTokenType_TIMES},
        {"+", TDTokenType_PLUS},
        {"||", TDTokenType_DOUBLE_PIPE},
        {",", TDTokenType_COMMA},
        {"and", TDTokenType_AND},
        {"YES", TDTokenType_YES_UPPER},
        {"-", TDTokenType_MINUS},
        {"in", TDTokenType_IN},
        {".", TDTokenType_DOT},
        {"/", TDTokenType_DIV},
        {"by", TDTokenType_BY},
        {"false", TDTokenType_FALSE},
        {"<=", TDTokenType_LE_SYM},
        {"to", TDTokenType_TO},
        {"ge", TDTokenType_GE},
        {"NO", TDTokenType_NO_UPPER},
        {"=", TDTokenType_ASSIGN},
        {"==", TDTokenType_DOUBLE_EQUALS},
        {"null", TDTokenType_NULL},
        {"with", TDTokenType_WITH},
        {"as", TDTokenType_AS},
        {"silent", TDTokenType_SILENT},
    };
    return tokenTab;
}

NSArray *TagParser::reversedArray(NSArray *inArray) {
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:inArray.count];
    for (id obj in [inArray reverseObjectEnumerator]) {
        [result addObject:obj];
    }
    return result;
}

void TagParser::pushAll(NSArray *a) {
    for (id obj in a) {
        _assembly->push_object(obj);
    }
}

NSArray *TagParser::objectsAbove(id fence) {
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

NSString *TagParser::stringByTrimmingQuotes(NSString *inStr) {
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

TagParser::TagParser() :
    BaseParser(tokenizer()),
    _engine(nullptr)
{}

TagParser::TagParser(TDTemplateEngine *engine) :
    BaseParser(tokenizer()),
    _engine(engine)
{}

TDTag *TagParser::parseTag(Reader *r, TDNode *parent) {
    TokenList lookahead;
    _lookahead = &lookahead;
    
    IntStack markers;
    _markers = &markers;
    
    TokenList token_stack;
    TokenList consumed;
    TagAssembly a(r, &token_stack, &consumed);
    _assembly = &a;

    _p = 0;
    
    TDTag *tag = nil;
    try {
        _tag(parent);
        match(TokenType_EOF);
        
        tag = POP_OBJ();
    } catch (std::exception& ex) {
        assert(0);
    }

    _assembly = nullptr;
    _markers = nullptr;
    _lookahead = nullptr;

    return tag;
}

void TagParser::_tag(TDNode *parent) {
    
    _tagName(parent);
    
    if (!predicts(TokenType_EOF, 0)) {
        assert(!isSpeculating());
        
        TDTag *tag = PEEK_OBJ();
        TDTagExpressionType et = [[tag class] tagExpressionType];

        switch (et) {
            case TDTagExpressionTypeDefault:
                _exprTag();
                break;
            case TDTagExpressionTypeLoop:
                _loopTag();
                break;
            case TDTagExpressionTypeArgList:
                _argListTag();
                break;
            case TDTagExpressionTypeLoad:
                _loadTag();
                break;
            case TDTagExpressionTypeInclude:
                _includeTag();
                break;
            case TDTagExpressionTypeCycle:
                _cycleTag();
                break;
            default:
                assert(0);
                break;
        }
    }
}

void TagParser::_tagName(TDNode *parent) {
    if (predicts(TokenType_WORD, 0)) {
        match(TokenType_ANY, false);
    }
    
    assert(!isSpeculating());
    Token tok = POP_TOK();
    
    NSString *tagName = _assembly->reader()->objc_substr(tok);

    TDTag *tag = [_engine makeTagForName:tagName token:tok parent:parent];
    assert(tag);
    
    PUSH_OBJ(tag);
}

#pragma mark -
#pragma mark ExprTag

void TagParser::_exprTag() {
    _expr();
    
    assert(!isSpeculating());
    
    TDExpression *path = POP_OBJ();
    TDTag *tag = PEEK_OBJ();
    tag.expression = path;
}

#pragma mark -
#pragma mark LoopTag

void TagParser::_loopTag() {
    _identifiers();
    match(TDTokenType_IN, true);
    _enumExpr();
    if (!isSpeculating()) {
        id enumExpr = POP_OBJ();
        id vars = POP_OBJ();
        TDTag *tag = PEEK_OBJ();
        tag.expression = [TDLoopExpression loopExpressionWithVariables:vars enumeration:enumExpr];
    }
}

#pragma mark -
#pragma mark ArgListTag

void TagParser::_argListTag() {
    assert(!isSpeculating());
    
    NSMutableArray *args = [NSMutableArray array];

    // args must be evaled at run time
    while (!predicts(TokenType_EOF, 0)) {
        _atom();
        
        TDExpression *expr = POP_OBJ();
        [args addObject:expr];
    }
    
    TDArgListTag *tag = POP_OBJ();
    tag.args = args;
}

#pragma mark -
#pragma mark LoadTag

void TagParser::_loadTag() {
    assert(!isSpeculating());
    
    // lib names are compile time constants, not to be eval'ed at runtime
    NSMutableArray *libNames = [NSMutableArray array];
    
    while (predicts(TokenType_WORD, 0)) {
        match(TokenType_WORD, false);
        Token tok = POP_TOK();
        NSString *libName = assembly()->reader()->objc_substr(tok);
        [libNames addObject:libName];
    }
    
    TDLoadTag *loadTag = POP_OBJ();
    loadTag.tagLibraryNames = libNames;
}

#pragma mark -
#pragma mark IncludeTag

void TagParser::_includeTag() {
    _atom(); // path
    // path is on stack here
    assert(!isSpeculating());
    
    TDExpression *path = POP_OBJ();
    assert(path);
    
    TDIncludeTag *includeTag = POP_OBJ();
    assert(includeTag);
    
    includeTag.expression = path;
    
    if (predicts(TDTokenType_WITH, 0)) {
        match(TDTokenType_WITH, true);
        _kwargs();
        // kwargs are on stack here
        NSDictionary *kwargs = POP_OBJ();
        includeTag.kwargs = kwargs;
    }
    
    PUSH_OBJ(includeTag);
}

void TagParser::_kwargs() {
    
    NSMutableDictionary *tab = nil;
    if (!isSpeculating()) {
        tab = [NSMutableDictionary dictionary];
    }
    
    while (!predicts(TokenType_EOF, 0)) {
        _identifier();
        match(TDTokenType_ASSIGN, true);
        _atom();
        
        if (!isSpeculating()) {
            id val = POP_OBJ();
            id key = POP_OBJ();
            [tab setObject:val forKey:key];
        }
    }
    
    if (!isSpeculating()) {
        PUSH_OBJ(tab);
    }
}

#pragma mark -
#pragma mark CycleTag

void TagParser::_cycleTag() {
    
    NSMutableArray *values = [NSMutableArray array];
    
    while (!predicts(TDTokenType_AS, TokenType_EOF, 0)) {
        _atom();
        
        TDExpression *expr = POP_OBJ();
        [values addObject:expr];
    }
    
    TDCycleTag *tag = PEEK_OBJ();
    tag.values = values;
    
    if (predicts(TDTokenType_AS, 0)) {
        match(TDTokenType_AS, true);
        _identifier();
        
        NSString *name = POP_OBJ();
        tag.name = name;
    }
    
    if (predicts(TDTokenType_SILENT, 0)) {
        match(TDTokenType_SILENT, true);
        tag.silent = YES;
    } else {
        tag.silent = NO;
    }
    
}

TDExpression *TagParser::parseExpression(Reader *r) {
    TokenList lookahead;
    _lookahead = &lookahead;
    
    IntStack markers;
    _markers = &markers;
    
    TokenList token_stack;
    TokenList consumed;
    TagAssembly a(r, &token_stack, &consumed);
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

#pragma mark -
#pragma mark Default

void TagParser::_expr() {
    _orExpr();
}

void TagParser::_identifiers() {
    
    if (!isSpeculating()) {
        PUSH_OBJ(OPEN_PAREN);
    }
    _identifier();
    if (predicts(TDTokenType_COMMA, 0)) {
        match(TDTokenType_COMMA, true);
        _identifier();
    }
    if (!isSpeculating()) {
        id strs = REV(OBJS_ABOVE(OPEN_PAREN));
        POP_OBJ(); // discard `(`
        PUSH_OBJ(strs);
    }

}

void TagParser::_enumExpr() {
    
    if (speculate([&]{ _rangeExpr(); })) {
        _rangeExpr();
    } else if (speculate([&]{ _collectionExpr(); })) {
        _collectionExpr();
    } else {
        raise("No viable alternative found in rule 'enumExpr'.");
    }

}

void TagParser::_collectionExpr() {
    
    _primaryExpr();
    if (!isSpeculating()) {
        id expr = POP_OBJ();
        PUSH_OBJ([TDCollectionExpression collectionExpressionWithExpression:expr]);
    }

}

void TagParser::_rangeExpr() {
    
    _unaryExpr();
    match(TDTokenType_TO, true);
    _unaryExpr();
    _optBy();
    if (!isSpeculating()) {
        id by = POP_OBJ();
        id stop = POP_OBJ();
        id start = POP_OBJ();
        PUSH_OBJ([TDRangeExpression rangeExpressionWithStart:start stop:stop by:by]);
    }

}

void TagParser::_optBy() {
    
    if (predicts(TDTokenType_BY, 0)) {
        match(TDTokenType_BY, true);
        _unaryExpr();
    } else {
        //[self matchEmpty:NO];
        if (!isSpeculating()) {
            PUSH_OBJ([TDNumericValue numericValueWithNumber:0.0]);
        }
    }

}

void TagParser::_orOp() {
    
    if (predicts(TDTokenType_OR, 0)) {
        match(TDTokenType_OR, true);
    } else if (predicts(TDTokenType_DOUBLE_PIPE, 0)) {
        match(TDTokenType_DOUBLE_PIPE, true);
    } else {
        raise("No viable alternative found in rule 'orOp'.");
    }

}

void TagParser::_orExpr() {
    
    _andExpr();
    while (predicts(TDTokenType_OR, TDTokenType_DOUBLE_PIPE, 0)) {
        _orOp();
        _andExpr();
        if (!isSpeculating()) {
            TDValue *rhs = POP_OBJ();
            TDValue *lhs = POP_OBJ();
            PUSH_OBJ([TDBooleanExpression booleanExpressionWithOperand:lhs operator:TDTokenType_OR operand:rhs]);
        }
    }

}

void TagParser::_andOp() {
    
    if (predicts(TDTokenType_AND, 0)) {
        match(TDTokenType_AND, true);
    } else if (predicts(TDTokenType_DOUBLE_AMPERSAND, 0)) {
        match(TDTokenType_DOUBLE_AMPERSAND, true);
    } else {
        raise("No viable alternative found in rule 'andOp'.");
    }

}

void TagParser::_andExpr() {
    
    _equalityExpr();
    while (predicts(TDTokenType_AND, TDTokenType_DOUBLE_AMPERSAND, 0)) {
        _andOp();
        _equalityExpr();
        if (!isSpeculating()) {
            TDValue *rhs = POP_OBJ();
            TDValue *lhs = POP_OBJ();
            PUSH_OBJ([TDBooleanExpression booleanExpressionWithOperand:lhs operator:TDTokenType_AND operand:rhs]);
        }
    }

}

void TagParser::_eqOp() {
    
    if (predicts(TDTokenType_DOUBLE_EQUALS, 0)) {
        match(TDTokenType_DOUBLE_EQUALS, true);
    } else if (predicts(TDTokenType_EQ, 0)) {
        match(TDTokenType_EQ, true);
    } else {
        raise("No viable alternative found in rule 'eqOp'.");
    }
    if (!isSpeculating()) {
        PUSH_OBJ(@(TDTokenType_EQ));
    }

}

void TagParser::_neOp() {
    
    if (predicts(TDTokenType_NOT_EQUAL, 0)) {
        match(TDTokenType_NOT_EQUAL, true);
    } else if (predicts(TDTokenType_NE, 0)) {
        match(TDTokenType_NE, true);
    } else {
        raise("No viable alternative found in rule 'neOp'.");
    }
    if (!isSpeculating()) {
        PUSH_OBJ(@(TDTokenType_NE));
    }

}

void TagParser::_equalityExpr() {
    
    _relationalExpr();
    while (predicts(TDTokenType_DOUBLE_EQUALS, TDTokenType_EQ, TDTokenType_NE, TDTokenType_NOT_EQUAL, 0)) {
        if (predicts(TDTokenType_DOUBLE_EQUALS, TDTokenType_EQ, 0)) {
            _eqOp();
        } else if (predicts(TDTokenType_NE, TDTokenType_NOT_EQUAL, 0)) {
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

void TagParser::_ltOp() {
    
    if (predicts(TDTokenType_LT_SYM, 0)) {
        match(TDTokenType_LT_SYM, true);
    } else if (predicts(TDTokenType_LT, 0)) {
        match(TDTokenType_LT, true);
    } else {
        raise("No viable alternative found in rule 'ltOp'.");
    }
    if (!isSpeculating()) {
        PUSH_OBJ(@(TDTokenType_LT));
    }

}

void TagParser::_gtOp() {
    
    if (predicts(TDTokenType_GT_SYM, 0)) {
        match(TDTokenType_GT_SYM, true);
    } else if (predicts(TDTokenType_GT, 0)) {
        match(TDTokenType_GT, true);
    } else {
        raise("No viable alternative found in rule 'gtOp'.");
    }
    if (!isSpeculating()) {
        PUSH_OBJ(@(TDTokenType_GT));
    }

}

void TagParser::_leOp() {
    
    if (predicts(TDTokenType_LE_SYM, 0)) {
        match(TDTokenType_LE_SYM, true);
    } else if (predicts(TDTokenType_LE, 0)) {
        match(TDTokenType_LE, true);
    } else {
        raise("No viable alternative found in rule 'leOp'.");
    }
    if (!isSpeculating()) {
        PUSH_OBJ(@(TDTokenType_LE));
    }

}

void TagParser::_geOp() {
    
    if (predicts(TDTokenType_GE_SYM, 0)) {
        match(TDTokenType_GE_SYM, true);
    } else if (predicts(TDTokenType_GE, 0)) {
        match(TDTokenType_GE, true);
    } else {
        raise("No viable alternative found in rule 'geOp'.");
    }
    {
        PUSH_OBJ(@(TDTokenType_GE));
    }

}

void TagParser::_relationalExpr() {
    
    _additiveExpr();
    while (predicts(TDTokenType_LT, TDTokenType_LT_SYM, TDTokenType_GT, TDTokenType_GT_SYM, TDTokenType_LE, TDTokenType_LE_SYM, TDTokenType_GE, TDTokenType_GE_SYM, 0)) {
        if (predicts(TDTokenType_LT, TDTokenType_LT_SYM, 0)) {
            _ltOp();
        } else if (predicts(TDTokenType_GT, TDTokenType_GT_SYM, 0)) {
            _gtOp();
        } else if (predicts(TDTokenType_LE, TDTokenType_LE_SYM, 0)) {
            _leOp();
        } else if (predicts(TDTokenType_GE, TDTokenType_GE_SYM, 0)) {
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

void TagParser::_plus() {
    
    match(TDTokenType_PLUS, true);
    if (!isSpeculating()) {
        PUSH_OBJ(@(TDTokenType_PLUS));
    }

}

void TagParser::_minus() {
    
    match(TDTokenType_MINUS, true);
    if (!isSpeculating()) {
        PUSH_OBJ(@(TDTokenType_MINUS));
    }

}

void TagParser::_additiveExpr() {
    
    _multiplicativeExpr();
    while (predicts(TDTokenType_PLUS, TDTokenType_MINUS, 0)) {
        if (predicts(TDTokenType_PLUS, 0)) {
            _plus();
        } else if (predicts(TDTokenType_MINUS, 0)) {
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

void TagParser::_times() {
    
    match(TDTokenType_TIMES, true);
    if (!isSpeculating()) {
        PUSH_OBJ(@(TDTokenType_TIMES));
    }

}

void TagParser::_div() {
    
    match(TDTokenType_DIV, true);
    if (!isSpeculating()) {
        PUSH_OBJ(@(TDTokenType_DIV));
    }

}

void TagParser::_mod() {
    
    match(TDTokenType_MOD, true);
    if (!isSpeculating()) {
        PUSH_OBJ(@(TDTokenType_MOD));
    }

}

void TagParser::_multiplicativeExpr() {
    
    _unaryExpr();
    while (predicts(TDTokenType_TIMES, TDTokenType_DIV, TDTokenType_MOD, 0)) {
        if (predicts(TDTokenType_TIMES, 0)) {
            _times();
        } else if (predicts(TDTokenType_DIV, 0)) {
            _div();
        } else if (predicts(TDTokenType_MOD, 0)) {
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

void TagParser::_unaryExpr() {
    
    if (predicts(TDTokenType_BANG, TDTokenType_NOT, 0)) {
        _negatedUnary();
    } else if (predicts(TokenType_NUMBER, TokenType_QUOTED_STRING, TokenType_WORD, TDTokenType_FALSE, TDTokenType_MINUS, TDTokenType_NO_UPPER, TDTokenType_OPEN_PAREN, TDTokenType_TRUE, TDTokenType_YES_UPPER, TDTokenType_NULL, 0)) {
        _unary();
    } else {
        raise("No viable alternative found in rule 'unaryExpr'.");
    }

}

void TagParser::_negatedUnary() {
    
    if (!isSpeculating()) {
        _negation = NO;
    }
    do {
        if (predicts(TDTokenType_NOT, 0)) {
            match(TDTokenType_NOT, true);
        } else if (predicts(TDTokenType_BANG, 0)) {
            match(TDTokenType_BANG, true);
        } else {
            raise("No viable alternative found in rule 'negatedUnary'.");
        }
        if (!isSpeculating()) {
         _negation = !_negation;
        }
    } while (predicts(TDTokenType_BANG, TDTokenType_NOT, 0));
    _unary();
    if (!isSpeculating()) {
        if (_negation) {
            PUSH_OBJ([TDNegationExpression negationExpressionWithExpression:POP_OBJ()]);
        }
    }

}

void TagParser::_unary() {
    
    if (predicts(TDTokenType_MINUS, 0)) {
        _signedFilterExpr();
    } else if (predicts(TokenType_NUMBER, TokenType_QUOTED_STRING, TokenType_WORD, TDTokenType_FALSE, TDTokenType_NO_UPPER, TDTokenType_OPEN_PAREN, TDTokenType_TRUE, TDTokenType_YES_UPPER, TDTokenType_NULL, 0)) {
        _filterExpr();
    } else {
        raise("No viable alternative found in rule 'unary'.");
    }

}

void TagParser::_signedFilterExpr() {
    
    if (!isSpeculating()) {
        _negative = NO;
    }
    do {
        match(TDTokenType_MINUS, true);
        if (!isSpeculating()) {
            _negative = !_negative;
        }
    } while (predicts(TDTokenType_MINUS, 0));
    _filterExpr();
    if (!isSpeculating()) {
        if (_negative) {
            PUSH_OBJ([TDUnaryExpression unaryExpressionWithExpression:POP_OBJ()]);
        }
    }

}

void TagParser::_filterExpr() {
    
    _primaryExpr();
    while (predicts(TDTokenType_PIPE, 0)) {
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

void TagParser::_filter() {
    
    match(TDTokenType_PIPE, true);
    _identifier();
    _filterArgs();

}

void TagParser::_filterArgs() {
    
    if (predicts(TDTokenType_COLON, 0)) {
        match(TDTokenType_COLON, true);
        PUSH_OBJ(COLON);
        _filterArg();
        while (predicts(TDTokenType_COMMA, 0)) {
            match(TDTokenType_COMMA, true);
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

void TagParser::_filterArg() {
    
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

void TagParser::_primaryExpr() {
    
    if (predicts(TokenType_NUMBER, TokenType_QUOTED_STRING, TokenType_WORD, TDTokenType_FALSE, TDTokenType_NO_UPPER, TDTokenType_TRUE, TDTokenType_YES_UPPER, TDTokenType_NULL, 0)) {
        _atom();
    } else if (predicts(TDTokenType_OPEN_PAREN, 0)) {
        _subExpr();
    } else {
        raise("No viable alternative found in rule 'primaryExpr'.");
    }

}

void TagParser::_subExpr() {
    
    match(TDTokenType_OPEN_PAREN, true);
    if (!isSpeculating()) {
        PUSH_OBJ(OPEN_PAREN);
    }
    _expr();
    match(TDTokenType_CLOSE_PAREN, true);
    if (!isSpeculating()) {
        id objs = OBJS_ABOVE(OPEN_PAREN);
        POP_OBJ(); // discard `(`
        PUSH_ALL_OBJS(REV(objs));
    }

}

void TagParser::_atom() {
    
    if (predicts(TokenType_NUMBER, TokenType_QUOTED_STRING, TDTokenType_FALSE, TDTokenType_NO_UPPER, TDTokenType_TRUE, TDTokenType_YES_UPPER, TDTokenType_NULL, 0)) {
        _literal();
    } else if (predicts(TokenType_WORD, 0)) {
        _pathExpr();
    } else {
        raise("No viable alternative found in rule 'atom'.");
    }

}

void TagParser::_pathExpr() {
    
    if (!isSpeculating()) {
        PUSH_OBJ(OPEN_PAREN);
    }
    _identifier();
    while (predicts(TDTokenType_DOT, 0)) {
        match(TDTokenType_DOT, true);
        _step();
    }
    if (!isSpeculating()) {
        id toks = REV(OBJS_ABOVE(OPEN_PAREN));
        POP_OBJ(); // discard `OPEN_PAREN`
        PUSH_OBJ([TDPathExpression pathExpressionWithSteps:toks]);
    }

}

void TagParser::_step() {
    
    if (predicts(TokenType_WORD, 0)) {
        _identifier();
    } else if (predicts(TokenType_NUMBER, 0)) {
        _num();
    } else {
        raise("No viable alternative found in rule 'step'.");
    }

}

void TagParser::_identifier() {
    
    match(TokenType_WORD, false);
    if (!isSpeculating()) {
        PUSH_OBJ(POP_TOK_STR());
    }

}

void TagParser::_literal() {
    
    if (predicts(TokenType_QUOTED_STRING, 0)) {
        _str();
    } else if (predicts(TokenType_NUMBER, 0)) {
        _num();
    } else if (predicts(TDTokenType_FALSE, TDTokenType_NO_UPPER, TDTokenType_TRUE, TDTokenType_YES_UPPER, 0)) {
        _bool();
    } else if (predicts(TDTokenType_NULL, 0)) {
        _null();
    } else {
        raise("No viable alternative found in rule 'literal'.");
    }

}

void TagParser::_bool() {
    
    if (predicts(TDTokenType_TRUE, TDTokenType_YES_UPPER, 0)) {
        _true();
        if (!isSpeculating()) {
            PUSH_OBJ([TDBooleanValue booleanValueWithBoolean:YES]);
        }
    } else if (predicts(TDTokenType_FALSE, TDTokenType_NO_UPPER, 0)) {
        _false();
        if (!isSpeculating()) {
            PUSH_OBJ([TDBooleanValue booleanValueWithBoolean:NO]);
        }
    } else {
        raise("No viable alternative found in rule 'bool'.");
    }

}

void TagParser::_true() {
    
    if (predicts(TDTokenType_TRUE, 0)) {
        match(TDTokenType_TRUE, true);
    } else if (predicts(TDTokenType_YES_UPPER, 0)) {
        match(TDTokenType_YES_UPPER, true);
    } else {
        raise("No viable alternative found in rule 'true'.");
    }

}

void TagParser::_false() {
    
    if (predicts(TDTokenType_FALSE, 0)) {
        match(TDTokenType_FALSE, true);
    } else if (predicts(TDTokenType_NO_UPPER, 0)) {
        match(TDTokenType_NO_UPPER, true);
    } else {
        raise("No viable alternative found in rule 'false'.");
    }

}

void TagParser::_num() {
    
    match(TokenType_NUMBER, false);
    if (!isSpeculating()) {
        PUSH_OBJ([TDNumericValue numericValueWithNumber:POP_TOK_DOUBLE()]);
    }

}

void TagParser::_str() {
    
    match(TokenType_QUOTED_STRING, false);
    if (!isSpeculating()) {
        PUSH_OBJ([TDStringValue stringValueWithString:POP_TOK_QUOTED_STR()]);
    }

}

void TagParser::_null() {
    
    match(TDTokenType_NULL, true);
    if (!isSpeculating()) {
        PUSH_OBJ([TDObjectValue objectValueWithObject:[NSNull null]]);
    }

}

}
