//
//  FCChatListViewController.m
//  FunChat
//
//  Created by Jyh on 15/10/9.
//  Copyright © 2015年 FeiZhu Tech. All rights reserved.
//

#import "FCChatListViewController.h"
#import <UIColor+Hex.h>
#import "FCChatWindowModel.h"
#import "FCChatCache.h"
#import "FCVideoTalkProtocol.h"
#import "FCChatModelConvertHandler.h"
//#import "MobClick.h"
#define HEIGHT_CHATLIST_CELL            (80)    // 聊天记录 cell 高度

static NSString *CustomCellIdentifier = @"FCChatListCell";

@interface FCChatListViewController () {
    BOOL    _isInChatListView;
}

@property (nonatomic, strong) NSMutableArray *systemListDataSource;

@end

@implementation FCChatListViewController


- (instancetype)initWithType:(ShowType)type
{
    self = [super init];
    if (self) {
        self.showType = type;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendTextMessageEventNotification:) name:kTextChatSendEventNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvTextMessageEventNotification:) name:kTextChatRecvEventNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self configureTableView];
    
    self.title = self.titleString;
    
    [self initDataSourceArray];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self reloadDataAndList];
    if ([_delegate respondsToSelector:@selector(cleanNewMessageRedDot)]) {
        [_delegate cleanNewMessageRedDot];
    }
    [self reloadSystemMessage];
    _isInChatListView = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _isInChatListView = NO;
}

#pragma mark - Public Function

- (void)reloadDataAndList {
    [self reloadChatList];
    [self.tableView reloadData];
}

// 添加 会话窗口数据
- (void)addWindowModel:(FCChatListModel *)windowModel {
    [self.chatListDataSource insertObject:windowModel atIndex:0];
    [self.tableView reloadData];
}

// 刷新 会话窗口数据
- (void)updateWindowModel:(FCChatListModel *)windowModel {
    for (FCChatListModel *windowModelTmp in self.chatListDataSource) {
        if (windowModelTmp.targetUId && [windowModelTmp.targetUId isEqualToString:windowModel.targetUId]) {
            [self.chatListDataSource removeObject:windowModelTmp];
            break;
        }
    }
    [self.chatListDataSource insertObject:windowModel atIndex:0];
    [self.tableView reloadData];
}

#pragma mark - private function

- (void)reloadChatList {
    NSArray *windowModels = [FCChatCache chatList];
    NSMutableArray *chatLists = [NSMutableArray array];
    for (FCChatWindowModel *windowModel in windowModels) {
        FCChatListModel *listModel = [FCChatModelConvertHandler convertChatWindowToChatList:windowModel];
        [chatLists addObject:listModel];
    }
    if (chatLists.count > 0) {
        self.chatListDataSource = chatLists;
    } else {
        [self.chatListDataSource removeAllObjects];
    }
}

- (NSMutableArray *)systemListDataSource {
    if (!_systemListDataSource) {
        _systemListDataSource = [NSMutableArray array];
    }
    return _systemListDataSource;
}

- (NSMutableArray *)chatListDataSource {
    if (!_chatListDataSource) {
        _chatListDataSource = [NSMutableArray array];
    }
    return _chatListDataSource;
}

#pragma mark - Notification event

- (void)refreshChatWindowCacheAndUIWithNotification:(NSNotification *)notification {
    //    kChatMessageStatus msgStatus = [[notification.userInfo objectForKey:kTextChatStatusKey] integerValue];
    MessageModel *msgModel = [notification.userInfo objectForKey:kTextChatMessageObjectKey];
    FCChatWindowModel * chatWindowModel = [FCChatCache fetchChatWindowWithUserID:[msgModel userTargetID]];
    
    // 刷新UI
    if ([FCChatCache isHaveChatWindowCacheWithUserID:chatWindowModel.userID]) {
        // 更新windowModel数据
        FCChatListModel *chatListModel = [FCChatModelConvertHandler convertChatWindowToChatList:chatWindowModel];
        [self updateWindowModel:chatListModel];
    } else {
        // 添加数据
        FCChatListModel *chatListModel = [FCChatModelConvertHandler convertChatWindowToChatList:chatWindowModel];
        [self addWindowModel:chatListModel];
    }
    NSString *currentChatTextID = [FCChatCache currentTextChatTargetUserID];
    if (!msgModel.isMsgFromMe && msgModel.msgType != kChatMessageTypeOfVideo && !_isInChatListView && ![currentChatTextID isEqualToString:msgModel.msgTargetIdentify]) {
        if ([_delegate respondsToSelector:@selector(addMessageRedPoint)]) {
            [_delegate addMessageRedPoint];
        }
    }
}

