//
//  FCTextChatViewController.h
//  FunChatStudent
//
//  Created by 李灿 on 15/10/10.
//  Copyright (c) 2015年 Feizhu Tech. All rights reserved.
//

#import "FCTextChatDetailManager.h"
#import "FCChatListModel.h"
#import "FZCommonViewController.h"

@class FCTextChatDetailManager;

/**
 * @guangfu yang 16-3-1 10:10
 *  弹出聊天页面
 *
 **/
typedef void(^PageBlock) (void);

@interface FCTextChatViewController : FZCommonViewController
@property (nonatomic, copy) PageBlock pageBlock;

@property (nonatomic, assign) BOOL isVideoPush;
@property (nonatomic, strong) FCTextChatDetailManager *textChatDetailManager;
@property (nonatomic, strong) NSString *confId;

- (instancetype)initWithRoomModel:(FCChatListModel *)roomModel;

@end
