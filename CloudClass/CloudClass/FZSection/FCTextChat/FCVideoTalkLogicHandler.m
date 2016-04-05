 //
//  FCViewRelation.m
//  FunChatStudent
//
//  Created by FZDubbing on 15/10/15.
//  Copyright © 2015年 Feizhu Tech. All rights reserved.
//

#import "FCVideoTalkLogicHandler.h"
//#import <FCVideoTalkProtocol.h>
//#import "FZAlipayViewController.h"
#import "FZNavigationController.h"
#import "FCTextChatViewController.h"
#import "FCUserTalkTransferModel.h"
//#import "FCVideoTalkSDKManager.h"
//#import "FCCommentTeacherViewController.h"
#import "FCDateString.h"
#import "FCChatCache.h"
#import <AVFoundation/AVFoundation.h>
//#import <UIAlertView+BlocksKit.h>
//#import "FCCallingServer.h"
//#import "FCUserActionReportDefines.h"
//#import "FCUserActionReportHandler.h"
//#import "FCMyTeacherInfoViewController.h"
#import "FZCommonTool.h"
#import "FCStuChatListViewController.h"
//#import "FZForeignTeacherService.h"
#import <AFNetworking/AFNetworkReachabilityManager.h>
//#import "FZStatusCheckModel.h"
#import "FCCallShareTopModel.h"
//#import "FZCommentTeacherViewController.h"
//#import "FZRechargeViewController.h"

@interface FCVideoTalkLogicHandler()< UIAlertViewDelegate> //,FCTextChatDetailDelegate>
{
//    BOOL _isRequestLoading;
    FCChatRoomModel *_videoEndTalkRoomModel;
    FCCallShareModel *_callEndShareModel;
}

@property (assign, nonatomic) BOOL isRequestLoading;

//@property (strong, nonatomic) FZForeignTeacherService *callServer;
@property (nonatomic, strong) FCChatListModel *chatListModel;
//@property(nonatomic,strong)FCTeachInfoSever* teachInfoSever;
@property (nonatomic, strong) FCTextChatDetailManager *textChatVCInVideoTalkMode;

@property (assign, nonatomic) BOOL preCheckIsDone;

@end

@implementation FCVideoTalkLogicHandler

- (id)init {
    self = [super init];
    if (self) {
        [self initNotification];
//        self.callServer = [[FZForeignTeacherService alloc] init];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - video talking

-(void)startVideoTalkWithChatListModel:(FCChatListModel *)chatListModel {
    chatListModel.targetUId = [FZCommonTool getNoPrefixUserID:chatListModel.targetUId];
    self.chatListModel = chatListModel;
    
    // 麦克风是否已经开启？
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        if (granted) {
            // 摄像头是否已开启?
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            if (authStatus != AVAuthorizationStatusDenied) {
//                [self requestVideoTalking];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LOCALSTRING(@"alert") message:LOCALSTRING(@"ft_open_camera") delegate:self cancelButtonTitle:LOCALSTRING(@"cancel") otherButtonTitles:LOCALSTRING(@"commit"), nil];
                [alert show];
            }
        } else {
            // 麦克风未开启
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LOCALSTRING(@"alert") message:LOCALSTRING(@"ft_open_microphone") delegate:nil cancelButtonTitle:LOCALSTRING(@"commit") otherButtonTitles:nil];
            [alert show];
        }
    }];
}

