#import <Foundation/Foundation.h>
#import <ParseKitCPP/Assembly.hpp>
#import <ParseKitCPP/Tokenizer.hpp>

using namespace parsekit;
namespace tdtemplateengine {

class ExpressionAssembly : public Assembly {
private:
    NSMutableArray *_object_stack;
        
public:
    ExpressionAssembly(Tokenizer *t, TokenList *token_stack, TokenList *consumed, NSArray *_object_stack);
    
    void push_object(id obj) {
        assert(_object_stack);
        [_object_stack addObject:obj];
    }
    
    id peek_object() {
        assert(_object_stack);
        return _object_stack.lastObject;
    }
    
    id pop_object() {
        assert(_object_stack);
        id res = [[_object_stack.lastObject retain] autorelease];
        [_object_stack removeLastObject];
        return res;
    }
};

}
