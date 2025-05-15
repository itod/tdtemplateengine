#import <Foundation/Foundation.h>
#import <ParseKitCPP/BaseParser.hpp>
#import <ParseKitCPP/ModalTokenizer.hpp>
#import "ExpressionAssembly.hpp"

@class TDTemplateEngine;
@class TDExpression;

using namespace parsekit;
namespace templateengine {

typedef NS_ENUM(int, EXTokenType) {
//    EXTokenType_GT                   =   2,
//    EXTokenType_GE_SYM               =   3,
//    EXTokenType_DOUBLE_AMPERSAND     =   4,
//    EXTokenType_PIPE                 =   5,
//    EXTokenType_TRUE                 =   6,
//    EXTokenType_NOT_EQUAL            =   7,
//    EXTokenType_BANG                 =   8,
//    EXTokenType_COLON                =   9,
//    EXTokenType_LT_SYM               =  10,
//    EXTokenType_MOD                  =  11,
//    EXTokenType_LE                   =  12,
//    EXTokenType_GT_SYM               =  13,
//    EXTokenType_LT                   =  14,
//    EXTokenType_OPEN_PAREN           =  15,
//    EXTokenType_CLOSE_PAREN          =  16,
//    EXTokenType_EQ                   =  17,
//    EXTokenType_NE                   =  18,
//    EXTokenType_OR                   =  19,
//    EXTokenType_NOT                  =  20,
//    EXTokenType_TIMES                =  21,
//    EXTokenType_PLUS                 =  22,
//    EXTokenType_DOUBLE_PIPE          =  23,
//    EXTokenType_COMMA                =  24,
//    EXTokenType_AND                  =  25,
//    EXTokenType_YES_UPPER            =  26,
//    EXTokenType_MINUS                =  27,
//    EXTokenType_IN                   =  28,
//    EXTokenType_DOT                  =  29,
//    EXTokenType_DIV                  =  30,
//    EXTokenType_BY                   =  31,
//    EXTokenType_FALSE                =  32,
//    EXTokenType_LE_SYM               =  33,
//    EXTokenType_TO                   =  34,
//    EXTokenType_GE                   =  35,
//    EXTokenType_NO_UPPER             =  36,
//    EXTokenType_DOUBLE_EQUALS        =  37,
//    EXTokenType_NULL                 =  38,
    
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

typedef std::map<std::string, EXTokenType> EXTokenTable;

class ExpressionParser : public BaseParser {
private:
    ExpressionAssembly *_assembly;
    
    TDTemplateEngine *_engine; // weakref
    bool _doLoopExpr;
    bool _negation;
    bool _negative;

    NSArray *reversedArray(NSArray *inArray);
    void pushAll(NSArray *a);
    NSArray *objectsAbove(id fence);
    NSString *stringByTrimmingQuotes(NSString *inStr);
    
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
    ExpressionParser(); // testing only
    ExpressionParser(TDTemplateEngine *engine);

    static Tokenizer *tokenizer();
    static const EXTokenTable& tokenTable();
    
    virtual Token edit_token_type(const Token& tok) const override {
        
        std::string s = _assembly->cpp_string_for_token(tok);
        const EXTokenTable tab = ExpressionParser::tokenTable();
        
        TokenType tt;
        try {
            tt = tab.at(s);
        } catch (std::exception& ex) {
            tt = tok.token_type();
        }
        
        return Token(tt, tok.range(), tok.line_number());
    }
    
    TDExpression *parse(Reader *r);

    Assembly *assembly() const override { return _assembly; }
    
    bool doLoopExpr() const { return _doLoopExpr; }
    void setDoLoopExpr(bool yn) { _doLoopExpr = yn; }
};

}
