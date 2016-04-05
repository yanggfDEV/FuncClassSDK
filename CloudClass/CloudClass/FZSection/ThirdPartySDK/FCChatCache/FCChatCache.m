//
//  FCChatCache.m
//  FunChatStudent
//
//  Created by 刘滔 on 15/10/8.
//  Copyright (c) 2015年 Feizhu Tech. All rights reserved.
//

#import "FCChatCache.h"
#import "FCRealmHandler.h"
//#import "FZVideoTalkSDKLocalization.h"

static NSString *currentTextChatTargetUserID = nil;       // 记录当前文字聊天页面对方userID （当为空时，代表不在文字聊天页面）
static NSString *currentAppUserID = nil;
static NSString *headPicPathPrefix = nil;

@implementation FCChatCache

#pragma mark - public function

// 设置当前App用户ID (切换账号使用)
+ (void)setCurrentAppUserID:(NSString *)userID {
    if ([userID isKindOfClass:[NSNumber class]]) {
        userID = [NSString stringWithFormat:@"%zd", [userID integerValue]];
    }
    currentAppUserID = userID;
    [self checkChatCache];
}

// 设置当前文字聊天聊天页面UserID
+ (void)setCurrentTextChatTargetUserID:(NSString *)targetUserID {
    currentTextChatTargetUserID = targetUserID;
}

// 获取当前正在文字聊天页面的
+ (NSString *)currentTextChatTargetUserID {
    return currentTextChatTargetUserID;
}

+ (void)setHeadPicPathPrefix:(NSString *)prefixPath {
    headPicPathPrefix = prefixPath;
}

+ (NSString *)headPicPathPrefix {
    return headPicPathPrefix;
}

#pragma mark - 会话列表
/***************** 会话列表 *******************/
// 获取会话列表
+ (NSArray *)chatList {
    [FCRealmHandler setDefaultRealmForName:[[self class] chatWindowRealmName]];
    RLMResults* resultsOne = [FCChatWindowModel allObjects];
    RLMResults *results = [resultsOne sortedResultsUsingProperty:@"timestamp" ascending:NO];
    NSMutableArray *array = [NSMutableArray array];
	for (FCChatWindowModel *model in results) {
	        [array addObject:[model copy]];
    }
    return array.count > 0 ? array : nil;
}

// 添加一条会话记录
+ (void)addOrUpdateChatWindow:(FCChatWindowModel *)windowModel {
    if (!windowModel || !windowModel.userID || windowModel.userID.length == 0) {
        return;
    }
    if (!currentTextChatTargetUserID || ![windowModel.userID isEqualToString:currentTextChatTargetUserID]) {
        NSInteger noReadCount = [[self class] getNoReadCountWithUserID:windowModel.userID];
        windowModel.noReadCount = ++ noReadCount;
    }

    [self addChatWindowCleanNoReadCount:windowModel];
}

// 添加一条会话记录
+ (void)addChatWindowCleanNoReadCount:(FCChatWindowModel *)windowModel {
    if (!windowModel || !windowModel.userID || windowModel.userID.length == 0 || !windowModel.userName || windowModel.userName.length == 0) {
        return;
    }
    if ([windowModel.userID isKindOfClass:[NSNumber class]]) {
        windowModel.userID = [NSString stringWithFormat:@"%zd", [windowModel.userID integerValue]];
    }
    [windowModel judgeNull];
    FCChatWindowModel *searchModelTmp = nil;
    NSString *where = [NSString stringWithFormat:@"userID == '%@'", windowModel.userID];
    RLMResults *result = [FCRealmHandler searchWhere:where searchClass:[FCChatWindowModel class] realmName:[[self class] chatWindowRealmName]];
    if (result.count > 0) {
        FCChatWindowModel *searchModel = [result firstObject];
        if ([searchModel.userID isEqualToString:windowModel.userID]) {
            searchModelTmp = [searchModel copy];
        }
    }
    if (searchModelTmp) {
        // 将老数据更新
        [windowModel updateModel:searchModelTmp];
    }
    
    [FCRealmHandler addOrUpdateModel:[windowModel copy] realmName:[[self class] chatWindowRealmName]];
}

