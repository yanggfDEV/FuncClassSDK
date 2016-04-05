//
//  FCTextChatDetailManager.h
//  FunChatStudent
//
//  Created by 李灿 on 15/10/12.
//  Copyright © 2015年 Feizhu Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FCTextChatView.h"
#import "FCChatMessageModel.h"
#import "FCVideoTalkProtocol.h"
#import "FCInputTextView.h"
#import "FCChatMessageModel.h"

@class FCChatListModel;
@protocol FCTextChatDetailDelegate;

@interface FCTextChatDetailManager : UIViewController

@property (nonatomic, assign) BOOL needAdjustOriginY;
@property (nonatomic, assign) BOOL isVideoPush;
@property (nonatomic, assign) BOOL isChaneseTeacher;
@property (nonatomic, strong) NSString *confId;
/**
 *  @author Victor Ji, 15-12-17 10:12:53
 *
 *  是否需要激活输入框
 */
@property (assign, nonatomic) BOOL shouldOpenKeyboard;
/**
 *  判断 是否显示英文(老师端专用字段)
 */
@property (nonatomic, assign) BOOL isShowEnglish;
@property (nonatomic, strong) NSMutableArray *resultArray;
@property (weak, nonatomic) id<FCTextChatDetailDelegate> delegate;
@property (nonatomic, strong) FCInputTextView *inputTextView;

- (void)setChatListModel:(FCChatListModel *)model;
- (void)refreshMessageStatus:(kChatMessageStatus)msgStatus messageModel:(FCChatMessageModel *)msgModel;
- (void)addMessageModel:(FCChatMessageModel *)messageModel;
- (void)addLeftButtonWithTypeexitVCType;
- (void)resetTargetUCID:(NSString *)ucid;

@end

@protocol FCTextChatDetailDelegate <NSObject>

@optional
- (void)teacherRefreshModel:(NSString *)chatNews time:(NSInteger)time;
- (void)chatManagerTapTeacherPhoto:(NSString *)teacherID;
- (void)chatManagerVideoTalk;

@end
