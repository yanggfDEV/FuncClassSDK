//
//  FZCommonViewController+item.h
//  FunChatStudent
//
//  Created by 刘滔 on 15/9/6.
//  Copyright (c) 2015年 Feizhu Tech. All rights reserved.
//

#import "FZCommonViewController.h"

// 导航栏左侧按钮类型
typedef NS_ENUM(NSUInteger, kLeftButtonType) {
    kLeftButtonTypeOfCloseImage,    // X形状的图片返回按钮
    kLeftButtonTypeOfBackImage,     // <形状的图片返回按钮
};

// 退出viewcontroller的方式
typedef NS_ENUM(NSUInteger, kExitVCMode) {
    kExitVCModeOfPop = 0,       // 导航栏pop方式离开
    kExitVCModeOfDismiss,       // VC dismiss方式离开
};

@interface FZCommonViewController (item)

// 导航栏添加返回按钮
- (void)addLeftButtonWithType:(kLeftButtonType)type exitVCType:(kExitVCMode)exitVCMode;

// 导航栏右边添加跳转到说明按钮
- (void)addRightDescriptionItemWithText:(NSString *)text jumpUrl:(NSString *)url;

#pragma mark - 子类重载
- (void)onPressedLeftButton:(id)sender;

@end
