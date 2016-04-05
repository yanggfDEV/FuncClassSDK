//
//  AppDelegate.h
//  CloudClass
//
//  Created by guangfu yang on 16/1/26.
//  Copyright © 2016年 yangguangfu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) UITabBarController *tabBarController;
@property (nonatomic, strong) UINavigationController *navigationController;
@property (nonatomic, strong) UINavigationController *navigationController2;
@property (nonatomic, strong) UINavigationController *navigationController3;

- (void)setupRootTabBarController;//初始创建
- (void)resetRootTabBarController;//重新设置
- (void)initNavigation;
- (void)get_JpushInfoToserver;

- (void)registerForRemoteNotifications;

@end

