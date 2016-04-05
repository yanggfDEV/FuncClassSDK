//
//  FCTextChatDetailManager.m
//  FunChatStudent
//
//  Created by 李灿 on 15/10/12.
//  Copyright © 2015年 Feizhu Tech. All rights reserved.
//

#import "FCTextChatDetailManager.h"
#import "FCTextChatView.h"
#import "FCTextChatTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <UIColor+Hex.h>
#import "FCChatModelConvertHandler.h"
#import "FCChatCache.h"
//#import <FCVideoTalkSDKManager.h>
#import "FCChatListModel.h"
#import "FZPhotosViewerViewController.h"
#import "MBProgressHUD.h"
#import "FCChatCache.h"
#import "Strings.h"

#import <MJRefresh.h>
#import "FCChatModelConvertHandler.h"
//#import "FZVideoTalkSDKLocalization.h"
#import "FCJusTalkConfigHandler.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import "DNImagePickerController.h"
#import "DNAsset.h"
//#import "MobClick.h"

@interface FCTextChatDetailManager () <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,InputViewDelegate, UITextViewDelegate, MBProgressHUDDelegate,DNImagePickerControllerDelegate>

{
    FCTextChatView *_textChatView;
    UITextField *_textField;
    dispatch_queue_t _sendPictureQueue;
}
@property (strong, nonatomic) MBProgressHUD *hud;
@property (nonatomic, strong) FCChatListModel *textChatRoomModel;
@property (nonatomic, strong) FCTextChatTableViewCell *chatCell;
@property (nonatomic, strong) FCChatMessageModel *messageModel;
@property (nonatomic, assign) CGFloat *cellHeight;
@property (nonatomic, strong) NSMutableArray *photoArray;
@property (nonatomic, assign) BOOL isKey;                                      // 判断键盘是否弹出
@property (nonatomic, assign) CGFloat keyHeight;                               // 记录键盘弹出高度
@property (nonatomic, assign) BOOL inControl;
@property (nonatomic, assign) NSInteger refreshPage;
@property (nonatomic, assign) BOOL isTableviewBottom;
@property (nonatomic, assign) CGFloat tableView_OriginalalY;
@property (nonatomic, strong) UIButton *closeButton;
@end

@implementation FCTextChatDetailManager

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _sendPictureQueue = dispatch_queue_create("send_picture.image", nil);
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    if (!_textChatView) {
        _textChatView = [[FCTextChatView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    self.view = _textChatView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // UI刷新
    
    self.hidesBottomBarWhenPushed = YES;
    //_textChatView.backgroundColor = [UIColor colorWithHexString:@"efefef"];
    _textChatView.backgroundColor =[UIColor clearColor];
    _textChatView.chatTableView.backgroundColor = [UIColor clearColor];
    self.keyHeight = 0;
//    self.tableView_OriginalalY = 0;//_isVideoPush ? 45 : 0;
    self.tableView_OriginalalY = 45;
    _textChatView.chatTableView.frame = CGRectMake(0, self.tableView_OriginalalY, _textChatView.frame.size.width, _textChatView.frame.size.height - [self currentNavigationBarHeight] - 44);
    //文字输入框和图片选取
    self.inputTextView = [[FCInputTextView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.inputTextView];
    [self.inputTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(_textChatView.chatTableView.mas_bottom);
        make.height.equalTo(@44);
    }];
    self.inputTextView.commonColorStyle = _isVideoPush ? weiKeStyle : commonStyle;
    [self.inputTextView createUI];
    self.inputTextView.chatTextView.delegate = self;
    self.inputTextView.inputViewDelegate = self;
    [self.inputTextView.sendButton setTitle:LOCALSTRING(@"kSendText") forState:UIControlStateNormal];
    self.inputTextView.chatTextView.layer.borderColor = [UIColor colorWithHexString:@"cecece"].CGColor;
   
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(theRecoveryOfTheKeyboardAction:)];
    tapGesture.cancelsTouchesInView = NO;
    [_textChatView.chatTableView addGestureRecognizer:tapGesture];
    
    [self.inputTextView.sendButton addTarget:self action:@selector(onPressedSendButton:) forControlEvents:UIControlEventTouchUpInside];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendTextMessageEventNotification:) name:kTextChatSendEventNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvTextMessageEventNotification:) name:kTextChatRecvEventNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(errorWindowStatusChanged:) name:KErrorWindowStatusChanged object:nil];
    
    if (_isVideoPush) {
        [self resetAlphaMode];
        self.inputTextView.chatTextView.textColor = [UIColor colorWithHexString:@"333333"];
        self.inputTextView.chatTextView.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.20].CGColor;
        self.inputTextView.chatTextView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
    }else{
        self.inputTextView.chatTextView.textColor = [UIColor colorWithHexString:@"333333"];
    }
    if (_isChaneseTeacher) {
        self.inputTextView.hidden = YES;
    }
    
    _textChatView.backgroundColor =[UIColor clearColor];
    self.view.backgroundColor = [UIColor clearColor];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self registerForKeyboardNotifications];
    if (self.textChatRoomModel.targetUId && self.textChatRoomModel.targetUId.length > 0) {
        [FCChatCache setCurrentTextChatTargetUserID:self.textChatRoomModel.targetUId];
        [FCChatCache cleanNoReadCountWithUserID:self.textChatRoomModel.targetUId];
    }
    
    /**
     *  @author Victor Ji, 15-12-17 10:12:53
     *
     *  根据需要激活输入框
     */
    //if (self.shouldOpenKeyboard) {
        [self.inputTextView.chatTextView becomeFirstResponder];
    //}
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if([self.inputTextView.chatTextView canResignFirstResponder]){
        [self.inputTextView.chatTextView resignFirstResponder];
    }
    [FCChatCache setCurrentTextChatTargetUserID:nil];
}

