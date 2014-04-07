#import "TDTemplateParser.h"
#import <PEGKit/PEGKit.h>
    
#import <TDTemplateEngine/TDTemplateEngine.h>
#import <TDTemplateEngine/TDTemplateContext.h>
#import "TDRootNode.h"
#import "TDVariableNode.h"
#import "TDBlockStartNode.h"
#import "TDBlockEndNode.h"
#import "TDTextNode.h"


@interface TDTemplateParser ()
    
@property (nonatomic, assign) TDNode *currentParent; // weakref

@property (nonatomic, retain) NSMutableDictionary *template_memo;
@property (nonatomic, retain) NSMutableDictionary *content_memo;
@property (nonatomic, retain) NSMutableDictionary *body_content_memo;
@property (nonatomic, retain) NSMutableDictionary *var_memo;
@property (nonatomic, retain) NSMutableDictionary *empty_tag_memo;
@property (nonatomic, retain) NSMutableDictionary *helper_tag_memo;
@property (nonatomic, retain) NSMutableDictionary *helper_start_tag_memo;
@property (nonatomic, retain) NSMutableDictionary *block_tag_memo;
@property (nonatomic, retain) NSMutableDictionary *block_start_tag_memo;
@property (nonatomic, retain) NSMutableDictionary *block_end_tag_memo;
@property (nonatomic, retain) NSMutableDictionary *text_memo;
@end

@implementation TDTemplateParser { }

