//
//  FCChatModelConvertHandler.h
//  FunChatStudent
//
//  Created by 刘滔 on 15/10/13.
//  Copyright © 2015年 Feizhu Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageModel.h"
#import "FCChatListModel.h"
#import "FCChatMessageModel.h"
#import "FCChatWindowModel.h"
#import "FCUserTalkTransferModel.h"

@interface FCChatModelConvertHandler : NSObject

// MessageModel -> FCChatMessageModel
+ (FCChatMessageModel *)convertMessageModelToChatMessage:(MessageModel *)messageModel;

// MessageModel -> FCChatWindowModel
+ (FCChatWindowModel *)convertMessageModelToChatWindow:(MessageModel *)messageModel;

// MessageModel -> FCChatListModel
+ (FCChatListModel *)convertMessageModelToChatList:(MessageModel *)messageModel;

// FCChatWindowModel -> FCChatListModel
+ (FCChatListModel *)convertChatWindowToChatList:(FCChatWindowModel *)chatWindow;

// FCUserTextExtraModel -> MessageModel;
+ (MessageModel *)convertUserTextExtraModelToMessageModel:(FCUserTextExtraModel *)extraModel;

// 转换时间格式
+ (NSString *)getMonthTime:(NSTimeInterval)timestamp isChStyle:(BOOL)isCh;
+ (NSString *)getCommentMonthTime:(NSTimeInterval)timestamp isChStyle:(BOOL)isCh;

@end