#pragma mark - Notification event

- (void)sendTextMessageEventNotification:(NSNotification *)notification {
    kChatMessageStatus msgStatus = [[notification.userInfo objectForKey:kTextChatStatusKey] integerValue];
    MessageModel *msgModel = [notification.userInfo objectForKey:kTextChatMessageObjectKey];
    // UI刷新
    FCChatMessageModel * chatMessageModel = [FCChatModelConvertHandler convertMessageModelToChatMessage:msgModel];
    [self refreshMessageStatus:msgStatus messageModel:chatMessageModel];
}

- (void)recvTextMessageEventNotification:(NSNotification *)notification {
    //    kChatMessageStatus msgStatus = [[notification.userInfo objectForKey:kTextChatStatusKey] integerValue];
    MessageModel *msgModel = [notification.userInfo objectForKey:kTextChatMessageObjectKey];
    // UI刷新
    FCChatMessageModel * chatMessageModel = [FCChatModelConvertHandler convertMessageModelToChatMessage:msgModel];
    [self addMessageModel:chatMessageModel];
}

- (void)didPressedSmallVideoWindowNotification:(NSNotification *)notification {
    [self willDismissAllSubViewController];
    if([self.inputTextView.chatTextView canResignFirstResponder]){
        [self.inputTextView.chatTextView resignFirstResponder];
    }
}

- (void)didTermVideoTalkNotification:(NSNotification *)notification {
    [self willDismissAllSubViewController];
}

- (void)willDismissAllSubViewController {

    BOOL isInTextChatVC = NO;
    UIViewController *viewController = self.navigationController.topViewController;
    if (viewController && viewController.childViewControllers.count > 0) {
        isInTextChatVC = YES;
    }
    if (self.presentedViewController) {
        [self dismissViewControllerAnimated:NO completion:nil];
    } else if (viewController && !isInTextChatVC) {
        [self.navigationController popViewControllerAnimated:NO];
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
        
        if ([type isEqualToString:@"public.image"]){
            UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage]; // 获取原始照片
            UIImage *rightImage = [FCIMChatGetImage rotateScreenImage:image];
            [self uploadPictureWithData:rightImage];
        }
    });
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.inputTextView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_textChatView.chatTableView.mas_bottom);
    }];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - DNImagePickerControllerDelegate

- (void)dnImagePickerController:(DNImagePickerController *)imagePickerController sendImages:(NSArray *)imageAssets isFullImage:(BOOL)fullImage
{
    if ([imageAssets count] == 0) {
        [self handlerALAsset:nil imagePickerController:imagePickerController];
        return;
    }
    if ([imageAssets count] > 0) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            __block dispatch_semaphore_t sem = dispatch_semaphore_create(0);
            for (int i = 0; i < [imageAssets count]; i++) {
                DNAsset *dnasset = imageAssets[i];
                dispatch_async(_sendPictureQueue, ^{
                    ALAssetsLibrary *library = [ALAssetsLibrary new];
                    [library assetForURL:dnasset.url
                             resultBlock:^(ALAsset *asset)
                     {
                         if (asset){
                             // SUCCESS POINT #1 - asset is what we are looking for
                             [self handlerALAsset:asset imagePickerController:imagePickerController];
                            dispatch_semaphore_signal(sem);
                         }
                         else {
                             // On iOS 8.1 [library assetForUrl] Photo Streams always returns nil. Try to obtain it in an alternative way
                             
                             [library enumerateGroupsWithTypes:ALAssetsGroupPhotoStream
                                                    usingBlock:^(ALAssetsGroup *group, BOOL *stop)
                              {
                                  [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                                      if([result.defaultRepresentation.url isEqual:dnasset.url])
                                      {
                                          // SUCCESS POINT #2 - result is what we are looking for
                                          [self handlerALAsset:result imagePickerController:imagePickerController];
                                          *stop = YES;
                                          dispatch_semaphore_signal(sem);
                                      }
                                  }];
                              } failureBlock:^(NSError *error)
                              {
                                  NSLog(@"Error: Cannot load asset from photo stream - %@", [error localizedDescription]);
                                  [self handlerALAsset:nil imagePickerController:imagePickerController];
                                  dispatch_semaphore_signal(sem);
                              }];
                         }
                     } failureBlock:^(NSError *error) {
                         NSLog(@"Error: Cannot load asset - %@", [error localizedDescription]);
                         [self handlerALAsset:nil imagePickerController:imagePickerController];
                         dispatch_semaphore_signal(sem);
                     }];
                });
                dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
            }
        });
    }
}

- (void)handlerALAsset:(ALAsset *)asset imagePickerController:(DNImagePickerController *)imagePickerController
{
    UIImage *image;
    if (asset) {
        NSNumber *orientationValue = [asset valueForProperty:ALAssetPropertyOrientation];
        UIImageOrientation orientation = UIImageOrientationUp;
        if (orientationValue != nil) {
            orientation = [orientationValue intValue];
        }
        
        image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        UIImage *rightImage = [FCIMChatGetImage rotateScreenImage:image];
        [self uploadPictureWithData:rightImage];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [imagePickerController dismissViewControllerAnimated:YES completion:nil];
    });
}

- (void)dnImagePickerControllerDidCancel:(DNImagePickerController *)imagePicker
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)uploadPictureWithData:(UIImage *)avatarData
{
    NSData *imageData;
    imageData = UIImageJPEGRepresentation(avatarData, 0.5);
    
    [self sendPic:[UIImage imageWithData:imageData]];
}

