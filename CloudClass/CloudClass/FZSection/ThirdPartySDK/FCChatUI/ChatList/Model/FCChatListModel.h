//
//  FCChatListModel.h
//  FunChat
//
//  Created by Jyh on 15/10/10.
//  Copyright © 2015年 FeiZhu Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FCChatListModel : NSObject


// 用户ID
@property (copy, nonatomic) NSString *myUId;

// 用户UCID
@property (copy, nonatomic) NSString *myUCID;

/**
 *  头像地址 NSString类型
 */
@property (copy, nonatomic) NSString *myAvatarUrl;

/**
 *  昵称
 */
@property (copy, nonatomic) NSString *myNickname;

// 消息列表数据
@property (copy, nonatomic) NSMutableArray  *messageList;

// 用户ID
@property (copy, nonatomic) NSString *targetUId;
@property (copy, nonatomic) NSString *targetUcid;
@property (copy, nonatomic) NSString *targetIDPrefix;

/**
 *  头像地址 NSString类型
 */
@property (copy, nonatomic) NSString *targetAvatarUrl;

/**
 *  头像本地Image 用于设置系统消息头像
 */
@property (copy, nonatomic) NSString *targetAvatarImageName;

/**
 *  昵称
 */
@property (copy, nonatomic) NSString *targetNickname;

/**
 *  最新消息 NSString类型
 */
@property (copy, nonatomic) NSString *subContent;

/**
 *  时间
 */
@property (nonatomic) NSInteger time;

/**
 *  未读消息数
 */
@property (copy, nonatomic) NSString *messageCount;

// 通话剩余时间
@property (assign, nonatomic) NSInteger restTime;
@property (assign, nonatomic) NSInteger restPackageTime;//剩余套餐时间

// 课程名称
@property (strong, nonatomic) NSString *courseName;
@property (strong, nonatomic) NSString *courseName_En;
@property (strong, nonatomic) NSString *titleName;
@property (strong, nonatomic) NSString *titleName_En;

@property (strong, nonatomic) NSString *courseID;

@property (strong, nonatomic) NSString *courseDownloadUrl;

// 卡片图片路径
@property (strong, nonatomic) NSArray *cardImagePaths;

- (NSString *)unitePlatformID;

@end
