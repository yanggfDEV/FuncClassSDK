//
//  FZJusMeettingSDKManager.m
//  CloudClass
//
//  Created by guangfu yang on 16/1/31.
//  Copyright © 2016年 yangguangfu. All rights reserved.
//

#import "FZJusMeettingSDKManager.h"
#import "FZJusMeettingConfigHandler.h"
#import "FZJusMeettingService.h"
#import "FZJusMeettingSignModel.h"
#import "FCTextChatManager.h"

#import "AppDelegate.h"

#include "rsa.h"
#include "evp.h"
#include "objects.h"
#include "x509.h"
#include "err.h"
#include "pem.h"
#include "ssl.h"

#define AuthNonce "AuthNonce"
#define AuthID "AuthID"

@interface FZJusMeettingSDKManager ()<MtcLoginDelegate>
@property (nonatomic, strong) FZJusMeettingService *service;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) FCTextChatManager *textChatManager;
@property (nonatomic, assign) BOOL hasLoginJustalk;
@end

@implementation FZJusMeettingSDKManager
{
    NSString *_confTitle;
    BOOL _isVideo;
}

+ (FZJusMeettingSDKManager *)shareInstance {
    static FZJusMeettingSDKManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[FZJusMeettingSDKManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [MtcLoginManager Set:self];
        [self addNotifications];
        self.hasLoginJustalk = NO;
        self.service = [[FZJusMeettingService alloc] init];
        self.textChatManager = [[FCTextChatManager alloc] init];
    }
    return self;
}

- (void)addNotifications {
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(loginOk) name:@MtcLoginOkNotification object:nil];
    [notificationCenter addObserver:self selector:@selector(loginedFailed:) name:@MtcLoginDidFailNotification object:nil];
    [notificationCenter addObserver:self selector:@selector(didLogout) name:@MtcDidLogoutNotification object:nil];
    [notificationCenter addObserver:self selector:@selector(logouted) name:@MtcLogoutedNotification object:nil];
}

- (void)jusMeettingSDKLogin:(NSString *)uid passWD:(NSString *)passWD development:(BOOL)development {
    NSString *stdUid = [NSString stringWithFormat:@"%@",uid];
    self.uid = stdUid;
    NSString *stdPassWD = [NSString stringWithFormat:@"%@",passWD];
    if (!stdUid || [stdUid isEqualToString:@""] ||
        !stdPassWD || [stdPassWD isEqualToString:@""]) {
        return;
    }
    if (![FZLoginUser userID]) {
        return;
    }
    if ([MtcLoginManager Login:[FZJusMeettingConfigHandler getJusMeettingIDWithUid:stdUid] password:stdPassWD server:[FZJusMeettingConfigHandler getJusMeettingServer:kAPITestMode]] == ZOK) {
        NSLog(@"justalk登录成功");
    } else {
        NSLog(@"justalk登录失败");
    }
}

- (void)retryloginWithCode:(NSString *)account withNonce:(NSString *)nonce {
    [self.service getJusMeettingSign:account nonce:nonce success:^(NSInteger statusCode, NSString *message, id dataObject) {
        if (statusCode == kFZRequestStatusCodeSuccess) {
            FZJusMeettingSignModel *model = dataObject;
            [MtcLoginManager PromptAuthCode:model.justalk_tls];
        }
    } failure:^(id responseObject, NSError *error) {
        
    }];
}

#pragma mark ----justalk是否登录成功------
- (BOOL)getHasLoginJustalk {
    return self.hasLoginJustalk;
}

#pragma mark - Notification callbacks
- (void)loginedFailed:(NSNotification *)notification {
    ZUINT dwStatusCode = [[notification.userInfo objectForKey:@MtcCliStatusCodeKey] unsignedIntValue];
    NSLog(@"====>>loginFailed,%u",dwStatusCode);
    NSLog(@"justalk登录失败");
    NSLog(@"%@", notification.object);
    self.hasLoginJustalk = NO;
    if (self.jusDelegate && [self.jusDelegate respondsToSelector:@selector(jusMettingLoginfail)]) {
        [self.jusDelegate jusMettingLoginfail];
    }
 }

//登录成功
- (void)loginOk {
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    [delegate registerForRemoteNotifications];
     NSLog(@"justalk登录成功");
    self.hasLoginJustalk = YES;
    if (self.jusDelegate && [self.jusDelegate respondsToSelector:@selector(jusMettingLoginSuccess)]) {
        [self.jusDelegate jusMettingLoginSuccess];
    }
}


//登录过期
- (void)logouted {
    if ([FZLoginUser mobile]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kPostLogoutNotification" object:nil userInfo:nil];
    }
    self.hasLoginJustalk = NO;
}

//登录失败
- (void)loginFailed:(NSInteger)reason {
    
}

- (void)didLogout {
    
}

- (void)authRequire:(NSString *)account withNonce:(NSString *)nonce {
    [self retryloginWithCode:account withNonce:nonce];
}

- (void)queryLoginInfoOk:(NSString *)user
                  status:(NSString *)status
                    date:(NSDate *)date
                   brand:(NSString *)brand
                   model:(NSString *)model
                 version:(NSString *)version
              appVersion:(NSString *)appVersion
{
    
}

- (void)queryLoginInfoFailed:(NSInteger)reason {
    NSString *showMsg;
    switch (reason) {
        case 0:
            showMsg = @"Query Failed Reason:User Not Found.";
            break;
        default:
            showMsg = @"Query Failed Reason:No Property.";
            break;
    }
}

- (void)jusMeettingSDKLogout {
    [MtcLoginManager Logout];
}

- (void)jusMeettingqueryLoginInfo:(NSString *)user {
    if (!user || [user isEqualToString:@""]) {
        return;
    }
    ZINT ret = [MtcLoginManager QueryLoginInfo:user];
    if (ret == ZFAILED) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Query failed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
    }
}

- (void)jusStartDoodle {
    [MtcDoodleManager StartDoodle:[MtcMeetingManager getMeetingId] pageCount:9];
}

- (void)jusJoinMeeting:(NSString *)confNumber dispName:(NSString *)dispName password:(NSString *)password {
    [MtcMeetingManager queryMeeting:confNumber displayName:dispName password:password];
}
// 发送文字
- (void)sendText:(NSString *)text extraModel:(FCUserTextExtraModel *)extraModel {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self.textChatManager sendText:text extraModel:extraModel];
    });
}

// 发送图片
- (void)sendPicture:(UIImage *)image extraModel:(FCUserTextExtraModel *)extraModel {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self.textChatManager sendPicture:image extraModel:extraModel];
    });
}

@end
