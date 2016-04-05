//
//  NSString+Size.h
//  FunChat
//
//  Created by Feizhu Tech . on 15/6/2.
//  Copyright (c) 2015年 hanbingquan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Size)

- (CGSize)textSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode;

@end