- (void)sendTextMessageEventNotification:(NSNotification *)notification {
    [self refreshChatWindowCacheAndUIWithNotification:notification];
}

- (void)recvTextMessageEventNotification:(NSNotification *)notification {
    [self refreshChatWindowCacheAndUIWithNotification:notification];
}

#pragma mark
#pragma mark - Requset Info

- (void)initDataSourceArray
{
    NSMutableArray *arraySystem = [NSMutableArray array];
    
    NSString *recentMessage = [[NSUserDefaults standardUserDefaults] objectForKey:kRecentSystemMessageKey];
    NSString *unreadMessageCount = [[NSUserDefaults standardUserDefaults] objectForKey:kUnreadSystemMessageCountKey];
    NSInteger createTimeStamp = [[[NSUserDefaults standardUserDefaults] objectForKey:kCreateSystemMessageTimeKey] integerValue];
    FCChatListModel *model = [[FCChatListModel alloc] init];
    if (self.showType == StudentType) {
        model.targetAvatarImageName = @"icon_logo";
        model.targetNickname = @"趣聊团队";
        model.messageCount = [unreadMessageCount length] > 0 ? unreadMessageCount:@"";
        model.time = createTimeStamp > 0 ? createTimeStamp : [[NSDate date] timeIntervalSinceNow];
        model.subContent = recentMessage ? recentMessage : @"暂无系统消息";
        
    } else if (self.showType == TeacherType) {
        model.targetAvatarImageName = @"icon_logo";
        model.targetNickname = @"NiceTalk Team";
        model.messageCount = [unreadMessageCount length] > 0 ? unreadMessageCount:@"";
        model.time = createTimeStamp > 0 ? createTimeStamp : [[NSDate date] timeIntervalSinceNow];
        model.subContent = recentMessage ? recentMessage : @"Welcome to NiceTalk Team";
    } else if (self.showType == FubDubbingType) {
        // 趣配音类型没有系统消息
    }
    [arraySystem addObject:model];
    
    self.systemListDataSource = arraySystem;
    
    self.chatListDataSource = [NSMutableArray array];
}

- (void)reloadSystemMessage//重新加载系统消息列
{
    NSMutableArray *arraySystem = [NSMutableArray array];
    NSString *recentMessage = [[NSUserDefaults standardUserDefaults] objectForKey:kRecentSystemMessageKey];
    NSString *unreadMessageCount = [[NSUserDefaults standardUserDefaults] objectForKey:kUnreadSystemMessageCountKey];
    NSInteger createTimeStamp = [[[NSUserDefaults standardUserDefaults] objectForKey:kCreateSystemMessageTimeKey] integerValue];
    FCChatListModel *model = [[FCChatListModel alloc] init];
    if (self.showType == StudentType) {
        model.targetAvatarImageName = @"icon_logo";
        model.targetNickname = @"趣聊团队";
        model.messageCount = [unreadMessageCount length] > 0 ? unreadMessageCount:@"";
        model.time = createTimeStamp > 0 ? createTimeStamp : [[NSDate date] timeIntervalSinceNow];
        model.subContent = recentMessage ? recentMessage : @"暂无系统消息";
    } else if (self.showType == TeacherType) {
        model.targetAvatarImageName = @"icon_logo";
        model.targetNickname = @"NiceTalk Team";
        model.messageCount = [unreadMessageCount length] > 0 ? unreadMessageCount:@"";
        model.time = createTimeStamp > 0 ? createTimeStamp : [[NSDate date] timeIntervalSinceNow];
        model.subContent = recentMessage ? recentMessage : @"Welcome to NiceTalk Team";
    }
    [arraySystem addObject:model];
    
    self.systemListDataSource = arraySystem;
    [self.tableView reloadData];
}


#pragma mark -
#pragma mark Private Methods

