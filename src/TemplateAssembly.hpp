//
//  TemplateAssembly.hpp
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 4/3/25.
//

#import <ParseKitCPP/Assembly.hpp>
#import <TDTemplateEngine/TDNode.h>

using namespace parsekit;
namespace templateengine {

class TemplateAssembly : public Assembly {
private:
    // TODO
//    NodeList *_node_stack;
    
    NSMutableArray *_node_stack;

public:
//    TemplateAssembly(Tokenizer *t, TokenList *token_stack, TokenList *consumed, NodeList *node_stack);
    
    // Node Stack
//    bool is_node_stack_empty() const;
//    NodePtr peek_node() const;
//    NodePtr pop_node();
//    void push_node(NodePtr node);

    TemplateAssembly(Tokenizer *t, TokenList *token_stack, TokenList *consumed, NSMutableArray *node_stack);
    ~TemplateAssembly();

    bool is_node_stack_empty() const;
    TDNode *peek_node() const;
    TDNode *pop_node();
    void push_node(TDNode *node);

};

}
