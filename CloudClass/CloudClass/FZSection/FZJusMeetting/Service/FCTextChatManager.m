//
//  FCTextChatManager.m
//  Pods
//
//  Created by 刘滔 on 15/10/8.
//
//

#import "FCTextChatManager.h"
#import "MessageModel.h"
#import "FZJusMeettingSDKManager.h"
#import "mtc_im.h"
#import "mtc_user.h"
#import "FCChatMessageModel.h"
#import "FCChatModelConvertHandler.h"
#import "FCChatCache.h"
#import "FCIMChatGetImage.h"

static NSInteger   _backgroundNoReadNumber = 0;

@implementation FCTextChatManager
{
    NSMutableArray *_msgArray;  // 正在发送的消息对象需要保存起来，否则会崩溃
    BOOL _isEnterBackground;
}

#pragma mark - life cycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initNotification];
        [DataBaseManager openDataBase];
        [DataBaseManager createMessageTable];
        
        _msgArray = [NSMutableArray array];
        _isEnterBackground = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)willEnterForeground:(NSNotification *)notification {
    _isEnterBackground = NO;
}

- (void)didEnterBackground:(NSNotification *)notification {
    _isEnterBackground = YES;
}

// 设置本地通知
+ (void)registerLocalNotification:(FCChatWindowModel *)windowModel {
    if (!windowModel.userName || !windowModel.userID) {
        return;
    }
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    // 设置触发通知的时间
    NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:0.1];
    NSLog(@"fireDate=%@",fireDate);
    
    notification.fireDate = fireDate;
    // 时区
    notification.timeZone = [NSTimeZone defaultTimeZone];
    
    // 设置未读消息数
    _backgroundNoReadNumber ++;
    
    // 通知内容
    notification.alertBody =  [NSString stringWithFormat:@"%@: %@", windowModel.userName, windowModel.recentMessageContent];
    notification.applicationIconBadgeNumber = _backgroundNoReadNumber;
    // 通知被触发时播放的声音
    notification.soundName = UILocalNotificationDefaultSoundName;
    // 通知参数
    NSDictionary *userDict = [NSDictionary dictionaryWithObject:windowModel.userID forKey:@"kTextChatUserIDKey"];
    notification.userInfo = userDict;
    
    // ios8后，需要添加这个注册，才能得到授权
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType type =  UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    
    // 执行通知注册
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

#pragma mark - public function

// 保存视频通话信息
- (void)saveVideoTalkMessageWithTime:(NSInteger)timeSec isMy:(BOOL)isMy extraModel:(FCUserTextExtraModel *)extraModel {
    
    MessageModel *msgModel = [FCChatModelConvertHandler convertUserTextExtraModelToMessageModel:extraModel];
    msgModel.msgFromMe = isMy;
    msgModel.isFailed = NO;
    msgModel.msgType = kChatMessageTypeOfVideo;
    
    NSString *talkTimeText = LOCALSTRING(@"kCallMissed");
    if (timeSec > 0) {
        NSInteger hourInt = timeSec / (3600);
        NSInteger minInt = (timeSec % 3600) / 60;
        NSInteger secInt = (timeSec % 3600) % 60;
        NSString *timeStr = nil;
        if (hourInt > 0) {
            timeStr = [NSString stringWithFormat:@"%zdh %zdm %zds", hourInt, minInt, secInt];
        } else if (minInt > 0) {
            timeStr = [NSString stringWithFormat:@"%zdm %zds", minInt, secInt];
        } else {
            timeStr = [NSString stringWithFormat:@"%zds", secInt];
        }
        
        talkTimeText = [NSString stringWithFormat:LOCALSTRING(@"kCallDurationKey"), timeStr];
    }
    
    msgModel.msgText = talkTimeText;
    
    NSDictionary *userInfo = @{kTextChatStatusKey : @(kChatMessageSuccess), kTextChatMessageObjectKey : msgModel};
    [self postTextEventNotification:kTextChatSendEventNotification userInfo:userInfo];
}