+ (BOOL)isHaveUserInfoWithUserID:(NSString *)userID {
    if (!userID) {
        return NO;
    }
    NSString *where = [NSString stringWithFormat:@"userID == '%@'", userID];
    RLMResults *result = [FCRealmHandler searchWhere:where searchClass:[FCChatWindowModel class] realmName:[[self class] chatWindowRealmName]];
    if (result.count > 0) {
        FCChatWindowModel *searchModel = [result firstObject];
        return [searchModel isHaveUserInfo];
    }
    return NO;
}

// 根据userID获取windowModel
+ (FCChatWindowModel *)fetchChatWindowWithUserID:(NSString *)userID {
    if (!userID) {
        return nil;
    }
    [FCRealmHandler setDefaultRealmForName:[[self class] chatWindowRealmName]];
    RLMResults *results = [FCChatWindowModel allObjects];
    for (FCChatWindowModel *model in results) {
        if ([model.userID isEqualToString:userID]) {
            return [model copy];
        }
    }
    return nil;
}

+ (BOOL)isHaveChatWindowCacheWithUserID:(NSString *)userID {
    if (!userID) {
        return NO;
    }
    [FCRealmHandler setDefaultRealmForName:[[self class] chatWindowRealmName]];
    RLMResults *results = [FCChatWindowModel allObjects];
    for (FCChatWindowModel *model in results) {
        if ([model.userID isEqualToString:userID]) {
            return YES;
        }
    }
    return NO;
}

// 删除一条会话记录
+ (void)deleteChatWindow:(NSString *)userID {
    if (!userID) {
        return;
    }
    NSString *where = [NSString stringWithFormat:@"userID == '%@'", userID];
    RLMResults *result = [FCRealmHandler searchWhere:where searchClass:[FCChatWindowModel class] realmName:[[self class] chatWindowRealmName]];
    if (result.count > 0) {
        FCChatWindowModel *searchModel = [result firstObject];
        if ([searchModel.userID isEqualToString:userID]) {
            [FCRealmHandler deleteModel:searchModel realmName:[[self class] chatWindowRealmName]];
        }
    }
    [[self class] deleteAllChatMessageWithUserID:userID];
}

// 清空未读消息数
+ (void)cleanNoReadCountWithUserID:(NSString *)userID {
    if (!userID) {
        return;
    }
    NSString *where = [NSString stringWithFormat:@"userID == '%@'", userID];
    RLMResults *result = [FCRealmHandler searchWhere:where searchClass:[FCChatWindowModel class] realmName:[[self class] chatWindowRealmName]];
    if (result.count > 0) {
        FCChatWindowModel *searchModel = [result firstObject];
        FCChatWindowModel *windowModel = [searchModel copy];
        windowModel.noReadCount = 0;
        [FCRealmHandler addOrUpdateModel:windowModel realmName:[[self class] chatWindowRealmName]];
    }
}

// 获取未读消息数
+ (NSInteger)getNoReadCountWithUserID:(NSString *)userID {
    if (!userID) {
        return -1;
    }
    NSString *where = [NSString stringWithFormat:@"userID == '%@'", userID];
    RLMResults *result = [FCRealmHandler searchWhere:where searchClass:[FCChatWindowModel class] realmName:[[self class] chatWindowRealmName]];
    if (result.count > 0) {
        FCChatWindowModel *searchModel = [result firstObject];
        return searchModel.noReadCount;
    }
    return 0;
}

// 获取所有的未读消息数
+ (NSInteger)allNoReadCount {
    NSArray *chatList = [[self class] chatList];
    NSInteger noReadCount = 0;
    for (FCChatWindowModel *windowModel in chatList) {
        noReadCount += [[self class] getNoReadCountWithUserID:windowModel.userID];
    }
    return noReadCount;
}

