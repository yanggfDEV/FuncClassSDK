//
//  FZTabBarController.m
//  EnglishTalk
//
//  Created by CyonLeuPro on 15/5/25.
//  Copyright (c) 2015年 Feizhu Tech. All rights reserved.
//

#import "FZTabBarController.h"
#import "FZStyleSheet.h"

@interface FZTabBarController ()

@property (strong, nonatomic) UIImageView *coachBgImageView;

@end

@implementation FZTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
}

- (void)setup {
    FZStyleSheet *css = [FZStyleSheet currentStyleSheet];
    self.tabBar.backgroundImage = [UIImage imageWithColor:css.tabBarBackgroundColor];
    self.tabBar.shadowImage = [UIImage imageWithColor:css.tabBarShadowColor size:CGSizeMake(1.0f, 0.5)];
    
//    UIImageView *coachBgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tab_coach_bg"]];
//    coachBgImageView.frame = CGRectMake(0, - 8, 25, 25);
////    coachBgImageView.center.x = self.tabBar.center.x;
////    
//    self.coachBgImageView = coachBgImageView;
//    [self.tabBar addSubview:coachBgImageView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tabBar bringSubviewToFront:self.coachBgImageView];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return self.selectedViewController.preferredInterfaceOrientationForPresentation;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.selectedViewController.supportedInterfaceOrientations;
}

- (BOOL)shouldAutorotate {
    return self.selectedViewController.shouldAutorotate;
}


@end