//- (void)requestVideoTalking {
//    self.isRequestLoading = YES;
//    
//    if (![FZLoginUser commonUId] || [[FZLoginUser commonUId] isEqualToString:@""] || [[FZLoginUser commonUId] isEqualToString:@"0"]) {
//        [self.delegate showHintWithText:@"检测到账号异常，请重新登录"];
//        return;
//    }
//    
//    if (![AFNetworkReachabilityManager sharedManager].reachable) {
//        [self.delegate showHintWithText:LOCALSTRING(@"mysetting_NoNetWork")];
//        return;
//    } else if ([AFNetworkReachabilityManager sharedManager].isReachableViaWWAN){
//        [self.delegate showHintWithText:LOCALSTRING(@"no_wan_net_alert")];
//        WEAKSELF
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            STRONGSELFFor(weakSelf)
//            if (strongSelf.isRequestLoading) {
//                [strongSelf.delegate startLoadingView:LOCALSTRING(@"ft_is_calling")];
//            }
//        });
//    } else {
//        if([self.delegate respondsToSelector:@selector(startLoadingView:)]){
//            [self.delegate startLoadingView:LOCALSTRING(@"ft_is_calling")];
//        }
//    }
//    
//    NSString *userIDTmp = [FZCommonTool getNoPrefixUserID:self.chatListModel.targetUId];
//    WEAKSELF
//    [self.callServer checkStatusBeforeCallWithTeacherId:userIDTmp type:0 success:^(NSInteger statusCode, NSString *message, id dataObject) {
//        STRONGSELFFor(weakSelf)
//        [strongSelf.delegate resetChatButtonStatus];
//        [strongSelf.delegate stopLoadingView];
//        
//        if (statusCode == kFZRequestStatusCodeSuccess) {
//            FZStatusCheckModel *checkModel = (FZStatusCheckModel *)dataObject;
//            strongSelf.chatListModel.restTime = checkModel.availableChattingSeconds;
//            if (checkModel.onlineStatus == 0) {
//                [strongSelf.delegate showHintWithText:LOCALSTRING(@"ft_call_offline")];
//                return;
//            } else if (checkModel.onlineStatus == 2) {
//                [strongSelf.delegate showHintWithText:LOCALSTRING(@"ft_call_busy")];
//                return;
//            }
//            if (checkModel.isFree == 1) {
//                [strongSelf beginCalling];
//            } else {
//                if ((checkModel.availableChattingSeconds > checkModel.minChattingSeconds)) {
//                    [strongSelf beginCalling];
//                } else {
////                    int minTime = (int)checkModel.minChattingSeconds / 60;
//                    strongSelf.preCheckIsDone = YES;
//                    int minTime = (int)checkModel.availableChattingSeconds / 60;
//                    [strongSelf.delegate showAlterViewWithTime:minTime];
//                }
//            }
//        } else {
//            [strongSelf.delegate showHintWithText:message];
//        }
//    } failure:^(id responseObject, NSError *error) {
//        STRONGSELFFor(weakSelf)
//        [strongSelf.delegate resetChatButtonStatus];
//        [strongSelf.delegate stopLoadingView];
//        [strongSelf.delegate showHintWithText:LOCALSTRING(@"network_error")];
//    }];
//}

-(void)beginCalling {
    if (![AFNetworkReachabilityManager sharedManager].reachable) {
        [self.delegate stopLoadingView];
        [self.delegate showHintWithText:LOCALSTRING(@"mysetting_NoNetWork")];
        return;
    }
    
    [self.delegate stopLoadingView];
//    FCVideoTalkSDKManager *avManager = [FCVideoTalkSDKManager shareInstance];
//    FCUserTalkTransferModel *transferMessage = [[FCUserTalkTransferModel alloc] init];
//    transferMessage.targetPicUrl = self.chatListModel.targetAvatarUrl;
//    transferMessage.myAvatarUrl = self.chatListModel.myAvatarUrl;
//    transferMessage.limitTime = [NSString stringWithFormat:@"%zd", self.chatListModel.restTime];
//    transferMessage.targetUcid = self.chatListModel.targetUcid;
//    transferMessage.packageAvaibleTime = [NSString stringWithFormat:@"%zd", self.chatListModel.restPackageTime];
//    transferMessage.titleName = self.chatListModel.titleName;
//    transferMessage.titleName_En = self.chatListModel.titleName_En;
//    transferMessage.courseName = self.chatListModel.courseName;
//    transferMessage.courseName_En = self.chatListModel.courseName_En;
//    transferMessage.courseDownloadUrl = self.chatListModel.courseDownloadUrl;
//    transferMessage.courseID = self.chatListModel.courseID;
//    transferMessage.imagePaths = self.chatListModel.cardImagePaths;
//    
//    avManager.delegate = self;
//    NSString *targetUserID = [NSString stringWithFormat:@"%@", self.chatListModel.targetUId];
//    WEAKSELF
//    [avManager call:targetUserID username:self.chatListModel.myNickname targetname:self.chatListModel.targetNickname extraMessage:transferMessage failBlock:^{
//        STRONGSELFFor(weakSelf)
//        [strongSelf.delegate showHintWithText:LOCALSTRING(@"ft_call_teacher_bad_network")];
//    }];
//    if ([FCChatCache isHaveChatWindowCacheWithUserID:targetUserID]) {
//        [self requestTeachinfoSeverWithUserID:[self.chatListModel.targetUId integerValue]];
//    } else {
//        // 将老师信息存入缓存
//        [self saveTeacherInfo:self.teachInfoModel];
//    }
}