#pragma mark 发送状态
- (void)stopLoadingView {
    [MBProgressHUD hideHUDForView:_textChatView.chatTableView animated:YES];
    if (self.hud) {
        [self.hud hide:YES];
    }
}

- (void)startLoadingViewWithText:(NSString *)text
{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:_textChatView.chatTableView animated:YES];
    HUD.delegate = self;
    self.hud = HUD;
    
    self.hud.labelText = text;
    [self.hud show:YES];
    
}

#pragma mark - public function

- (void)resetAlphaMode{
    
//    if()如果一开始就知道对方摄像头关闭，起始点是25
    self.closeButton = [[UIButton alloc] initWithFrame:CGRectMake(15, self.needAdjustOriginY ? 25:5, 44, 44)];
    self.closeButton.imageEdgeInsets = UIEdgeInsetsMake(4, 4, -4, -4);
    [self.closeButton setImage:[UIImage imageNamed:@"common_close_left"] forState:UIControlStateNormal];
    [self.closeButton addTarget:self action:@selector(dismissViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.closeButton];
    
    UIView *backGroundView = [[UIView alloc] initWithFrame:self.view.frame];
    backGroundView.backgroundColor = [UIColor blackColor];
    backGroundView.alpha = .5;
    [self.view addSubview:backGroundView];
    [self.view sendSubviewToBack:backGroundView];
    
    self.view.superview.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor clearColor];
    _textChatView.chatTableView.backgroundColor = [UIColor clearColor];
    _textChatView.backgroundColor = [UIColor clearColor];
}

- (void)resetTargetUCID:(NSString *)ucid {
    if (ucid) {
        self.textChatRoomModel.targetUcid = ucid;
    }
}

- (void)setIsVideoPush:(BOOL)isVideoPush {
    if (isVideoPush) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didTermVideoTalkNotification:) name:kTextChatPopTeacherInfoNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didPressedSmallVideoWindowNotification:) name:kTextChatPressedSmallVideoWindowNotification object:nil];
    }
    _isVideoPush = isVideoPush;
}

