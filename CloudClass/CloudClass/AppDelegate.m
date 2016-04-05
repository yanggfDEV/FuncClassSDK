//
//  AppDelegate.m
//  CloudClass
//
//  Created by guangfu yang on 16/1/26.
//  Copyright © 2016年 yangguangfu. All rights reserved.
//

#import "AppDelegate.h"
#import <FZRefreshTokenService.h>
#import "FZCommonConstants.h"
#import <FZLoginUser.h>
#import "JPUSHService.h"
#import "FZLoginManager.h"
#import "FZLoginOrOthersService.h"
#import "FZNavigationController.h"
#import "FZTabBarController.h"

#import "FZArrangeClassViewController.h"
#import "FZPersonCenterViewController.h"
#import "FZHomePageViewController.h"
#import "FZJusMeettingSDKManager.h"
#import "FCChatCache.h"
#import <AlipaySDK/AlipaySDK.h>
//#import <JusDoc/JusDoc.h>

static NSString *_token = nil;
static NSString *_tokenInfo;

@interface AppDelegate ()<UINavigationControllerDelegate, UITabBarControllerDelegate,FZJusMeetingSDKDelegate>
{
    BOOL development;
    BOOL _isIncoming;
    ZUINT _callId;
}

@property (nonatomic, strong) UIAlertView *reloginAlertView;
@property (nonatomic, strong) FZNavigationController *loginNavigationController;
@property (nonatomic, assign) BOOL reLoginBool;
@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [FZLocalization loadLanguageFiles];
    [FZAPIGenerate sharedInstance].isTestMode = kAPITestMode;
    development = YES;
    

    if (![self registerJustalk]) {
        return NO;
    }
    //检测网络
    Reachability* reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    [reach startNotifier];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults  objectForKey:CurrentUnfinishedDubbing_forNextLaunch]) {
        [userDefaults   setObject:[userDefaults  objectForKey:CurrentUnfinishedDubbing_forNextLaunch] forKey:CurrentUnfinishedDubbing];
        [userDefaults  removeObjectForKey:CurrentUnfinishedDubbing_forNextLaunch];
    }
    [userDefaults synchronize];
    
    //每个新版本   三个配音之后  首页 弹出打分的弹窗
    if (![[[userDefaults dictionaryRepresentation] allKeys]   containsObject:ishowDubbingAppVersion]) {
        NSMutableDictionary  *aboutAppVersion = [[NSMutableDictionary  alloc] init];
        [aboutAppVersion  setObject:@"0" forKey:CurrentVersionSucceedComposeTimes];
        [userDefaults  setObject:aboutAppVersion forKey:ishowDubbingAppVersion];
        [userDefaults synchronize];
    }
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    //没有黑屏的结果
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:channel apsForProduction:isProduction];
    
    // 初始化navigation相关
    [self initNavigation];

    [self setupRootTabBarController];
    
    [self.window makeKeyAndVisible];
    
    //视频配置
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    BOOL systemVersionLessThan8 = ([systemVersion compare:@"8.0"] == NSOrderedAscending);
    if (!systemVersionLessThan8) {
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    
    if (launchOptions) {
        [MtcPushManager SetUpWithOption:launchOptions];
    }
    
    [self initMob];
    
    return YES;
}

-(BOOL)registerJustalk
{
    //视频配置
    Zmf_AudioInitialize(NULL);
    Zmf_VideoInitialize(NULL);
    
    if (kAPITestMode) {
        //测试环境
        if (Mtc_Init(MY_APP_KEY_TEST)!= ZOK) {
            return NO;
        }
    } else {
        //正式环境
        if (Mtc_Init(MY_APP_KEY)!= ZOK) {
            return NO;
        }
    }
    
    [MtcLoginManager Init];
    [MtcMeetingManager init];
    
    [JusDocManager Init:(id<JusDocDelegate>)self];
    [MtcDoodleManager Init:(id<MtcDoodleDelegate>)self];
    return YES;
    
}


- (void)reachabilityChanged: (NSNotification*)note {
    Reachability * reach = [note object];
    if(![reach isReachable]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:Notice_Tag_IsReachable object:@"NO"];
        return;
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:Notice_Tag_IsReachEnable object:@"YES"];
        return;
    }
}

