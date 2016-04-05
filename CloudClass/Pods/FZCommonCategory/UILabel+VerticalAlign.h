//
//  UILabel+VerticalAlign.h
//  EnAlibaba
//
//  Created by joy on 13-10-11.
//  Copyright (c) 2013年 com.alibaba.test. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark VerticalAlign
@interface UILabel (VerticalAlign)
- (void)alignTop;
- (void)alignBottom;
- (void) setHighLabel:(NSString *)string
                    Font:(UIFont *)font
                  StartX:(CGFloat)x
                  StartY:(CGFloat)y
                   Width:(CGFloat)width
                   Color:(UIColor*)color;
- (void) setHighLabelWithNoLimited:(NSString *)string
                                      Font:(UIFont *)font
                                    StartX:(CGFloat)x
                                    StartY:(CGFloat)y
                                     Width:(CGFloat)width
                                     Color:(UIColor*)color;
- (void) setHighLabel:(NSString *)string
                 Font:(UIFont *)font
               StartX:(CGFloat)x
               StartY:(CGFloat)y
                Width:(CGFloat)width
                Color:(UIColor *)color
              MaxLine:(int) line;
-(void )setLabelWithLink:(NSString *)string Font:(UIFont *)font StartX:(CGFloat)x StartY:(CGFloat)y Width:(CGFloat)width target:(id)_target action:(SEL)_action;

- (void) setNormLabel:(NSString *)string
						 Font:(UIFont *)font
					   StartX:(CGFloat)x
					   StartY:(CGFloat)y
                        Width:(CGFloat)width Color:(UIColor *)color;
- (void) setNormLabel:(NSString *)string
						 Font:(UIFont *)font
					   StartX:(CGFloat)x
					   StartY:(CGFloat)y
						Width:(CGFloat)width;
-(void)setLabelListWithFrame:(CGRect)frame line:(NSInteger)line font:(UIFont*)font color:(UIColor*)color;
- (void) setLabel:(NSString *)string
                    Font:(UIFont *)font
                  StartX:(CGFloat)x
                  StartY:(CGFloat)y
                   Width:(CGFloat)width
                   Color:(UIColor *)color;
- (void) setHighLabelWithNoLimitedWidth:(NSString *)string
                                   Font:(UIFont *)font
                                 StartX:(CGFloat)x
                                 StartY:(CGFloat)y
                                  Width:(CGFloat)width
                                  Color:(UIColor*)color;
@end


