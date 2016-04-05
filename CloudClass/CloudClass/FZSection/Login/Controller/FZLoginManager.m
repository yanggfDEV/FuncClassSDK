//
//  FZLoginManager.m
//  EnglishTalk
//
//  Created by CyonLeuPro on 15/6/9.
//  Copyright (c) 2015年 Feizhu Tech. All rights reserved.
//

#import "FZLoginManager.h"
#import "FZHTTPRequestOperationManager.h"
#import "FZNavigationController.h"
#import <OpenUDID.h>
//#import <FZUserVideoTalkSDK/FCVideoTalkSDKManager.h>
//#import <FCChatCache/FCChatCache.h>
#import <NSString+Enhanced.h>
#import "FCUtil.h"
#import "JSONKit.h"

@interface FZLoginManager () 
//@property (strong, nonatomic) FZLoginUser *currentUser;

//@property (strong, nonatomic) TencentOAuth *tencentOAuth;
@property (strong, nonatomic) FZLoginViewController *loginViewController;

@property (copy, nonatomic) FZLoginSuccessBlock loginSuccessBlock;
@property (copy, nonatomic) FZLoginFailureBlock loginFailureBlock;
@property (copy, nonatomic) FZLoginCancelBlock loginCancelBlock;

@property (strong, nonatomic) UIWindow *loginWindow;
@property (strong, nonatomic) UIWindow *originWindow;

@end

@implementation FZLoginManager

+ (instancetype)sharedManager {
    static id sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
//        _currentUser = [[FZLoginUser alloc] init];

    }
    return self;
}

#pragma mark - Public method

//+ (BOOL)handelOpenURL:(NSURL *)url {
//    
//    FZLoginManager *shareManager = [FZLoginManager sharedManager];
//    
////    return [TencentOAuth HandleOpenURL:url] ||
////    [WXApi handleOpenURL:url delegate:shareManager] ||
////    [QQApiInterface handleOpenURL:url delegate:shareManager] ||
////    [WeiboSDK handleOpenURL:url delegate:shareManager];
//    
//    return NO;
//}

- (BOOL)hasLogin {
    if ([FZLoginUser userID] && [FZLoginUser authToken]) {
        return YES;
    }
    return NO;
}

- (void)logout {
    [self clear];
}
- (void)clear {
    [FZLoginUser setUserID:nil];
    [FZLoginUser setCommonUId:nil];
    [FZLoginUser setNickname:nil];
    [FZLoginUser setAvatar:nil];
    [FZLoginUser setEmail:nil];
    [FZLoginUser setType:nil];
    
    [FZLoginUser setAuthToken:nil];
    [FZLoginUser setUploadToken:nil];
    [FZLoginUser setUploadMessageToken:nil];
    [FZLoginUser setMessageLogURL:nil];
    
    //detail info
    [FZLoginUser setCover:nil];
    [FZLoginUser setArea:nil];
    [FZLoginUser setMobile:nil]; 
    [FZLoginUser setSchool:nil];
    [FZLoginUser setSchoolName:nil];
    
    [FZLoginUser setBirthday:nil];
    [FZLoginUser setSex:0];
    [FZLoginUser setSignature:nil];
    [FZLoginUser setCampus:nil];
    [FZLoginUser setUserClass:nil];
    
    [FZLoginUser setUserClassList:nil];
    [FZLoginUser setTeacherID:nil];
    [FZLoginUser setImageURL:nil];
    [FZLoginUser setUserSchoolIdentity:-1];
    
}

