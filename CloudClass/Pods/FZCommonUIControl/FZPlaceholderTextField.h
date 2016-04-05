//
//  FZPlaceholderTextField.h
//  Pods
//
//  Created by Patty on 15/7/8.
//
//

#import <UIKit/UIKit.h>
#import <UIColor+Hex.h>

@interface FZPlaceholderTextField : UITextField

@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, strong) UIColor *placeholderColor;
@property (nonatomic,strong) UILabel* placeholderLabel;

// 如果需要设置文本框默认内容请使用这个方法
-(void)setTextFieldText:(NSString *)text;

@end
