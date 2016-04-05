//
//  ConfSettings.h
//  Batter
//
//  Created by cathy on 12-8-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConfSettings : NSObject

+ (NSArray *)skinColorArray;
+ (void)setSkinColor:(UIColor *)skinColor;

+ (UIColor *)highlightedColor:(UIColor *)color;
+ (UIColor *)disabledColor:(UIColor *)color;

+ (UIColor *)skinColor;
+ (UIColor *)highlightedSkinColor;
+ (UIColor *)disabledSkinColor;

+ (UIColor *)primaryTextColor;
+ (UIColor *)secondaryTextColor;
+ (UIColor *)disabledTextColor;
+ (UIColor *)whiteDisabledTextColor;
+ (UIColor *)dividersColor;

+ (UIColor *)callEndColor;
+ (UIColor *)callAnswerColor;

+ (UIFont *)primaryTextFont;

+ (UIColor *)color:(UIColor *)color withHueValue:(CGFloat)value;
+ (CGFloat)hueValueOfColor:(UIColor *)color;
+ (UIColor *)color:(UIColor *)color withBrightnessValue:(CGFloat)value;
+ (CGFloat)brightnessValueOfColor:(UIColor *)color;

+ (UIColor *)cameraOffBackgroundDarkColor;
+ (UIColor *)cameraOffBackgroundLightColor;

@end
