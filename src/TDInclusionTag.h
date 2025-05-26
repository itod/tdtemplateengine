//
//  TDInclusionTag.h
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 5/21/25.
//  Copyright © 2025 Todd Ditchendorf. All rights reserved.
//

#import <TDTemplateEngine/TDTag.h>
#import <TDTemplateEngine/TDCompileTimeTag.h>

@class TDTemplate;

@interface TDInclusionTag : TDTag <TDCompileTimeTag>

+ (NSString *)inclusionTemplatePath;

- (id)runInContext:(TDTemplateContext *)ctx;

@property (nonatomic, retain) TDTemplate *inclusionTemplate;
@end