- (void)shouldContinueCall {
    if (self.chatListModel && self.preCheckIsDone) {
        [self beginCalling];
    }
}

#pragma mark - server

-(void)requestTeachinfoSeverWithUserID:(NSInteger)userID
{
//    NSMutableDictionary* teachDic = [[NSMutableDictionary alloc] initWithCapacity:2];
//    [teachDic setValue:[NSNumber numberWithInteger:userID] forKey:@"tch_id"];
//    if (!self.teachInfoSever) {
//        self.teachInfoSever = [[FCTeachInfoSever alloc] init];
//    }
//    WEAKSELF
//    [self.teachInfoSever getTeacherInfo:teachDic successBlock:^(id responseObject) {
//        FCTeachInfoTopModel* teachInfoTopModel = responseObject;
//        weakSelf.teachInfoModel = teachInfoTopModel.teachModel;
//        [weakSelf saveTeacherInfo:teachInfoTopModel.teachModel];
//    } failBlock:nil];
}


- (void)saveTeacherInfo:(FCTeachInfoModel *)teachInfoModel {
    FCChatWindowModel *model = [[FCChatWindowModel alloc] init];
    model.countryChstr = teachInfoModel.countryChstr;
    model.star = teachInfoModel.star;
    model.levelName = teachInfoModel.levelName;
    model.price = teachInfoModel.price;
    model.sex = teachInfoModel.sex;
    model.isCollect = teachInfoModel.isCollect;
    
    model.userID = [NSString stringWithFormat:@"%zd", teachInfoModel.userId];
    model.userName = teachInfoModel.nickName;
    model.headPicPath = teachInfoModel.avatar;
    
    [FCChatCache addChatWindowCleanNoReadCount:model];
}

#pragma mark - notification

- (void)initNotification {
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(GotoPayViewController:) name:kVideoViewControllerGotoAliPay object:nil];
    [notificationCenter addObserver:self selector:@selector(sendTextChatTalkNotification:) name:kTextChatTalkNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willTermVideoTalkNotification:) name:kTextChatPopTeacherInfoNotification object:nil];
}

- (void)GotoPayViewController:(NSNotification *)notification {
//    FZRechargeViewController *vc = [[FZRechargeViewController alloc] init];
//    vc.delegate = self;
//    vc.isPresent = YES;
//    
//    UIViewController *videoViewController = [notification.userInfo objectForKey:kSuperViewControllerKey];
//    FZNavigationController *navi = [[FZNavigationController alloc] initWithRootViewController:vc];
//    
//    [videoViewController presentViewController:navi animated:YES completion:nil];
    
    
//    FZAlipayViewController *alipayViewController = [[FZAlipayViewController alloc] initWithPresentStyle];
//    alipayViewController.delegate = self;
//    alipayViewController.isPresentToShowSelfViewController = YES;
//   
//    UIViewController *videoViewController = [notification.userInfo objectForKey:kSuperViewControllerKey];
//    FZNavigationController *navi = [[FZNavigationController alloc] initWithRootViewController:alipayViewController];
//    [videoViewController presentViewController:navi animated:YES completion:nil];
    
}

- (void)sendTextChatTalkNotification:(NSNotification *)notification {
    BOOL isCreateVC = NO;
    if (!self.textChatVCInVideoTalkMode) {
        FCTextChatDetailManager *chatDetailVc = [[FCTextChatDetailManager alloc] init];
        chatDetailVc.isVideoPush = YES;
//        chatDetailVc.delegate = self;
        chatDetailVc.modalPresentationStyle = UIModalPresentationOverFullScreen;
        self.textChatVCInVideoTalkMode = chatDetailVc;
        isCreateVC = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [chatDetailVc setChatListModel:self.chatListModel];
        });
        if([[notification.userInfo objectForKey:@"RemotoVideoStatus"] boolValue] == YES){
            //需要修改IM页面frame，下降20
            chatDetailVc.needAdjustOriginY = YES;
        }else{
            chatDetailVc.needAdjustOriginY = NO;
        }
    }
    
    UIViewController *callingViewController = [notification.userInfo objectForKey:kSuperViewControllerKey];
    callingViewController.view.superview.backgroundColor = [UIColor clearColor];
    self.textChatVCInVideoTalkMode.shouldOpenKeyboard = [[notification.userInfo objectForKey:@"OpenKeyboard"] boolValue];
    [callingViewController presentViewController:self.textChatVCInVideoTalkMode animated:YES completion:nil];
}

