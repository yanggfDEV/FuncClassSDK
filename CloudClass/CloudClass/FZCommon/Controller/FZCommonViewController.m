//
//  FZCommonViewController.m
//  EnglishTalk
//
//  Created by yanming.huym on 15/5/20.
//  Copyright (c) 2015年 ishowtalk. All rights reserved.
//

#import "FZCommonViewController.h"
#define OSVERSION [[UIDevice currentDevice].systemVersion intValue]

#import "ProgressHUD.h"
@interface FZCommonViewController ()

@property (strong, nonatomic) MBProgressHUD *hud;

@property (nonatomic, strong) UIButton *goBackBtn;

@end

@implementation FZCommonViewController

-(id)initControllerWithParameters:(NSDictionary*)parameters
{
    self = [self initWithNibName:nil    bundle:nil];
    if (self) {
  
    }
    return self;
}


-(instancetype)initControllerWithRemoteNotificationParameters:(NSDictionary *)parameters{
    self = [self initWithNibName:nil    bundle:nil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"18ba6e"];
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSFontAttributeName:[UIFont boldSystemFontOfSize:18],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"ffffff"]}];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    if (self.navigationController.viewControllers.count > 0) {
        UIBarButtonItem * backItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:nil action:nil];
        [self.navigationItem setBackBarButtonItem:backItem];
        
    }
    
    self.loadingView = [[FZLoadingView alloc] initWithFrame:self.view.bounds containerView:self.view];
    
}

- (void)onGoBack {
    [self.navigationController popViewControllerAnimated:YES];
}


//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//
//    self.navigationController.navigationBar.titleTextAttributes = nil;
//    self.navigationController.navigationBarHidden = NO;
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
//                                                  forBarMetrics:UIBarMetricsDefault];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
//}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [ProgressHUD dismiss];
}

-(void)doBack {
    [self stopProgressHUD];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

#pragma mark - Public Method

- (void)setRightBarButtonItem:(UIBarButtonItem *)rightBarItem {
//    UIBarButtonItem *spaceFixBarItem = [[UIBarButtonItem alloc] init];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                   target:nil action:nil];
    negativeSpacer.width = -5;//这个数值可以根据情况自由变化
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, rightBarItem];
}

- (void)setLeftBarButtonItem:(UIBarButtonItem *)leftBarItem {
    //    UIBarButtonItem *spaceFixBarItem = [[UIBarButtonItem alloc] init];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                   target:nil action:nil];
    negativeSpacer.width = -20;//这个数值可以根据情况自由变化
    self.navigationItem.leftBarButtonItems = @[negativeSpacer, leftBarItem];
}

- (void)setClearNavigationBar:(BOOL)isClear {
    if (isClear) {
        self.navigationController.navigationBarHidden = NO;
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                      forBarMetrics:UIBarMetricsDefault];
//        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
        self.navigationController.navigationBar.clipsToBounds = YES;
    } else {
        //复原
        [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:[FZStyleSheet currentStyleSheet].colorOfSeperatorOnLightBackground]];
        self.navigationController.navigationBar.clipsToBounds = NO;
    }
   
}

- (void)setLeftBarButtonItemWithWhite
{
    UIImage *image = [UIImage imageNamed:@"common_back_white"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [UINavigationBar appearance].backIndicatorImage = image;
    [UINavigationBar appearance].backIndicatorTransitionMaskImage = image;
}

- (void)setLeftBarButtonItemWithGray
{
    
//    UIImage *image = [UIImage imageNamed:@"common_back_gray"];
//    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    [UINavigationBar appearance].backIndicatorImage = image;
//    [UINavigationBar appearance].backIndicatorTransitionMaskImage = image;
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setBackgroundImage:[UIImage  imageNamed:@"common_back_gray"] forState:UIControlStateNormal];
    [rightButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    rightButton.frame = CGRectMake(0, 0, 22, 22);
    [rightButton addTarget: self action: @selector(doBack) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.leftBarButtonItem = leftBarItem;
}

- (void)setNavgationbarTitleColorToWhite
{
    NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                               [UIColor whiteColor],NSForegroundColorAttributeName,
                                               [UIFont systemFontOfSize:15],
                                               NSFontAttributeName, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:navbarTitleTextAttributes];
}

- (void)setNavgationbarTitleColorToDefault
{
    self.navigationController.navigationBar.titleTextAttributes = nil;
}


#pragma mark - Loading & tip

- (void)updateHUDgrogress:(MBProgressHUDMode)mode  labelText:(NSString*)text
{
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.view addSubview:self.hud];
    self.hud.mode = mode;
    self.hud.labelText = text;
    
}



-(void) updateMyProgressTask:(CGFloat)pregress{
    self.hud.progress = pregress;
}

-(void)showMBProGressHUD
{
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.hud];
    self.hud.mode = MBProgressHUDModeDeterminate;
    self.hud.delegate = self;
    [self.hud show:YES];

}
- (void)startProgressHUD {
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    self.hud = HUD;
    
    self.hud.labelText = @"正在加载...";
    [self.view bringSubviewToFront:HUD];
    [self.hud show:YES];
}

