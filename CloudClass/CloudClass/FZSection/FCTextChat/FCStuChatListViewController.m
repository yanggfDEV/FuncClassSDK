//
//  FCStuChatListViewController.m
//  FunChatStudent
//
//  Created by 刘滔 on 15/10/12.
//  Copyright © 2015年 Feizhu Tech. All rights reserved.
//

#import "FCStuChatListViewController.h"
#import "FCChatListViewController.h"
#import "FCTextChatViewController.h"
//#import <FCVideoTalkSDKManager.h>
#import "FCTextChatDetailManager.h"
#import "FCChatModelConvertHandler.h"
#import "FCChatCache.h"
//#import "FCSystemMessageViewController.h"
#import "FCVideoTalkLogicHandler.h"
#import "FCUtil.h"
//#import "FCNoticeCenterServer.h"
//#import "FCSystemTopModel.h"
//#import "FCSystemMessageModel.h"
//#import "FCUserInfoServer.h"

@interface FCStuChatListViewController ()<FCChatListDelegate>



@property (strong, nonatomic) FCChatListViewController *chatListVC;
@property (strong, nonatomic) UIView *messageRedPoint;
//@property (strong, nonatomic) FCNoticeCenterServer *centerServer;

@end

@implementation FCStuChatListViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        FCChatListViewController *chatListVC = [[FCChatListViewController alloc] initWithType:FubDubbingType];
        chatListVC.delegate = self;
        self.chatListVC = chatListVC;
        self.chatListVC.view.frame = self.view.frame;
        // 修改非初次登陆升级，从头像中获取头像前缀
        NSString *avatarPrefix = [FZLoginUser avatarPrefix];
        if (!avatarPrefix || avatarPrefix.length == 0) {
            NSString *avatar = [FZLoginUser avatar];
            if (avatar && avatar.length > 0) {
                NSRange range = [avatar rangeOfString:@".com/"];
                if (range.location < avatar.length) {
                    avatarPrefix = [avatar substringToIndex:(range.location + range.length)];
                }
            }
        }
        [FCChatCache setHeadPicPathPrefix:avatarPrefix];
        [self requestSystemMessage];
        
        // 判断ucid是否存在，没有则请求
