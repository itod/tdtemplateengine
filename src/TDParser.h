#import <PEGKit/PKParser.h>
        
@class PKTokenizer;
@class TDTemplateEngine;

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
};

@interface TDParser : PKParser
        
+ (PKTokenizer *)tokenizer;

@property (nonatomic, assign) TDTemplateEngine *engine; // weakref
@property (nonatomic, assign) BOOL doLoopExpr;

@end

