//
//  FCChatListViewController.h
//  FunChat
//
//  Created by Jyh on 15/10/9.
//  Copyright © 2015年 FeiZhu Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FCChatListCell.h"

#define kRecentSystemMessageKey      @"kRecentSystemMessageKey"
#define kCreateSystemMessageTimeKey  @"kCreateSystemMessageTimeKey"
#define kUnreadSystemMessageCountKey @"kUnreadSystemMessageCountKey"

@class FCChatWindowModel;
@class FCChatListModel;

@protocol FCChatListDelegate;
@interface FCChatListViewController : UITableViewController

@property (nonatomic, weak) id<FCChatListDelegate> delegate;

/**
 *  大量数据的数据源
 */
@property (nonatomic, strong) NSMutableArray *chatListDataSource;

/**
 *  Title显示
 */
@property (copy, nonatomic) NSString *titleString;

/**
 *  两种类型 老师 学生
 */
@property (nonatomic) ShowType showType;

/**
 *  初始化方法
 *
 *  @param type 传入(学生/老师/趣配音)类型
 *
 *  @return
 */
- (instancetype)initWithType:(ShowType)type;

// 添加 会话窗口数据
- (void)addWindowModel:(FCChatListModel *)windowModel;

// 刷新 会话窗口数据
- (void)updateWindowModel:(FCChatListModel *)windowModel;

// 重新加载数据并刷新列表
- (void)reloadDataAndList;

- (void)initDataSourceArray; //初始化

- (void)reloadSystemMessage;//重新加载系统消息列
@end

@protocol FCChatListDelegate <NSObject>

/**
 *  点击会话列表单个会话的委托回调
 *
 *  @param seciton 分区 分区为0 为系统消息
 *  @param index
 *  @param model   
 */
- (void)didSelectSection:(NSInteger)seciton Index:(NSInteger)index model:(FCChatListModel *)model;

// 添加新消息红点
- (void)addMessageRedPoint;

// 清空红点
- (void)cleanNewMessageRedDot;

@end
