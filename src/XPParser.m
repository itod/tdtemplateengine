#import "XPParser.h"
#import <PEGKit/PEGKit.h>

#define LT(i) [self LT:(i)]
#define LA(i) [self LA:(i)]
#define LS(i) [self LS:(i)]
#define LF(i) [self LD:(i)]

#define POP()        [self.assembly pop]
#define POP_STR()    [self popString]
#define POP_TOK()    [self popToken]
#define POP_BOOL()   [self popBool]
#define POP_INT()    [self popInteger]
#define POP_UINT()   [self popUnsignedInteger]
#define POP_FLOAT()  [self popFloat]
#define POP_DOUBLE() [self popDouble]

#define PUSH(obj)      [self.assembly push:(id)(obj)]
#define PUSH_BOOL(yn)  [self pushBool:(BOOL)(yn)]
#define PUSH_INT(i)    [self pushInteger:(NSInteger)(i)]
#define PUSH_UINT(u)   [self pushUnsignedInteger:(NSUInteger)(u)]
#define PUSH_FLOAT(f)  [self pushFloat:(float)(f)]
#define PUSH_DOUBLE(d) [self pushDouble:(double)(d)]

#define EQ(a, b) [(a) isEqual:(b)]
#define NE(a, b) (![(a) isEqual:(b)])
#define EQ_IGNORE_CASE(a, b) (NSOrderedSame == [(a) compare:(b)])

#define MATCHES(pattern, str)               ([[NSRegularExpression regularExpressionWithPattern:(pattern) options:0                                  error:nil] numberOfMatchesInString:(str) options:0 range:NSMakeRange(0, [(str) length])] > 0)
#define MATCHES_IGNORE_CASE(pattern, str)   ([[NSRegularExpression regularExpressionWithPattern:(pattern) options:NSRegularExpressionCaseInsensitive error:nil] numberOfMatchesInString:(str) options:0 range:NSMakeRange(0, [(str) length])] > 0)

#define ABOVE(fence) [self.assembly objectsAbove:(fence)]
#define EMPTY() [self.assembly isStackEmpty]

#define LOG(obj) do { NSLog(@"%@", (obj)); } while (0);
#define PRINT(str) do { printf("%s\n", (str)); } while (0);

@interface PKParser ()
@property (nonatomic, retain) NSMutableDictionary *tokenKindTab;
@property (nonatomic, retain) NSMutableArray *tokenKindNameTab;
@property (nonatomic, retain) NSString *startRuleName;
@property (nonatomic, retain) NSString *statementTerminator;
@property (nonatomic, retain) NSString *singleLineCommentMarker;
@property (nonatomic, retain) NSString *blockStartMarker;
@property (nonatomic, retain) NSString *blockEndMarker;
@property (nonatomic, retain) NSString *braces;

- (BOOL)popBool;
- (NSInteger)popInteger;
- (double)popDouble;
- (PKToken *)popToken;
- (NSString *)popString;

- (void)pushBool:(BOOL)yn;
- (void)pushInteger:(NSInteger)i;
- (void)pushDouble:(double)d;
@end

@interface XPParser ()
@end

@implementation XPParser

- (id)initWithDelegate:(id)d {
    self = [super initWithDelegate:d];
    if (self) {
        self.startRuleName = @"expr";
        self.tokenKindTab[@"YES"] = @(XP_TOKEN_KIND_YES_UPPER);
        self.tokenKindTab[@"("] = @(XP_TOKEN_KIND_OPEN_PAREN);
        self.tokenKindTab[@"true"] = @(XP_TOKEN_KIND_TRUE);
        self.tokenKindTab[@"false"] = @(XP_TOKEN_KIND_FALSE);
        self.tokenKindTab[@")"] = @(XP_TOKEN_KIND_CLOSE_PAREN);
        self.tokenKindTab[@"NO"] = @(XP_TOKEN_KIND_NO_UPPER);

        self.tokenKindNameTab[XP_TOKEN_KIND_YES_UPPER] = @"YES";
        self.tokenKindNameTab[XP_TOKEN_KIND_OPEN_PAREN] = @"(";
        self.tokenKindNameTab[XP_TOKEN_KIND_TRUE] = @"true";
        self.tokenKindNameTab[XP_TOKEN_KIND_FALSE] = @"false";
        self.tokenKindNameTab[XP_TOKEN_KIND_CLOSE_PAREN] = @")";
        self.tokenKindNameTab[XP_TOKEN_KIND_NO_UPPER] = @"NO";

    }
    return self;
}

