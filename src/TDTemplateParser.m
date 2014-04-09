#import "TDTemplateParser.h"
#import <PEGKit/PEGKit.h>
    
#import <TDTemplateEngine/TDTemplateEngine.h>
#import <TDTemplateEngine/TDTemplateContext.h>
#import "TDRootNode.h"
#import "TDVariableNode.h"
#import "TDTextNode.h"
#import "TDTag.h"

@interface TDTemplateEngine ()
- (TDVariableNode *)varNodeFromFragment:(PKToken *)frag withParent:(TDNode *)parent;
- (TDTag *)tagFromFragment:(PKToken *)tok withParent:(TDNode *)parent;
@end

@interface TDTemplateParser ()
    
@property (nonatomic, assign) TDNode *currentParent; // weakref

@end

@implementation TDTemplateParser { }

- (id)initWithDelegate:(id)d {
    self = [super initWithDelegate:d];
    if (self) {
        
        self.startRuleName = @"template";
        self.tokenKindTab[@"block_start_tag"] = @(TDTEMPLATE_TOKEN_KIND_BLOCK_START_TAG);
        self.tokenKindTab[@"var"] = @(TDTEMPLATE_TOKEN_KIND_VAR);
        self.tokenKindTab[@"block_end_tag"] = @(TDTEMPLATE_TOKEN_KIND_BLOCK_END_TAG);
        self.tokenKindTab[@"empty_tag"] = @(TDTEMPLATE_TOKEN_KIND_EMPTY_TAG);
        self.tokenKindTab[@"text"] = @(TDTEMPLATE_TOKEN_KIND_TEXT);

        self.tokenKindNameTab[TDTEMPLATE_TOKEN_KIND_BLOCK_START_TAG] = @"block_start_tag";
        self.tokenKindNameTab[TDTEMPLATE_TOKEN_KIND_VAR] = @"var";
        self.tokenKindNameTab[TDTEMPLATE_TOKEN_KIND_BLOCK_END_TAG] = @"block_end_tag";
        self.tokenKindNameTab[TDTEMPLATE_TOKEN_KIND_EMPTY_TAG] = @"empty_tag";
        self.tokenKindNameTab[TDTEMPLATE_TOKEN_KIND_TEXT] = @"text";

    }
    return self;
}

- (void)dealloc {
        
    self.staticContext = nil;
    self.currentParent = nil;


    [super dealloc];
}

- (void)start {

    [self template_]; 
    [self matchEOF:YES]; 

}

- (void)template_ {
    
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

- (void)content_ {
    
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

- (void)var_ {
    
    [self match:TDTEMPLATE_TOKEN_KIND_VAR discard:NO]; 
    [self execute:^{
    
    PKToken *tok = POP();
    TDNode *varNode = [[TDTemplateEngine currentTemplateEngine] varNodeFromFragment:tok withParent:_currentParent];
    [_currentParent addChild:varNode];

    }];

}

- (void)empty_tag_ {
    
    [self match:TDTEMPLATE_TOKEN_KIND_EMPTY_TAG discard:NO]; 
    [self execute:^{
    
    PKToken *tok = POP();
    NSString *tagName = tok.stringValue;
    ASSERT([tagName length]);
    TDTag *startTagNode = [[TDTemplateEngine currentTemplateEngine] tagFromFragment:tok withParent:_currentParent];
    ASSERT(startTagNode);
    [_currentParent addChild:startTagNode];
    //self.currentParent = startTagNode;

    }];

}

- (void)block_tag_ {
    
    [self execute:^{
     PUSH(_currentParent); 
    }];
    [self block_start_tag_]; 
    while (![self predicts:TDTEMPLATE_TOKEN_KIND_BLOCK_END_TAG, 0]) {
        [self content_]; 
    }
    [self block_end_tag_]; 
    [self execute:^{
     self.currentParent = POP(); 
    }];

}

- (void)block_start_tag_ {
    
    [self match:TDTEMPLATE_TOKEN_KIND_BLOCK_START_TAG discard:NO]; 
    [self execute:^{
    
    PKToken *tok = POP();
    NSString *tagName = tok.stringValue;
    ASSERT([tagName length]);
    TDTag *startTagNode = [[TDTemplateEngine currentTemplateEngine] tagFromFragment:tok withParent:_currentParent];
    ASSERT(startTagNode);
    [_currentParent addChild:startTagNode];
    self.currentParent = startTagNode;
    }];

}

- (void)block_end_tag_ {
    
    [self match:TDTEMPLATE_TOKEN_KIND_BLOCK_END_TAG discard:NO]; 
    [self execute:^{
    
    PKToken *tok = POP();
    NSString *tagName = [tok.stringValue substringFromIndex:[TD_END_TAG_PREFIX length]];
    while (![_currentParent.tagName isEqualToString:tagName])
        self.currentParent = POP();

    ASSERT([_currentParent.tagName isEqualToString:tagName]);
    ASSERT([_currentParent isKindOfClass:[TDTag class]]);
    TDTag *startNode = (id)_currentParent;
    startNode.endTagToken = tok;

    }];

}

- (void)text_ {
    
    [self match:TDTEMPLATE_TOKEN_KIND_TEXT discard:NO]; 
    [self execute:^{
    
    PKToken *tok = POP();
    TDNode *txtNode = [TDTextNode nodeWithToken:tok parent:_currentParent];
    [_currentParent addChild:txtNode];

    }];

}

@end
