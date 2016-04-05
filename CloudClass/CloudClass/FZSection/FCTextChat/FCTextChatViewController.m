//
//  FCTextChatViewController.m
//  FunChatStudent
//
//  Created by 李灿 on 15/10/10.
//  Copyright (c) 2015年 Feizhu Tech. All rights reserved.
//

#import "FCTextChatViewController.h"
#import "FCTextChatDetailManager.h"
#import <UIColor+Hex.h>
//#import <FCVideoTalkSDKManager.h>
#import "FCChatCache.h"
#import "FCChatMessageModel.h"
#import "FCStuChatListViewController.h"
#import "FCChatModelConvertHandler.h"
#import <FZUIButton.h>
#import "FZLoginUser.h"
#import "FZCommonViewController+item.h"
//#import "FCMyTeacherInfoViewController.h"
//#import "FZForeignTeacherInfoViewController.h"
#import "FCVideoTalkLogicHandler.h"
#import "FZCommonTool.h"
//#import "FZForeignTeacherService.h"
//#import "FZStatusCheckModel.h"
//#import "FZRechargeViewController.h"

@interface FCTextChatViewController () <FCTextChatDetailDelegate, FCVideoTalkLogicHandlerDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) FCChatListModel *chatRoomModel;
@property (nonatomic, strong) FCVideoTalkLogicHandler *videoTalkLogicHandler;
@property (strong, nonatomic) MBProgressHUD *hud;
@property (nonatomic, strong) UIButton *goBackBtn;
@property (strong, nonatomic) UIButton *backButton;
@end

@implementation FCTextChatViewController {
    BOOL _isNeedHideTabbar; // 是否需要隐藏tabbar （关闭视频聊天页面后，会显示tabbar，此时需要在viewwillappear中处理）
}

- (void)dealloc {
    self.chatRoomModel = nil;
    self.textChatDetailManager = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
//        roomModel.targetUId = [FZCommonTool getNoPrefixUserID:roomModel.targetUId];
        FCTextChatDetailManager *chatDetailVc = [[FCTextChatDetailManager alloc] init];
        chatDetailVc.delegate = self;
        self.textChatDetailManager = chatDetailVc;
        
//        self.chatRoomModel = roomModel;
        
        // 添加自己的信息
//        [self addMyUserInfoWithModel:roomModel];
        
        // 如果老师ucid不存在，则请求
//        if (!roomModel.targetUcid || roomModel.targetUcid.length == 0) {
//            [self requestTeacherUCIDWithUid:roomModel.targetUId];
//        }
    }
    return self;
}

- (void)loadView {
    [super loadView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textChatDetailManager.hidesBottomBarWhenPushed = YES;
    _textChatDetailManager.confId = self.confId;
    [self addChildViewController:self.textChatDetailManager];
    [self.view addSubview:self.textChatDetailManager.view];
    _textChatDetailManager.delegate = self;
    [_textChatDetailManager setChatListModel:self.chatRoomModel];

    self.hidesBottomBarWhenPushed = YES;
    self.title = self.chatRoomModel.targetNickname;
    _textChatDetailManager.isVideoPush = _isVideoPush;
//    if (_isVideoPush) {
//        [self addLeftButtonWithType:kLeftButtonTypeOfCloseImage exitVCType:kExitVCModeOfPop];
//    } else {
//        UIButton *rightButton = [[FZUIButton alloc] initWithRightButtonItemwithTitle:LOCALSTRING(@"聊天") target:self action:@selector(chatManagerVideoTalk)];
//        [rightButton setTitle:nil forState:UIControlStateNormal];
//        [rightButton setImage:[UIImage imageNamed:@"msg_title_video"] forState:UIControlStateNormal];
//        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
//        [self setRightBarButtonItem:rightItem];
//    }
    FZStyleSheet *css = [[FZStyleSheet alloc] init];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"返回" forState:UIControlStateNormal];
    [button setTitleColor:css.colorOfLighterText forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"common_icon_leftarrow"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onGoBack) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 100, 44);
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 30, 0, 0)];
    button.titleLabel.font = css.fontOfH2;
    self.goBackBtn = button;
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:self.goBackBtn];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                   target:nil action:nil];
    negativeSpacer.width = -15;//这个数值可以根据情况自由变化
    self.navigationItem.leftBarButtonItems = @[negativeSpacer, leftBarItem];
    
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton setImage:[UIImage imageNamed:@"common_close_white"] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backButton];
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(40);
        make.right.equalTo(self.view).offset(-10);
        make.width.height.equalTo(@(40));
    }];
}

-(void)backButtonClick:(UIButton*)sender
{
    if (self.pageBlock) {
        self.pageBlock();
    }
    [self.view removeFromSuperview];
}

