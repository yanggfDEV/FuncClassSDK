//
//  PublicMacros.h
//  EnglishTalk
//  Created by DING FENG on 6/7/14.
//  Copyright (c) 2014 ishowtalk. All rights reserved.
#define DocumentsDirectory [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) lastObject]
#define TemporaryDirectory  NSTemporaryDirectory()
#define CachesDirectory    [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES) lastObject]

//http://112.124.25.25:8081         //测试
//http://peiyin.ishowedu.com        //生产  http://115.29.250.230:8085


#define ImgServerIp  [FZLoginUser imageURL]
#define ChatMediaSourcerIp  [FZLoginUser messageLogURL]
//聊天文件上传七牛token
#define  ishowDubbingAppVersion  APPVersion //@"3.21"
//2.2   主要:域名  iOS8 bug（不能配音时间问题！）；
// yyyy-MM-dd hh:mm:ss,SSS      hh erro---->  yyyy-MM-dd HH:mm:ss,SSS
#define RAND_FROM_TO(min, max) (min + arc4random_uniform(max - min + 1))
//com.ishowtalk.dubbing
// 消息中心 即时消息  通知
#define Notice_Tag_pageCancelLogin @"Notice_Tag_pageCancelLogin"
#define Notice_Tag_messageNoticeShouldUpdate    @"Notice_Tag_messageNoticeShouldUpdate"
#define Notice_Tag_gotyeSearchTargetUser        @"Notice_Tag_gotyeSearchTargetUser"
#define Notice_Tag_resentMessage        @"Notice_Tag_resentMessage"
#define Notice_Tag_deleteMessage        @"Notice_Tag_deleteMessage"
#define Notice_Tag_MessageShouldSend      @"Notice_Tag_MessageShouldSend"
#define Notice_Tag_PushToUserSpace      @"Notice_Tag_PushToUserSpace"
#define Notice_Tag_AddFansNum     @"Notice_Tag_AddFansNum"
#define Notice_Tag_AddVisitorNum      @"Notice_Tag_AddVisitorNum"
#define Notice_Tag_RecieveComment   @"Notice_Tag_RecieveComment"
#define Notice_Tag_AddMessageNum    @"Notice_Tag_AddMessageNum"
#define Notice_Tag_ApplyForTeacherSuccess @"Notice_Tag_ApplyForTeacherSuccess"
#define Notice_Tag_TeacherOnline @"Notice_Tag_TeacherOnline"
#define Notice_Tag_TeacherOffline @"Notice_Tag_TeacherOffline"

#define Notice_Tag_DBmanager_dataBaseUpdated      @"Notice_Tag_DBmanager_dataBaseUpdated"
#define Notice_Tag_DBmanager_dataBaseUpdated      @"Notice_Tag_DBmanager_dataBaseUpdated"
#define Notice_Tag_AddM    @"Notice_Tag_AddMessageNum"


#define Notice_Tag_UnreadCallRecord @"Notice_Tag_UnreadCallRecord"
#define Notice_Called_Cancel @"Notice_Called_Cancel"

#define Notice_Tag_DeleteGroup @"Notice_Tag_DeleteGroup"
#define Notice_Tag_GroupInfoChanged @"Notice_Tag_GroupInfoChanged"

#define Notice_Login_Cancel @"FZLoginCancelNotification"
#define Notice_Register_Success @"FZRegisterSuccessNotification"
#define Notice_thirdPortyLogin_Success @"FZThirdPortyLoginSuccessNotification"

//#define Notice_Tag_SendMessageToTheGroupMyShow      @"Notice_Tag_SendMessageToTheGroupMyShow"

//登出消息 通知
#define Notice_message_force_logout @"Notice_message_force_logout"
#define Notice_select_video @"Notice_select_video"
// 消息中心 即时消息  通知  +群组聊天功能添加的

#define Notice_DB_groupChat_dataBaseUpdate        @"Notice_DB_groupChat_dataBaseUpdate"
#define Notice_DB_groupChat_dataBaseUpdate_audioMessageReadStadus        @"Notice_DB_groupChat_dataBaseUpdate_audioMessageReadStadus"



#define Notice_messageTaped  @"Notice_messageTaped"

//趣课堂视频聊天
#define Notice_Tag_IsReachable @"Notice_Tag_IsReachable"
#define Notice_Tag_IsReachEnable @"Notice_Tag_IsReachEnable"

