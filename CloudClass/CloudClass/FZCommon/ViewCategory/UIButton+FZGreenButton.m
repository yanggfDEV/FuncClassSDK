//
//  UIButton+FZGreenButton.m
//  EnglishTalk
//
//  Created by CyonLeuPro on 15/9/7.
//  Copyright (c) 2015年 Feizhu Tech. All rights reserved.
//

#import "UIButton+FZGreenButton.h"
#import "FZStyleSheet.h"

@implementation UIButton (FZGreenButton)

- (void)applyGreenBackgroundColor {
    FZStyleSheet *css = [FZStyleSheet currentStyleSheet];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = css.buttonCornerRadius;
    
    [self setBackgroundImage:[UIImage imageWithColor:css.colorOfGreenButtonNormal] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageWithColor:css.colorOfGreenButtonHightlighted] forState:UIControlStateHighlighted];
    [self setBackgroundImage:[UIImage imageWithColor:css.colorOfGreenButtonDisabled] forState:UIControlStateDisabled];
    
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.titleLabel.font = css.fontOfH2;
}

- (void)applyEllipseGreenBackgroundColor{
    FZStyleSheet *css = [FZStyleSheet currentStyleSheet];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = CGRectGetHeight(self.frame) / 2;
    
    [self setBackgroundImage:[UIImage imageWithColor:css.colorOfGreenButtonNormal] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageWithColor:css.colorOfGreenButtonHightlighted] forState:UIControlStateHighlighted];
    [self setBackgroundImage:[UIImage imageWithColor:css.colorOfGreenButtonDisabled] forState:UIControlStateDisabled];
    
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.titleLabel.font = css.fontOfH2;
}


- (void)applyGreenTitleColor{
    FZStyleSheet *css = [FZStyleSheet currentStyleSheet];
    [self setTitleColor:css.colorOfGreenButtonNormal forState:UIControlStateNormal];
    [self setTitleColor:css.colorOfGreenButtonHightlighted forState:UIControlStateHighlighted];
    [self setTitleColor:css.colorOfGreenButtonDisabled forState:UIControlStateDisabled];
    
    self.titleLabel.font = css.fontOfH2;
}

@end