- (void)updateUserInfo:(NSDictionary *)userInfo {
    
    if (!userInfo || ![userInfo isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    [FZLoginUser setUserID:userInfo[@"uid"]];
    [FZLoginUser setCommonUId:userInfo[@"uc_id"]];
    [FZLoginUser setNickname:userInfo[@"nickname"]];
    [FZLoginUser setAvatar:userInfo[@"avatar"]];
    [FZLoginUser setEmail:userInfo[@"email"]];
    [FZLoginUser setType:userInfo[@"type"]];

    [FZLoginUser setAuthToken:userInfo[@"auth_token"]];
    [FZLoginUser setRefreshToken:userInfo[@"refresh_token"]];
    [FZLoginUser setAuthTokenExpire:userInfo[@"endtime"]];

    
    [FZLoginUser setUploadToken:userInfo[@"upload_token"]];
    [FZLoginUser setUploadMessageToken:userInfo[@"upload_msgtoken"]];
    [FZLoginUser setMessageLogURL:userInfo[@"msglog_url"]];
    
    //detail info
    [FZLoginUser setCover:userInfo[@"cover"]];
    [FZLoginUser setArea:userInfo[@"area"]];
    [FZLoginUser setMobile:userInfo[@"mobile"]];
    [FZLoginUser setSchool:userInfo[@"school"]];
    [FZLoginUser setSchoolName:userInfo[@"school_str"]];
    [FZLoginUser setBirthday:userInfo[@"birthday"]];
    
    NSString *sexString = userInfo[@"sex"];
    if (sexString) {
        NSInteger sexInt = [sexString integerValue];
        [FZLoginUser setSex:sexInt];
    } else {
        [FZLoginUser setSex:0];
    }
    
    [FZLoginUser setSignature:userInfo[@"signature"]];
    [FZLoginUser setCampus:userInfo[@"campus"]];
    [FZLoginUser setUserClass:userInfo[@"class"]];

    [FZLoginUser setUserClassList:userInfo[@"class_list"]];
    [FZLoginUser setTeacherID:userInfo[@"tch_id"]];
    [FZLoginUser setImageURL:userInfo[@"img_url"]];

    NSString *schoolIdentityString = userInfo[@"identity"];
    if (schoolIdentityString) {
        NSInteger schoolIdentityInt = [schoolIdentityString integerValue];
        [FZLoginUser setUserSchoolIdentity:schoolIdentityInt];
    } else {
        [FZLoginUser setUserSchoolIdentity:0];
    }
    
    
    /**
     * @guangfu yang 15-12-21 18:54
     * 第三方登录木有绑定手机号，马上弹出绑定页面
     **/
    if (![FZLoginUser mobile] || [[FZLoginUser mobile] isEqualToString:@""]) {
        //木有绑定手机号
        [[NSNotificationCenter defaultCenter] postNotificationName:Notice_thirdPortyLogin_Success object: nil];
    }
}



- (void)showLoginViewControllerFromViewController:(UIViewController *)fromViewController
                                 showCancelButton:(BOOL)showCancel
                                          success:(FZLoginSuccessBlock)success
                                          failure:(FZLoginFailureBlock)failure
                                           cancel:(FZLoginCancelBlock)cancel{

    if (!fromViewController) {
        cancel();
        return;
    }
    
    self.loginSuccessBlock = success;
    self.loginFailureBlock = failure;
    self.loginCancelBlock = cancel;
    
    WEAKSELF
    FZLoginViewController *viewController = [[FZLoginViewController alloc] initWithNibName:@"FZLoginViewController" bundle:nil];
    viewController.showCancelButton = showCancel;
    viewController.loginSuccessBlock = ^(void) {
        [weakSelf didLoginSuccess];
    };
    
    viewController.loginCancelBlock = weakSelf.loginCancelBlock;
    viewController.loginFailureBlock = ^(NSString *message) {
        [weakSelf didLoginFailure:message];
    };
    
    if (fromViewController.navigationController) {
        [fromViewController.navigationController pushViewController:viewController animated:YES];
    } else {
        FZNavigationController *loginNavigationController = [[FZNavigationController alloc] initWithRootViewController:viewController];
        [fromViewController presentViewController:loginNavigationController animated:YES completion:nil];
    }
    
    self.loginViewController = viewController;
}

- (void)showLoginViewControllerFromWindow:(UIWindow *)window
                         showCancelButton:(BOOL)showCancel
                                  success:(FZLoginSuccessBlock)success
                                  failure:(FZLoginFailureBlock)failure
                                   cancel:(FZLoginCancelBlock)cancel{
    [self showLoginViewControllerFromWindow:window showCancelButton:showCancel successEnvent:nil success:success failure:failure cancel:cancel];
}

- (void)showLoginViewControllerFromWindow:(UIWindow *)window
                         showCancelButton:(BOOL)showCancel
                            successEnvent:(FZLoginSuccessEventBlock)successEnvent
                                  success:(FZLoginSuccessBlock)success
                                  failure:(FZLoginFailureBlock)failure
                                   cancel:(FZLoginCancelBlock)cancel{
    self.loginSuccessBlock = success;
    self.loginFailureBlock = failure;
    self.loginCancelBlock = cancel;
    self.originWindow = window;
    
    WEAKSELF
    FZLoginViewController *viewController = [[FZLoginViewController alloc] initWithNibName:@"FZLoginViewController" bundle:nil];
    viewController.showCancelButton = showCancel;
    viewController.loginTip = self.loginTip;
    viewController.loginSuccessEventBlock = successEnvent;
    
    viewController.loginSuccessBlock = ^(void) {
        STRONGSELFFor(weakSelf)
        strongSelf.loginWindow.windowLevel = UIWindowLevelNormal;
        [strongSelf.originWindow makeKeyAndVisible];
        strongSelf.loginWindow = nil;
        [strongSelf didLoginSuccess];
    };
    
    viewController.loginCancelBlock = ^(void) {
        STRONGSELFFor(weakSelf)
        strongSelf.loginWindow.windowLevel = UIWindowLevelNormal;
        [strongSelf.originWindow makeKeyAndVisible];
        strongSelf.loginWindow = nil;
        if (strongSelf.loginCancelBlock) {
            strongSelf.loginCancelBlock();
        }

    };
    viewController.loginFailureBlock = ^(NSString *message) {
        STRONGSELFFor(weakSelf)
//        strongSelf.loginWindow.windowLevel = UIWindowLevelNormal;
//        [strongSelf.originWindow makeKeyAndVisible];
        [strongSelf didLoginFailure:message];
    };
    
    self.loginViewController = viewController;
    
    FZNavigationController *loginNavigationController = [[FZNavigationController alloc] initWithRootViewController:viewController];
//    window.rootViewController = loginNavigationController;
    self.loginWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.loginWindow.rootViewController = loginNavigationController;
    self.loginWindow.windowLevel = UIWindowLevelNormal + 1;
    [self.loginWindow makeKeyAndVisible];
}

#pragma mark --上传极光设备号


#pragma mark - QQ Login

//- (void)onQQLogin {
//    NSMutableArray *qqPermissions =[NSMutableArray arrayWithObjects:
//                                    kOPEN_PERMISSION_GET_USER_INFO,
//                                    kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
//                                    kOPEN_PERMISSION_ADD_ALBUM,
//                                    kOPEN_PERMISSION_ADD_IDOL,
//                                    kOPEN_PERMISSION_ADD_ONE_BLOG,
//                                    kOPEN_PERMISSION_GET_INFO,
//                                    kOPEN_PERMISSION_GET_OTHER_INFO,
//                                    kOPEN_PERMISSION_GET_REPOST_LIST,
//                                    kOPEN_PERMISSION_UPLOAD_PIC,
//                                    kOPEN_PERMISSION_GET_VIP_INFO,
//                                    kOPEN_PERMISSION_GET_VIP_RICH_INFO,
//                                    kOPEN_PERMISSION_GET_INTIMATE_FRIENDS_WEIBO,
//                                    kOPEN_PERMISSION_MATCH_NICK_TIPS_WEIBO,
//                                    nil];
//    self.tencentOAuth = [[TencentOAuth alloc] initWithAppId:kQQAPPID andDelegate:self];
//    [self.tencentOAuth authorize:qqPermissions inSafari:NO];
//}
//
//#pragma mark - TencentLoginDelegate
//
//- (void)tencentDidLogin {
//    // 登录成功
//    BOOL bSuccess = [self.tencentOAuth getUserInfo];
//    if (!bSuccess) {
//        [self didLoginFailure:nil];
//    } else {
//        [self showLoadingView];
//    }
//}
//
//- (void)tencentDidNotLogin:(BOOL)cancelled {
//    if (cancelled) {
//        [self didLoginFailure:LOCALSTRING(@"login_thirdCancelLoginTip")];
//    } else {
//        [self didLoginFailure:nil];
//    }
//}
//
//-(void)tencentDidNotNetWork {
//    [self didLoginFailure:nil];
//}
//
//-(void)tencentDidLogout {
//    
//}
//
////获取qq用户信息
//- (void)getUserInfoResponse:(APIResponse *)response {
//    if (response.retCode != 0) {
//        //获取失败
//        [self didLoginFailure:nil];
//        return;
//    }
//    
//    NSString *accessToken = self.tencentOAuth.accessToken;
//    NSDictionary *responseObject = response.jsonResponse;
//    
//    NSString *token = self.tencentOAuth.openId;
//    NSString *nickname = responseObject[@"nickname"];
//    NSString *avatar = responseObject[@"figureurl_qq_2"];
//    
//    NSString *sexString = responseObject[@"gender"];
//    NSString *sex = @"0";
//    if ([sexString isEqualToString:@"男"]) {
//        sex = @"1";
//    } else if ([sexString isEqualToString:@"女"]) {
//        sex = @"2";
//    }
//    
//    NSString *deviceToken = [self uniqID];
//    NSString *authURL = [NSString stringWithFormat:@"https://graph.qq.com/user/get_user_info?oauth_consumer_key=%@&access_token=%@&openid=%@&format=json", kQQAPPID, accessToken, token];
//    
//    NSMutableDictionary *params = [@{} mutableCopy];
//    [params setValue:token forKey:@"token"];
//    [params setValue:@(1) forKey:@"type"];
//    [params setValue:nickname forKey:@"nickname"];
//    [params setValue:avatar forKey:@"avatar"];
//    [params setValue:sex forKey:@"sex"];
//    [params setValue:deviceToken forKey:@"devicetoken"];
//    [params setValue:authURL forKey:@"auth_url"];
//    
//    [self thirdLoginWithParams:params];
//}
//
//- (void)isOnlineResponse:(NSDictionary *)response {
//    //qq在线状态
//}
//
//#pragma mark - SinaWeiboDelegate
//
//- (void)didReceiveWeiboResponse:(WBBaseResponse *)response {
//    if([response isKindOfClass:[WBSendMessageToWeiboResponse class]]){
//       //分享
//    }else if ([response isKindOfClass:[WBAuthorizeResponse class]]){
//        if(response.statusCode == WeiboSDKResponseStatusCodeSuccess){
//            //授权成功
//            WBAuthorizeResponse *authResponse = (WBAuthorizeResponse *)response;
//            NSString *accessToken = authResponse.accessToken;
//            NSString *openID = authResponse.userID;
//            
//            [self showLoadingView];
//            [self querySinaWeiboUserInfoWithAccessToken:accessToken openID:openID];
//        }else if (response.statusCode == WeiboSDKResponseStatusCodeUserCancel){
//            [self didLoginFailure:LOCALSTRING(@"login_thirdCancelLoginTip")];
//        } else {
//            [self didLoginFailure:nil];
//        }
//    }
//}
//
//- (void)didReceiveWeiboRequest:(WBBaseRequest *)request {
////    NSLog(@"收到微博请求");
//}
//
//- (void)querySinaWeiboUserInfoWithAccessToken:(NSString *)accessToken openID:(NSString *)openID {
//    //根据用户ID获取用户信息
//    NSString *requestString = [NSString stringWithFormat:@"https://api.weibo.com/2/users/show.json?uid=%@&access_token=%@", openID,accessToken];
//    WEAKSELF
//    [[FZHTTPRequestOperationManager manager] GET:requestString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        //获取accessToken 之后，需要获取用户信息
//        if (!responseObject) {
//            //错误
//            [weakSelf didLoginFailure:nil];
//        } else {
//            NSString *nickname = responseObject[@"name"];
//            NSString *avatar = responseObject[@"avatar_hd"];
//            
//            NSString *sexString = responseObject[@"gender"];
//            NSString *sex = @"0";
//            if ([sexString isEqualToString:@"f"]) {
//                sex = @"2";
//            } else if ([sexString isEqualToString:@"m"]){
//                sex = @"1";
//            }
//            
//            NSString *deviceToken = [weakSelf uniqID];
//            NSString *preWeiboID = [NSString stringWithFormat:@"funpeiyin%@", openID];
//            NSString *weiboID = [preWeiboID MD5Hash];
//            
//            NSMutableDictionary *params = [@{} mutableCopy];
//            [params setValue:weiboID forKey:@"token"];
//            [params setValue:@(2) forKey:@"type"];
//            [params setValue:nickname forKey:@"nickname"];
//            [params setValue:avatar forKey:@"avatar"];
//            [params setValue:sex forKey:@"sex"];
//            [params setValue:deviceToken forKey:@"devicetoken"];
//            [params setValue:requestString forKey:@"auth_url"];
//            
//            [weakSelf thirdLoginWithParams:params];
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [weakSelf didLoginFailure:nil];
//    }];
//}
//
//
////QQ 和 微信的回调方式一样
//#pragma mark - WXApiDelegate && QQApiInterfaceDelegate <NSObject>
//
///**
// 处理来至QQ的请求
// */
//- (void)onReq:(id )req {
//    if ([req isKindOfClass:[QQBaseReq class]]) {
//      //qq 回调
//    } else if ([req isKindOfClass:[BaseReq class]]) {
//        //微信回调
//    }
//}
//
///**
// 处理来至QQ的响应
// */
//- (void)onResp:(id )resp {
//    if ([resp isKindOfClass:[QQBaseResp class]]) {
//        //qq回调
//    } else if ([resp isKindOfClass:[SendAuthResp class]]) {
//        //微信登录
//        SendAuthResp *authResp = (SendAuthResp *)resp;
//        if (authResp.errCode == 0) {
//            //登录授权成功,然后可以获取用户信息
//            [self showLoadingView];
//            [self queryWeChatAccessTokenWithCode:authResp.code];
//        } else {
//            [self didLoginFailure:LOCALSTRING(@"login_thirdCancelLoginTip")];
//        }
//    }
//}
//
////1、通过code, 先获取accessToken；2、通过accessToken获取用户信息
//- (void)queryWeChatAccessTokenWithCode:(NSString *)code {
//    
//    WEAKSELF
//    NSString *requestString = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code", kWechatAPPKey, kWechatAPPSecret, code];
//    [[FZHTTPRequestOperationManager manager] GET:requestString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSString *errCode = responseObject[@"errcode"];
//        if (errCode && [errCode integerValue] > 0) {
//            //错误
//            [weakSelf didLoginFailure:responseObject[@"errmsg"]];
//        } else {
//            NSString *accessToken = responseObject[@"access_token"];
//            NSString *openID = responseObject[@"openid"];
//            [weakSelf queryWeChatUserInfoWithAccessToken:accessToken openID:openID];
//        }
// 
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [weakSelf  didLoginFailure:nil];
// 
//    } ];
//}
//
//- (void)queryWeChatUserInfoWithAccessToken:(NSString *)accessToken openID:(NSString *)openID {
//    WEAKSELF
//    NSString *requestString = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@", accessToken, openID];
//    
//    [[FZHTTPRequestOperationManager manager] GET:requestString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        //获取accessToken 之后，需要获取用户信息
//        NSString *errCode = responseObject[@"errcode"];
//        if (errCode && [errCode integerValue] > 0) {
//            //错误
//            [weakSelf didLoginFailure:responseObject[@"errmsg"]];
//        } else {
//            NSString *token = responseObject[@"openid"];
//            NSString *nickname = responseObject[@"nickname"];
//            NSString *avatar = responseObject[@"avatar"];
//            NSString *sex = responseObject[@"sex"];
//            NSString *deviceToken = [weakSelf uniqID];
//            NSString *authURL = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?qupeiyin=1&access_token=%@&openid=%@", accessToken, openID];
//            
//            NSMutableDictionary *params = [@{} mutableCopy];
//            [params setValue:token forKey:@"token"];
//            [params setValue:@(3) forKey:@"type"];
//            [params setValue:nickname forKey:@"nickname"];
//            [params setValue:avatar forKey:@"avatar"];
//            [params setValue:sex forKey:@"sex"];
//            [params setValue:deviceToken forKey:@"devicetoken"];
//            [params setValue:authURL forKey:@"auth_url"];
//            
//            [weakSelf thirdLoginWithParams:params];
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [weakSelf  didLoginFailure:nil];
//        
//    } ];
//}

#pragma mark - Private Method 

- (void)didLoginSuccess {
    [self.loginViewController stopProgressHUD];
    if (self.loginSuccessBlock) {
        self.loginSuccessBlock();
    }
}

- (void)didLoginFailure:(NSString *)message {
    [self.loginViewController stopProgressHUD];
    if (!message) {
        message = LOCALSTRING(@"login_loginFailureTip");
    }
    [self.loginViewController showHUDErrorMessage:message];
    
    if (self.loginFailureBlock) {
        self.loginFailureBlock(message);
    }
}

- (void)showLoadingView {
    [self.loginViewController startProgressHUDWithText:LOCALSTRING(@"login_loginLoadingTitle")];
}

- (void)thirdLoginWithParams:(NSDictionary *)params {
    WEAKSELF
    NSString *requestString = [[FZAPIGenerate sharedInstance] API:@"user_third_login"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:params];
    [self addDeviceInfoParameters:parameters];
    
//    FZHTTPRequestOperationManager *manager = [FZHTTPRequestOperationManager manager];
//    [manager POST:requestString needCache:NO parameters:parameters responseClass:nil success:^(NSInteger statusCode, NSString *message, id dataObject) {
//        if (statusCode == kFZRequestStatusCodeSuccess) {
//            [weakSelf updateUserInfo:dataObject];
//            if ([FZLoginUser mobile] && ![[FZLoginUser mobile] isEqualToString:@""]) {
//                [[FCVideoTalkSDKManager shareInstance] loadAVSDKConfigWithUid:[FZLoginUser userID] ucid:[FZLoginUser commonUId]];
//                [FCChatCache setCurrentAppUserID:[FZLoginUser userID]];
//            }
//            [weakSelf didLoginSuccess];
//        } else {
//            [weakSelf didLoginFailure:message];
//        }
//    } failure:^(id responseObject, NSError *error) {
//        [weakSelf didLoginFailure:nil];
//    }];
}


- (NSString *)uniqID {
    NSString* uniqueIdentifier = kUniqueIdentifier;
    return uniqueIdentifier;
}

- (void)addDeviceInfoParameters:(NSMutableDictionary *)parameters {
    NSMutableDictionary *deviceInfo = [NSMutableDictionary dictionary];
    [deviceInfo setValue:[FCUtil IDFA] forKey:@"idfa"];
    [deviceInfo setValue:[OpenUDID value] forKey:@"openudid"];
    
    NSString *deviceInfoJson = [deviceInfo JSONString];
    [parameters setValue:deviceInfoJson forKey:@"device_info"];
}

@end