// 获取所有的外教的未读消息数
+ (NSInteger)allNoForeignReadCount {
    NSArray *chatList = [[self class] chatList];
    NSInteger noReadCount = 0;
    for (FCChatWindowModel *windowModel in chatList) {
//        if(windowModel.teacherType == kChatTeacherTypeForeign){
            noReadCount += [[self class] getNoReadCountWithUserID:windowModel.userID];
//        }
    }
    return noReadCount;
}

/***************** 聊天内容 *******************/

// 获取用户聊天内容 （进入聊天页时调用）
+ (NSArray *)chatContentWithUserID:(NSString *)userID {
    return [[self class] chatContentWithUserID:userID pageCount:0];
}

// 根据用户ID获取聊天内容
+ (NSArray *)chatContentWithUserID:(NSString *)userID pageCount:(NSInteger)count {
    if (userID <= 0) {
        return nil;
    }
    NSString *where = [NSString stringWithFormat:@"userID == '%@' AND messageType != %zd", userID, kChatMessageTypeOfInputCache];
    RLMResults *results = [FCRealmHandler searchWhere:where searchClass:[FCChatMessageModel class] sortName:@"timestamp" ascending:YES realmName:[[self class] chatMessageRealmName]];
    NSInteger needResultCount = (count + 1) * kDefaultChatMessageCount;
    
    NSInteger startIndex = 0;
    if (results.count > needResultCount) {
        startIndex = results.count - needResultCount;
    }
    
    NSMutableArray *messageModels = [NSMutableArray array];
    for (NSInteger i = startIndex; i < results.count; i ++) {
        FCChatMessageModel *messageModel = [results objectAtIndex:i];
        [messageModels addObject:[messageModel copy]];
    }
    
    return messageModels;
}

+ (FCChatMessageModel *)fetchRecentMessageModelWithUserID:(NSString *)userID {
    NSArray *messageModels = [self chatContentWithUserID:userID];
    if (messageModels && messageModels.count > 0) {
        return [messageModels lastObject];
    }
    return nil;
}

// 添加一条聊天消息
+ (void)addOrUpdateChatMessage:(FCChatMessageModel *)messageModel {
    if (!messageModel || messageModel.userID.length == 0) {
        return;
    }
    [messageModel judgeNull];
    [FCRealmHandler addOrUpdateModel:messageModel realmName:[[self class] chatMessageRealmName]];
}

// 删除一条聊天消息
+ (void)deleteChatMessage:(FCChatMessageModel *)messageModel {
    if (!messageModel) {
        return;
    }
    [messageModel judgeNull];
    NSString *where = [NSString stringWithFormat:@"timestamp == %zd", messageModel.timestamp];
    RLMResults *result = [FCRealmHandler searchWhere:where searchClass:[FCChatMessageModel class] realmName:[[self class] chatMessageRealmName]];
    if (result.count > 0) {
        FCChatMessageModel *searchModel = [result firstObject];
        if (searchModel.timestamp == messageModel.timestamp) {
            [FCRealmHandler deleteModel:searchModel realmName:[[self class] chatMessageRealmName]];
            
            // 判断删除的是否为最新发送的消息，如果是，更新会话列表数据
            FCChatWindowModel *windowModel = [[self class] fetchChatWindowWithUserID:messageModel.userID];
            if (windowModel.timestamp == messageModel.timestamp) {
                windowModel.recentMessageContent = @"";
                // 取删除后最近的一条消息
                FCChatMessageModel *newMessageModel = [[self class] fetchRecentMessageModelWithUserID:messageModel.userID];
                if (newMessageModel) {
                    windowModel.timestamp = newMessageModel.timestamp;
                    NSString *content = newMessageModel.content;
                    if (newMessageModel.messageType == kChatMessageTypeOfVideo) {
                        content = [NSString stringWithFormat:@"[%@]", newMessageModel.content];
                    } else if (newMessageModel.messageType == kChatMessageTypeOfInputCache) {
                        content = [NSString stringWithFormat:@"[草稿]%@", newMessageModel.content];
                    } else if (newMessageModel.messageType == kChatMessageTypeOfPic) {
                        content = LOCALSTRING(@"kImageTextKey");
                    }
                    windowModel.recentMessageContent = content;
                    [FCChatCache addChatWindowCleanNoReadCount:windowModel];
                }
            }
        }
    }
}

