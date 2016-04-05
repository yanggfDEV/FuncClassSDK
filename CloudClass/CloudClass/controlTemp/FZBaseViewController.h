//
//  FZBaseViewController.h
//  EnglishTalk
//
//  Created by Jyh on 15/5/7.
//  Copyright (c) 2015年 ishowtalk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FZCommonViewController.h"
@interface FZBaseViewController : FZCommonViewController

#pragma mark - KeyBoard

- (void)clearKeyboard;

#pragma mark - MBProgressHud

- (void)showHudWithString:(NSString *)str;
- (void)showText:(NSString *)str;
- (void)hideHud;

@end
