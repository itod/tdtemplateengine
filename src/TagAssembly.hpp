#import <Foundation/Foundation.h>
#import <ParseKitCPP/Assembly.hpp>

using namespace parsekit;
namespace templateengine {

class TagAssembly : public Assembly {
private:
    NSMutableArray *_object_stack;
        
public:
    TagAssembly(Reader *reader, TokenList *token_stack, TokenList *consumed, NSMutableArray *object_stack);
    ~TagAssembly();
    
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
    
    bool is_object_stack_empty() {
        assert(_object_stack);
        return 0 == _object_stack.count;
    }
};

}