- (void)setChatListModel:(FCChatListModel *)model {
    self.refreshPage = 0;
    // 知会缓存，告知当前页面UserID
    if (model.targetUId && model.targetUId.length > 0) {
        [FCChatCache setCurrentTextChatTargetUserID:model.targetUId];
    }
    // 获取消息缓存
    _resultArray = [NSMutableArray array];
    NSMutableArray *msgArray = [DataBaseManager selectMessageTable:self.confId];
    [DataBaseManager updateMessageTable:self.confId];
    for (MessageModel *model in msgArray) {
        FCChatMessageModel *chatMessageModel = [FCChatModelConvertHandler convertMessageModelToChatMessage:model];
        if ([self.resultArray containsObject:chatMessageModel] == NO) {
            [self.resultArray addObject:chatMessageModel];
        }
    }
     if (!_textChatView) {
        _textChatView = [[FCTextChatView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    _textChatView.chatTableView.delegate = self;
    _textChatView.chatTableView.dataSource = self;
    [_textChatView.chatTableView reloadData];
    
    _textChatView.chatTableView.header.hidden = self.resultArray.count < 50 ? YES : NO;
    if (_resultArray.count != 0) {
        NSInteger count = _resultArray.count - 1;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:count];
        if (_textChatView.chatTableView.visibleCells.count > 0 && count > 0 && count < [self numberOfSectionsInTableView:_textChatView.chatTableView]) {
            [_textChatView.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
        }
    }
    
    [self refresh];
}

- (void)refreshSetChatListModel:(FCChatListModel *)model refreshPage:(NSInteger)page{
    // 知会缓存，告知当前页面UserID
    if (model.targetUId && model.targetUId.length > 0) {
        [FCChatCache setCurrentTextChatTargetUserID:model.targetUId];
    }

    // 获取消息缓存
    NSArray *messageList = [FCChatCache chatContentWithUserID:model.targetUId pageCount:page];
    model.messageList = [NSMutableArray arrayWithArray:messageList];
    self.textChatRoomModel = model;
    [self.resultArray removeAllObjects];
    for (int i = 0; i < model.messageList.count ; i++) {
        FCChatMessageModel *messageModel = model.messageList[i];
        [_resultArray addObject:messageModel];
    }
   
    [_textChatView.chatTableView reloadData];
    _textChatView.chatTableView.header.hidden = self.resultArray.count < kDefaultChatMessageCount * (page + 1) ? YES : NO;

    if (_resultArray.count != 0) {
        NSInteger count = _resultArray.count - self.refreshPage * kDefaultChatMessageCount;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:count];
        if (_textChatView.chatTableView.visibleCells.count > 0 && count > 0 && count < [self numberOfSectionsInTableView:_textChatView.chatTableView]) {
            [_textChatView.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
        }
    }
}

- (void)refreshMessageStatus:(kChatMessageStatus)msgStatus messageModel:(FCChatMessageModel *)msgModel {
    if ([_delegate respondsToSelector:@selector(teacherRefreshModel:time:)]) {
        [_delegate teacherRefreshModel:msgModel.content time:msgModel.timestamp];
    }
    NSInteger section = -1;
    BOOL bHasMessage = NO;
    for (int i = 0; i < _resultArray.count; ++ i) {
        FCChatMessageModel *msgModelTmp = _resultArray[i];
        if (msgModel.timestamp == msgModelTmp.timestamp) {
            [_resultArray replaceObjectAtIndex:i withObject:msgModel];
            section = i;
            bHasMessage = YES;
            break;
        }
    }
    if (!bHasMessage) {
        [_resultArray addObject:msgModel];
    }
    if (section < 0) {
        section = _resultArray.count - 1;
    }
    [_textChatView.chatTableView reloadData];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    if (section > 0 && section < [self numberOfSectionsInTableView:_textChatView.chatTableView]) {
        NSArray *visibleCells = [_textChatView.chatTableView visibleCells];
        if (visibleCells.count > 0) {
            [_textChatView.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
        }
    }
}

- (void)addMessageModel:(FCChatMessageModel *)messageModel {
//    if (![messageModel.userID isEqualToString:self.textChatRoomModel.targetUId]) {
//        return;
//    }
    if ([_delegate respondsToSelector:@selector(teacherRefreshModel:time:)]) {
        [_delegate teacherRefreshModel:messageModel.content time:[messageModel.messageDate intValue]];
    }
    if (messageModel.messageType == kChatMessageTypeOfPic) {
        if (_resultArray.count > 0) {
            FCChatMessageModel *model = _resultArray[_resultArray.count - 1];
            if (messageModel.messagePicFileName.length != 0 && (model.timestamp != messageModel.timestamp)) {
                [_resultArray addObject:messageModel];
            }
        } else if (_resultArray.count == 0 && messageModel.messagePicFileName.length != 0) {
            [_resultArray addObject:messageModel];
        }
    } else {
        [_resultArray addObject:messageModel];
    }
    CGPoint contentOffsetPoint = _textChatView.chatTableView.contentOffset;
    CGRect frame = _textChatView.chatTableView.frame;
    if (contentOffsetPoint.y + 40 >= _textChatView.chatTableView.contentSize.height - frame.size.height || _textChatView.chatTableView.contentSize.height < frame.size.height)
    {
        self.isTableviewBottom = YES;
    } else {
        self.isTableviewBottom = NO;
    }
    [_textChatView.chatTableView reloadData];
    if (_isTableviewBottom) {
        NSInteger count = _resultArray.count - 1;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:count];
        if (count > 0 && count < [self numberOfSectionsInTableView:_textChatView.chatTableView]) {
            NSArray *visibleCells = [_textChatView.chatTableView visibleCells];
            if (visibleCells.count > 0) {
                [_textChatView.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
            }
        }
    }
}

#pragma mark - private function

- (NSInteger)currentNavigationBarHeight {
    if (self.navigationController) {
        return 64;
    } else {
        return 45;
    }
}

- (void)dismissViewController {
    [[NSNotificationCenter defaultCenter] postNotificationName:kTextChatIntoVideoNotification object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -  refresh
- (void)refresh
{
    if (_resultArray.count >= kDefaultChatMessageCount) {
        [_textChatView.chatTableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    }
}

- (void)headerRereshing
{
    ++self.refreshPage;
    [self refreshSetChatListModel:self.textChatRoomModel refreshPage:self.refreshPage];
    [_textChatView.chatTableView.header endRefreshing];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _resultArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FCChatMessageModel *messageModel = [_resultArray objectAtIndex:indexPath.section];
    UIFont *font = [UIFont systemFontOfSize:14];
    CGSize size = [messageModel.content sizeWithFont:font constrainedToSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 150, 20000.0f) lineBreakMode:NSLineBreakByWordWrapping];
    if (messageModel.messageType == kChatMessageTypeOfPic) {
        UIImage *cellImage = [UIImage imageWithContentsOfFile:[messageModel thumbnailPicPath]];
        CGFloat cellHeight = cellImage.size.height / ([UIScreen mainScreen].scale);
        if (cellHeight < 40) {
            return 50;
        }
        return cellHeight + 10.0f + 20;
    } else if (messageModel.messageType == kChatMessageTypeOfVideo) {
        CGSize size = [messageModel.content sizeWithFont:font constrainedToSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 170, 20000.0f) lineBreakMode:NSLineBreakByWordWrapping];
        return size.height + 34;
    }
    NSInteger baseCellHeight = messageModel.isMy?0.0f:(20 + 0.0f);
    return size.height+34 + baseCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"textChatCell";
    FCTextChatTableViewCell *cell;
    if (!cell) {
        cell = [[FCTextChatTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }else{
        for (UIView *cellView in cell.subviews){
            [cellView removeFromSuperview];
        }
    }

    if (indexPath.section == _resultArray.count - 1) {
        cell.isHub = YES;
    }
    cell.isVideoPush = self.isVideoPush;
     cell.messageModel = [_resultArray objectAtIndex:indexPath.section];
    //创建头像
    UIImageView *photo;
    if (cell.messageModel.isMy) {
        photo = [[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width- 55, 0, 40, 40)];
        photo.layer.masksToBounds = YES;
        photo.layer.cornerRadius = 20;
        photo.contentMode = UIViewContentModeScaleAspectFill;
        [photo sd_setImageWithURL:[NSURL URLWithString:[[FZLoginUser avatar] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
        
        [cell addSubview:photo];
    } else {
        /* @guangfu yang 16-2-23 12:00
         * 聊天界面加名称
         **/
        FZStyleSheet *css = [[FZStyleSheet alloc] init];
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = css.fontOfH4;
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.frame = CGRectMake(72, 0, 100, 20);
        nameLabel.text = cell.messageModel.targetIDPrefix;
        [cell addSubview:nameLabel];
        
        photo = [[UIImageView alloc]initWithFrame:CGRectMake(15, 0, 40, 40)];
        photo.layer.masksToBounds = YES;
        photo.layer.cornerRadius = 20;
        [photo sd_setImageWithURL:[NSURL URLWithString:[cell.messageModel.messagePicFileName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
        photo.userInteractionEnabled = YES;
        photo.contentMode = UIViewContentModeScaleAspectFill;
        UITapGestureRecognizer *photoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapUserHead:)];
        [photo addGestureRecognizer:photoTap];
       
        [cell addSubview:photo];
    }
    
    cell.tapChatBlock = ^(){
        [self tapChatMessage:indexPath.section];
    };
    
    cell.tapSendImage = ^(){
        [self tapSendImage:indexPath];
    };
    if (_isVideoPush) {
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.bubbleImageView.alpha = .8;
    } else {
        cell.backgroundColor = [UIColor colorWithHexString:@"efefef"];
    }
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell.longPressGesture addTarget:self action:@selector(cellLongPress:)];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section > 0) {
        FCChatMessageModel *isHeaderTimeModel = _resultArray[section];
        FCChatMessageModel *isHeaderTimeRearModel = _resultArray[section - 1];
        if ((isHeaderTimeModel.timestamp - isHeaderTimeRearModel.timestamp) < 60) {
            return 0.0f;
        }
    }
    return 25.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    FCChatMessageModel *messageModel = _resultArray[section];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30)];
    UILabel *tableviewHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 100, 0, 200, 20)];
    NSString *text = [FCChatModelConvertHandler getMonthTime:messageModel.timestamp isChStyle:[FCJusTalkConfigHandler IsChineseLanguage]];
    [tableviewHeaderLabel setText:text];
    [tableviewHeaderLabel setTextColor:[UIColor colorWithHexString:@"888888"]];
    tableviewHeaderLabel.font = [UIFont systemFontOfSize:14.0f];
    [tableviewHeaderLabel setTextAlignment:NSTextAlignmentCenter];
    //[headerView setBackgroundColor:[UIColor colorWithHexString:@"efefef"]];
    [headerView setBackgroundColor:[UIColor clearColor]];

    [headerView addSubview:tableviewHeaderLabel];
    if (_isVideoPush) {
        headerView.backgroundColor = [UIColor clearColor];
        tableviewHeaderLabel.backgroundColor = [UIColor clearColor];
    }
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - UIScrollviewDelegate
// 消除header显示在屏幕上
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if([scrollView isKindOfClass:[UITextView class]]){
        scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        CGFloat terminalHeight = 110/6*5;
        CGFloat height = self.inputTextView.chatTextView.contentSize.height >= terminalHeight? terminalHeight: self.inputTextView.chatTextView.contentSize.height;
        
        [self.inputTextView.chatTextView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(height));
        }];
        _textChatView.chatTableView.frame = CGRectMake(0, self.tableView_OriginalalY, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height - _keyHeight - height - 14 - [self currentNavigationBarHeight]);

        [self.inputTextView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
//            make.top.equalTo(_textChatView.chatTableView.mas_bottom).offset(-22);
            make.top.equalTo(_textChatView.chatTableView.mas_bottom);
            make.height.equalTo(@(height+14));
        }];
        
        if( height < terminalHeight){
            self.inControl = YES;
            [self.inputTextView.chatTextView scrollRangeToVisible:NSMakeRange([self.inputTextView.chatTextView.text length], 1)];
            return;
        }else if(height == terminalHeight){
            self.inControl = NO;
        }
        return;
    }
    CGFloat sectionHeaderHeight = 30;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.inputTextView.chatTextView resignFirstResponder];
}

#pragma mark - event

- (void)sendText:(NSString *)text {
    
    
    NSString *headPrefixUrl = [FCChatCache headPicPathPrefix];
    
    FCUserTextExtraModel *extraModel = [[FCUserTextExtraModel alloc] init];
    extraModel.confid = self.confId;
    extraModel.uid = [FZLoginUser userID];
    extraModel.ucid = [FZLoginUser userID];
    extraModel.userName = [FZLoginUser nickname];
    NSString *myAvatarUrl = [FZLoginUser avatar];
    if (myAvatarUrl && myAvatarUrl.length > headPrefixUrl.length) {
        extraModel.avatarName =  myAvatarUrl;
    }

    extraModel.targetUid = self.textChatRoomModel.targetUId;
    extraModel.targetUcid = self.textChatRoomModel.targetUcid;
    extraModel.targetIDPrefix = self.textChatRoomModel.targetIDPrefix;
    extraModel.targetUserName = self.textChatRoomModel.targetNickname;
    if (self.textChatRoomModel.targetAvatarUrl && self.textChatRoomModel.targetAvatarUrl.length > headPrefixUrl.length) {
        extraModel.targetAvatarName = [self.textChatRoomModel.targetAvatarUrl substringFromIndex:headPrefixUrl.length];
    }
    
    [extraModel judgeNull];
    [[FZJusMeettingSDKManager shareInstance] sendText:text extraModel:extraModel];
}

- (void)sendPic:(UIImage *)image {
    NSString *headPrefixUrl = [FCChatCache headPicPathPrefix];

    FCUserTextExtraModel *extraModel = [[FCUserTextExtraModel alloc] init];
    extraModel.uid = self.textChatRoomModel.myUId;
    extraModel.ucid = self.textChatRoomModel.myUCID;
    extraModel.userName = self.textChatRoomModel.myNickname;
    
    // justalk根据文件名，文件名必须唯一
    static NSInteger addPicFileName = 1;
    extraModel.picMessageName = [NSString stringWithFormat:@"%zd_%zd.jpg", [[NSDate date] timeIntervalSince1970], addPicFileName ++];
    if (self.textChatRoomModel.myAvatarUrl && self.textChatRoomModel.myAvatarUrl.length > headPrefixUrl.length) {
        extraModel.avatarName = [self.textChatRoomModel.myAvatarUrl substringFromIndex:headPrefixUrl.length];
    }
    extraModel.targetUid = self.textChatRoomModel.targetUId;
    extraModel.targetUcid = self.textChatRoomModel.targetUcid;
    extraModel.targetIDPrefix = self.textChatRoomModel.targetIDPrefix;
    extraModel.targetUserName = self.textChatRoomModel.targetNickname;
    if (self.textChatRoomModel.targetAvatarUrl && self.textChatRoomModel.targetAvatarUrl.length > headPrefixUrl.length) {
        extraModel.targetAvatarName = [self.textChatRoomModel.targetAvatarUrl substringFromIndex:headPrefixUrl.length];
    }
    [extraModel judgeNull];
    [[FZJusMeettingSDKManager shareInstance] sendPicture:image extraModel:extraModel];
}

- (void)onPressedSendButton:(UIButton *)sender {
    if (self.inputTextView.chatTextView.text.length == 0) {
        return;
    }
    [self sendText:self.inputTextView.chatTextView.text];
    
    _textChatView.chatTableView.frame = CGRectMake(0, self.tableView_OriginalalY, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height - _keyHeight - [self currentNavigationBarHeight] - 44);

    [self.inputTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
//        make.top.equalTo(_textChatView.chatTableView.mas_bottom).offset(-22);
        make.top.equalTo(_textChatView.chatTableView.mas_bottom);
        make.height.equalTo(@44);
    }];
    self.inputTextView.chatTextView.text = nil;
    self.inputTextView.sendButton.enabled = NO;
    self.inputTextView.chatTextView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
    [self changeSendButtonStateWithAlpha:0.2];
}