- (void)start {
    [self expr_]; 
    [self matchEOF:YES]; 
}

- (void)expr_ {
    
    [self primary_]; 

    [self fireDelegateSelector:@selector(parser:didMatchExpr:)];
}

- (void)primary_ {
    
    if ([self predicts:TOKEN_KIND_BUILTIN_NUMBER, XP_TOKEN_KIND_FALSE, XP_TOKEN_KIND_NO_UPPER, XP_TOKEN_KIND_TRUE, XP_TOKEN_KIND_YES_UPPER, 0]) {
        [self atom_]; 
    } else if ([self predicts:XP_TOKEN_KIND_OPEN_PAREN, 0]) {
        [self subExpr_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'primary'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchPrimary:)];
}

- (void)subExpr_ {
    
    [self match:XP_TOKEN_KIND_OPEN_PAREN discard:NO]; 
    [self expr_]; 
    [self match:XP_TOKEN_KIND_CLOSE_PAREN discard:YES]; 

    [self fireDelegateSelector:@selector(parser:didMatchSubExpr:)];
}

- (void)atom_ {
    
    [self literal_]; 

    [self fireDelegateSelector:@selector(parser:didMatchAtom:)];
}

- (void)literal_ {
    
    if ([self predicts:TOKEN_KIND_BUILTIN_NUMBER, 0]) {
        [self num_]; 
    } else if ([self predicts:XP_TOKEN_KIND_FALSE, XP_TOKEN_KIND_NO_UPPER, XP_TOKEN_KIND_TRUE, XP_TOKEN_KIND_YES_UPPER, 0]) {
        [self bool_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'literal'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchLiteral:)];
}

- (void)bool_ {
    
    if ([self predicts:XP_TOKEN_KIND_TRUE, XP_TOKEN_KIND_YES_UPPER, 0]) {
        [self true_]; 
    } else if ([self predicts:XP_TOKEN_KIND_FALSE, XP_TOKEN_KIND_NO_UPPER, 0]) {
        [self false_]; 
    } else {
        [self raise:@"No viable alternative found in rule 'bool'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchBool:)];
}

- (void)true_ {
    
    if ([self predicts:XP_TOKEN_KIND_TRUE, 0]) {
        [self match:XP_TOKEN_KIND_TRUE discard:YES]; 
    } else if ([self predicts:XP_TOKEN_KIND_YES_UPPER, 0]) {
        [self match:XP_TOKEN_KIND_YES_UPPER discard:YES]; 
    } else {
        [self raise:@"No viable alternative found in rule 'true'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchTrue:)];
}

- (void)false_ {
    
    if ([self predicts:XP_TOKEN_KIND_FALSE, 0]) {
        [self match:XP_TOKEN_KIND_FALSE discard:YES]; 
    } else if ([self predicts:XP_TOKEN_KIND_NO_UPPER, 0]) {
        [self match:XP_TOKEN_KIND_NO_UPPER discard:YES]; 
    } else {
        [self raise:@"No viable alternative found in rule 'false'."];
    }

    [self fireDelegateSelector:@selector(parser:didMatchFalse:)];
}

- (void)num_ {
    
    [self matchNumber:NO]; 

    [self fireDelegateSelector:@selector(parser:didMatchNum:)];
}

@end