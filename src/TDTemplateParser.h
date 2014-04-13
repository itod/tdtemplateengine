#import <PEGKit/PKParser.h>
        
@class TDTemplateEngine;
@class TDTemplateContext;

enum {
    TDTEMPLATE_TOKEN_KIND_BLOCK_START_TAG = 14,
    TDTEMPLATE_TOKEN_KIND_PRINT,
    TDTEMPLATE_TOKEN_KIND_BLOCK_END_TAG,
    TDTEMPLATE_TOKEN_KIND_EMPTY_TAG,
    TDTEMPLATE_TOKEN_KIND_TEXT,
};

@interface TDTemplateParser : PKParser
        
@property (nonatomic, assign) TDTemplateEngine *engine; // weakref
@property (nonatomic, retain) TDTemplateContext *staticContext;

@end