- (void)videoButtonAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - UITapGestureRecognizer
- (void)theRecoveryOfTheKeyboardAction:(UITapGestureRecognizer *)sender
{
    [self.inputTextView.chatTextView resignFirstResponder];
}

- (void)tapUserHead:(UITapGestureRecognizer *)sender
{
    if ([_delegate respondsToSelector:@selector(chatManagerTapTeacherPhoto:)]) {
        [_delegate chatManagerTapTeacherPhoto:self.textChatRoomModel.targetUId];
    }
}

- (void)tapChatMessage:(NSInteger)section {
    if (_resultArray.count <= section) {
        return;
    }
    FCChatMessageModel *messageModel = [_resultArray objectAtIndex:section];
    switch (messageModel.messageType) {
        case kChatMessageTypeOfPic:
        {
            // 点击图片
            [self tapChatImage:section];
        }
            break;
        case kChatMessageTypeOfVideo:
        {
//            [MobClick event:@"kTextChatCallFailure"];
            // 点击视频通话消息
            [self tapVideoTalkMessage:section];
        }
            break;
            
        default:
            break;
    }
}

- (void)tapVideoTalkMessage:(NSInteger)section {
    if ([_delegate respondsToSelector:@selector(chatManagerVideoTalk)]) {
        [_delegate chatManagerVideoTalk];
    }
}

