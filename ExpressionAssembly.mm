#import "ExpressionAssembly.hpp"

using namespace parsekit;
namespace templateengine {

ExpressionAssembly::ExpressionAssembly(Tokenizer *t, TokenList *token_stack, TokenList *consumed) :
    Assembly(t, token_stack, consumed),
    _object_stack([NSMutableArray new])
{}

}
