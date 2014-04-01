#import "TDTemplateParser.h"
#import <PEGKit/PEGKit.h>
    
#import "TDRootNode.h"
#import "TDVariableNode.h"
#import "TDTextNode.h"
#import "TDBlockEndNode.h"
#import "TDBlockStartNode.h"


@interface TDTemplateParser ()

@end

@implementation TDTemplateParser { }

- (id)initWithDelegate:(id)d {
    self = [super initWithDelegate:d];
    if (self) {
        
        self.startRuleName = @"template";
        self.tokenKindTab[@"block_start_tag"] = @(TDTEMPLATE_TOKEN_KIND_BLOCK_START_TAG);
        self.tokenKindTab[@"var"] = @(TDTEMPLATE_TOKEN_KIND_VAR);
        self.tokenKindTab[@"block_end_tag"] = @(TDTEMPLATE_TOKEN_KIND_BLOCK_END_TAG);
        self.tokenKindTab[@"text"] = @(TDTEMPLATE_TOKEN_KIND_TEXT);

        self.tokenKindNameTab[TDTEMPLATE_TOKEN_KIND_BLOCK_START_TAG] = @"block_start_tag";
        self.tokenKindNameTab[TDTEMPLATE_TOKEN_KIND_VAR] = @"var";
        self.tokenKindNameTab[TDTEMPLATE_TOKEN_KIND_BLOCK_END_TAG] = @"block_end_tag";
        self.tokenKindNameTab[TDTEMPLATE_TOKEN_KIND_TEXT] = @"text";

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
    
    [self execute:^{
    
	TDNode *root = [TDRootNode rootNode];
	self.assembly.target = root;
    PUSH(root);

    }];
    do {
        [self content_]; 
    } while ([self predicts:TOKEN_KIND_BUILTIN_ANY, 0]);

}

- (void)content_ {
    
    if ([self predicts:TDTEMPLATE_TOKEN_KIND_VAR, 0]) {
        [self var_]; 
    } else if ([self predicts:TDTEMPLATE_TOKEN_KIND_BLOCK_START_TAG, 0]) {
        [self block_]; 
    } else if ([self predicts:TDTEMPLATE_TOKEN_KIND_TEXT, 0]) {
        [self text_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'content'."];
    }

}

- (void)var_ {
    
    [self match:TDTEMPLATE_TOKEN_KIND_VAR discard:NO]; 
    [self execute:^{
    
	PKToken *tok = POP();
	TDNode *parent = POP();
	[parent addChild:[TDVariableNode nodeWithFragment:tok]];
	PUSH(parent);

    }];

}

- (void)block_ {
    
    [self block_start_tag_]; 
    [self block_body_]; 
    [self block_end_tag_]; 

}

- (void)block_start_tag_ {
    
    [self match:TDTEMPLATE_TOKEN_KIND_BLOCK_START_TAG discard:NO]; 
    [self execute:^{
    
	PKToken *tok = POP();
	TDNode *parent = POP();
	TDNode *startTagNode = [TDBlockStartNode nodeWithFragment:tok];
	[parent addChild:startTagNode];
	PUSH(parent);
	PUSH(startTagNode);

    }];

}

- (void)block_end_tag_ {
    
    [self match:TDTEMPLATE_TOKEN_KIND_BLOCK_END_TAG discard:NO]; 
    [self execute:^{
    
	PKToken *tok = POP();
    POP(); // startTagNode
	TDNode *parent = POP();
	TDNode *endTagNode = [TDBlockEndNode nodeWithFragment:tok];
	[parent addChild:endTagNode];
	PUSH(parent);

    }];

}

- (void)block_body_ {
    
    [self content_]; 

}

- (void)text_ {
    
    [self match:TDTEMPLATE_TOKEN_KIND_TEXT discard:NO]; 
    [self execute:^{
    
	PKToken *tok = POP();
	TDNode *parent = POP();
	[parent addChild:[TDTextNode nodeWithFragment:tok]];
	PUSH(parent);

    }];

}

@end