- (void)tapChatImage:(NSInteger)section
{
    self.photoArray = [NSMutableArray array];
    int j = 0, k;
    for (int i = 0; i < _resultArray.count; i++) {
        FCChatMessageModel *messageModel = _resultArray[i];
        if (messageModel.messageType == kChatMessageTypeOfPic) {
            j++;
            FZPhotosViewerModel *item = [[FZPhotosViewerModel alloc] init];
            item.icon = [messageModel originPicPath];
            item.image = [UIImage imageWithContentsOfFile:[messageModel originPicPath]];
            [self.photoArray addObject:item];
            if (i == section) {
                k = j - 1;
            }
        }
    }

    FZPhotosViewerViewController *photosVC = [[FZPhotosViewerViewController alloc] initWithPhotos:self.photoArray currentIndex:k];
    photosVC.isEnglish = self.isShowEnglish;
    [self presentViewController:photosVC animated:YES completion:nil];
//    if (_isVideoPush) {
//    } else {
//        [self.navigationController pushViewController:photosVC animated:YES];
//    }
}

- (void)tapSendImage:(NSIndexPath *)indexPath
{
    FCChatMessageModel *messageModel = _resultArray[indexPath.section];
    UIImage *picImage = [UIImage imageWithContentsOfFile:[messageModel thumbnailPicPath]];
    
    [FCChatCache deleteChatMessage:messageModel];
    if (self.resultArray.count > indexPath.section) {
        [self.resultArray removeObjectAtIndex:indexPath.section];//移除数据源的数据
    }
    [_textChatView.chatTableView deleteSections:[NSIndexSet indexSetWithIndex: indexPath.section] withRowAnimation:UITableViewRowAnimationBottom];
    
    if (messageModel.messageType == kChatMessageTypeOfText) {
        [self sendText:messageModel.content];
    } else if (messageModel.messageType == kChatMessageTypeOfPic) {
        [self sendPic:picImage];
    }

}
#pragma mark - UILongPressGestureRecognizer
- (void)cellLongPress:(UIGestureRecognizer *)recognizer{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint location = [recognizer locationInView:_textChatView.chatTableView];
        NSIndexPath * indexPath = [_textChatView.chatTableView indexPathForRowAtPoint:location];
        FCTextChatTableViewCell *cell = (FCTextChatTableViewCell *)recognizer.view;
        self.chatCell = cell;
        //这里把cell做为第一响应(cell默认是无法成为responder,需要重写canBecomeFirstResponder方法)
        [cell becomeFirstResponder];
        if (_isKey) {
            [self.inputTextView.chatTextView becomeFirstResponder];
        }

        FCChatMessageModel *menuMessageModel = _resultArray[indexPath.section];
        self.messageModel = menuMessageModel;
        
        UIMenuItem *itResend = [[UIMenuItem alloc] initWithTitle:LOCALSTRING(@"kResend") action:@selector(handleResendCell:)];
        UIMenuItem *itCopy = [[UIMenuItem alloc] initWithTitle:LOCALSTRING(@"kCopy") action:@selector(handleCopyCell:)];
        UIMenuItem *itDelete = [[UIMenuItem alloc] initWithTitle:LOCALSTRING(@"kDelete") action:@selector(handleDeleteCell:)];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        if (menuMessageModel.isFailed && menuMessageModel.messageType == kChatMessageTypeOfPic) {
            [menu setMenuItems:[NSArray arrayWithObjects:itResend,itDelete,nil]];
        } else if (menuMessageModel.isFailed && menuMessageModel.messageType == kChatMessageTypeOfText) {
            [menu setMenuItems:[NSArray arrayWithObjects:itResend,itCopy,itDelete,nil]];
        } else if ((!menuMessageModel.isFailed) && (menuMessageModel.messageType == kChatMessageTypeOfPic || menuMessageModel.messageType == kChatMessageTypeOfVideo)) {
            [menu setMenuItems:[NSArray arrayWithObjects:itDelete,nil]];
        } else if ((!menuMessageModel.isFailed) && (menuMessageModel.messageType == kChatMessageTypeOfText)) {
            [menu setMenuItems:[NSArray arrayWithObjects:itCopy,itDelete,nil]];
        }
        switch (menuMessageModel.messageType) {
            case kChatMessageTypeOfText:
                [menu setTargetRect:cell.cellView.frame inView:cell];
                break;
            case kChatMessageTypeOfPic:
                [menu setTargetRect:cell.cellImageView.frame inView:cell];
                break;
            case kChatMessageTypeOfVideo:
                [menu setTargetRect:cell.videoButton.frame inView:cell];
                break;
            default:
                break;
        }
        [menu setMenuVisible:YES animated:YES];
    }
}
#pragma mark - cell event
- (void)handleCopyCell:(id)sender{//复制
    FCChatMessageModel *messageModel = self.messageModel;
    if (messageModel.messageType == kChatMessageTypeOfText) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = messageModel.content;
    }
}