// 发送文字
- (void)sendText:(NSString *)text extraModel:(FCUserTextExtraModel *)extraModel {
    MessageModel *message = [[MessageModel alloc] init];
    ZCONST ZCHAR *userUri;
    userUri = Mtc_UserFormUri(EN_MTC_USER_ID_USERNAME, [[extraModel targetIdentify] UTF8String]);
//    message.msgByIdentify = [extraModel identify];
//    message.msgTargetIdentify = [extraModel targetIdentify];
    message.msgByTargetUserName = extraModel.targetUserName;
    message.targetHeadPicUrlName = extraModel.targetAvatarName;
    
    message.msgId = [[FZLoginUser msgId] intValue];
    message.msgByUserName = extraModel.userName;
    message.headPicUrlName = extraModel.avatarName;
    message.msgText = text;
    message.msgFromMe = YES;
    message.msgType = kChatMessageTypeOfText;
    message.timestamp = [[NSDate date] timeIntervalSince1970];
//    __weak id weakMessage = message;
//    ZINT zCookie = (ZINT)(__bridge void *)weakMessage;
//    NSString *extraInfo = [self extraMessageInfo:extraModel msgType:kChatMessageTypeOfText thumbnailPath:nil];
//    Mtc_ImSendText(ZCOOKIE zCookie, ZCONST ZCHAR *pcUserUri,
//                   ZCONST ZCHAR *pcText, ZCONST ZCHAR *pcInfo);
    
    //{"firstName":"Brett","lastName":"McLaughlin","email":"aaaa"}
    NSDictionary *jsonDict = @{@"content":message.msgText,
                               @"avatar":[FZLoginUser avatar],
                               @"nickname":[FZLoginUser nickname]};
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

    ZINT iret = Mtc_ConfSendText([extraModel.confid intValue], nil, [jsonString UTF8String]);

    //ZINT iret = Mtc_ConfSendText([extraModel.confid intValue], nil, [message.msgText UTF8String]);
//    ZINT iret = Mtc_ConfSendData([extraModel.confid intValue], nil, [message.msgText UTF8String], [[FZLoginUser avatar] UTF8String]);
    if (iret == ZFAILED) {
        NSLog(@"文字发送失败：%@", message);
        return;
    }
    
    [_msgArray addObject:message];
    
    // 先发送，刷新UI
    message.isFailed = NO;
    message.messageStatus = kChatMessageCreate;
    NSDictionary *userInfo = @{kTextChatStatusKey : @(kChatMessageCreate), kTextChatMessageObjectKey : message};
    [DataBaseManager insertMessageTable:message userId:[FZLoginUser userID]];
    [self postTextEventNotification:kTextChatSendEventNotification userInfo:userInfo];
}

// 发送图片
- (void)sendPicture:(UIImage *)image extraModel:(FCUserTextExtraModel *)extraModel {
    MessageModel *message = [[MessageModel alloc] init];
    ZCONST ZCHAR *userUri;
    userUri = Mtc_UserFormUri(EN_MTC_USER_ID_USERNAME, [[extraModel targetIdentify] UTF8String]);
    message.msgByIdentify = [extraModel identify];
    message.msgTargetIdentify = [extraModel targetIdentify];
    message.msgByTargetUserName = extraModel.targetUserName;
    message.targetHeadPicUrlName = extraModel.targetAvatarName;
    
    message.msgByUserName = extraModel.userName;
    message.msgText = @"";
    message.msgFromMe = YES;
//    message.thumbnail = image;
    message.msgType = kChatMessageTypeOfPic;
    
    NSInteger timeStamp = [[NSDate date] timeIntervalSince1970];
    // 防止同一时间发送多张图片，导致图片只发送成功一张的处理
    {
        static NSInteger lastTimeStamp = 0;
        if (lastTimeStamp != 0 && lastTimeStamp >= timeStamp) {
            timeStamp = ++ lastTimeStamp;
        }
        lastTimeStamp = timeStamp;
    }

    message.timestamp = timeStamp;
    message.headPicUrlName = extraModel.avatarName;

    NSString *originPath = [self getOriginPicFilePath:extraModel.picMessageName];
    [self saveImage:image withPath:originPath];
    message.originPicPath = originPath;
    message.thumbnailPicPath = [self getAndSaveThumbnailImageWithOriginFilePath:originPath];

    __weak id weakMessage = message;
    ZCOOKIE zCookie = (ZCOOKIE)(__bridge void *)weakMessage;
    NSString *extraInfo = [self extraMessageInfo:extraModel msgType:kChatMessageTypeOfPic thumbnailPath:originPath];
    ZINT iret = Mtc_ImSendFile(zCookie, userUri, EN_MTC_IM_FILE_IMAGE, [originPath UTF8String], [extraInfo UTF8String]);
    if (iret == ZFAILED) {
        NSLog(@"图片发送失败：%@", message);
        return;
    }
    message.msgStatus = @"Sending...";
    [_msgArray addObject:message];
    
    // 先发送，刷新UI
    message.isFailed = NO;
    message.messageStatus = kChatMessageCreate;
    NSDictionary *userInfo = @{kTextChatStatusKey : @(kChatMessageCreate), kTextChatMessageObjectKey : message};
    [self postTextEventNotification:kTextChatSendEventNotification userInfo:userInfo];
}

