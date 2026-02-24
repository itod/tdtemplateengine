#import <Foundation/Foundation.h>
#import <ParseKitCPP/Assembly.hpp>

using namespace parsekit;
namespace templateengine {

class TagAssembly : public Assembly {
private:
    NSMutableArray *_objectStack;
        
public:
    TagAssembly(Reader *reader, TokenList *tokenStack, TokenList *consumed, NSMutableArray *objectStack);
    ~TagAssembly();
    
    void pushObject(id obj) {
        assert(_objectStack);
        [_objectStack addObject:obj];
    }
    
    id peekObject() {
        assert(_objectStack);
        return _objectStack.lastObject;
    }
    
    id popObject() {
        assert(_objectStack);
        id res = [[_objectStack.lastObject retain] autorelease];
        [_objectStack removeLastObject];
        return res;
    }
    
    bool isObjectStackEmpty() {
        assert(_objectStack);
        return 0 == _objectStack.count;
    }
};

}