- (void)startProgressHUDWithView:(UIView*)view{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    HUD.delegate = self;
    self.hud = HUD;
    
    self.hud.labelText = @"正在加载...";
    [self.view bringSubviewToFront:HUD];
    [self.hud show:YES];
}

- (void)stopProgressHUD {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (self.hud) {
        [self.hud hide:YES];
    }
}

- (void)startProgressHUDWithText:(NSString *)text{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    self.hud = HUD;
    
    self.hud.labelText = text;
    [self.hud show:YES];
}

- (void)showHUDError {
    [self showHUDHintWithText:@"加载失败,请检查网络"];
}
- (void)showHUDErrorMessage:(NSString *)message{
    [self showHUDHintWithText:message];
}

- (void)showHUDHintWithText:(NSString *)text {
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hub.mode = MBProgressHUDModeText;
    //    hub.labelText = text;
    hub.detailsLabelText = text;
    hub.removeFromSuperViewOnHide = YES;
    [hub show:YES];
    [hub hide:YES afterDelay:2];
}

#pragma mark - FZLoadingView 

- (void)showLoadingViewWithCompletedBlock:(LVAnimationCompletedBlock)completedBlock {
    [self.loadingView showAnimated:YES completionHandler:completedBlock];
}

- (void)failedLoadingViewWithTitle:(NSString *)title {
    if (title) {
        [self.loadingView failedWithTitle:title];
    } else {
        [self.loadingView failed];
    }
}
- (void)emptyLoadingViewWithTitle:(NSString *)title {
    if (title) {
        [self.loadingView emptyWithTitle:title subTitle:nil];
    } else {
        [self.loadingView empty];
    }
}
- (void)hideLoadingView {
    [self.loadingView hide];
}

+ (BOOL)errorCode:(NSInteger)codeStauts
{
    if ((codeStauts == 401)||(codeStauts == 402)||(codeStauts == 403)) {
        //        [FZLoginUser setIsSignIn:NO];
        //        [FCVideoTalkSDKManager Logout];
        //        //退出登录
        //        [[FZLoginManager sharedManager] logout];
        //        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        //        UIViewController *viewController = nil;
        //        if ([appDelegate.window.rootViewController isMemberOfClass:[FZNavigationController class]]) {
        //            UINavigationController *navi = (UINavigationController *)appDelegate.window.rootViewController;
        //            viewController = navi.topViewController;
        //        } else {
        //            viewController = appDelegate.window.rootViewController;
        //        }
        //        if ([viewController isMemberOfClass:[FCSigninViewController class]]) {
        //            return YES;
        //        }
        //        static UIAlertView *logoutAlertView = nil;
        //        if (!logoutAlertView) {
        //            UIAlertView *alertView = [UIAlertView bk_showAlertViewWithTitle:nil message:LOCALSTRING(@"mysetting_errorCode") cancelButtonTitle:LOCALSTRING(@"resign_title") otherButtonTitles:@[LOCALSTRING(@"common_logout")] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        //                [((AppDelegate *)[UIApplication sharedApplication].delegate) setupLoginViewController];
        //                logoutAlertView = nil;
        //            }];
        //            [alertView show];
        //            logoutAlertView = alertView;
        //        }
        return YES;
    }
    return NO;
}

- (void)showTabBar {
//    if (self.tabBarController.tabBar.hidden == NO)
//    {
//        return;
//    }
//    UIView *contentView;
//    if ([[self.tabBarController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]]) {
//        contentView = [self.tabBarController.view.subviews objectAtIndex:1];
//    } else {
//        contentView = [self.tabBarController.view.subviews objectAtIndex:0];
//    }
//    if (contentView.bounds.size.height == 0) {
//        CGRect rect = contentView.frame;
//        rect.size.height = 49.0f;
//        contentView.frame = rect;
//    }
//    contentView.frame = CGRectMake(contentView.bounds.origin.x, contentView.bounds.origin.y,  contentView.bounds.size.width, contentView.bounds.size.height);
//    self.tabBarController.tabBar.hidden = NO;
}

// 隐藏tabbar
- (void)hideTabBar {
//    if (self.tabBarController.tabBar.hidden == YES)
//    {
//        return;
//    }
//    UIView *contentView;
//    if ( [[self.tabBarController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]]) {
//        contentView = [self.tabBarController.view.subviews objectAtIndex:1];
//    } else {
//        contentView = [self.tabBarController.view.subviews objectAtIndex:0];
//    }
//    contentView.frame = CGRectMake(contentView.bounds.origin.x,  contentView.bounds.origin.y,  contentView.bounds.size.width, contentView.bounds.size.height);
//    self.tabBarController.tabBar.hidden = YES;
}

#pragma mark - Orientation

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return  UIInterfaceOrientationPortrait;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationMaskPortrait);//系统默认不支持旋转功能
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate {
    return NO;
}
@end