- (void)onGoBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ViewDelegate

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    if(self.speakerId && self.speakerId.length){
//        [FCChatCache cleanNoReadCountWithUserID:self.speakerId];
//    }
    NSInteger noReadCount = [FCChatCache allNoReadCount];
    if (noReadCount == 0) {
//        UINavigationController *secondNavigation =[self.tabBarController.childViewControllers objectAtIndex:2];
//        FCStuChatListViewController  *chatListVC = [secondNavigation.childViewControllers objectAtIndex:0];
//        [chatListVC cleanNewMessageRedDot];
    }
}

- (void)onPressedLeftButton:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kTextChatIntoVideoNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - request

- (void)requestTeacherUCIDWithUid:(NSString *)uid {
    // 暂时无法获取老是UCID
    
//    NSMutableDictionary* dicParam = [[NSMutableDictionary alloc] initWithCapacity:2];
//    [dicParam setValue:[FZLoginUser authToken] forKey:@"token"];
    NSString *userIDTmp = [FZCommonTool getNoPrefixUserID:uid];
//    [dicParam setValue:userIDTmp forKey:@"tch_id"];
//    [dicParam setValue:@20 forKey:@"timeoutInterval"];
    
    WEAKSELF
//    FCCallingServer *callServer = [[FCCallingServer alloc] init];
//    [callServer postCallingChattime:dicParam successBlock:^(id responseObject) {
//        FZCallingTopTimeModle *callTopTime = responseObject;
//        if ([FZCommonViewController errorCode:callTopTime.status]) {
//            return;
//        }
//        NSString *targetUCID = [NSString stringWithFormat:@"%zd", callTopTime.callingTimeModel.tchUCID];
//        if (callTopTime.status == 0 && targetUCID) {
//            FCChatWindowModel *messageModel = [FCChatCache fetchChatWindowWithUserID:uid];
//            messageModel.userUCID = targetUCID;
//            [FCChatCache addChatWindowCleanNoReadCount:messageModel];
//            [weakSelf resetChatListModelWithUCID:targetUCID];
//            return ;
//        }
//        
//    } failBlock:^(id responseObject, NSError *error) {
//    }];
}

- (void)resetChatListModelWithUCID:(NSString *)ucid {
    if (ucid) {
        self.chatRoomModel.targetUcid = ucid;
        [_textChatDetailManager resetTargetUCID:ucid];
    }
}

#pragma mark - private function

- (void)addMyUserInfoWithModel:(FCChatListModel *)model {
    id uid = [FZLoginUser userID];
    if ([uid isKindOfClass:[NSNumber class]]) {
        uid = [NSString stringWithFormat:@"%zd", [uid integerValue]];
    } else {
        uid = [NSString stringWithFormat:@"%@", uid];
    }
    model.myUId = uid;
//    model.myUCID = [FZLoginUser userUCID];
    model.myUCID = [FZLoginUser commonUId];
    model.myNickname = [FZLoginUser nickname];
    model.myAvatarUrl = [FZLoginUser avatar];
}

#pragma mark - events

- (void)chatManagerVideoTalk
{
//    [FCUserActionReportHandler reportEventName:@"文字聊天点击呼叫按钮" eventId:@"kTextChatClickCallingBtn"];
    if (_isVideoPush) {
        return;
    }
    
    if(self.chatRoomModel.courseID){
        self.chatRoomModel.courseID = nil;
        self.chatRoomModel.courseName = nil;
        self.chatRoomModel.courseName_En = nil;
        self.chatRoomModel.courseDownloadUrl = nil;
        self.chatRoomModel.titleName = nil;
        self.chatRoomModel.titleName_En = nil;
    }
    
    _isNeedHideTabbar = YES;
    if (!self.videoTalkLogicHandler) {
        FCVideoTalkLogicHandler *videoTalkLogicHandler = [[FCVideoTalkLogicHandler alloc] init];
        videoTalkLogicHandler.delegate = self;
        self.videoTalkLogicHandler = videoTalkLogicHandler;
    }
    self.videoTalkLogicHandler.delegate = self;
    [self.videoTalkLogicHandler startVideoTalkWithChatListModel:self.chatRoomModel];
}

- (BOOL)navigationShouldPopOnBackButton{
    return YES;
}

#pragma mark - FCTextChatDetailDelegate

- (void)chatManagerTapTeacherPhoto:(NSString *)teacherID
{
//    FCMyTeacherInfoViewController *myTeavherInfoVC = [[FCMyTeacherInfoViewController alloc] init];
//    FZForeignTeacherInfoViewController *vc = [[FZForeignTeacherInfoViewController alloc] init];
//    vc.teacherId = [teacherID integerValue];
//    vc.isRightButton = YES;
//    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!_isVideoPush && _isNeedHideTabbar) {
        [self hideTabBar];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self showTabBar];
}

