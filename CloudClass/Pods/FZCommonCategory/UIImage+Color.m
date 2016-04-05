//
//  UIImage+Color.m
//  FunChat
//
//  Created by Feizhu Tech . on 15/6/2.
//  Copyright (c) 2015年 hanbingquan. All rights reserved.
//

#import "UIImage+Color.h"
#import "UIColor+Hex.h"

@implementation UIImage (Color)

+ (UIImage *)createImageWithHexColor:(NSString *)hexColor
{
    UIColor *color = [UIColor colorWithHexString:hexColor];
    if (!color) {
        return nil;
    }
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end
