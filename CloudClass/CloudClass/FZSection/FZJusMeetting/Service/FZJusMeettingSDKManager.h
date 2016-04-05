//
//  FZJusMeettingSDKManager.h
//  CloudClass
//
//  Created by guangfu yang on 16/1/31.
//  Copyright © 2016年 yangguangfu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <JusLogin/MtcLoginDelegate.h>
#import "FCUserTalkTransferModel.h"

@protocol FZJusMeetingSDKDelegate <NSObject>

- (void)jusMettingLoginSuccess;
- (void)jusMettingLoginfail;

@end

@interface FZJusMeettingSDKManager : NSObject 
 
+ (FZJusMeettingSDKManager *)shareInstance;
@property (nonatomic, weak) id<FZJusMeetingSDKDelegate> jusDelegate;

//登录
/**
 *
 * development是是否为开发环境和发布环境的配置
 **/
- (void)jusMeettingSDKLogin:(NSString *)uid passWD:(NSString *)passWD development:(BOOL)development;

//退出
- (void)jusMeettingSDKLogout;

//提交queryLoginInfo
- (void)jusMeettingqueryLoginInfo:(NSString *)user;

//startDoodle
- (void)jusStartDoodle;

//joinMeeting
- (void)jusJoinMeeting:(NSString *)confNumber dispName:(NSString *)dispName password:(NSString *)password;
// 发送文字
- (void)sendText:(NSString *)text extraModel:(FCUserTextExtraModel *)extraModel;

// 发送图片
- (void)sendPicture:(UIImage *)image extraModel:(FCUserTextExtraModel *)extraModel;

/**
 * @guangfu yang, 16-3-23
 * justalk登录失败问题
 *
 **/
- (BOOL)getHasLoginJustalk;
////startMeeting
//+ (void)jusStartMeetting:(NSString *)user dispName:(NSString *)dispName;


@end
