//
//  TDArgListTag.h
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 5/17/25.
//  Copyright © 2025 Todd Ditchendorf. All rights reserved.
//

#import <TDTemplateEngine/TDTag.h>

@interface TDArgListTag : TDTag

@property (nonatomic, retain) NSArray *args; // exprs to be evaled at runtime
@end