#pragma mark - FCVideoTalkLogicHandlerDelegate

- (UINavigationController *)currentNavigationViewController {
    return self.navigationController;
}

- (UIViewController *)superViewController {
    return self;
}

//- (void)videoTalkSDKManager:(FCVideoTalkSDKManager *)manager actionType:(kVideoTalkActionType)type message:(NSString *)msg error:(NSError *)error {
//    
//}
//
//- (void)videoTalkSDKManager:(FCVideoTalkSDKManager *)manager userEventType:(kVideoTalkUserEventType)type model:(id)response error:(NSError *)err {
//    
//}

- (void)startLoadingViewWithText:(NSString *)text {
    [self startProgressHUDWithText:text];
}

- (void)showHintWithText:(NSString *)text {
    [self showHUDHintWithText:text];
}

- (void)showHintWithText:(NSString *)text completeBlock:(void (^)())completeBlock {
    [self showHUDHintWithText:text];
    if (completeBlock) {
        completeBlock();
    }
}


- (void)startLoadingView:(NSString*)text {
//    DDLogInfo(@"提示框：%@", text);
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    self.hud = HUD;
    
    self.hud.labelText = text;
    [self.view bringSubviewToFront:self.hud];
    [self.hud show:YES];
    
    // 弹窗延迟出现，否则网络很好的时候会一闪而过
    float oldGraceTime = self.hud.graceTime;
    self.hud.graceTime = 0.5;
    [self.hud show:YES];
    self.hud.graceTime = oldGraceTime;
}

- (void)stopLoadingView {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (self.hud) {
        [self.hud hide:YES];
    }
}

- (void)showAlterViewWithTime:(int)alterTime {
    if (alterTime > 0) {
        NSString *alertString = [NSString stringWithFormat:@"%@%d%@", LOCALSTRING(@"ft_call_not_enough_time_prefix"), alterTime, LOCALSTRING(@"ft_call_not_enough_time_suffix")];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LOCALSTRING(@"alert") message:alertString delegate:self cancelButtonTitle:LOCALSTRING(@"ft_call_continue") otherButtonTitles:LOCALSTRING(@"ft_binding_phone_now"), nil];
        alert.tag = 0;
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LOCALSTRING(@"alert") message:LOCALSTRING(@"ft_call_not_enough_time") delegate:self cancelButtonTitle:LOCALSTRING(@"ft_binding_phone_cancel") otherButtonTitles:LOCALSTRING(@"ft_binding_phone_now"), nil];
        alert.tag = 1;
        [alert show];
    }
}

- (void)resetChatButtonStatus {
    
}

#pragma mark - uialertview delegate

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//    // 0: 余额不足10分钟的情况
//    if (alertView.tag == 0) {
//        if (buttonIndex != alertView.cancelButtonIndex) {
//            FZRechargeViewController *vc = [[FZRechargeViewController alloc] initWithNibName:@"FZRechargeViewController" bundle:nil];
//            [self.navigationController pushViewController:vc animated:YES];
//        } else {
//            [self startProgressHUD];
//            WEAKSELF
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                STRONGSELFFor(weakSelf)
//                [strongSelf stopProgressHUD];
//                [strongSelf.videoTalkLogicHandler shouldContinueCall];
//            });
//        }
//    } else if (alertView.tag == 1) {
//        if (buttonIndex != alertView.cancelButtonIndex) {
//            FZRechargeViewController *vc = [[FZRechargeViewController alloc] initWithNibName:@"FZRechargeViewController" bundle:nil];
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//    }
//}

//#pragma mark 隐藏Tabbar
//- (void)hideTabBar {
//    CGRect frame = self.tabBarController.tabBar.frame;
//    frame.size.height = 0;
//    self.tabBarController.tabBar.frame = frame;
//    if (self.tabBarController.tabBar.hidden == YES)
//    {
//        return;
//    }
//    UIView *contentView;
//    if ( [[self.tabBarController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]]) {
//        contentView = [self.tabBarController.view.subviews objectAtIndex:1];
//    } else {
//        contentView = [self.tabBarController.view.subviews objectAtIndex:0];
//    }
//    contentView.frame = CGRectMake(contentView.bounds.origin.x,  contentView.bounds.origin.y,  contentView.bounds.size.width, contentView.bounds.size.height + self.tabBarController.tabBar.frame.size.height);
//    self.tabBarController.tabBar.hidden = YES;
//}
//
//#pragma mark显示tabbar
//- (void)showTabBar
//{
//    CGRect frame = self.tabBarController.tabBar.frame;
//    frame.size.height = 49;
//    self.tabBarController.tabBar.frame = frame;
//}

@end