- (void)handleDeleteCell:(id)sender{//删除cell
    NSIndexPath *indexPath = [_textChatView.chatTableView indexPathForCell:_chatCell];
    FCChatMessageModel *messageModel = self.messageModel;
    [FCChatCache deleteChatMessage:messageModel];
    if (self.resultArray.count > indexPath.section) {
        [self.resultArray removeObjectAtIndex:indexPath.section];//移除数据源的数据
    }
    
    [_textChatView.chatTableView deleteSections:[NSIndexSet indexSetWithIndex: indexPath.section] withRowAnimation:UITableViewRowAnimationBottom];
    
    if (_resultArray.count > 0) {
        if ([_delegate respondsToSelector:@selector(teacherRefreshModel:time:)]) {
            [_delegate teacherRefreshModel:[_resultArray[_resultArray.count - 1] content] time:[[_resultArray[_resultArray.count - 1] messageDate] intValue]];
        }
    }
}

- (void)handleResendCell:(id)sender{// 重发
    NSIndexPath *indexPath = [_textChatView.chatTableView indexPathForCell:_chatCell];
    FCChatMessageModel *messageModel = self.messageModel;
    UIImage *picImage = [UIImage imageWithContentsOfFile:[messageModel thumbnailPicPath]];

    [FCChatCache deleteChatMessage:messageModel];
    if (self.resultArray.count > indexPath.section) {
        [self.resultArray removeObjectAtIndex:indexPath.section];//移除数据源的数据
    }
    [_textChatView.chatTableView deleteSections:[NSIndexSet indexSetWithIndex: indexPath.section] withRowAnimation:UITableViewRowAnimationBottom];

    if (messageModel.messageType == kChatMessageTypeOfText) {
        [self sendText:messageModel.content];
    } else if (messageModel.messageType == kChatMessageTypeOfPic) {
        [self sendPic:picImage];
    }
}

#pragma mark 处理action事件
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    if(action ==@selector(handleCopyCell:)){
        return YES;
    }else if (action==@selector(handleDeleteCell:)){
        return YES;
    }
    return [super canPerformAction:action withSender:sender];
}

#pragma mark -监听键盘Height

- (void)registerForKeyboardNotifications
{
    //使用NSNotificationCenter 鍵盤出現時
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardDidShown:)
     
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    //使用NSNotificationCenter 鍵盤隐藏時
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    
}

//实现当键盘出现的时候计算键盘的高度大小。用于输入框显示位置
- (void)keyboardDidShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    //kbSize即為鍵盤尺寸 (有width, height)
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    [UIView animateWithDuration:0.5 animations:^{
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height - kbSize.height);

        _textChatView.chatTableView.frame = CGRectMake(_textChatView.chatTableView.frame.origin.x, _textChatView.chatTableView.frame.origin.y, _textChatView.chatTableView.frame.size.width, self.view.frame.size.height - [self currentNavigationBarHeight] - self.inputTextView.frame.size.height);
        if (_resultArray.count != 0) {
            NSInteger count = _resultArray.count - 1;

            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:count];
            if (_textChatView.chatTableView.visibleCells.count > 0 && count > 0 && count < [self numberOfSectionsInTableView:_textChatView.chatTableView]) {
                [_textChatView.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
            }
        }
        _isKey = YES;
        self.keyHeight = kbSize.height;
    }];
}