#pragma mark - notifications

- (void)postTextEventNotification:(NSString *)notificationName userInfo:(NSDictionary *)userInfo {
    dispatch_async(dispatch_get_main_queue(), ^{
        kChatMessageStatus msgStatus = [[userInfo objectForKey:kTextChatStatusKey] integerValue];
        if (msgStatus == kChatMessageProgress || msgStatus == kChatFileProgress) {
            return;
        }
        MessageModel *msgModel = [userInfo objectForKey:kTextChatMessageObjectKey];
        if (!msgModel.msgByTargetUserName && msgModel.msgByTargetUserName.length == 0) {
            return;
        }
        
        // 会话列表缓存处理
        msgModel.noReadMsgCount = [FCChatCache getNoReadCountWithUserID:[msgModel userTargetID]];
        FCChatWindowModel * chatWindowModel = [FCChatModelConvertHandler convertMessageModelToChatWindow:msgModel];
        if (msgModel.msgType == kChatMessageTypeOfVideo) {
            chatWindowModel.recentMessageContent = [NSString stringWithFormat:@"[%@]", msgModel.msgText];
            if (!msgModel.isMsgFromMe && [msgModel.msgText isEqualToString:LOCALSTRING(@"kCallMissed")]) {
                [FCChatCache addOrUpdateChatWindow:chatWindowModel];
            } else {
                [FCChatCache addChatWindowCleanNoReadCount:chatWindowModel];
            }
        } else if (msgModel.msgType == kChatMessageTypeOfInputCache) {
            chatWindowModel.recentMessageContent = [NSString stringWithFormat:@"[草稿]%@", msgModel.msgText];
            if (msgModel.isMsgFromMe) {
                [FCChatCache addChatWindowCleanNoReadCount:chatWindowModel];
            } else {
                [FCChatCache addOrUpdateChatWindow:chatWindowModel];
            }
        } else if (msgModel.msgType == kChatMessageTypeOfPic) {
            chatWindowModel.recentMessageContent = LOCALSTRING(@"kImageTextKey");
            if (msgModel.isMsgFromMe || msgStatus == kChatFileSuccess || msgStatus == kChatFileProgress) {
                [FCChatCache addChatWindowCleanNoReadCount:chatWindowModel];
            } else {
                [FCChatCache addOrUpdateChatWindow:chatWindowModel];
            }
        } else  {
            if (msgModel.isMsgFromMe) {
                [FCChatCache addChatWindowCleanNoReadCount:chatWindowModel];
            } else {
                [FCChatCache addOrUpdateChatWindow:chatWindowModel];
            }
        }
        
        NSInteger noReadCount = [FCChatCache getNoReadCountWithUserID:chatWindowModel.userID];
        msgModel.noReadMsgCount = noReadCount;
        
        // 聊天详情缓存处理
        FCChatMessageModel * chatMessageModel = [FCChatModelConvertHandler convertMessageModelToChatMessage:msgModel];
        [FCChatCache addOrUpdateChatMessage:chatMessageModel];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil userInfo:userInfo];
        
        //  如果退到后台，发送本地通知
        if (msgModel.msgType != kChatMessageTypeOfVideo && msgStatus == kChatMessageSuccess && _isEnterBackground) {
            NSLog(@"发送本地通知！");
            [[self class] registerLocalNotification:chatWindowModel];
        } else {
            _backgroundNoReadNumber = 0;
        }
    });
}

