//
//  ConfSettings.m
//  Batter
//
//  Created by cathy on 12-8-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ConfSettings.h"

#define kSkinColorKey @"SkinColor"
static UIColor *_skinColor = nil;

@implementation ConfSettings

+ (NSArray *)skinColorArray
{
    return @[
             //pink
             [UIColor colorWithRed:233.0f/255.0f green:30.0f/255.0f blue:99.0f/255.0f alpha:1],
             //purple
             [UIColor colorWithRed:156.0f/255.0f green:39.0f/255.0f blue:176.0f/255.0f alpha:1],
             //indigo
             [UIColor colorWithRed:63.0f/255.0f green:81.0f/255.0f blue:181.0f/255.0f alpha:1],
             //legacy:blue
             [UIColor colorWithRed:0.0f/255.0f green:132.0f/255.0f blue:235.0f/255.0f alpha:1],
             //cyan
             [UIColor colorWithRed:0.0f/255.0f green:188.0f/255.0f blue:212.0f/255.0f alpha:1],
             //green
             [UIColor colorWithRed:76.0f/255.0f green:175.0f/255.0f blue:80.0f/255.0f alpha:1],
             //amber
             [UIColor colorWithRed:255.0f/255.0f green:193.0f/255.0f blue:7.0f/255.0f alpha:1],
             //orange
             [UIColor colorWithRed:255.0f/255.0f green:152.0f/255.0f blue:0.0f/255.0f alpha:1],
             //deep orange
             [UIColor colorWithRed:255.0f/255.0f green:87.0f/255.0f blue:34.0f/255.0f alpha:1]
            ];
}

+ (void)setSkinColor:(UIColor *)skinColor
{
    _skinColor = skinColor;
    NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:skinColor];
    [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:kSkinColorKey];
}

+ (UIColor *)highlightedColor:(UIColor *)color
{
    return [color colorWithAlphaComponent:0.26];
}

+ (UIColor *)disabledColor:(UIColor *)color
{
    return [color colorWithAlphaComponent:0.54];
}

+ (UIColor *)skinColor
{
    if (!_skinColor) {
        NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:kSkinColorKey];
        if (colorData) {
            _skinColor = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
        } else {
#ifdef JUSTEE
            _skinColor = [UIColor colorWithRed:0.0f/255.0f green:132.0f/255.0f blue:235.0f/255.0f alpha:1];
#else
            _skinColor = [UIColor colorWithRed:0.0f/255.0f green:188.0f/255.0f blue:212.0f/255.0f alpha:1];
#endif
        }
    }
    return _skinColor;
}

+ (UIColor *)highlightedSkinColor
{
    return [ConfSettings highlightedColor:[ConfSettings skinColor]];
}

+ (UIColor *)disabledSkinColor
{
    return [ConfSettings disabledColor:[ConfSettings skinColor]];
}

+ (UIColor *)primaryTextColor
{
    static UIColor *_primaryTextColor = nil;
    if (!_primaryTextColor) {
        _primaryTextColor = [[UIColor blackColor] colorWithAlphaComponent:0.87];
    }
    return _primaryTextColor;
}

+ (UIColor *)secondaryTextColor
{
    static UIColor *_secondaryTextColor = nil;
    if (!_secondaryTextColor) {
        _secondaryTextColor = [[UIColor blackColor] colorWithAlphaComponent:0.54];
    }
    return _secondaryTextColor;
}

+ (UIColor *)disabledTextColor
{
    static UIColor *_disabledTextColor = nil;
    if (!_disabledTextColor) {
        _disabledTextColor = [[UIColor blackColor] colorWithAlphaComponent:0.26];
    }
    return _disabledTextColor;
}

+ (UIColor *)whiteDisabledTextColor
{
    static UIColor *_whiteDisabledTextColor = nil;
    if (!_whiteDisabledTextColor) {
        _whiteDisabledTextColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    }
    return _whiteDisabledTextColor;
}

+ (UIColor *)dividersColor
{
    static UIColor *_dividersColor = nil;
    if (!_dividersColor) {
        _dividersColor = [[UIColor blackColor] colorWithAlphaComponent:0.12];
    }
    return _dividersColor;
}

+ (UIColor *)callEndColor
{
    return [UIColor colorWithRed:252.0f/255.0f green:60.0f/255.0f blue:64.0f/255.0f alpha:1];
}

+ (UIColor *)callAnswerColor
{
    return [UIColor colorWithRed:38.0f/255.0f green:214.0f/255.0f blue:80.0f/255.0f alpha:1];
}

+ (UIFont *)primaryTextFont
{
    static UIFont *_primaryTextFont = nil;
    if (!_primaryTextFont) {
        _primaryTextFont = [UIFont systemFontOfSize:18];
    }
    return _primaryTextFont;
}

+ (UIColor *)color:(UIColor *)color withHueValue:(CGFloat)value
{
    CGFloat saturation, brightness, alpha;
    [color getHue:nil saturation:&saturation brightness:&brightness alpha:&alpha];
    return [UIColor colorWithHue:value saturation:saturation brightness:brightness alpha:alpha];
}

+ (CGFloat)hueValueOfColor:(UIColor *)color
{
    CGFloat hue;
    [color getHue:&hue saturation:nil brightness:nil alpha:nil];
    return hue;
}

+ (UIColor *)color:(UIColor *)color withBrightnessValue:(CGFloat)value
{
    CGFloat hue, saturation, alpha;
    [color getHue:&hue saturation:&saturation brightness:nil alpha:&alpha];
    return [UIColor colorWithHue:hue saturation:saturation brightness:value alpha:alpha];
}

+ (CGFloat)brightnessValueOfColor:(UIColor *)color
{
    CGFloat brightness;
    [color getHue:nil saturation:nil brightness:&brightness alpha:nil];
    return brightness;
}

+ (UIColor *)cameraOffBackgroundDarkColor
{
    return [UIColor colorWithRed:50.0f/255.0f green:50.0f/255.0f blue:50.0f/255.0f alpha:1];
}

+ (UIColor *)cameraOffBackgroundLightColor
{
    return [UIColor colorWithRed:70.0f/255.0f green:70.0f/255.0f blue:70.0f/255.0f alpha:1];
}

@end
