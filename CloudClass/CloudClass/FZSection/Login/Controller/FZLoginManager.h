//
//  FZLoginManager.h
//  EnglishTalk
//
//  Created by CyonLeuPro on 15/6/9.
//  Copyright (c) 2015年 Feizhu Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <TencentOpenAPI/QQApiInterface.h>
//#import <TencentOpenAPI/TencentOAuth.h>
//#import <WXApi.h>
//#import <WeiboSDK.h>


#import "FZLoginViewController.h"
#import "FZLoginUser.h"


@interface FZLoginManager : NSObject 
@property (strong, nonatomic) NSString *loginTip;//提示登录原因


+ (instancetype)sharedManager;

//- (FZLoginUser *)currentUser;
+ (BOOL)handelOpenURL:(NSURL *)url;
- (BOOL)hasLogin;
- (void)logout;
- (void)clear;

- (void)updateUserInfo:(NSDictionary *)userInfo;
- (void)onQQLogin;
- (void)showLoginViewControllerFromViewController:(UIViewController *)fromViewController
                                 showCancelButton:(BOOL)showCancel
                                          success:(FZLoginSuccessBlock)success
                                          failure:(FZLoginFailureBlock)failure
                                           cancel:(FZLoginCancelBlock)cancel;

- (void)showLoginViewControllerFromWindow:(UIWindow *)window
                         showCancelButton:(BOOL)showCancel
                                  success:(FZLoginSuccessBlock)success
                                  failure:(FZLoginFailureBlock)failure
                                   cancel:(FZLoginCancelBlock)cancel;

- (void)showLoginViewControllerFromWindow:(UIWindow *)window
                         showCancelButton:(BOOL)showCancel
                            successEnvent:(FZLoginSuccessEventBlock)successEnvent
                                  success:(FZLoginSuccessBlock)success
                                  failure:(FZLoginFailureBlock)failure
                                   cancel:(FZLoginCancelBlock)cancel;

@end
