//
//  ConfUIImage+Tint.m
//  Batter
//
//  Created by Cathy on 12-8-15.
//  Copyright (c) 2012年 Juphoon.com. All rights reserved.
//

#import "ConfUIImage+Tint.h"

@implementation UIImage (Tint)

+ (UIImage *)confColoredImage:(UIColor *)color size:(CGSize)imageSize
{
    CGRect rect = CGRectMake(0, 0, imageSize.width, imageSize.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)confImageWithColor:(UIColor *)tintColor
{
    CGSize size = self.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, self.scale);
    
    CGRect drawRect = CGRectMake(0, 0, size.width, size.height);
    [self drawInRect:drawRect];
    [tintColor set];
    UIRectFillUsingBlendMode(drawRect, kCGBlendModeSourceAtop);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
