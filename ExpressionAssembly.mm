#import "ExpressionAssembly.hpp"

using namespace parsekit;
namespace templateengine {

ExpressionAssembly::ExpressionAssembly(Reader *reader, TokenList *token_stack, TokenList *consumed) :
    Assembly(reader, token_stack, consumed),
    _object_stack([NSMutableArray new])
{}

}
