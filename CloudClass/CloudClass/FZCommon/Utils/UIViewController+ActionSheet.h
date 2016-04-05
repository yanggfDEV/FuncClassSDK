//
//  UIViewController+ActionSheet.h
//  EnglishTalk
//
//  Created by apple on 15/5/28.
//  Copyright (c) 2015年 Feizhu Tech. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^CancelCompletion)(void);
typedef void(^ConfirmCompletion)(void);
typedef void(^ClickCompletion)(void);

@interface UIViewController (ActionSheet) <UIActionSheetDelegate>

- (void)showActionSheetTitle:(NSString *)title
           cancelButtonTitle:(NSString *)cancelButtonTitle
      destructiveButtonTitle:(NSString *)destructiveButtonTitle
            cancelCompletion:(CancelCompletion)cancelCompletion
           confirmCompletion:(ConfirmCompletion)confirmCompletion;

/**
 *  底部弹出菜单,
 *
 *  @param title
 *  @param clickCompletionTitles 菜单标题集合(第一个必须传入 取消 菜单)  最多支持5个菜单(包括取消菜单)
 *  @param clickCompletions 菜单点击回调
 */
- (void)showActionSheetTitle:(NSString *)title
             clickCompletionTitles:(NSArray*)clickCompletionTitles
             clickCompletions:(NSArray*)clickCompletions;

@end
