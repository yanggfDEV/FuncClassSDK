//
//  FZUIButton.h
//  EnglishTalk
//
//  Created by huyangming on 15/3/29.
//  Copyright (c) 2015年 ishowtalk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FZUIButton : UIButton

@property(nonatomic,strong)id tapParameter;

- (id)initALiOrangeButtonWithFrame:(CGRect)frame title:(NSString*)title target:(id)target action:(SEL)action;
- (id)initSignInButtonWithFrame:(CGRect)frame title:(NSString*)title target:(id)target action:(SEL)action;

- (id)initMoreTimeButtonWithFrame:(CGRect)frame title:(NSString*)title target:(id)target action:(SEL)action;

- (id)initDepositButtonWithFrame:(CGRect)frame title:(NSString*)title target:(id)target action:(SEL)action;

- (id)initForgotButtonWithFrame:(CGRect)frame title:(NSString*)title target:(id)target action:(SEL)action;

- (id)initNewUpdateButtonWithFrame:(CGRect)frame title:(NSString*)title target:(id)target action:(SEL)action;

- (id)initNewMessageButtonWithFrame:(CGRect)frame title:(NSString *)title target:(id)target action:(SEL)action;

- (id)initWithRightButtonItemwithTitle:(NSString *)title target:(id)target action:(SEL)action;

- (id)initWithLeftButtonItemwithTitle:(NSString *)title target:(id)target action:(SEL)action;

- (id)initWithBottomLeftButtonwithwithFrame:(CGRect)frame Title:(NSString *)title target:(id)target action:(SEL)action;

- (id)initWithBottomRightButtonwithwithFrame:(CGRect)frame Title:(NSString *)title target:(id)target action:(SEL)action;

- (id)initWithPairButtonWithFrame:(CGRect)frame title:(NSString*)title target:(id)target action:(SEL)action;

- (id)initWithFrame:(CGRect)frame withFont:(CGFloat)fontSize withTitle:(NSString *)title withTitleColor:color target:(id)target action:(SEL)action;

- (id)initWithFrame:(CGRect)frame withImage:(NSString *)imageName target:(id)target action:(SEL)action;

- (id)initGuideButtonWithFrame:(CGRect)frame withTitle:(NSString *)title  target:(id)target action:(SEL)action;
@end
