//
//  TDCompileTimeTag.h
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 5/15/25.
//  Copyright © 2025 Todd Ditchendorf. All rights reserved.
//

#import <TDTemplateEngine/TDTag.h>

@protocol TDCompileTimeTag <NSObject>

- (void)compileInContext:(TDTemplateContext *)staticContext;

@end