-(void)initMob
{
    //添加友盟统计
    // 1.开始统计数据
    [MobClick startWithAppkey:kUmengAPPKey reportPolicy:REALTIME channelId:nil];
    
    // 2.设置版本号
    [MobClick setAppVersion:APPVersion];
    
    // 3.对数据加密再发送到服务器
    [MobClick setEncryptEnabled:YES];

}

#pragma mark -- autologin
- (void)get_JpushInfoToserver {
    FZLoginOrOthersService *service = [[FZLoginOrOthersService alloc] init];
    NSString  *registrationID = [JPUSHService registrationID];
    [service get_JpushInfoToserver:registrationID success:^(NSInteger statusCode, NSString *message, id dataObject) {
    } failure:^(id responseObject, NSError *error) {
    }];
}

#pragma mark - Init app info
- (void)initNavigation {
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];

    UIImage *originBackImage = [UIImage imageNamed:@"common_icon_leftarrow"];
    UIImage *newBackImage = [originBackImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [[UINavigationBar appearance] setBackIndicatorImage:newBackImage];
    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:newBackImage];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-5,1.5) forBarMetrics:UIBarMetricsDefault];
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 10, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


//第一次创建
- (void)setupRootTabBarController {
    // justalk 登录
    if ([[FZLoginManager sharedManager] hasLogin]) {
        if ([FZLoginUser mobile] && ![[FZLoginUser mobile] isEqualToString:@""]) {
            [[FZJusMeettingSDKManager shareInstance] jusMeettingSDKLogin:[FZLoginUser userID] passWD:[FZLoginUser passWD] development:NO];
            [FZJusMeettingSDKManager shareInstance].jusDelegate = self;
            [FCChatCache setCurrentAppUserID:[FZLoginUser userID]];
        }else {
            [[FZLoginManager sharedManager] logout];
        }
    }
    //首页
    FZHomePageViewController *homePageViewController = [[FZHomePageViewController alloc] init];
    [self setTabTitle:LOCALSTRING(@"homepage_page") selectedTabImage:@"tab_index_icon_sel" unSelectedTabImage:@"tab_index_icon_nor" toViewController:homePageViewController];
    
    //约课
    FZArrangeClassViewController *arrangeClassView = [[FZArrangeClassViewController alloc] init];
    [self setTabTitle:LOCALSTRING(@"arrange_class_page") selectedTabImage:@"tab_teacher_icon_sel" unSelectedTabImage:@"tab_teacher_icon_nor" toViewController:arrangeClassView];
    
    //我的
    FZPersonCenterViewController *meTableViewController = [[FZPersonCenterViewController alloc] init];
    [self setTabTitle:LOCALSTRING(@"personCenter_page") selectedTabImage:@"tab_icon_user_selected" unSelectedTabImage:@"tab_icon_user" toViewController:meTableViewController];
    
    self.navigationController = [[FZNavigationController alloc]  initWithRootViewController:homePageViewController];
    self.navigationController2 = [[FZNavigationController alloc] initWithRootViewController: arrangeClassView];
    self.navigationController3 = [[FZNavigationController alloc] initWithRootViewController:meTableViewController];
    
    self.tabBarController = [[FZTabBarController alloc] init];
    self.tabBarController.delegate = self;
    self.tabBarController.viewControllers = @[self.navigationController,self.navigationController2,self.navigationController3];
    self.tabBarController.selectedViewController = self.navigationController;
    
    self.navigationController.delegate = self;
    self.navigationController2.delegate = self;
    self.navigationController3.delegate = self;
    
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController2.navigationBar setTranslucent:YES];
    [self.navigationController3.navigationBar setTranslucent:YES];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldReloginNotification:) name:kPostLogoutNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTokenExpiredNotification:) name:kRefreshTokenExpiredNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerSuccessAction:) name:Notice_Register_Success object:nil];
    //判断是否要显示广告
    NSString *advertPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:kFZAdvertHomeScreenImgName];
    if([[NSFileManager defaultManager] fileExistsAtPath:advertPath]){
        UIImage *image = [UIImage imageWithContentsOfFile:advertPath];
        if(image){
            //            FZFullScreenAdvertViewController *advertViewController = [[FZFullScreenAdvertViewController alloc] init];
            //            advertViewController.image = [UIImage imageWithContentsOfFile:advertPath];
            //            self.window.rootViewController = advertViewController;
        }else{
            self.window.rootViewController = self.tabBarController;
        }
    }else{
        self.window.rootViewController = self.tabBarController;
    }
    
    // 提前调用“我”页面的viewDidLoad
    UIView * __unused unusedView = meTableViewController.view;
}

