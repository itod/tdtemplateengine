#import "TDTemplateParser.h"
#import <PEGKit/PEGKit.h>


@interface TDTemplateParser ()

@end

@implementation TDTemplateParser { }

- (id)initWithDelegate:(id)d {
    self = [super initWithDelegate:d];
    if (self) {
        
        self.startRuleName = @"template";
        self.tokenKindTab[@"out"] = @(TDTEMPLATE_TOKEN_KIND_OUT);
        self.tokenKindTab[@"openTag"] = @(TDTEMPLATE_TOKEN_KIND_OPENTAG);
        self.tokenKindTab[@"closeTag"] = @(TDTEMPLATE_TOKEN_KIND_CLOSETAG);

        self.tokenKindNameTab[TDTEMPLATE_TOKEN_KIND_OUT] = @"out";
        self.tokenKindNameTab[TDTEMPLATE_TOKEN_KIND_OPENTAG] = @"openTag";
        self.tokenKindNameTab[TDTEMPLATE_TOKEN_KIND_CLOSETAG] = @"closeTag";

    }
    return self;
}

- (void)dealloc {
    

    [super dealloc];
}

- (void)start {

    [self template_]; 
    [self matchEOF:YES]; 

}

- (void)template_ {
    
    if ([self predicts:TDTEMPLATE_TOKEN_KIND_OUT, 0]) {
        [self out_]; 
    } else if ([self predicts:TDTEMPLATE_TOKEN_KIND_OPENTAG, 0]) {
        [self tag_]; 
    } else if ([self predicts:TOKEN_KIND_BUILTIN_ANY, 0]) {
        [self text_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'template'."];
    }

}

- (void)out_ {
    
    [self match:TDTEMPLATE_TOKEN_KIND_OUT discard:NO]; 

}

- (void)tag_ {
    
    [self openTag_]; 
    [self tagBody_]; 
    [self closeTag_]; 

}

- (void)openTag_ {
    
    [self match:TDTEMPLATE_TOKEN_KIND_OPENTAG discard:NO]; 

}

- (void)closeTag_ {
    
    [self match:TDTEMPLATE_TOKEN_KIND_CLOSETAG discard:NO]; 

}

- (void)tagBody_ {
    
    [self template_]; 

}

- (void)text_ {
    
    [self matchAny:NO]; 

}

@end