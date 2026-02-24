#import "TagAssembly.hpp"

using namespace parsekit;
namespace templateengine {

TagAssembly::TagAssembly(Reader *reader, TokenList *tokenStack, TokenList *consumed, NSMutableArray *objectStack) :
    Assembly(reader, tokenStack, consumed),
    _objectStack([objectStack retain])
{}

TagAssembly::~TagAssembly() {
    [_objectStack release];
    _objectStack = nil;
}

}