- (void)resetRootTabBarController {
  [self.window makeKeyAndVisible];
}

- (void)setTabTitle:(NSString *)title selectedTabImage:(NSString *)selectedTabImageName unSelectedTabImage:(NSString *)unSelectedTabImageName toViewController:(UIViewController *)viewController
{
    [viewController.tabBarItem setTitle:title];
    UIImage *selectedTabImage = [UIImage imageNamed:selectedTabImageName];
    UIImage *unSelectedTabImage = [UIImage imageNamed:unSelectedTabImageName];
    UIImage *newSelectedTabImage = [selectedTabImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *newUnSelectedTabImage = [unSelectedTabImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    viewController.tabBarItem.image = newUnSelectedTabImage;
    viewController.tabBarItem.selectedImage = newSelectedTabImage;
    FZStyleSheet *css = [FZStyleSheet currentStyleSheet];
    [viewController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:css.tabBarTextColor, NSFontAttributeName:[UIFont boldSystemFontOfSize:10.f]} forState:UIControlStateNormal];
    [viewController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:css.tabBarSelectedTextColor, NSFontAttributeName:[UIFont boldSystemFontOfSize:10.f]} forState:UIControlStateSelected];
}

- (void)shouldReloginNotification:(NSNotification *)notification {
    if (self.loginNavigationController != self.window.rootViewController) {
        
        if (!self.reLoginBool) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:Notice_message_force_logout object:nil userInfo:nil];
        }
        if (!self.reloginAlertView || !self.reloginAlertView.visible) {
            WEAKSELF
            if (!self.reLoginBool) {
                
                self.reloginAlertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                   message:@"您的趣课堂帐号已在其它地方登录，请重新登录！"
                                                          cancelButtonItem:[RIButtonItem itemWithLabel:@"确定"
                                                                                                action:^(){
                                                                                                    [weakSelf logoutAndRelogin:nil];}]
                                                          otherButtonItems:nil];
                [self.reloginAlertView show];
            }
        }
    }
}

- (void)refreshTokenExpiredNotification:(NSNotification *)notification {
    if (self.loginNavigationController != self.window.rootViewController) {
        [[NSNotificationCenter defaultCenter] postNotificationName:Notice_message_force_logout object:nil userInfo:nil];
        NSString *tipMessage = nil;
        if (notification.object) {
            tipMessage = [NSString stringWithFormat:@"%@", notification.object];
        } else {
            tipMessage = @"因您长时间不玩，已被迫下线，请重新登录！";
        }
        [self logoutAndRelogin:tipMessage];
    }
}

- (void)registerSuccessAction:(NSNotification *)notification {
    [self.tabBarController setSelectedIndex:0];
}

- (void)logoutAndRelogin:(NSString *)loginTip {
    [[FZJusMeettingSDKManager shareInstance] jusMeettingSDKLogout];
    [[FZLoginManager sharedManager] logout];
    [FZLoginManager sharedManager].loginTip = loginTip;
    
    [self.navigationController popToRootViewControllerAnimated:NO];
    [self.navigationController2 popToRootViewControllerAnimated:NO];
    
    [self.tabBarController setSelectedIndex:0];
    [self setupLoginViewController];
}

- (void)setupLoginViewController {
    [self setupLoginViewControllerWithLoginSuccessEventBlock:nil];
}

- (void)setupLoginViewControllerWithLoginSuccessEventBlock:(FZLoginSuccessEventBlock)loginSuccessEventBlock {
    WEAKSELF
    [[FZLoginManager sharedManager] showLoginViewControllerFromWindow:self.window showCancelButton:YES successEnvent:loginSuccessEventBlock success:^{
        [weakSelf get_JpushInfoToserver];
        //jusTalk登录
        
        [[FZJusMeettingSDKManager shareInstance] jusMeettingSDKLogin:[FZLoginUser userID] passWD:[FZLoginUser passWD] development:NO];
        [FZJusMeettingSDKManager shareInstance].jusDelegate = self;
        
         [FCChatCache setCurrentAppUserID:[FZLoginUser userID]];
        //通知app登录成功了
        [[NSNotificationCenter defaultCenter] postNotificationName:FZLoginSucessNotification object:nil];
    } failure:^(NSString *errorMessage) {
        
    } cancel:^{
        BOOL hide = self.tabBarController.tabBar.hidden;
        self.window.rootViewController = self.tabBarController;
        self.tabBarController.tabBar.hidden = hide;
        [[NSNotificationCenter defaultCenter] postNotificationName: Notice_Login_Cancel object: nil];
    }];
}

