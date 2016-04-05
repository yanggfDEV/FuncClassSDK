//
//  FCChatCache.h
//  FunChatStudent
//
//  Created by 刘滔 on 15/10/8.
//  Copyright (c) 2015年 Feizhu Tech. All rights reserved.
//

// 文字聊天数据缓存类

#import <Foundation/Foundation.h>
#import "FCChatWindowModel.h"
#import "FCChatMessageModel.h"

static NSInteger kDefaultChatMessageCount = 50;     // 聊天内容默认一次加载的消息数量

@interface FCChatCache : NSObject

// 设置当前App用户ID (切换账号使用)
+ (void)setCurrentAppUserID:(NSString *)userID;

// 设置当前文字聊天聊天页面UserID
+ (void)setCurrentTextChatTargetUserID:(NSString *)targetUserID;

// 获取当前正在文字聊天页面的
+ (NSString *)currentTextChatTargetUserID;

// 设置头像url前缀
+ (void)setHeadPicPathPrefix:(NSString *)prefixPath;





// 获取头像url前缀
+ (NSString *)headPicPathPrefix;

/***************** 会话列表 *******************/
// 获取会话列表
+ (NSArray *)chatList;

// 添加一条会话记录
+ (void)addOrUpdateChatWindow:(FCChatWindowModel *)windowModel;

// 添加一条会话记录(不记录未读消息数)
+ (void)addChatWindowCleanNoReadCount:(FCChatWindowModel *)windowModel;

// 根据userID获取windowModel
+ (FCChatWindowModel *)fetchChatWindowWithUserID:(NSString *)userID;

// 判断缓存是否包含userID的会话
+ (BOOL)isHaveChatWindowCacheWithUserID:(NSString *)userID;

// 删除一条会话记录
+ (void)deleteChatWindow:(NSString *)userID;

// 清空未读消息数
+ (void)cleanNoReadCountWithUserID:(NSString *)userID;

// 获取未读消息数
+ (NSInteger)getNoReadCountWithUserID:(NSString *)userID;

// 获取所有的未读消息数
+ (NSInteger)allNoReadCount;

// 获取所有的外教的未读消息数
+ (NSInteger)allNoForeignReadCount;

/***************** 聊天详情 *******************/
// 获取用户聊天内容 （进入聊天页时调用）
+ (NSArray *)chatContentWithUserID:(NSString *)userID;

// 根据用户ID获取聊天内容 （用户下拉刷新聊天内容时调用）
+ (NSArray *)chatContentWithUserID:(NSString *)userID pageCount:(NSInteger)count;

// 添加一条聊天消息
+ (void)addOrUpdateChatMessage:(FCChatMessageModel *)messageModel;

// 删除一条聊天消息
+ (void)deleteChatMessage:(FCChatMessageModel *)messageModel;

// 获取缓存消息所有图片
+ (NSArray *)allMessagePics:(NSString *)userID;

// 输入窗口未发送的文字
+ (NSString *)inputCacheTextWithUserID:(NSString *)userID;

// 缓存兼容
+ (void)handlerCacheCompatible;

@end