+ (void)deleteAllChatMessageWithUserID:(NSString *)userID {
    if (!userID) {
        return;
    }
    NSString *where = [NSString stringWithFormat:@"userID == '%@'", userID];
    RLMResults *result = [FCRealmHandler searchWhere:where searchClass:[FCChatMessageModel class] realmName:[[self class] chatMessageRealmName]];
    for (FCChatMessageModel *searchModel in result) {
        [FCRealmHandler deleteModel:searchModel realmName:[[self class] chatMessageRealmName]];
    }
}

// 获取缓存消息所有图片
+ (NSArray *)allMessagePics:(NSString *)userID {
    if (userID <= 0) {
        return nil;
    }
    NSString *where = [NSString stringWithFormat:@"userID == '%@' AND messageType == %zd", userID, kChatMessageTypeOfPic];
    RLMResults *results = [FCRealmHandler searchWhere:where searchClass:[FCChatMessageModel class] realmName:[[self class] chatMessageRealmName]];
    NSMutableArray *picArray = [NSMutableArray array];
    for (FCChatMessageModel *model in results) {
        if (model.messagePicFileName && model.messagePicFileName.length > 0) {
            [picArray addObject:[model originPicPath]];
        }
    }
    return picArray;
}

// 输入窗口未发送的文字
+ (NSString *)inputCacheTextWithUserID:(NSString *)userID {
    if (userID <= 0) {
        return nil;
    }
    NSString *where = [NSString stringWithFormat:@"userID == '%@' AND messageType == %zd", userID, kChatMessageTypeOfInputCache];
    RLMResults *results = [FCRealmHandler searchWhere:where searchClass:[FCChatMessageModel class] realmName:[[self class] chatMessageRealmName]];
    
    return results.count > 0 ? (NSString *)[results firstObject] : nil;
}

+ (void)handlerCacheCompatible {
    NSArray *windowModels = [[self class] chatList];
    for (FCChatWindowModel *windowModel in windowModels) {
        NSString *oldWindowUserID = windowModel.userID;
        [windowModel handlerCompatible];
        
        if (![oldWindowUserID isEqualToString:windowModel.userID]) {
            NSArray *messageModels = [[self class] chatContentWithUserID:oldWindowUserID];
            for (FCChatMessageModel *messageModel in messageModels) {
                [messageModel handlerCompatible];
                [FCRealmHandler addOrUpdateModel:messageModel realmName:[[self class] chatMessageRealmName]];
            }
            [FCRealmHandler addOrUpdateModel:[windowModel copy] realmName:[[self class] chatWindowRealmName]];
            [[self class] deleteChatWindow:oldWindowUserID];
        }
    }
}

#pragma mark - private function

// 更新realm数据模型
+ (void)checkChatCache {
    if (!currentAppUserID || currentAppUserID.length == 0) {
        return;
    }
    // 判断realm是否需要进行数据迁移
    [FCRealmHandler checkRealmModelWithName:[[self class] chatWindowRealmName] className:[FCChatWindowModel class] realmVersion:kChatWindowListRealmVersion];
    [FCRealmHandler checkRealmModelWithName:[[self class] chatMessageRealmName] className:[FCChatMessageModel class] realmVersion:kChatMessageListRealmVersion];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[self class] handlerCacheCompatible];
    });
}

+ (NSString *)chatWindowRealmName {
    return [NSString stringWithFormat:@"%@_%@", currentAppUserID, kChatWindowListRealmName];
}

+ (NSString *)chatMessageRealmName {
    return [NSString stringWithFormat:@"%@_%@", currentAppUserID, kChatMessageListRealmName];
}

@end
