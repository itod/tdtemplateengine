#import <PEGKit/PKParser.h>

enum {
    TDTEMPLATE_TOKEN_KIND_OUT = 14,
    TDTEMPLATE_TOKEN_KIND_OPENTAG,
    TDTEMPLATE_TOKEN_KIND_CLOSETAG,
};

@interface TDTemplateParser : PKParser

@end

