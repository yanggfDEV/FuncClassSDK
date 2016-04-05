//
//  FCJusTalkConfigHandler.h
//  Pods
//
//  Created by 刘滔 on 15/11/3.
//
//

// 设置所有需要的justalk逻辑需要的配置
// 注意：为了保证库的逻辑一致性，请勿添加客户端的判断方法，所有各个端的判断方法放到此类内部

#import <UIKit/UIKit.h>
#import "FZJusTalkConfig.h"
#import "zpios_osenv.h"
#import "FCVideoTalkProtocol.h"
//#import <MtcSessTimer.h>

typedef NS_ENUM(NSUInteger, KDJustalkIdType) {
    KDJustalkIdTypeStudent,
    KDJustalkIdTypeTeacher
};

@interface FCJusTalkConfigHandler : NSObject

// 判断是否打开Justalk探测 (当bHaveParam为YES时，为设置方法，当bHaveParam为NO时，为获取方法)
+ (BOOL)IsOpenCheckOnline:(NSString *)bOpenString isHaveInParam:(BOOL)bHaveParam;

// 根据端类型，获取justalk app key
+ (ZCHAR *)GetJustalkAppKeyWithProjectType:(kVideoTalkProjectType)projectType;

// 判断是否为有效的jid
+ (BOOL)IsValidJustalkID:(NSString *)justalkUid;

// 根据justalkUid获取Uid
+ (NSString *)GetUidWithJustalkID:(NSString *)justalkUid;

// 根据justalk uri获取Uid
+ (NSString *)GetUidWithJustalkUri:(NSString *)uri;

// 根据justalkUid获取UCID
+ (NSString *)GetUCIDWithJustalkID:(NSString *)justalkUid;

// 根据justalkUid获取ID前缀
+ (NSString *)GetIDPrefixWithJustalkID:(NSString *)justalkUid;

// 获取justalkID (uid：当前平台ID；ucid：全平台ID， idPrefix：各个平台前缀)
+ (NSString *)GetJustalkIDWithUid:(NSString *)uid ucid:(NSString *)ucid idPrefix:(NSString *)idPrefix;

+ (NSString *)GetJustalkIDWithUid:(NSString *)uid ucid:(NSString *)ucid idPrefix:(NSString *)idPrefix idType:(KDJustalkIdType)type;

// 获取justalkID (uid：当前平台ID；ucid：全平台ID)
+ (NSString *)GetJustalkIDWithUid:(NSString *)uid ucid:(NSString *)ucid;

+ (NSString *)GetJustalkIDWithUid:(NSString *)uid ucid:(NSString *)ucid idType:(KDJustalkIdType)type;

// 呼出方？
+ (BOOL)IsCallOutWithType:(kVideoTalkCallInOutType)callType;

// 接入方？
+ (BOOL)IsReceiveCallWithType:(kVideoTalkCallInOutType)callType;

// 中文?
+ (BOOL)IsChineseLanguage;

// 鉴权接口
+ (NSString *)SignCheckApi;

// 是否连接测试服务器
+ (BOOL)IsTestServer;

// 是否接收到来电埋点
+ (NSString *)NoticeReceiveCall;

// 弹评论的时长
+ (NSInteger)CommentSecondsWithCallType:(kVideoTalkCallInOutType)callType;

// 根据JustalkID获取服务器的会话ID
+ (NSString *)RequestUCallID;

// 获取通话结束的通话信息
+ (NSString *)RequestCallInfo;

// 默认头像名
+ (NSString *)DefaultHeadFileName;

// 弹时间不足提醒
+ (NSInteger)TalkWarnSeconds;

// 请求成功的status值
+ (BOOL)isRequestSuccessWithStatus:(NSInteger)status;

// 通话信息
+ (NSString *)RecordInfo;

// 通知服务器，老师不在线
+ (NSString *)TeacherOffline;

// 获取画笔颜色
+ (UIColor *)GetBrushColorWithCallType:(kVideoTalkCallInOutType)callType;

// 获取画笔宽度
+ (CGFloat)GetBrushLineWidthWithType:(kVideoTalkCallInOutType)callType;

@end
