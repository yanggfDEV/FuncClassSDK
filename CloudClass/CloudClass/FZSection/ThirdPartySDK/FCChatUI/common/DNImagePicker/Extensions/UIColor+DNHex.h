//
//  UIColor+DNHex.h
//  Pods
//
//  Created by Jyh on 15/11/6.
//
//

#import <UIKit/UIKit.h>

@interface UIColor (DNHex)

+ (UIColor *)hexStringToColor:(NSString *)stringToConvert;
+ (UIColor *)colorWithHexNumber:(NSUInteger)hexColor;

@end
