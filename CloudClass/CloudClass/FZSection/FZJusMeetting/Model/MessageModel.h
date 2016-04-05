//
//  MessageModel.h
//  CloudSample
//
//  Created by Fiona on 7/14/15.
//  Copyright (c) 2015 young. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FCChatMessageModel.h"

@interface MessageModel : NSObject

@property (nonatomic, retain) NSString *msgText;
@property (nonatomic, retain) NSString *msgByIdentify;
@property (nonatomic, retain) NSString *msgConfNumber;
@property (nonatomic, retain) NSString *msgByUserName;
@property (nonatomic, retain) NSString *headPicUrlName;     // 头像url，不包含前面字段

@property (nonatomic, retain) NSString *msgTargetIdentify;
@property (nonatomic, retain) NSString *msgByTargetUserName;
@property (nonatomic, retain) NSString *targetHeadPicUrlName;     // 头像url，不包含前面字段

@property (strong, nonatomic) NSString *msgVideoSelect;

@property (nonatomic, retain) NSString *msgStatus;
@property (nonatomic, assign) kChatMessageType msgType;
@property (nonatomic, assign) kChatMessageStatus messageStatus;
@property (nonatomic, assign) int msgId;
@property (nonatomic, assign) float progress;
@property (nonatomic, getter=isMsgFromMe) BOOL msgFromMe;
@property (nonatomic, retain) NSString *thumbnailPicPath;   // 消息缩略图
@property (nonatomic, retain) NSString *originPicPath;      // 消息原图

@property (nonatomic, assign) BOOL isFailed;        // 是否发送失败
@property (nonatomic, assign) NSInteger timestamp;  // 消息时间戳
@property (nonatomic, assign) NSInteger noReadMsgCount; // 未读消息数

- (NSString *)picFileName;
- (NSString *)userID;
- (NSString *)userUCID;
- (NSString *)userTargetID;
- (NSString *)userTargetUCID;
- (NSString *)targetIDPrefix;

@end