- (void)willTermVideoTalkNotification:(NSNotification *)notification {
    [self.textChatVCInVideoTalkMode dismissViewControllerAnimated:YES completion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.textChatVCInVideoTalkMode = nil;
    });
}

#pragma mark - FCVideoTalkSDKDelegate

- (void)startLoadingViewWithText:(NSString *)text
{
    if ([_delegate respondsToSelector:@selector(startLoadingViewWithText:)]) {
        [_delegate startLoadingViewWithText:text];
    }
}

- (void)backToLoginAgain {
    [FCStuChatListViewController errorCode:403];
}

//- (void)videoTalkSDKManager:(FCVideoTalkSDKManager *)manager userEventType:(kVideoTalkUserEventType)type model:(id)response error:(NSError *)err {
//    [_delegate stopLoadingView];
//    if (err) {
//        return;
//    }
//    static BOOL bShouldPresentContent = NO;
//    
//    switch (type) {
//        case kVideoTalkPressedCloseBtnType: {
//            if ([response isKindOfClass:[FCCallEndInfoModel class]]) {
//                FCCallEndInfoModel *model = (FCCallEndInfoModel *)response;
//                FCChatRoomModel *chatModel = [[FCChatRoomModel alloc] init];
//                
//                chatModel.tch_id = model.userID;
//                chatModel.cid = [NSString stringWithFormat:@"%zd", model.cid];
//                chatModel.intCallingTime = [model.minutes integerValue];
//                chatModel.nickname = model.nickName;
//                chatModel.avatarUrl = model.avatarUrl;
//                chatModel.packageTime = model.packageMinutes;
//                chatModel.miniCourseID = model.miniCourseID;
//                chatModel.consumeAmount = model.amount;
//                chatModel.tradeNum = model.tradeNum;
//                chatModel.restTime = model.tradeMinute;//通话消费分钟
//                _videoEndTalkRoomModel = chatModel;
//                
//                FCCallShareModel *callShareModel = [[FCCallShareModel alloc] init];
//                callShareModel.share_content = model.shareContent;
//                callShareModel.share_pic = model.sharePicUrl;
//                callShareModel.share_title = model.shareTitle;
//                callShareModel.share_url = model.shareUrl;
//                _callEndShareModel = callShareModel;
//
//                bShouldPresentContent = NO;
//                if (bShouldPresentContent) {
//                    [self showTeacherCommentViewControllerWithChatRoomModel:chatModel withShareMode:callShareModel];
//                    bShouldPresentContent = NO;
//                }
//            }
//        }
//            break;
//        case kVideoTalkViewDismiss:
//        {
//            // 通话界面消失
//            bShouldPresentContent = YES;
//            if (_videoEndTalkRoomModel) {
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [self showTeacherCommentViewControllerWithChatRoomModel:_videoEndTalkRoomModel withShareMode:_callEndShareModel];
//                });
//                bShouldPresentContent = NO;
//            }
//        }
//        default:
//            break;
//    }
//}
//
- (void)showTeacherCommentViewControllerWithChatRoomModel:(FCChatRoomModel *)chatModel withShareMode:(FCCallShareModel *)shareModel {
//    FZCommentTeacherViewController *vc = [[FZCommentTeacherViewController alloc] initWithNibName:@"FZCommentTeacherViewController" bundle:nil];
//    vc.chatModel = chatModel;
//    vc.shareModel = shareModel;
//    if (chatModel.cid) {
//        vc.cid = [chatModel.cid integerValue];
//    }
//    FZNavigationController *nv = [[FZNavigationController alloc] initWithRootViewController:vc];
//    [[_delegate superViewController] presentViewController:nv animated:YES completion:nil];
//    _videoEndTalkRoomModel = nil;
    
    
//    FCCommentTeacherViewController *viewController = [[FCCommentTeacherViewController alloc] initWithType:kVideoTalkTermCommentTypeOfNormal];
//    FCTeachInfoModel *teachInfoModel = self.teachInfoModel ? self.teachInfoModel : [self teachInfoModelWithUserID:chatModel.tch_id];
//    viewController.teacherInfoModel = teachInfoModel;
//    viewController.chattingTimeString = [FCDateString hmsTimeLengthWithHMSfromSecond:chatModel.intCallingTime];
//    viewController.intCallTime = chatModel.intCallingTime;
//    viewController.packageTime = chatModel.packageTime;
//    viewController.courseID = chatModel.miniCourseID;
//    viewController.callshareModel = shareModel;
//    viewController.consumeAmount = chatModel.consumeAmount;
//    if (chatModel.cid) {
//        viewController.cid = [chatModel.cid integerValue];
//    }
//    FZNavigationController *navi = [[FZNavigationController alloc] initWithRootViewController:viewController];
//    [[_delegate superViewController] presentViewController:navi animated:YES completion:nil];
//    _videoEndTalkRoomModel = nil;
}

