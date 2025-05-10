#import "ExpressionAssembly.hpp"

using namespace parsekit;
namespace tdtemplateengine {

ExpressionAssembly::ExpressionAssembly(Tokenizer *t, TokenList *token_stack, TokenList *consumed, NSArray *_object_stack) :
    Assembly(t, token_stack, consumed),
    _object_stack([NSMutableArray new])
{}

}