- (void)configureTableView
{
    self.tableView.rowHeight = HEIGHT_CHATLIST_CELL;
    self.tableView.backgroundColor= [UIColor colorWithHexString:@"efeff4"];
    
    UINib *cellNib = [UINib nibWithNibName:@"FCChatListCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:CustomCellIdentifier];
}

#pragma mark -
#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FCChatListCell *cell = (FCChatListCell *)[tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"FCChatListCell" owner:self options:nil].firstObject;
    }
    FCChatListModel *chatListModel;
    
    if (self.showType != FubDubbingType) {
        chatListModel = indexPath.section == 0 ? self.systemListDataSource[indexPath.row] : self.chatListDataSource[indexPath.row];
        if (indexPath.section == 0) {
            NSString *recentMessage = [[NSUserDefaults standardUserDefaults] objectForKey:kRecentSystemMessageKey];
            NSString *unreadMessageCount = [[NSUserDefaults standardUserDefaults] objectForKey:kUnreadSystemMessageCountKey];
            NSInteger createTimeStamp = [[[NSUserDefaults standardUserDefaults] objectForKey:kCreateSystemMessageTimeKey] integerValue];
            if (![chatListModel.subContent isEqualToString:recentMessage]) {
                chatListModel.subContent = recentMessage;
                chatListModel.time = createTimeStamp > 0 ? createTimeStamp : 0;
                chatListModel.messageCount = [unreadMessageCount length] > 0 ? unreadMessageCount:@"";
            }
            
            cell.avatarImage.image = [UIImage imageNamed:@"msg_nicetalkteam"];
        }
    } else {
        chatListModel = self.chatListDataSource[indexPath.row];
    }
    
    cell.model = chatListModel;
    [cell configureViewWithData:chatListModel type:self.showType];

    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.showType == FubDubbingType) {
        return 1;
    } else {
        NSInteger secCount = 0;
        if (self.systemListDataSource.count > 0) {
            secCount ++;
        }
        if (self.chatListDataSource.count > 0) {
            secCount ++;
        }
        return secCount;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.showType == FubDubbingType) {
        return self.chatListDataSource.count;
    } else {
        if (section == 0) {
            return self.systemListDataSource.count;
        } else {
            return self.chatListDataSource.count;
        }
    }
}

#pragma mark -
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    FCChatListModel *chatListModel;
    if (self.showType != FubDubbingType) {
        chatListModel = indexPath.section == 0 ? self.systemListDataSource[indexPath.row] : self.chatListDataSource[indexPath.row];
    } else {
        chatListModel = self.chatListDataSource[indexPath.row];
    }
   
    if ([self.delegate respondsToSelector:@selector(didSelectSection:Index:model:)]) {
        [self.delegate didSelectSection:indexPath.section Index:indexPath.row model:chatListModel];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.showType != FubDubbingType) {
        if (indexPath.section == 0) {
            return NO;
        }
    }
    
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (self.showType == StudentType) {
            // 删除和外教文字聊天记录
//            [MobClick event:@"kDeleteForeignChatRecord"];
        }
        FCChatListModel *chatListModel;
        if (self.showType != FubDubbingType) {
            chatListModel = indexPath.section == 0 ? self.systemListDataSource[indexPath.row] : self.chatListDataSource[indexPath.row];
            
            [FCChatCache deleteChatWindow:chatListModel.targetUId];
            [self.chatListDataSource removeObjectAtIndex:indexPath.row];
            
            if (self.chatListDataSource.count == 0) {
                NSIndexSet *set = [[NSIndexSet alloc] initWithIndex:1];
                [tableView deleteSections:set withRowAnimation:UITableViewRowAnimationFade];
            } else {
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
        } else {
            chatListModel = self.chatListDataSource[indexPath.row];
            [FCChatCache deleteChatWindow:chatListModel.targetUId];
            [self.chatListDataSource removeObjectAtIndex:indexPath.row];

            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];

        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
    }
    
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [[UIView alloc] init];
    footView.backgroundColor = [UIColor colorWithHexString:@"efeff4"];
    
    return footView;
}

#pragma mark - Orientation

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return  UIInterfaceOrientationPortrait;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationMaskPortrait);//系统默认不支持旋转功能
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate {
    return NO;
}

@end
