//
//  FCChatWindowModel.h
//  FunChatStudent
//
//  Created by 刘滔 on 15/10/9.
//  Copyright (c) 2015年 Feizhu Tech. All rights reserved.
//

// 【注意】数据模型与数据库key对应，不可随便添加成员

#import <Realm/Realm.h>

// 会话窗口和内容详情db名称
static NSString *kChatWindowListRealmName = @"chatWindowListDB";

// realm版本号，当数据模型的成员改变时，修改此版本号，系统将在启动时检测是否需要进行数据迁移
static NSInteger kChatWindowListRealmVersion = 6;

@interface FCChatWindowModel : RLMObject <NSCopying>

/*
 *  每次修改和添加成员，kChatMessageListRealmVersion + 1
 */

@property NSString *userID;             // 用户ID
@property NSString *userUCID;             // 用户UCID
@property NSString *userName;           // 用户名
@property NSString *headPicPath;        // 头像路径
@property NSInteger noReadCount;        // 未读数
@property NSString *recentMessageDate;    // 最近一条消息的时间
@property NSString *recentMessageContent;   // 最近一条消息内容
@property NSInteger timestamp;      // 会话window最近一条消息的时间戳（可用于排序）
@property NSString *targetIDPrefix; // 消息前缀,消息来至于哪个平台

// 老师信息
@property NSString *countryChstr;
@property NSString *star;
@property NSString *levelName;
@property NSString *price;
@property NSInteger sex;
@property NSString *isCollect;

- (void)judgeNull;
- (void)updateModel:(FCChatWindowModel *)model;
- (BOOL)isHaveUserInfo;
// 旧版本兼容处理
- (void)handlerCompatible;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<FCChatWindowModel>
RLM_ARRAY_TYPE(FCChatWindowModel)
