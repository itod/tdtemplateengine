#import "ExpressionAssembly.hpp"

using namespace parsekit;
namespace templateengine {

ExpressionAssembly::ExpressionAssembly(TokenList *token_stack, TokenList *consumed) :
    Assembly(token_stack, consumed),
    _object_stack([NSMutableArray new])
{}

}