- (void)initNotification {
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(sendOk:) name:@MtcImSendOkNotification object:nil];
    [notificationCenter addObserver:self selector:@selector(sendedFailed:) name:@MtcImSendDidFailNotification object:nil];
    [notificationCenter addObserver:self selector:@selector(messageDidReceived:) name:@MtcConfDataReceivedNotification object:nil];
    [notificationCenter addObserver:self selector:@selector(infoDidReceived:) name:@MtcConfTextReceivedNotification object:nil];
    
    [notificationCenter addObserver:self selector:@selector(sendProgress:) name:@MtcImSendingNotification object:nil];
    [notificationCenter addObserver:self selector:@selector(fileDidReceived:) name:@MtcImFileDidReceiveNotification object:nil];
    [notificationCenter addObserver:self selector:@selector(fetchProgress:) name:@MtcImFetchingNotification object:nil];
    [notificationCenter addObserver:self selector:@selector(fetchOk:) name:@MtcImFetchOkNotification object:nil];
    [notificationCenter addObserver:self selector:@selector(fetchedDidFail:) name:@MtcImFetchDidFailNotification object:nil];
}

- (void)sendOk:(NSNotification *)notification{
    MessageModel *msgModel = notification.object;
    for (MessageModel *model in _msgArray) {
        if ([model isEqual:msgModel]) {
            model.msgStatus = @"Sended";
        }
    }
    msgModel.isFailed = NO;
    msgModel.messageStatus = kChatMessageSuccess;
    NSDictionary *userInfo = @{kTextChatStatusKey : @(kChatMessageSuccess), kTextChatMessageObjectKey : msgModel};
    [self postTextEventNotification:kTextChatSendEventNotification userInfo:userInfo];
    NSLog(@"====>>sendSuccess");
}

- (void)sendedFailed:(NSNotification *)notification {
    MessageModel *msgModel = notification.object;
    for (MessageModel *model in _msgArray) {
        if ([model isEqual:msgModel]) {
            model.msgStatus = @"Send fail!";
        }
    }
    msgModel.isFailed = YES;
    msgModel.messageStatus = kChatMessageFailed;
    NSDictionary *userInfo = @{kTextChatStatusKey : @(kChatMessageFailed), kTextChatMessageObjectKey : msgModel};
    [self postTextEventNotification:kTextChatSendEventNotification userInfo:userInfo];
//    [MtcUILogicDelegateClass() uploadJustalkLog:@"消息发送失败！"];

    NSLog(@"====>>sendFailed");
}

- (void)sendProgress:(NSNotification *)notification {
    MessageModel *msgModel = notification.object;
    for (MessageModel *model in _msgArray) {
        if ([model isEqual:msgModel]) {
            float progress = [[notification.userInfo objectForKey:@MtcImProgressKey] floatValue];
            model.progress = progress/100;
        }
    }
    float progress = [[notification.userInfo objectForKey:@MtcImProgressKey] floatValue];
    msgModel.progress = progress/100;
    msgModel.messageStatus = kChatMessageProgress;
    NSDictionary *userInfo = @{kTextChatStatusKey : @(kChatMessageProgress), kTextChatMessageObjectKey : msgModel};
    [self postTextEventNotification:kTextChatSendEventNotification userInfo:userInfo];

    NSLog(@"====>>sending Porogress:%f", msgModel.progress);
}

- (void)fetchProgress:(NSNotification *)notification {
    MessageModel *msgModel = notification.object;
    for (MessageModel *model in _msgArray) {
        if ([model isEqual:msgModel]) {
            float progress = [[notification.userInfo objectForKey:@MtcImProgressKey] floatValue];
            model.progress = progress/100;
        }
    }
    float progress = [[notification.userInfo objectForKey:@MtcImProgressKey] floatValue];
    msgModel.progress = progress/100;
    msgModel.messageStatus = kChatFileProgress;
    NSDictionary *userInfo = @{kTextChatStatusKey : @(kChatFileProgress), kTextChatMessageObjectKey : msgModel};
    [self postTextEventNotification:kTextChatRecvEventNotification userInfo:userInfo];

    NSLog(@"====>>fetching Porogress:%f", msgModel.progress);
}

- (NSString *)getAndSaveThumbnailImageWithOriginFilePath:(NSString *)originFilePath {
    UIImage *image = [UIImage imageWithContentsOfFile:originFilePath];
    UIImage *thumbnailImage = [FCIMChatGetImage rotateImage:image maxWidth:280 maxHeight:300];
    NSString *fileNameNoPrefix = [self getOriginFileNameNoPrefix:[originFilePath lastPathComponent]];
    NSString *thumbnailFilePath = [self getThumbnailPicFilePath:fileNameNoPrefix];
    [self saveImage:thumbnailImage withPath:thumbnailFilePath];
    return thumbnailFilePath;
}

