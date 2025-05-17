#import <Foundation/Foundation.h>
#import <ParseKitCPP/BaseParser.hpp>
#import <ParseKitCPP/ModalTokenizer.hpp>
#import "TagAssembly.hpp"
#import <TDTemplateEngine/TDTag.h>

@class TDTemplateEngine;
@class TDExpression;

using namespace parsekit;
namespace templateengine {

typedef NS_ENUM(int, TDTokenType) {
    TDTokenType_GT                   =   2,
    TDTokenType_GE_SYM               =   3,
    TDTokenType_DOUBLE_AMPERSAND     =   4,
    TDTokenType_PIPE                 =   5,
    TDTokenType_TRUE                 =   6,
    TDTokenType_NOT_EQUAL            =   7,
    TDTokenType_BANG                 =   8,
    TDTokenType_COLON                =   9,
    TDTokenType_LT_SYM               =  10,
    TDTokenType_MOD                  =  11,
    TDTokenType_LE                   =  12,
    TDTokenType_GT_SYM               =  13,
    TDTokenType_LT                   =  14,
    TDTokenType_OPEN_PAREN           =  15,
    TDTokenType_CLOSE_PAREN          =  16,
    TDTokenType_EQ                   =  17,
    TDTokenType_NE                   =  18,
    TDTokenType_OR                   =  19,
    TDTokenType_NOT                  =  20,
    TDTokenType_TIMES                =  21,
    TDTokenType_PLUS                 =  22,
    TDTokenType_DOUBLE_PIPE          =  23,
    TDTokenType_COMMA                =  24,
    TDTokenType_AND                  =  25,
    TDTokenType_YES_UPPER            =  26,
    TDTokenType_MINUS                =  27,
    TDTokenType_IN                   =  28,
    TDTokenType_DOT                  =  29,
    TDTokenType_DIV                  =  30,
    TDTokenType_BY                   =  31,
    TDTokenType_FALSE                =  32,
    TDTokenType_LE_SYM               =  33,
    TDTokenType_TO                   =  34,
    TDTokenType_GE                   =  35,
    TDTokenType_NO_UPPER             =  36,
    TDTokenType_ASSIGN               =  37,
    TDTokenType_DOUBLE_EQUALS        =  38,
    TDTokenType_NULL                 =  39,
    TDTokenType_WITH                 =  40,
    TDTokenType_AS                   =  41,
};

typedef std::map<std::string, TDTokenType> EXTokenTable;

class TagParser : public BaseParser {
private:
    TagAssembly *_assembly;
    
    TDTemplateEngine *_engine; // weakref
    
    bool _negation;
    bool _negative;

    NSArray *reversedArray(NSArray *inArray);
    void pushAll(NSArray *a);
    NSArray *objectsAbove(id fence);
    NSString *stringByTrimmingQuotes(NSString *inStr);
    
    void start();
    
    // tag
    void _tag(TDNode *parent);
    void _tagName(TDNode *parent);
    
    // tag types
    void _exprTag();
    void _loopTag(); void _identifiers();
    void _loadTag();
    void _argListTag();
    void _includeTag(); void _kwargs();
    void _cycleTag();

    void _expr();
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
    TagParser(); // testing only
    TagParser(TDTemplateEngine *engine);

    static Tokenizer *tokenizer();
    static const EXTokenTable& tokenTable();
    
    virtual Token edit_token_type(const Token& tok) const override {
        
        std::string s = _assembly->cpp_string_for_token(tok);
        const EXTokenTable tab = TagParser::tokenTable();
        
        TokenType tt;
        try {
            tt = tab.at(s);
        } catch (std::exception& ex) {
            tt = tok.token_type();
        }
        
        return Token(tt, tok.range(), tok.line_number());
    }
    
    TDTag *parseTag(Reader *r, TDNode *parent);
    TDExpression *parseExpression(Reader *r);

    Assembly *assembly() const override { return _assembly; }
};

}