// 专区
#define Notice_Tag_DeleteClass @"Notice_Tag_DeleteClass"
#define Notice_Tag_DeleteHomework_Succuss @"Notice_Tag_DeleteHomework_Succuss"
#define Notice_Tag_SubmitVideo_Succuss @"Notice_Tag_SubmitVideo_Succuss"

//message type
#define MessageType_ChatIMMessage @"MessageType_ChatIMMessage"
#define MessageType_ChatIMMessage_GotyeMessageTypeText @"MessageType_ChatIMMessage_GotyeMessageTypeText"
#define MessageType_LikedTap @"MessageType_LikedTap"
#define MessageType_SystermMessage @"MessageType_SystermMessage"
#define  DefaultAvatarUrl  @"http://pic.ishowedu.com:8083/Uploads/Picture/avatar_default.png"

/*sql数据表结构
 
 表1:
 NSDictionary *d = @{@"id":@"",@"fromId":message.sender.name,@"toId":message.receiver.name,@"timeStamp":timestampStr,@"type":messageType,@"content":message.text,@"attach0":messageStatus,@"attach1":@"",@"attach2":@"attach2",@"attach3":@"attach3"};
 attach0   :消息发送状态
 attach1   :此条消息的hash
 attach2   :此条消息的已读状态  NO  未读   / YES 已读
 attach3   :

 表2：
 CREATE TABLE messageTable_V2(id integer primary key, fromId text, toId text, timeStamp text, type text, content text, sendStadus text, checkSum text, readStadus text, attach0 text, attach1 text, attach2 text, attach3 text);     

  */
//  some  little  string
//语音聊天文件的前缀   ie  :AudioMessageHash4ad44970f7c5ea9e8ce34408d6a5e491.aac
#define  AudioMessageHash      @"AudioMessageHash"
//userdefalt 里面存了大量东西  为了相对显性了解  每个key 应该设置为宏字符串比较好

#define CurrentVersionSucceedComposeTimes  @"CurrentVersionSucceedComposeTimes"
#define CurrentUnfinishedDubbing  @"CurrentUnfinishedDubbing"
#define CurrentUnfinishedDubbing_forNextLaunch  @"CurrentUnfinishedDubbing_forNextLaunch"
#define Userdefalt_key_localGroupsArray  @"Userdefalt_key_localGroupsArray"
#define Userdefalt_key_localUnreadMessageNum  @"Userdefalt_key_localUnreadMessageNum"
#define Userdefalt_key_groupMessageDraft  @"Userdefalt_key_groupMessageDraft"
#define Userdefalt_key_TimeStamp_LastTimeGetOfflineMessage  @"Userdefalt_key_TimeStamp_LastTimeGetOfflineMessage"
#define UserDefualt_Key_FirstInstall @"UserDefualt_Key_FirstInstall"



#ifdef DEBUG
# define FZLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ## __VA_ARGS__);
#else
#define FZLog(fmt, ...)
#endif

//by ww
#define ESWeak(var, weakVar) __weak __typeof(&*var) weakVar = var
#define ESStrong_DoNotCheckNil(weakVar, _var) __typeof(&*weakVar) _var = weakVar
#define ESStrong(weakVar, _var) ESStrong_DoNotCheckNil(weakVar, _var); if (!_var) return;

#define ESWeak_(var) ESWeak(var, weak_##var);
#define ESStrong_(var) ESStrong(weak_##var, _##var);

/** defines a weak `self` named `__weakSelf` */
#define ESWeakSelf      ESWeak(self, __weakSelf);
/** defines a strong `self` named `_self` from `__weakSelf` */
#define ESStrongSelf    ESStrong(__weakSelf, _self);

//视频 比例  ScreenRatio 16/9  1.777777777

#define  VideoScreenRatio     1.777777777


//  infoRemind     关闭声音:1


//git  test  by  dingfeng
//develop_b_dingfeng  branch  test  by  dingfeng


#define OnePX (1.0f / [UIScreen mainScreen].scale)


#define DubbingCacheDir  @"recordedAudio"
#define DubbingDocumentsDir [NSString stringWithFormat:@"%@/recordedAudio", [FZLoginUser userID]] 

#define SAClassMessageKey [NSString stringWithFormat:@"sa_notification_%@", [FZLoginUser userID]]
//切换线下线上
#define kAPITestMode   [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"APITestMode"] boolValue]
#define kSendSeccodeInterval 60

static NSString *appKey = @"0939eb542a294d9ab9121938";
static NSString *channel = @"Publish channel";
static BOOL isProduction = FALSE;