- (void)fetchOk:(NSNotification *)notification {
    NSString *filePath = [notification.userInfo objectForKey:@MtcImFilePathKey];
    NSString *fileUri = [notification.userInfo objectForKey:@MtcImFileUriKey];
//    NSString *thumbPath = [notification.userInfo objectForKey:@MtcImThumbFilePathKey];
    
    MessageModel *msgModel = notification.object;
    if (msgModel.msgType == kChatMessageTypeOfPic) {
        msgModel.thumbnailPicPath = [self getAndSaveThumbnailImageWithOriginFilePath:filePath];
        msgModel.originPicPath = filePath;
    }else{
        msgModel.msgText = [filePath lastPathComponent];
    }
    msgModel.msgStatus = @"Received";
    
    msgModel.messageStatus = kChatFileSuccess;
    NSDictionary *userInfo = @{kTextChatStatusKey : @(kChatFileSuccess), kTextChatMessageObjectKey : msgModel};
    [self postTextEventNotification:kTextChatRecvEventNotification userInfo:userInfo];

    NSLog(@"====>>filename:%@,fileuri:%@,fetching done",filePath,fileUri);
}

- (void)fetchedDidFail:(NSNotification *)notification {
    
    NSString *fileName = [notification.userInfo objectForKey:@MtcImFileNameKey];
    NSString *fileUri = [notification.userInfo objectForKey:@MtcImFileUriKey];
    
    MessageModel *msgModel = notification.object;
    for (MessageModel *model in _msgArray) {
        if ([model isEqual:msgModel]) {
            model.msgStatus = @"Fetch failed!";
        }
    }
    
    msgModel.messageStatus = kChatFileFailed;
    NSDictionary *userInfo = @{kTextChatStatusKey : @(kChatMessageFailed), kTextChatMessageObjectKey : msgModel};
    [self postTextEventNotification:kTextChatRecvEventNotification userInfo:userInfo];
//    [MtcUILogicDelegateClass() uploadJustalkLog:@"文件拉取失败！"];

    NSLog(@"====>>filename:%@,fileuri:%@,fetching failed",fileName,fileUri);
}

- (void)fileDidReceived:(NSNotification *)notification {
    EN_MTC_IM_FILE_TYPE type = [[notification.userInfo objectForKey:@MtcImFileTypeKey] unsignedIntValue];

    MessageModel *message = [self processRecvMessageModelWithNotification:notification];
    message.msgStatus = @"Received";
    
    NSString *fileName = [notification.userInfo objectForKey:@MtcImFileNameKey];
    NSString *filePath = [self getOriginPicFilePath:fileName];
    
    if (type == EN_MTC_IM_FILE_IMAGE) {
        message.msgType = kChatMessageTypeOfPic;
        
        // 下载原图
        NSString *imaegUri = [notification.userInfo objectForKey:@MtcImFileUriKey];
        if (!imaegUri) {
            NSLog(@"====>>fileDidReceived failed ： %@",message);
            [_msgArray addObject:message];

            return;
        }
        __weak id weakMessage = message;
        ZCOOKIE zCookie = (ZCOOKIE)(__bridge void *)weakMessage;
        ZINT iret = Mtc_ImFetchFile(zCookie, [imaegUri UTF8String],[filePath UTF8String]);
        if (iret == ZFAILED) {
            NSLog(@"文件接收失败：%@", message);
            return;
        }
        
        message.messageStatus = kChatMessageSuccess;
        NSDictionary *userInfo = @{kTextChatStatusKey : @(kChatMessageSuccess), kTextChatMessageObjectKey : message};
        [self postTextEventNotification:kTextChatRecvEventNotification userInfo:userInfo];
    }
    [_msgArray addObject:message];
}

- (void)infoDidReceived:(NSNotification *)notification {
    MessageModel *message = [self processRecvMessageModelWithNotification:notification];
    [_msgArray addObject:message];

    message.messageStatus = kChatMessageSuccess;
    NSDictionary *userInfo = @{kTextChatStatusKey : @(kChatMessageSuccess), kTextChatMessageObjectKey : message};
    [[NSNotificationCenter defaultCenter] postNotificationName:kTextChatRecvEventNotification object:nil userInfo:userInfo];
    [DataBaseManager insertMessageTable:message userId:[FZLoginUser userID]];
}