//        NSString *myUCID = [FZLoginUser userUCID];
//        if (!myUCID || myUCID.length == 0) {
//            [self requestUserInfo];
//        }
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshToIM) name:kTextChatPopTeacherInfoNotification object:nil];
    self.title = @"外教消息";
    [self addChildViewController:self.chatListVC];
    [self.view addSubview:self.chatListVC.view];
    
    NSArray * chatArray = [FCChatCache chatList];
    if (chatArray.count <= 0) {
        [self.loadingView emptyWithTitle: @"木有外教消息" subTitle: nil image: [UIImage imageNamed:@"common_nocontent"]];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -收到挂断电话通知刷新小红点

- (void)refreshToIM
{
//    NSInteger messageNoReadCount = [FCChatCache allNoReadCount];
//    if([FZLoginUser systemUnreadMessage] > 0 || messageNoReadCount > 0){
//        [self addMessageRedPoint];
//    }else{
//        [self cleanNewMessageRedDot];
//    }
}

- (void)initMessageRedPoint {
//    NSInteger messageNoReadCount = [FCChatCache allNoReadCount];
//    if([FZLoginUser systemUnreadMessage] > 0 || messageNoReadCount > 0){
//        [self addMessageRedPoint];
//    }
}

#pragma mark - request

- (void)requestUserInfo
{
//    FCUserInfoServer *userInfoServer = [[FCUserInfoServer alloc] init];
//    [userInfoServer getUserInfoWithsuccessBlock:^(id responseObject) {
//        FCUserInfoTopModel * topModel = responseObject;
//        [FZCommonViewController errorCode:topModel.status];
//        FCUserInfoModel *userInfoModel = topModel.userInfoModel;
//        if(userInfoModel){
//            NSDictionary *dict = [MTLJSONAdapter JSONDictionaryFromModel:userInfoModel];
//            [[FZLoginManager sharedManager] updateUserInfoWithDict:dict];
//        }
//        
//    } failBlock:^(id responseObject, NSError *error) {
//        
//    }];
}

#pragma mark - public function

- (void)backToLoginAgain {
    
}

#pragma mark - private function

// 设置消息通知数量
- (void)setNoticeWithNum:(NSUInteger)num{
    
    if(num > 99){
        self.NoticeButton.hidden = NO;
        [self.NoticeButton setFrame:CGRectMake(175, 33, 20, 20)];
        
        [self.NoticeButton setTitle:@"99+" forState:UIControlStateNormal];
    }else if(num > 0){
        self.NoticeButton.hidden = NO;
        [self.NoticeButton setFrame:CGRectMake(175, 33, 20, 20)];
        
        [self.NoticeButton setTitle:[NSString stringWithFormat:@"%lu",(unsigned long)num] forState:UIControlStateNormal];
    }else{
        self.NoticeButton.hidden = YES;
    }
    
}

- (void)showBadgeView
{
    if (!self.messageRedPoint) {
        float  p_x = [FCUtil screenWidth] / 4 * 3 - 35.5;
        self.messageRedPoint = [[UIView alloc] initWithFrame:CGRectMake(p_x, 14-6.5, 12, 12)];
        self.messageRedPoint.backgroundColor =[UIColor redColor];
        self.messageRedPoint.layer.cornerRadius = 6;  // 将图层的边框设置为圆脚
        self.messageRedPoint.layer.masksToBounds = YES; // 隐藏边界
        self.messageRedPoint.tag = 100;
        [self.tabBarController.tabBar addSubview:self.messageRedPoint];
    }
    self.messageRedPoint.hidden = NO;
}

- (void)requestSystemMessage {
    
//    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",(int)[FZLoginUser systemUnreadMessage]] forKey:kUnreadSystemMessageCountKey];
    
//    WEAKSELF
//    if (!self.centerServer) {
//        self.centerServer = [[FCNoticeCenterServer alloc] init];
//    }
//    
//    NSInteger pagesize;
//    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"kApplicationIconBadgeNumber"]) {
//        pagesize = [[NSUserDefaults standardUserDefaults] integerForKey:@"kApplicationIconBadgeNumber"];
//    } else {
//        pagesize = 0;
//    }
//    if (pagesize) {
//        [self.centerServer getSystemMessage:1 pagesize:pagesize  Success:^(id responseObject) {
//            
//            FCSystemTopModel *topModel = responseObject;
//            if(topModel.status == 0){
//                
//                FCSystemResultMessageModel *resultModel = topModel.systemResultMessageModel;
//                NSArray *array = resultModel.systemMessageArray;
//                NSError * error= nil;
//                
//                if (pagesize) {
//                    for (NSDictionary *dict in array) {
//                        [FCSystemMessageViewController cacheSystemMessageData:dict];
//                    }
//                    if (array.count > 0) {
//                        NSDictionary *dict = [array objectAtIndex:0];
//                        FCSystemMessageModel *messageCenterModel = [MTLJSONAdapter modelOfClass:[FCSystemMessageModel class] fromJSONDictionary:dict error:&error];
//                        [[NSUserDefaults standardUserDefaults] setObject:(messageCenterModel.title && messageCenterModel.title.length > 0 ? messageCenterModel.title : messageCenterModel.content) forKey:kRecentSystemMessageKey];
//                        [[NSUserDefaults standardUserDefaults] setObject:@(messageCenterModel.create_time) forKey:kCreateSystemMessageTimeKey];
//                        [[NSUserDefaults standardUserDefaults] synchronize];
//                    }
//                }
//            }
//            
//            [FZCommonViewController errorCode:topModel.status];
//        } failBlock:nil];
//    }
}

#pragma mark -FCPushManager Delegate

- (void)receiveMessage
{
    [self.chatListVC reloadDataAndList];//刷新
}
- (void)receiveSystemMessage //收到系统消息通知，更新消息内容，时间，未读数量，小红点
{
//     [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",(int)[FZLoginUser systemUnreadMessage]] forKey:kUnreadSystemMessageCountKey];
    [self.chatListVC reloadSystemMessage];
//    [self setNoticeWithNum:[FZLoginUser systemUnreadMessage]];
//    if([FZLoginUser systemUnreadMessage] == 0 ){
//        [self clearRedPoint];
//    }
}

#pragma mark -清除红点
- (void)clearRedPoint
{
//    [FZLoginUser setRedPoint:NO];
    for (UIView *subView in self.tabBarController.tabBar.subviews) {
        
        if(subView.tag == 100){
            [subView removeFromSuperview];
        }
    }
}

- (void)headrefreshList
{
    [self.chatListVC reloadDataAndList];//刷新
}

#pragma mark -Tabbar

- (NSString *)tabTitle
{
    return LOCALSTRING(@"myFunChat_message");
}

- (NSString *)tabNormalImageName
{
    return @"myForeign_normal";
}

- (NSString *)tabSelectedImageName
{
    return @"myForeign_selected";
}

#pragma mark - FCChatListDelegate

- (void)didSelectSection:(NSInteger)seciton Index:(NSInteger)index model:(FCChatListModel *)model {
    FCTextChatViewController *chatDetailVC = [[FCTextChatViewController alloc] initWithRoomModel:model];
    chatDetailVC.isVideoPush = NO;
    chatDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatDetailVC animated:YES];
}

// 添加新消息红点
- (void)addMessageRedPoint {
    [self showBadgeView];
}

// 清空红点
- (void)cleanNewMessageRedDot {
    self.messageRedPoint.hidden = YES;
}

- (void)pushViewController:(UIViewController *)VC animated:(BOOL)animated
{
    VC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:VC
                                         animated:animated];
}

@end
