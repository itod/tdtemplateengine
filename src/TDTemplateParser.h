#import <PEGKit/PKParser.h>
        
@class TDTemplateContext;

enum {
    TDTEMPLATE_TOKEN_KIND_HELPER_START_TAG = 14,
    TDTEMPLATE_TOKEN_KIND_VAR,
    TDTEMPLATE_TOKEN_KIND_BLOCK_START_TAG,
    TDTEMPLATE_TOKEN_KIND_BLOCK_END_TAG,
    TDTEMPLATE_TOKEN_KIND_EMPTY_TAG,
    TDTEMPLATE_TOKEN_KIND_TEXT,
};

@interface TDTemplateParser : PKParser
        
@property (nonatomic, retain) TDTemplateContext *staticContext;

@end