- (void)messageDidReceived:(NSNotification *)notification {
    MessageModel *message = [self processRecvMessageModelWithNotification:notification];
    
    if (message.msgType == KVideoSelect) {
        [[NSNotificationCenter defaultCenter] postNotificationName:KVideoSelectNotification object:self userInfo:notification.userInfo];
        return;
    }
    
    if (message.msgType == kDocumentSharing) {
        return;
    }
    
    message.msgStatus = @"Received";
    [_msgArray addObject:message];

    message.messageStatus = kChatMessageSuccess;
    NSDictionary *userInfo = @{kTextChatStatusKey : @(kChatMessageSuccess), kTextChatMessageObjectKey : message};
    
    [self postTextEventNotification:kTextChatRecvEventNotification userInfo:userInfo];

    
    [DataBaseManager insertMessageTable:message userId:[FZLoginUser userID]];
}

#pragma mark - private function

- (void)saveImage:(UIImage *)currentImage withPath:(NSString *)filePath
{
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 1.0);
    NSLog(@"filepath : %@", filePath);
    [imageData writeToFile:filePath atomically:NO];
}

- (MessageModel *)processRecvMessageModelWithNotification:(NSNotification *)notification{
    MessageModel *message = [[MessageModel alloc] init];
    
    message.msgId = [[notification.userInfo objectForKey:@MtcConfIdKey] unsignedIntValue];
    NSString *peerUri = [notification.userInfo objectForKey:@MtcConfUserUriKey];
    NSString *username = [NSString stringWithUTF8String:Mtc_UserGetId([peerUri UTF8String])];
    message.msgTargetIdentify = [NSString stringWithFormat:@"%@", username];
    NSString *formUserID = [[message.msgTargetIdentify componentsSeparatedByString:@"_"] lastObject];
    NSLog(@"%@", formUserID);
    if ([formUserID isEqualToString:[NSString stringWithFormat:@"%@",[FZLoginUser userID]]]) {
        message.msgFromMe = YES;
    } else {
        message.msgFromMe = NO;
        message.msgStatus = @"Received";
    }
    message.messageStatus = kChatMessageCreate;
    
    /**
     * @guangfu yang 16-2-29 17:37
     * 判断是否是老师
     **/
    NSArray *tchArray = [peerUri componentsSeparatedByString:@":"];
    NSString *tchStr = [[tchArray lastObject] substringToIndex:3];
    BOOL teacher = NO;
    if ([tchStr isEqualToString:@"tch"]) {
        teacher = YES;
    }
    
    if ([notification.userInfo objectForKey:@MtcConfDataTypeKey] == nil) {
        message.msgText = [notification.userInfo objectForKey:@MtcConfTextKey];
        NSDictionary *dic = [self dictionaryWithJsonString:message.msgText];
        message.msgText =  dic[@"content"];
        NSString *avatarURL =  dic[@"avatar"];
        message.headPicUrlName = avatarURL;
        NSString *nickName  = dic[@"nickname"];
        if (teacher) {
            message.msgTargetIdentify = @"老师";
        } else {
            message.msgTargetIdentify = nickName;
        }
        
    } else {
        message.msgVideoSelect =  [notification.userInfo objectForKey:@"VideoSelect"];
        
        NSDictionary *dict = [self dictionaryWithJsonString:message.msgVideoSelect];
        message.msgVideoSelect = dict[@"userUri"];
    }
    
    message.msgConfNumber = [notification.userInfo objectForKey:@MtcConfNumberKey];
    if (!message.msgText) {
        message.msgText = @"";
    }
    NSInteger timeStamp = [[NSDate date] timeIntervalSince1970];
    // 防止同一秒内收到多个消息，使用long long 后 realm库可能崩溃，使用此方法进行规避
    {
        static NSInteger lastTimeStamp = 0;
        if (lastTimeStamp != 0 && lastTimeStamp >= timeStamp) {
            timeStamp = ++ lastTimeStamp;
        }
        lastTimeStamp = timeStamp;
    }
    message.timestamp = timeStamp;

    NSLog(@"From%@, Text:%@, time:%zd", username, message.msgText, timeStamp);
    
//    NSString *userDataStr = [notification.userInfo objectForKey:@MtcImUserDataKey];
//    NSData *data = [userDataStr
//                      dataUsingEncoding:NSUTF8StringEncoding];
//    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//    NSString *targetUserID = [dict objectForKey:@"uid"];
//    if ([FCJusTalkConfigHandler IsValidJustalkID:targetUserID]) {
//        message.msgTargetIdentify = [dict objectForKey:@"uid"];
//    }
//    message.msgByTargetUserName = [dict objectForKey:@"nickname"];
//    message.targetHeadPicUrlName = [dict objectForKey:@"avatar_name"];
    message.msgType = kChatMessageTypeOfText;
    NSString * msgType = [notification.userInfo objectForKey:@MtcConfDataTypeKey];
    if ([msgType isEqualToString:@"DocumentSharing"]) {
        message.msgType = kDocumentSharing;
    } else if ([msgType isEqualToString:@"VideoSelect"]) {
        message.msgType = KVideoSelect;
    }
    return message;
}

