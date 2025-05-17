//
//  TDArgListTag.m
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 5/17/25.
//  Copyright © 2025 Todd Ditchendorf. All rights reserved.
//

#import "TDArgListTag.h"

@implementation TDArgListTag

+ (TDTagExpressionType)tagExpressionType {
    return TDTagExpressionTypeArgList;
}


- (void)dealloc {
    self.args = nil;
    [super dealloc];
}

@end
