//
//  ConfUIImage+Tint.h
//  JusTel
//
//  Created by Cathy on 12-8-15.
//  Copyright (c) 2012年 Juphoon.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Tint)

+ (UIImage *)confColoredImage:(UIColor *)color size:(CGSize)imageSize;
- (UIImage *)confImageWithColor:(UIColor *)tintColor;

@end