/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

// 发送消息协议：{"uid":"t207","nickname":"P B","avatar_name":"\/2015-07-13_55a35766e2238.png","msg_type":1}
- (NSString *)extraMessageInfo:(FCUserTextExtraModel *)extraModel msgType:(kChatMessageType)type thumbnailPath:(NSString *)thumbnailPath {
//    NSDictionary *extraDic = @{@"uid" : [extraModel identify],
//                               @"nickname" : extraModel.userName,
//                               @"avatar_name" : extraModel.avatarName,
//                               @"msg_type" : @(type)};
    NSDictionary *extraDic = [[NSDictionary alloc] initWithObjectsAndKeys:[extraModel identify],@"uid",
                              extraModel.userName,@"nickname",
                              extraModel.avatarName,@"avatar_name",
                              @(type),@"msg_type",
                              nil];
    
    NSData *extraData = [NSJSONSerialization dataWithJSONObject:extraDic options:0 error:nil];
    NSString *userInfo = [[NSString alloc] initWithData:extraData encoding:NSUTF8StringEncoding];
    
    NSDictionary *dict = nil;
    
    if (type == kChatMessageTypeOfText) {
        dict = @{ @MtcImDisplayNameKey : extraModel.uid,
                   @MtcImUserDataKey : userInfo};
    } else {
        dict = @{ @MtcImThumbFilePathKey : thumbnailPath,
                   @MtcImUserDataKey : userInfo};
    }
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
    NSString *info = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return info;
}

#pragma mark - genarate thumbnail

- (NSString *)getOriginFileNameNoPrefix:(NSString *)fileName {
    NSString *prefix = [kPicMessageOriginName substringToIndex:(kPicMessageOriginName.length - 2)];
    NSString *fileNameNoPrefix = fileName;
    if (prefix && [fileName hasPrefix:prefix]) {
        fileNameNoPrefix = [fileName substringFromIndex:prefix.length];
    }
    return fileNameNoPrefix;
}

- (NSString *)getThumbnailFileNameNoPrefix:(NSString *)fileName {
    NSString *prefix = [kPicMessageThumbnailName substringToIndex:(kPicMessageThumbnailName.length - 2)];
    NSString *fileNameNoPrefix = fileName;
    if (prefix && [fileName hasPrefix:prefix]) {
        fileNameNoPrefix = [fileName substringFromIndex:prefix.length];
    }
    return fileNameNoPrefix;
}

- (NSString *)getThumbnailPicFilePath:(NSString *)fileName {
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:kPicMessageCacheDirPath]) {
        [fm createDirectoryAtPath:kPicMessageCacheDirPath withIntermediateDirectories:NO attributes:nil error:nil];
    }
    NSString *prefix = [kPicMessageThumbnailName substringToIndex:(kPicMessageThumbnailName.length - 2)];
    NSString *fileNameTmp = fileName;
    if (prefix && ![fileName hasPrefix:prefix]) {
        fileNameTmp = [NSString stringWithFormat:kPicMessageThumbnailName, fileName];
    }
    return [kPicMessageCacheDirPath stringByAppendingPathComponent:fileNameTmp];
}

- (NSString *)getOriginPicFilePath:(NSString *)fileName {
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:kPicMessageCacheDirPath]) {
        [fm createDirectoryAtPath:kPicMessageCacheDirPath withIntermediateDirectories:NO attributes:nil error:nil];
    }
    NSString *prefix = [kPicMessageOriginName substringToIndex:(kPicMessageOriginName.length - 2)];
    NSString *fileNameTmp = fileName;
    if (prefix && ![fileName hasPrefix:prefix]) {
        fileNameTmp = [NSString stringWithFormat:kPicMessageOriginName, fileName];
    }
    
    return [kPicMessageCacheDirPath stringByAppendingPathComponent:fileNameTmp];
}

@end
