//
//  NSString+TDAdditions.h
//  TDTemplateEngine
//
//  Created by Todd Ditchendorf on 5/20/25.
//  Copyright © 2025 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (TDAdditions)
- (void)markSafe;
- (BOOL)isSafe;
@end
