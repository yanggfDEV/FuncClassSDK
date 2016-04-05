//
//  FZPlaceholderTextView.h
//  EnglishTalk
//
//  Created by huyangming on 15/3/25.
//  Copyright (c) 2015年 ishowtalk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIColor+Hex.h>


@interface FZPlaceholderTextView : UITextView

@property(nonatomic, copy) NSString *placeholder;
@property (nonatomic, strong) UIColor *placeholderColor;
@property(nonatomic,strong) UILabel* placeholderLabel;

// 如果需要设置文本框默认内容请使用这个方法
-(void)setTextViewText:(NSString *)text;
@end
