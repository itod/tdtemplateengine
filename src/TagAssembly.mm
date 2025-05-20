#import "TagAssembly.hpp"

using namespace parsekit;
namespace templateengine {

TagAssembly::TagAssembly(Reader *reader, TokenList *token_stack, TokenList *consumed, NSMutableArray *object_stack) :
    Assembly(reader, token_stack, consumed),
    _object_stack([object_stack retain])
{}

TagAssembly::~TagAssembly() {
    [_object_stack release];
    _object_stack = nil;
}

}