#pragma mark - uitabbarcontroller delegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[FZNavigationController class]]) {
        FZNavigationController *nav = (FZNavigationController *)viewController;
        NSArray *vcs = nav.viewControllers;
        //        if ([vcs.firstObject isKindOfClass:[FZForeignersTeacherViewController class]]) {
        //            [MobClick event:kTeacherTabEventID];
        //        }
    }
    return YES;
}

#pragma mark ——justMettingdelegate登录情况——
- (void)jusMettingLoginSuccess {

}

- (void)jusMettingLoginfail {
    [[FZJusMeettingSDKManager shareInstance] jusMeettingSDKLogout];
    [[FZLoginManager sharedManager] logout];
}

#pragma mark -- JPush极光推送来的信息
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    //视频配置
    [MtcPushManager RegisterDeviceToken:deviceToken];
    
    // Required
    [JPUSHService registerDeviceToken:deviceToken];
    NSLog(@"registrationID------:%@", [JPUSHService registrationID]);
    NSString *registrationID = [JPUSHService registrationID];
    if(![registrationID isEqualToString:@""] ||
       ![registrationID isKindOfClass:[NSNull class]] ||
       registrationID){
        [[NSUserDefaults standardUserDefaults] setObject:registrationID forKey:@"registrationID"];
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"registrationID"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [JPUSHService handleRemoteNotification:userInfo];
    [MtcPushManager HandleRemoteNotifications:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
    if ( application.applicationState == UIApplicationStateInactive){
        if(userInfo && userInfo[@"type"]){
            //通知处理
            [[FZRemoteNotificationParser sharedRemoteNotificationParser] handleRemoteNotification:userInfo tabcontroller:_tabBarController];
        }
    }else if ( application.applicationState == UIApplicationStateActive){
        //通知处理
        [[FZRemoteNotificationParser sharedRemoteNotificationParser] handleRemoteNotification:userInfo];
    }
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {

    //NSString* title =  [notification.userInfo objectForKey:@"title"];
    //NSString* avatar = [notification.userInfo objectForKey:@"avatar"];
    //NSString* nickname = [notification.userInfo objectForKey:@"nickname"];
    
    // [notification.userInfo objectForKey:ConfIncomingNotificationConfUriKey];

    //NSLog(@"%@",notification);
   // NSLog(@"标题:%@,头像:%@,昵称:%@",title,avatar,nickname);
    
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
   // [self registerJustalk];
    [application setKeepAliveTimeout:600 handler:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        Mtc_CliRefresh();
    });
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL isUrlDo = [[FZUrlSchemesRouter sharedUrlSchemesRouterManager] handleUrlSchemaMap:url tabcontroller:_tabBarController];
    if (isUrlDo) {
        return YES;
    }
//    [QQApiInterface handleOpenURL:url delegate:nil];
//    [FZLoginManager handelOpenURL:url];
//    [NeteaseShare handleOpenURL:url];
    
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:nil];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [application setKeepAliveTimeout:600 handler:^{
        NSLog(@"===>keepAlive");
        Mtc_CliRefresh();
    }];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    dispatch_async(dispatch_get_main_queue(), ^{
        [MtcMeetingManager didBecomeActive];
    });
}

- (void)registerForRemoteNotifications {
    [MtcPushManager RegisterForRemoteNotificationsTypes:(UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound) categories:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)doodleDidCreate:(int)callId {
    
}

- (void)doodleDidStart:(int)callId {
    [MtcMeetingManager switchFloatWindow:YES];
}

- (void)doodleDidStop:(int)callId {
    [MtcMeetingManager switchFloatWindow:NO];
}


- (void) RequestToStart:(JCallId)callId
{
    CGFloat h = [MtcMeetingManager getMainVideoViewHeight];
    UIViewController *viewController = [JusDocManager Start:callId displayHeight:h];
    if (viewController) {
        [MtcMeetingManager coverMainVideoView:viewController];
    }
}

- (void) RequestToStop:(JCallId)callId
{
    [MtcMeetingManager recoverMainVideoView];
}

- (void) DidCreate:(JCallId)callId
{
    
}

@end
