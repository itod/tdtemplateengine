#import <ParseKitCPP/BaseParser.hpp>
#import <ParseKitCPP/ModalTokenizer.hpp>

@class TDTemplateEngine;

namespace parsekit {


enum {
    TD_TOKEN_KIND_GT = 14,
    TD_TOKEN_KIND_GE_SYM = 15,
    TD_TOKEN_KIND_DOUBLE_AMPERSAND = 16,
    TD_TOKEN_KIND_PIPE = 17,
    TD_TOKEN_KIND_TRUE = 18,
    TD_TOKEN_KIND_NOT_EQUAL = 19,
    TD_TOKEN_KIND_BANG = 20,
    TD_TOKEN_KIND_COLON = 21,
    TD_TOKEN_KIND_LT_SYM = 22,
    TD_TOKEN_KIND_MOD = 23,
    TD_TOKEN_KIND_LE = 24,
    TD_TOKEN_KIND_GT_SYM = 25,
    TD_TOKEN_KIND_LT = 26,
    TD_TOKEN_KIND_OPEN_PAREN = 27,
    TD_TOKEN_KIND_CLOSE_PAREN = 28,
    TD_TOKEN_KIND_EQ = 29,
    TD_TOKEN_KIND_NE = 30,
    TD_TOKEN_KIND_OR = 31,
    TD_TOKEN_KIND_NOT = 32,
    TD_TOKEN_KIND_TIMES = 33,
    TD_TOKEN_KIND_PLUS = 34,
    TD_TOKEN_KIND_DOUBLE_PIPE = 35,
    TD_TOKEN_KIND_COMMA = 36,
    TD_TOKEN_KIND_AND = 37,
    TD_TOKEN_KIND_YES_UPPER = 38,
    TD_TOKEN_KIND_MINUS = 39,
    TD_TOKEN_KIND_IN = 40,
    TD_TOKEN_KIND_DOT = 41,
    TD_TOKEN_KIND_DIV = 42,
    TD_TOKEN_KIND_BY = 43,
    TD_TOKEN_KIND_FALSE = 44,
    TD_TOKEN_KIND_LE_SYM = 45,
    TD_TOKEN_KIND_TO = 46,
    TD_TOKEN_KIND_GE = 47,
    TD_TOKEN_KIND_NO_UPPER = 48,
    TD_TOKEN_KIND_DOUBLE_EQUALS = 49,
    TD_TOKEN_KIND_NULL = 50,
};

class ExpressionAssembly;

class ExpressionParser : public BaseParser {
private:
    ModalTokenizerPtr _tokenizer;
    ExpressionAssembly *_assembly;
    
    TDTemplateEngine *_engine; // weakref
    bool _doLoopExpr;
    
    
    void start();
    
    void _expr();
    void _loopExpr();
    void _identifiers();
    void _enumExpr();
    void _collectionExpr();
    void _rangeExpr();
    void _optBy();
    void _orOp();
    void _orExpr();
    void _andOp();
    void _andExpr();
    void _eqOp();
    void _neOp();
    void _equalityExpr();
    void _ltOp();
    void _gtOp();
    void _leOp();
    void _geOp();
    void _relationalExpr();
    void _plus();
    void _minus();
    void _additiveExpr();
    void _times();
    void _div();
    void _mod();
    void _multiplicativeExpr();
    void _unaryExpr();
    void _negatedUnary();
    void _unary();
    void _signedFilterExpr();
    void _filterExpr();
    void _filter();
    void _filterArgs();
    void _filterArg();
    void _primaryExpr();
    void _subExpr();
    void _atom();
    void _pathExpr();
    void _step();
    void _identifier();
    void _literal();
    void _bool();
    void _true();
    void _false();
    void _num();
    void _str();
    void _null();

public:
    ExpressionParser();
    
    Assembly *assembly() const override { return _assembly; }
    ModalTokenizerPtr tokenizer() const { return _tokenizer; }
    
    bool doLoopExpr() const { return _doLoopExpr; }
    void setDoLoopExpr(bool yn) { _doLoopExpr = yn; }
};

}
