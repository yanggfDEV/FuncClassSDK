//
//  FCChatMessageModel.h
//  FunChatStudent
//
//  Created by 刘滔 on 15/10/9.
//  Copyright (c) 2015年 Feizhu Tech. All rights reserved.
//

// 【注意】数据模型与数据库key对应，不可随便添加成员

#import <Realm/Realm.h>

static NSString *kChatMessageListRealmName = @"chatMessageListDB";
static NSInteger kChatMessageListRealmVersion = 7;

#define kPicMessageCacheDirPath  [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"/.picmessage/"]    // 图片缓存路径
#define kPicMessageThumbnailName @"thumbnail_%@"    // 缩略缓存名称格式
#define kPicMessageOriginName @"origin_%@"          // 原图缓存名称格式

// 消息类型
typedef NS_ENUM(NSUInteger, kChatMessageType) {
    kChatMessageTypeOfText = 1, // 文本消息
    kChatMessageTypeOfPic,  // 图片消息
    kChatMessageTypeOfVideo,    // 通话消息
    kChatMessageTypeOfInputCache,    // 输入后未发送的消息
    kDocumentSharing, //涂鸦消息
    KVideoSelect,//视频选择消息
};

// 文字发送状态
typedef NS_ENUM(NSUInteger, kChatMessageStatus) {
    kChatMessageCreate = 0,     // 消息创建完成
    kChatMessageSuccess,    // 接收/发送 成功
    kChatMessageFailed,     // 接收/发送 失败
    kChatMessageProgress,   // 接收/发送 中
    kChatFileProgress,   // 接收/发送 文件 中
    kChatFileSuccess,       // 接收/发送 文件 成功
    kChatFileFailed,        // 接收/发送 文件 失败
};

@interface FCChatMessageModel : RLMObject<NSCopying>

/*
 *  每次修改和添加成员，kChatMessageListRealmVersion + 1
 */

@property NSInteger timestamp;      // 消息创建的时间戳（每条消息的时间戳不同，可用于排序）
@property NSString *userID;     // 聊天人的userID
@property NSString *userUCID;     // 聊天人的userUCID
@property BOOL  isMy;   // 自己发送的消息？
@property NSInteger messageType;    // 消息类型 （kChatMessageType）
@property NSString *content;    // 消息内容
@property BOOL isFailed;   // (发送/接收) 失败
@property NSString *messageDate;    // 消息 (发送/接收) 时间
@property NSString *messagePicFileName; // 图片路径
@property NSInteger messageStutus;  // 消息发送状态 （kChatMessageStatus）
@property NSString *targetIDPrefix; // 消息前缀,消息来至于哪个平台

- (void)judgeNull;

- (NSString *)thumbnailPicPath;
- (NSString *)originPicPath;
// 旧版本兼容处理
- (void)handlerCompatible;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<FCChatMessageModel>
RLM_ARRAY_TYPE(FCChatMessageModel)
