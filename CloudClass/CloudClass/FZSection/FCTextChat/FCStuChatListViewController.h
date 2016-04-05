//
//  FCStuChatListViewController.h
//  FunChatStudent
//
//  Created by 刘滔 on 15/10/12.
//  Copyright © 2015年 Feizhu Tech. All rights reserved.
//

#import "FZCommonViewController.h"

@class FCTextChatViewController;

@interface FCStuChatListViewController : FZCommonViewController

@property (strong, nonatomic)UIButton *NoticeButton;

// 添加新消息红点
- (void)addMessageRedPoint;

// 清空红点
- (void)cleanNewMessageRedDot;

@end
