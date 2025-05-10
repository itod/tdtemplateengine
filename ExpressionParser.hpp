#import <ParseKitCPP/BaseParser.hpp>
#import <ParseKitCPP/ModalTokenizer.hpp>
#import "ExpressionAssembly.hpp"

@class TDTemplateEngine;

using namespace parsekit;
namespace tdtemplateengine {

typedef NS_ENUM(int, EXTokenType) {
    EXTokenType_GT = 14,
    EXTokenType_GE_SYM = 15,
    EXTokenType_DOUBLE_AMPERSAND = 16,
    EXTokenType_PIPE = 17,
    EXTokenType_TRUE = 18,
    EXTokenType_NOT_EQUAL = 19,
    EXTokenType_BANG = 20,
    EXTokenType_COLON = 21,
    EXTokenType_LT_SYM = 22,
    EXTokenType_MOD = 23,
    EXTokenType_LE = 24,
    EXTokenType_GT_SYM = 25,
    EXTokenType_LT = 26,
    EXTokenType_OPEN_PAREN = 27,
    EXTokenType_CLOSE_PAREN = 28,
    EXTokenType_EQ = 29,
    EXTokenType_NE = 30,
    EXTokenType_OR = 31,
    EXTokenType_NOT = 32,
    EXTokenType_TIMES = 33,
    EXTokenType_PLUS = 34,
    EXTokenType_DOUBLE_PIPE = 35,
    EXTokenType_COMMA = 36,
    EXTokenType_AND = 37,
    EXTokenType_YES_UPPER = 38,
    EXTokenType_MINUS = 39,
    EXTokenType_IN = 40,
    EXTokenType_DOT = 41,
    EXTokenType_DIV = 42,
    EXTokenType_BY = 43,
    EXTokenType_FALSE = 44,
    EXTokenType_LE_SYM = 45,
    EXTokenType_TO = 46,
    EXTokenType_GE = 47,
    EXTokenType_NO_UPPER = 48,
    EXTokenType_DOUBLE_EQUALS = 49,
    EXTokenType_NULL = 50,
};

class ExpressionParser : public BaseParser {
private:
    Tokenizer *_tokenizer;
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

    static Tokenizer *tokenizer();

    Assembly *assembly() const override { return _assembly; }
    //ModalTokenizerPtr tokenizer() const { return _tokenizer; }
    
    bool doLoopExpr() const { return _doLoopExpr; }
    void setDoLoopExpr(bool yn) { _doLoopExpr = yn; }
};

}