- (FCTeachInfoModel *)teachInfoModelWithUserID:(NSString *)userID {
    if (!userID) {
        return nil;
    }
    FCTeachInfoModel *teachInfoModel = [[FCTeachInfoModel alloc] init];
    NSString *searchUserID = [NSString stringWithFormat:@"%@", userID];
    FCChatWindowModel *windowModel = [FCChatCache fetchChatWindowWithUserID:searchUserID];
    teachInfoModel.userId = [userID  integerValue];
    teachInfoModel.nickName = windowModel.userName;
    teachInfoModel.avatar = windowModel.headPicPath;
    teachInfoModel.countryChstr = windowModel.countryChstr;
    teachInfoModel.star = windowModel.star;
    teachInfoModel.levelName = windowModel.levelName;
    teachInfoModel.price = windowModel.price;
    teachInfoModel.sex = windowModel.sex;
    teachInfoModel.isCollect = windowModel.isCollect;
    return teachInfoModel;
}

//- (void)videoTalkSDKManager:(FCVideoTalkSDKManager *)manager actionType:(kVideoTalkActionType)type message:(NSString *)msg error:(NSError *)error {
//    
//}

- (void)stopLoadingView {
    
}

- (void)showHintWithText:(NSString *)text completeBlock:(void (^)())completeBlock {
    
}

#pragma mark - FZMyAccountRefreshDelegate

//- (void)shouldReloadAccountPage { //重新获取可通话时间
//    NSString *userIDTmp = self.chatListModel.targetUId;
//    
//    WEAKSELF
//    [self.callServer checkStatusBeforeCallWithTeacherId:userIDTmp type:1 success:^(NSInteger statusCode, NSString *message, id dataObject) {
//        [_delegate stopLoadingView];
//        if (statusCode == kFZRequestStatusCodeSuccess) {
//            FZStatusCheckModel *model = (FZStatusCheckModel *)dataObject;
//            weakSelf.chatListModel.restTime = model.availableChattingSeconds;
//            [[FCVideoTalkSDKManager shareInstance] updateUserTalkTime:model.availableChattingSeconds];
//        } else {
//            [_delegate showHintWithText:message];
//        }
//    } failure:^(id responseObject, NSError *error) {
//        [_delegate stopLoadingView];
//        [_delegate showHintWithText:LOCALSTRING(@"network_error")];
//    }];
//    
////    NSMutableDictionary* dicParam = [[NSMutableDictionary alloc] initWithCapacity:2];
////    [dicParam setValue:[FZLoginUser authToken] forKey:@"token"];
////    NSString *userIDTmp = [FZCommonTool getNoPrefixUserID:self.chatListModel.targetUId];
////    [dicParam setValue:userIDTmp forKey:@"tch_id"];
////    [dicParam setValue:@20 forKey:@"timeoutInterval"];
////    
////    WEAKSELF
////    [self.callServer postCallingChattime:dicParam successBlock:^(id responseObject) {
////        FZCallingTopTimeModle* callTopTime = responseObject;
////        if ([FZCommonViewController errorCode:callTopTime.status]) {
////            [_delegate stopLoadingView];
////            return;
////        }
////        if (callTopTime.status != 0) {
////            [_delegate stopLoadingView];
////            [_delegate showHintWithText:callTopTime.message];
////            return ;
////        }
////        FZCalllingTimeModel* callTimeModel = callTopTime.callingTimeModel;
////        weakSelf.chatListModel.restTime = callTimeModel.seconds;
////        callTimeModel.packageAvailable = callTimeModel.packageAvailable == -1 ? 0 : callTimeModel.packageAvailable;
////        [[FCVideoTalkSDKManager shareInstance] updateUserTalkTime:callTimeModel.seconds+callTimeModel.packageAvailable];
////
////    } failBlock:^(id responseObject, NSError *error) {
////        [_delegate stopLoadingView];
////        [_delegate showHintWithText:LOCALSTRING(@"mysetting_errorNetwork")];
////    }];
//
//}

#pragma mark - uialertview delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
//        [self requestVideoTalking];
    }
}

@end
