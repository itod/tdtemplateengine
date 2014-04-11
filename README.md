TDTemplateEngine
================

###A multi-pass, streaming template engine implemented in Cocoa, for use in Cocoa. 

TDTemplateEngine is a template engine implemented in Objective-C, and intended for use on Apple's OS X and iOS platforms.

TDTemplateEngine is built on top of [PEGKit](https://github.com/itod/pegkit#pegkit), my parsing toolkit for Cocoa. TDTemplateEngine is inspired by the [Django template language](https://docs.djangoproject.com/en/dev/topics/templates/), [Java ServerPages](http://en.wikipedia.org/wiki/JavaServer_Pages "JavaServer Pages - Wikipedia, the free encyclopedia"), and [MGTemplateEngine](http://mattgemmell.com/mgtemplateengine-templates-with-cocoa "MGTemplateEngine - Templates with Cocoa - Matt Gemmell") by Matt Gemmell.

####Similarity to MGTemplateEngine
In fact, TDTemplateEngine's API and usage scenarios are very similar to [MGTemplateEngine](https://github.com/mattgemmell/MGTemplateEngine). If you are in need of a template engine for Cocoa, you should definitely investigate MGTemplateEngine as well. It is more mature.

So if MGTemplateEngine exists, why create another one? What makes TDTemplateEngine different?

###Design Goals of TDTemplateEngine

####Mutliple-pass
TDTemplateEngine offers a **multiple-pass architecture**. This means that TDTemplateEngine's API allows renderinging of any given template in *2 distinct phases*: 

1. **Compile** the template source to an intermediate [Abstract Syntax Tree](https://en.wikipedia.org/wiki/Abstract_syntax_tree) (AST) representation.
1. **Render** the AST to the final template text result.
	
This multiple-pass architecture has many advantages:

* A clean, well-factored, classic archecture that should be recognizable for anyone familiar with compiler design basics. It should be easy to jump into the code and add or remove features without breaking things.
* Any use case where a template must be loaded into memory and compiled once, but rendered with runtime data multiple times should see a performance benefit.
* TDTemplateEngine's expression language should exhibit good performance in such *compile-once, render-often* scenarios: tempate expressions are compiled once, and some compile-time optimizations are performed before render-time. Currently, the expressions language optimizations are quite rudimentary, but the hooks are there, and they could be further improved with well-known compiler techniques.
* With a powerful parser, multiple parser passes, and an intermediate AST representation, TDTemplateEngine's expression language should be easy to extend and improve with new features.

This multiple-pass architecture may have disadvantages:

* One man's *clean, well-factored design*, is another man's *[lasanga code](http://en.wikipedia.org/wiki/Spaghetti_code "Spaghetti code - Wikipedia, the free encyclopedia")* -- too many layers.
* MGTemplateEngine (which I believe is a single-pass architecture), offers a smaller code footprint and architecture. Again, if you're in the market, you should check it out too.

####Streaming output
TDTemplateEngine also uses `NSOutputStream` for output, rather than only offering an in-memory string output option. This should offer performance and memory-usage benefits for use cases where rendering a template produces large text output at runtime.

The downside of streaming output is the simple *render-to-in-memory-string* use case is slightly more complex.