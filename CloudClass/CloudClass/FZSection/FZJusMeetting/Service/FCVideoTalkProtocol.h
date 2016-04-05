//
//  FCVideoTalkProtocol.h
//  Pods
//
//  Created by 刘滔 on 15/9/19.
//
//

#ifndef Pods_FCVideoTalkProtocol_h
#define Pods_FCVideoTalkProtocol_h

@protocol FCVideoTalkLogicDelegate;

// 文字聊天面向UI逻辑的事件通知
#define kTextChatSendEventNotification @"kTextChatSendEventNotification"   // 发送文字事件通知
#define kTextChatRecvEventNotification @"kTextChatRecvEventNotification"  // 接收文字事件通知
#define kTextChatTalkNotification @"kTextChatTalkNotification"          // 点击视频文字聊天事件通知

#define KVideoSelectNotification @"KVideoSelectNotification"

#define KErrorWindowStatusChanged     @"KErrorWindowStatusChanged" 
//当对方摄像头状态发生变化时发出通知，进入IM页面调整页面起始点位置

#define kTextChatIntoVideoNotification @"kTextChatIntoVideoNotification"// 关闭文字聊天进入视频聊天
#define kTextChatPopTeacherInfoNotification @"kTextChatPopTeacherInfoNotification" //结束通话通知
#define kTextChatPressedSmallVideoWindowNotification                                                            @"kTextChatPressedSmallVideoWindowNotification"  // 文字聊天页面回到视频聊天页面
#define kJustalkInElseDeviceLoginNotification   @"kJustalkInElseDeviceLoginNotification"    
                                                // justalk检测到在其他设备登录

// 通知中包含的Key值
#define kTextChatStatusKey  @"kTextChatStatusKey"   // (NSNumber 对象) 对应 kChatMessageStatus 状态值
#define kTextChatMessageObjectKey   @"kTextChatMessageObjectKey"


// 视频页面跳转到充值页面
#define kVideoViewControllerGotoAliPay   @"kVideoViewControllerGotoAliPay"
#define kSuperViewControllerKey          @"kSuperViewControllerKey"
#define kSuperViewControllerSpeakerID    @"kSuperViewControllerSpeakerID" //当前对象的ID

#define kReceiveStudentCallNotification @"kReceiveStudentCallNotification"  // 收到来电通知

// 通话中进入微课页面显示小窗口发出的通知
#define kVideoTalkShowCameraOpenType         @"kVideoTalkShowCameraOpenType"
#define kVideoTalkShowCameraOpenKey          @"kVideoTalkShowCameraOpenKey"
#define kMicroCourseAboutCameraOffNotification @"kMicroCourseAboutCameraOffNotification"
//卡片播放时，如果对方视频关闭，发出通知



// 客户端属性
typedef NS_ENUM(NSUInteger, kVideoTalkProjectType) {
    kVideoTalkProjectTypeOfFunChatStudent,      // 老外趣聊学生端
    kVideoTalkProjectTypeOfFunChatTeacher,      // 老外趣聊老师端
    kVideoTalkProjectTypeOfQuPeiYing,   // 英语趣配英
    kVideoTalkProjectTypeOfShaoErQuPeiYing  // 少儿趣配音
};

// 通话中，端所属的状态（在呼出或接收时确定）
typedef NS_ENUM(NSUInteger, kVideoTalkCallInOutType) {
    kVideoTalkCallNoneType, // 非通话状态
    kVideoTalkCallOutType,  // 呼出方
    kVideoTalkReceiveCallType,  // 接收方
};

// AppDelegate中调用的系统方法类型（kApplication + 方法名 + Type）
typedef NS_ENUM(NSUInteger, kApplicationFunctionType) {
    kApplicationDidReceiveLocalNotificationType,
    kApplicationDidEnterBackgroundType,
    kApplicationWillEnterForegroundType,
    kApplicationDidBecomeActiveType,
    kApplicationDidReceiveRemoteNotificationType,
    kApplicationDidRegisterForRemoteNotificationsType,
    kApplicationDidFailToRegisterForRemoteNotificationsType,
};

// 通话请求各种状态type
typedef NS_ENUM(NSUInteger, kVideoTalkActionType) {
    kLoginSuccessType,       // 登录成功
    kWillCallingType,       // 发起呼叫
    kReceiveCallingType,    // 收到呼叫
    kBackgroundReceiveCallingType,    // 后台收到呼叫
    kDoingCallingType,      // 呼叫中
    kDoingVideoTalkType,    // 通话中
    kDoingCloseType,        // 正在关闭
    kDidCloseType,          // 已经关闭通话
    kDidLogOutType,         // 登出
    kLoginTimeOutType,      // 登录超时
};

typedef NS_ENUM(NSUInteger, kVideoTalkUserEventType) {
    kVideoTalkPressedCloseBtnType,  // 用户点击关闭通话按钮
    kVideoTalkPressedReportBtnType, // 用户点击举报按钮
   // kVideoTalkPressedToTopUpType,  //学生端用户去充值
    kVideoTalkViewDismiss,       // 通话界面消失
    kVideoTalkWillDismiss,       //通话界面即将消失
};

typedef NS_ENUM(NSUInteger, kVideoTalkOtherPartyEventType) {//对方动作
    kVideoTalkPressedCallCloseBtnType,  // 对方点击关闭通话按钮
    kVideoTalkCallOverTimeType, // 对方通话超时挂断
};

//通话中双方摄像头开启情况
typedef NS_ENUM(NSUInteger, kVideoTalkCameraOpenType){
    kVideoTalkBothCameraOpen  =0,//均开启
    kVideoTalkBothCameraClose,//均关闭
    kVideoTalkOtherCameraOpen,  //对方开启
    kVideoTalkSelfCameraOpen, //自己开启
};

//通话阶段状态
typedef NS_ENUM(NSUInteger, kVideoTalkCallActionType) {
    kCallingActionType, //发起呼叫
    kRecvingActionType, // 收到呼叫
    kConnectingActionType, //连接中
    kAnsweringActionType, //answer
    kTalkingActionType,  // 通话中
    kDeclineActionType,  //挂断
    kTermActionType,
    kOutgoingActionType,
    kAlteredActionType,
};

extern id<FCVideoTalkLogicDelegate> MtcUILogicDelegateClass();

@class FCUserTalkTransferModel;
@protocol FCVideoTalkLogicDelegate <NSObject>

//- (void)showText:(NSString *)text;
- (void)sendUserExtraMessage:(unsigned int)dwSessId;
- (void)didReceiveTalkActionType:(kVideoTalkActionType)type userInfo:(NSDictionary *)userInfo error:(NSError *)err;
- (void)didReceiveUserEventType:(kVideoTalkUserEventType)type userInfo:(NSDictionary *)userInfo error:(NSError *)err;
- (FCUserTalkTransferModel *)GetExtraUserMessage;
- (void)showTermTip:(kVideoTalkOtherPartyEventType)eventType;
// 上传日志
- (void)uploadJustalkLog:(NSString *)memo;

// 获取当前呼叫方类型
- (kVideoTalkCallInOutType) GetCurrentCallType;

@end

#endif