- (id)initWithDelegate:(id)d {
    self = [super initWithDelegate:d];
    if (self) {
        
        self.startRuleName = @"template";
        self.tokenKindTab[@"helper_start_tag"] = @(TDTEMPLATE_TOKEN_KIND_HELPER_START_TAG);
        self.tokenKindTab[@"var"] = @(TDTEMPLATE_TOKEN_KIND_VAR);
        self.tokenKindTab[@"block_start_tag"] = @(TDTEMPLATE_TOKEN_KIND_BLOCK_START_TAG);
        self.tokenKindTab[@"block_end_tag"] = @(TDTEMPLATE_TOKEN_KIND_BLOCK_END_TAG);
        self.tokenKindTab[@"empty_tag"] = @(TDTEMPLATE_TOKEN_KIND_EMPTY_TAG);
        self.tokenKindTab[@"text"] = @(TDTEMPLATE_TOKEN_KIND_TEXT);

        self.tokenKindNameTab[TDTEMPLATE_TOKEN_KIND_HELPER_START_TAG] = @"helper_start_tag";
        self.tokenKindNameTab[TDTEMPLATE_TOKEN_KIND_VAR] = @"var";
        self.tokenKindNameTab[TDTEMPLATE_TOKEN_KIND_BLOCK_START_TAG] = @"block_start_tag";
        self.tokenKindNameTab[TDTEMPLATE_TOKEN_KIND_BLOCK_END_TAG] = @"block_end_tag";
        self.tokenKindNameTab[TDTEMPLATE_TOKEN_KIND_EMPTY_TAG] = @"empty_tag";
        self.tokenKindNameTab[TDTEMPLATE_TOKEN_KIND_TEXT] = @"text";

        self.template_memo = [NSMutableDictionary dictionary];
        self.content_memo = [NSMutableDictionary dictionary];
        self.body_content_memo = [NSMutableDictionary dictionary];
        self.var_memo = [NSMutableDictionary dictionary];
        self.empty_tag_memo = [NSMutableDictionary dictionary];
        self.helper_tag_memo = [NSMutableDictionary dictionary];
        self.helper_start_tag_memo = [NSMutableDictionary dictionary];
        self.block_tag_memo = [NSMutableDictionary dictionary];
        self.block_start_tag_memo = [NSMutableDictionary dictionary];
        self.block_end_tag_memo = [NSMutableDictionary dictionary];
        self.text_memo = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)dealloc {
        
    self.staticContext = nil;
    self.currentParent = nil;

    self.template_memo = nil;
    self.content_memo = nil;
    self.body_content_memo = nil;
    self.var_memo = nil;
    self.empty_tag_memo = nil;
    self.helper_tag_memo = nil;
    self.helper_start_tag_memo = nil;
    self.block_tag_memo = nil;
    self.block_start_tag_memo = nil;
    self.block_end_tag_memo = nil;
    self.text_memo = nil;

    [super dealloc];
}

- (void)clearMemo {
    [_template_memo removeAllObjects];
    [_content_memo removeAllObjects];
    [_body_content_memo removeAllObjects];
    [_var_memo removeAllObjects];
    [_empty_tag_memo removeAllObjects];
    [_helper_tag_memo removeAllObjects];
    [_helper_start_tag_memo removeAllObjects];
    [_block_tag_memo removeAllObjects];
    [_block_start_tag_memo removeAllObjects];
    [_block_end_tag_memo removeAllObjects];
    [_text_memo removeAllObjects];
}

- (void)start {

    [self template_]; 
    [self matchEOF:YES]; 

}

- (void)__template {
    
    [self execute:^{
    
    TDAssert(_staticContext);
    TDNode *root = [TDRootNode rootNodeWithStaticContext:_staticContext];
    self.assembly.target = root;
    self.currentParent = root;

    }];
    do {
        [self content_]; 
    } while ([self predicts:TOKEN_KIND_BUILTIN_ANY, 0]);

}

- (void)template_ {
    [self parseRule:@selector(__template) withMemo:_template_memo];
}

- (void)__content {
    
    if ([self predicts:TDTEMPLATE_TOKEN_KIND_VAR, 0]) {
        [self var_]; 
    } else if ([self predicts:TDTEMPLATE_TOKEN_KIND_EMPTY_TAG, 0]) {
        [self empty_tag_]; 
    } else if ([self predicts:TDTEMPLATE_TOKEN_KIND_BLOCK_START_TAG, 0]) {
        [self block_tag_]; 
    } else if ([self predicts:TDTEMPLATE_TOKEN_KIND_TEXT, 0]) {
        [self text_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'content'."];
    }

}

- (void)content_ {
    [self parseRule:@selector(__content) withMemo:_content_memo];
}

- (void)__body_content {
    
    if ([self predicts:TDTEMPLATE_TOKEN_KIND_VAR, 0]) {
        [self var_]; 
    } else if ([self predicts:TDTEMPLATE_TOKEN_KIND_EMPTY_TAG, 0]) {
        [self empty_tag_]; 
    } else if ([self predicts:TDTEMPLATE_TOKEN_KIND_HELPER_START_TAG, 0]) {
        [self helper_tag_]; 
    } else if ([self predicts:TDTEMPLATE_TOKEN_KIND_BLOCK_START_TAG, 0]) {
        [self block_tag_]; 
    } else if ([self predicts:TDTEMPLATE_TOKEN_KIND_TEXT, 0]) {
        [self text_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'body_content'."];
    }

}

- (void)body_content_ {
    [self parseRule:@selector(__body_content) withMemo:_body_content_memo];
}

- (void)__var {
    
    [self match:TDTEMPLATE_TOKEN_KIND_VAR discard:NO]; 
    [self execute:^{
    
    PKToken *tok = POP();
    TDNode *varNode = [TDVariableNode nodeWithToken:tok parent:_currentParent];
    [_currentParent addChild:varNode];

    }];

}

- (void)var_ {
    [self parseRule:@selector(__var) withMemo:_var_memo];
}

- (void)__empty_tag {
    
    [self match:TDTEMPLATE_TOKEN_KIND_EMPTY_TAG discard:NO]; 
    [self execute:^{
    
    PKToken *tok = POP();
    TDNode *startTagNode = [TDBlockStartNode nodeWithToken:tok parent:_currentParent];
    [_currentParent addChild:startTagNode];
    //self.currentParent = startTagNode;

    }];

}

- (void)empty_tag_ {
    [self parseRule:@selector(__empty_tag) withMemo:_empty_tag_memo];
}

- (void)__helper_tag {
    
    [self helper_start_tag_]; 
    do {
        [self content_]; 
    } while ([self speculate:^{ [self content_]; }]);

}

- (void)helper_tag_ {
    [self parseRule:@selector(__helper_tag) withMemo:_helper_tag_memo];
}

- (void)__helper_start_tag {
    
    [self match:TDTEMPLATE_TOKEN_KIND_HELPER_START_TAG discard:NO]; 
    [self execute:^{
    
    PKToken *tok = POP();
    TDNode *startTagNode = [TDBlockStartNode nodeWithToken:tok parent:_currentParent];
    [_currentParent addChild:startTagNode];
    PUSH(_currentParent);
    self.currentParent = startTagNode;

    }];

}

- (void)helper_start_tag_ {
    [self parseRule:@selector(__helper_start_tag) withMemo:_helper_start_tag_memo];
}

- (void)__block_tag {
    
    [self execute:^{
     PUSH(_currentParent); 
    }];
    [self block_start_tag_]; 
    do {
        [self body_content_]; 
    } while ([self speculate:^{ [self body_content_]; }]);
    [self block_end_tag_]; 
    [self execute:^{
     self.currentParent = POP(); 
    }];

}

- (void)block_tag_ {
    [self parseRule:@selector(__block_tag) withMemo:_block_tag_memo];
}

- (void)__block_start_tag {
    
    [self match:TDTEMPLATE_TOKEN_KIND_BLOCK_START_TAG discard:NO]; 
    [self execute:^{
    
    PKToken *tok = POP();
    TDNode *startTagNode = [TDBlockStartNode nodeWithToken:tok parent:_currentParent];
    [_currentParent addChild:startTagNode];
    self.currentParent = startTagNode;

    }];

}

- (void)block_start_tag_ {
    [self parseRule:@selector(__block_start_tag) withMemo:_block_start_tag_memo];
}

- (void)__block_end_tag {
    
    [self match:TDTEMPLATE_TOKEN_KIND_BLOCK_END_TAG discard:NO]; 
    [self execute:^{
    
    PKToken *tok = POP();
    NSString *tagName = [tok.stringValue substringFromIndex:[TD_END_TAG_PREFIX length]];
    while (![_currentParent.name hasPrefix:tagName])
        self.currentParent = POP();

    ASSERT([_currentParent.name hasPrefix:tagName]);
    TDNode *endTagNode = [TDBlockEndNode nodeWithToken:tok parent:_currentParent.parent];
    [_currentParent.parent addChild:endTagNode];

    }];

}

- (void)block_end_tag_ {
    [self parseRule:@selector(__block_end_tag) withMemo:_block_end_tag_memo];
}

- (void)__text {
    
    [self match:TDTEMPLATE_TOKEN_KIND_TEXT discard:NO]; 
    [self execute:^{
    
    PKToken *tok = POP();
    TDNode *txtNode = [TDTextNode nodeWithToken:tok parent:_currentParent];
    [_currentParent addChild:txtNode];

    }];

}

- (void)text_ {
    [self parseRule:@selector(__text) withMemo:_text_memo];
}

@end
