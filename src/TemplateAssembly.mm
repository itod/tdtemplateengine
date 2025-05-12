//
//  TemplateAssembly.mm
//  TDTEmplateEngine
//
//  Created by Todd Ditchendorf on 4/3/25.
//

#import "TemplateAssembly.hpp"

using namespace parsekit;
namespace templateengine {

//TemplateAssembly::TemplateAssembly(Tokenizer *t, TokenList *token_stack, TokenList *consumed, NodeList *node_stack) :
//    Assembly(t, token_stack, consumed),
//    
//    _node_stack(node_stack),
//{}
//
//bool TemplateAssembly::is_node_stack_empty() const {
//    assert(_node_stack);
//    return 0 == _node_stack->size();
//}
//
//NodePtr TemplateAssembly::peek_node() const {
//    assert(_node_stack);
//    NodePtr node = nullptr;
//    if (!is_node_stack_empty()) {
//        node = _node_stack->back();
//    }
//    return node;
//}
//
//NodePtr TemplateAssembly::pop_node() {
//    assert(_node_stack->size());
//    NodePtr node = _node_stack->back();
//    _node_stack->pop_back();
//    return node;
//}
//
//void TemplateAssembly::push_node(NodePtr node) {
//    assert(_node_stack);
//    _node_stack->push_back(node);
//}

TemplateAssembly::TemplateAssembly(TokenList *token_stack, TokenList *consumed, NSMutableArray *node_stack) :
    Assembly(token_stack, consumed),
    _node_stack([node_stack retain])
{}

TemplateAssembly::~TemplateAssembly() {
    [_node_stack release];
    _node_stack = nil;
}

bool TemplateAssembly::is_node_stack_empty() const {
    assert(_node_stack);
    return 0 == _node_stack.count;
}

TDNode *TemplateAssembly::peek_node() const {
    assert(_node_stack);
    TDNode *node = nullptr;
    if (!is_node_stack_empty()) {
        node = _node_stack.lastObject;
    }
    return node;
}

TDNode *TemplateAssembly::pop_node() {
    assert(_node_stack.count);
    TDNode *node = _node_stack.lastObject;
    [_node_stack removeLastObject];
    return node;
}

void TemplateAssembly::push_node(TDNode *node) {
    assert(_node_stack);
    [_node_stack addObject:node];
}

}