//当键盘隐藏的时候
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [UIView animateWithDuration:0.5 animations:^{
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height);
        _isKey = NO;
    }];
    if (_textChatView.chatTableView.contentSize.height < self.view.frame.size.height - [self currentNavigationBarHeight] - self.inputTextView.frame.size.height) {
        [_textChatView.chatTableView setContentOffset:CGPointMake(0, 0) animated:NO];
    }
    _textChatView.chatTableView.frame = CGRectMake(0, self.tableView_OriginalalY, self.view.frame.size.width, self.view.frame.size.height - [self currentNavigationBarHeight] - self.inputTextView.frame.size.height);
    
    self.inputTextView.frame = CGRectMake(0, _textChatView.chatTableView.frame.origin.y + _textChatView.chatTableView.frame.size.height, self.view.frame.size.width, self.inputTextView.frame.size.height);
    self.keyHeight = 0;
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView{
    [textView scrollRangeToVisible:NSMakeRange([self.inputTextView.chatTextView.text length], 0)];
}

// 5
- (void)textViewDidChange:(UITextView *)textView{
    if(self.inControl == NO){
        [textView scrollRangeToVisible:NSMakeRange([self.inputTextView.chatTextView.text length], 1)];
    }
    if([textView.text isEqualToString:@""]){
        self.inputTextView.chatTextView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
        self.inputTextView.sendButton.enabled = NO;
        [self changeSendButtonStateWithAlpha:0.2];
    }else{
        self.inputTextView.chatTextView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:1];
        self.inputTextView.sendButton.enabled = YES;
        [self changeSendButtonStateWithAlpha:0.6];
    }
}

- (void)changeSendButtonStateWithAlpha:(CGFloat)alpha
{
    if(!_isVideoPush){
        UIColor *sendButtonColor;
        if(alpha < 0.5){
            sendButtonColor=[UIColor colorWithHexString:@"cecece"];
        }else{
            sendButtonColor =[UIColor colorWithHexString:@"439cf4"];
        }
        alpha = 1;
        self.inputTextView.sendButton.layer.borderColor = [sendButtonColor colorWithAlphaComponent:alpha].CGColor;
        [self.inputTextView.sendButton setTitleColor:[sendButtonColor colorWithAlphaComponent:alpha] forState:UIControlStateNormal];
    }else{
        self.inputTextView.sendButton.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:alpha].CGColor;
        [self.inputTextView.sendButton setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:alpha] forState:UIControlStateNormal];
    }

}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {
        [self onPressedSendButton:nil];
        return NO;
    }
    if([textView.text isEqualToString:@""]){
        self.inputTextView.sendButton.enabled = NO;
        self.inputTextView.chatTextView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
        [self changeSendButtonStateWithAlpha:0.2];
    }
    
    CGFloat terminalHeight = 110/6*5;
    CGFloat height = textView.contentSize.height > terminalHeight? terminalHeight: textView.contentSize.height + 3;
    
    [self.inputTextView.chatTextView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(height));
    }];
    _textChatView.chatTableView.frame = CGRectMake(0, self.tableView_OriginalalY, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height - _keyHeight - height - 14 - [self currentNavigationBarHeight]);
    
    [self.inputTextView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
//        make.top.equalTo(_textChatView.chatTableView.mas_bottom).offset(-22);
        make.top.equalTo(_textChatView.chatTableView.mas_bottom);
        make.height.equalTo(@(height+14));
    }];
    
    
    [textView scrollRectToVisible:CGRectMake(0, textView.frame.origin.y, textView.frame.size.width, textView.contentSize.height) animated:NO];
    
    
    return YES;
}

#pragma mark -InputTextViewDelegate

- (void)showpicture
{
//    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
//    imagePicker.delegate = self;
//    imagePicker.allowsEditing = NO; // 头像允许编辑
//    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    
//    [self presentViewController:imagePicker animated:YES completion:nil];
    // 加载系统相册，支持多选
    // 统计点击发送图片按钮
//    [MobClick event:@"kTextChatSendPhoto"];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithHexString:@"34495e"]];
    
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          [UIColor whiteColor], NSForegroundColorAttributeName,
                                                          [UIFont systemFontOfSize:19.], NSFontAttributeName, nil]];
    
    DNImagePickerController *imagePicker = [[DNImagePickerController alloc] init];
    imagePicker.imagePickerDelegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - item定制化配置

- (void)addLeftButtonWithTypeexitVCType {
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat iconWidth, iconHeight;
    NSString *iconDefaultName, *iconHighlighName;
 
    iconWidth = iconHeight = 22;
    iconDefaultName = @"common_close.png";
    iconHighlighName = @"";
    
    CGRect naviRect = self.navigationController.navigationBar.frame;
    CGRect rect = CGRectMake(10, (naviRect.size.height - iconHeight) / 2, iconWidth, iconHeight);
    leftButton.frame = rect;
    
    if (iconDefaultName && iconDefaultName.length > 0) {
        [leftButton setImage:[UIImage imageNamed:iconDefaultName] forState:UIControlStateNormal];
        
        if (iconHighlighName && iconHighlighName.length > 0) {
            [leftButton setImage:[UIImage imageNamed:iconHighlighName] forState:UIControlStateHighlighted];
        }
    }
    
//    [leftButton addTarget:self action:@selector(onPressedLeftButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
}

#pragma mark -对方摄像头状态发生变化导致ErrorWindow发生变化

- (void)errorWindowStatusChanged:(NSNotification *)notification
{
    BOOL hidden = [[notification.userInfo objectForKey:@"ErrorWindowStatus"] boolValue];

    if(hidden){
        CGRect frame = self.closeButton.frame;
        frame.origin.y = 5;
        self.closeButton.frame = frame;
        
//        _textChatView.chatTableView.frame
    }else{
        CGRect frame = self.closeButton.frame;
        frame.origin.y = 25;
        self.closeButton.frame = frame;
    }
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
