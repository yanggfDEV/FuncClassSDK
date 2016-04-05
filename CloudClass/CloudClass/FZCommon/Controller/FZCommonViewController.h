//
//  FZCommonViewController.h
//  EnglishTalk
//
//  Created by yanming.huym on 15/5/20.
//  Copyright (c) 2015年 ishowtalk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FZUrlSchemesRouter.h"
#import "FZUIBarButtonItem.h"
#import "MBProgressHUD.h"
#import "FZLoadingView.h"
#import "FZRemoteNotificationParser.h"
#import "FZCommonTool.h"
#import <FZAPIGenerate.h>
#import "FZUmengStatisticalKeyConstants.h"

typedef NS_ENUM(NSUInteger, FZDataLoadType) {
    FZDataLoadTypeFirstTime,
    FZDataLoadTypeRefresh,
    FZDataLoadTypeMore
};

@interface FZCommonViewController : UIViewController <FZUrlSchemesInitControllerDelegate, MBProgressHUDDelegate, FZRemoteNotificationParserDelegate,UIGestureRecognizerDelegate>

@property (strong, nonatomic) FZLoadingView *loadingView; //封装了加载动画，失败显示，空数据显示等

- (void)doBack;

- (void)setRightBarButtonItem:(UIBarButtonItem *)rightBarItem;
- (void)setLeftBarButtonItem:(UIBarButtonItem *)leftBarItem;
- (void)setLeftBarButtonItemWithWhite;
- (void)setLeftBarButtonItemWithGray;

- (void)setNavgationbarTitleColorToWhite;
- (void)setNavgationbarTitleColorToDefault;
/**
 *  设置导航栏透明
 *
 *  @param isClear 是否要透明
 */

- (void)setClearNavigationBar:(BOOL)isClear;


#pragma mark - Loading
- (void)startProgressHUD;
- (void)startProgressHUDWithView:(UIView*)view;
- (void)startProgressHUDWithText:(NSString *)text;
- (void)stopProgressHUD;

//- (void)showSuccess;

- (void)showHUDError;
- (void)showHUDErrorMessage:(NSString *)message;

- (void)showHUDHintWithText:(NSString *)text;


#pragma mark - LoadingView 
/**
 *  loadingView 是覆盖在self.view上，为显示全屏的加载，错误，数据为空的提示，与progressHUD不同，progressHUD只是临时提示然后消失
 *
 *  @param completedBlock 显示加载动画后执行其他操作
 */
- (void)updateHUDgrogress:(MBProgressHUDMode)mode  labelText:(NSString*)text;
-(void) updateMyProgressTask:(CGFloat)pregress;

    
+ (BOOL)errorCode:(NSInteger)codeStauts;
- (void)showLoadingViewWithCompletedBlock:(LVAnimationCompletedBlock)completedBlock;
- (void)failedLoadingViewWithTitle:(NSString *)title;
- (void)emptyLoadingViewWithTitle:(NSString *)title;
- (void)hideLoadingView;

- (void)showTabBar;
- (void)hideTabBar;

@end
