//
//  FZCommonHeader.h
//  EnglishTalk
//
//  Created by CyonLeuPro on 15/5/21.
//  Copyright (c) 2015年 ishowtalk. All rights reserved.
//

#ifndef EnglishTalk_FZCommonHeader_h
#define EnglishTalk_FZCommonHeader_h

#import <SDWebImage/UIImageView+WebCache.h>
#import "UIViewController+ActionSheet.h"
#import <FZNetWorkManager.h>
#import "FZStyleSheet.h"

#define CALLORTALKINGCANCEL @"CallOrTalkingCancel"
#define APPVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define APPBuilderVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
#define kUmengAPPKey @"56d4fcfd67e58ea31c00170c"
//#define ServerIP @"http://112.124.25.25:8081"
#define ServerIP @"http://child.qupeiyin.cn"

// AppStore id
#define APPSTOREAPPID @"1017181218"
#define APPSTOREURL @"https://itunes.apple.com/app/id1017181218"
#define WEAKSELF typeof(self) __weak weakSelf = self;


//新浪微博的appKey
#define kSinaAppKey @"3797555578"
#define kSinaAPPSecret @"7e4dbc19f20bd64b62310b85eafa8cfb"
#define kSinaAPPURL @"https://api.weibo.com/oauth2/default.html"

//QQ APPKey
#define kQQAPPID @"1104670989"
#define kQQAPPKey @"aEJyOGJ9FxD0YUYi"

/**
 *  友盟appkey
 */
#define kUmengAPPKey @"56ebb9b767e58e9d31000a45"
#define USER_SETTING_FLAG_1  @"USER_SETTING_FLAG_1"   //为用户获取通讯录
#define OSVERSION [[UIDevice currentDevice].systemVersion intValue]

/**
 *  微信appkey
 */

#define kWechatAPPKey @"wxa12880c55537ecb0"
#define kWechatAPPSecret @"0f7f7e8d7ef6aebcddc07137bc73a695"

#define kGotyeAPPKey @"5bb39d2a-3dc8-46cf-a9aa-5a18832004b6"


#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


//视觉设计稿是 720p的则自动转换该值
#define PX_MARK_TO_REAL(x) ((x)/(640.0/320.0))
#define P2P(x) (PX_MARK_TO_REAL(x))
#define RP2P(x) (round(P2P(x)))

#define SCREEN_WIDTH (CGRectGetWidth([UIScreen mainScreen].bounds))
#define SCREEN_HEIGHT (CGRectGetHeight([UIScreen mainScreen].bounds))
// 根据标注稿等比计算对应的point值。标注稿宽度为720，所以 实际值 = 标注值 * 屏幕宽度 / 720.0 。
// 以下三个宏是等价关系
#define PX_TO_SCREENWIDTH(x) ((x)*(CGRectGetWidth([UIScreen mainScreen].bounds)/640.0))
#define PX_MARK_TO_REAL_SCREEN_SIZE(x) (PX_TO_SCREENWIDTH(x))
#define P2PSZ(x) (PX_MARK_TO_REAL_SCREEN_SIZE(x))
// 这个宏是对上述结果取四舍五入得到的，可能用于不接受任意浮点值的场合
#define RP2PSZ(x) (round(P2PSZ(x)))


// make weak object
#define fzweak(x, weakX) try{}@finally{}; __weak __typeof(x) weakX = x;
#define WEAKSELF typeof(self) __weak weakSelf = self;
#define STRONGSELF typeof(self) __strong strongSelf = self;

#define STRONGSELFFor(object) typeof(object) __strong strongSelf = object;

// singleton
#define singleton(x) property(strong, nonatomic) id __singletonInfo; \
    + (instancetype)x;\
    - (instancetype)init __attribute__((unavailable("use class method \"+ (instancetype)"#x"\" instead"))); \
    + (instancetype)new __attribute__((unavailable("use class method \"+ (instancetype)"#x"\" instead")));

#define singletonImp(x) dynamic __singletonInfo; \
    + (instancetype)x { \
    static id x; \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
    x = [[self alloc] init]; \
    }); \
    return x; \
    }

#define kFZRequestStatusCodeSuccess 1
#define kFZRequestStatusCodeError 0
#define kFZRequestStatusCodeNotLogin 403

#define kFZRequestStatusExpCodeError 10004


#define kUniqueIdentifier ([[[UIDevice currentDevice] identifierForVendor] UUIDString])

#endif
