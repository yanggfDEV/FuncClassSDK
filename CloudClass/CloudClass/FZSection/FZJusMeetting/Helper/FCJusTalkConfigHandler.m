//
//  FCJusTalkConfigHandler.m
//  Pods
//
//  Created by 刘滔 on 15/11/3.
//
//

#import "FCJusTalkConfigHandler.h"
#import "FZJusTalkHeader.h"
#import "UIColor+Hex.h"

#define kRequestCommentSeconds  59  // 超过 xx sec才发起评论     //59
#define kTalkWarnSeconds    (60*5)    // 剩余五分钟通话弹剩余时间

/*
 老外趣聊：ql_uid_ucid
 趣配音：  py_uid_ucid                                   
 少儿趣配音：se_uid_ucid
 登陆时返回 uid（原来ID）， ucid（统一平台id）
 注册justalk的id改为ql_uid_ucid，se_uid_ucid，py_uid_ucid
 新用户uid，ucid
 */
#define kFunChatJustalkIDFormat(uid, ucid)     [NSString stringWithFormat:@"ql_%@_%@", uid, ucid]
#define kQuPeiYingJustalkIDFormat(uid, ucid)   [NSString stringWithFormat:@"py_%@_%@", uid, ucid]
#define kShaoErJustalkIDFormat(uid, ucid)      [NSString stringWithFormat:@"se_%@_%@", uid, ucid]

static kVideoTalkProjectType _projectType;   // 调用当前库的工程类型

@implementation FCJusTalkConfigHandler

#pragma mark - 工程配置

+ (ZCHAR *)GetJustalkAppKeyWithProjectType:(kVideoTalkProjectType)projectType {
    _projectType = projectType;
    switch (projectType) {
        case kVideoTalkProjectTypeOfFunChatStudent:
        {
            return STUDENT_JUSTALK_APP_KEY;
        }
            break;
        case kVideoTalkProjectTypeOfFunChatTeacher:
        {
            return TEACHER_JUSTALK_APP_KEY;
        }
            break;
        case kVideoTalkProjectTypeOfQuPeiYing:
        {
            return QUPEIYING_JUSTALK_APP_KEY;
        }
            break;
        case kVideoTalkProjectTypeOfShaoErQuPeiYing:
        {
            return SHAOER_QuPeiYing_JUSTALK_APP_KEY;
        }
            break;
            
        default:
            break;
    }
}

+ (BOOL)IsValidJustalkID:(NSString *)justalkUid {
    if (_NullString(justalkUid)) {
        return NO;
    }
    NSString *uid = [[self class] GetUidWithJustalkID:justalkUid];
    if (_NullString(uid)) {
        return NO;
    }
    NSString *ucid = [[self class] GetUCIDWithJustalkID:justalkUid];
    if (_NullString(ucid) || [ucid isEqualToString:@"0"]) {
        return NO;
    }
    return YES;
}

// 根据justalkUid获取Uid
+ (NSString *)GetUidWithJustalkID:(NSString *)justalkUid {
    if (justalkUid) {
        NSString *gap = @"_";
        NSRange startRange = [justalkUid rangeOfString:gap];
        NSRange endRange = [justalkUid rangeOfString:gap options:NSBackwardsSearch];
        if (startRange.location < justalkUid.length && endRange.location < justalkUid.length && startRange.location != endRange.location) {
            NSRange targetRange;
            targetRange.location = startRange.location + startRange.length;
            targetRange.length = endRange.location - startRange.location - gap.length;
            if (targetRange.location + targetRange.length < justalkUid.length) {
                NSString *uid = [justalkUid substringWithRange:targetRange];
                return uid;
            }
        }
    }
    return nil;
}

// 根据justalk uri获取Uid
+ (NSString *)GetUidWithJustalkUri:(NSString *)uri {
    if (uri) {
        NSString *gap = @":";
        NSRange startRange = [uri rangeOfString:gap];
        NSRange endRange = [uri rangeOfString:@"@" options:NSBackwardsSearch];
        if (startRange.location < uri.length && endRange.location < uri.length && startRange.location != endRange.location) {
            NSRange targetRange;
            targetRange.location = startRange.location + startRange.length;
            targetRange.length = endRange.location - startRange.location - gap.length;
            if (targetRange.location + targetRange.length < uri.length) {
                NSString *justalkUid = [uri substringWithRange:targetRange];
                NSString *uid = [[self class] GetUidWithJustalkID:justalkUid];
                return uid;
            }
        }
    }
    return nil;
}

// 根据justalkUid获取Ucid
+ (NSString *)GetUCIDWithJustalkID:(NSString *)justalkUid {
    if (justalkUid) {
        NSString *gap = @"_";
        NSRange endRange = [justalkUid rangeOfString:gap options:NSBackwardsSearch];
        if ((endRange.location + endRange.length) < justalkUid.length) {
            NSString *ucid = [justalkUid substringFromIndex:(endRange.location + endRange.length)];
            return ucid;
        }
    }
    return nil;
}

// 根据justalkUid获取ID前缀
+ (NSString *)GetIDPrefixWithJustalkID:(NSString *)justalkUid {
    if (justalkUid) {
        NSString *gap = @"_";
        NSRange startRange = [justalkUid rangeOfString:gap];
        if ((startRange.location + startRange.length) < justalkUid.length) {
            NSString *idPrefix = [justalkUid substringToIndex:startRange.location];
            return idPrefix;
        }
    }
    return nil;
}

+ (NSString *)GetJustalkIDWithUid:(NSString *)uid ucid:(NSString *)ucid idPrefix:(NSString *)idPrefix idType:(KDJustalkIdType)type {
    if (_NullString(uid) || !ucid) {
        return nil;
    }
    if (_NullString(idPrefix)) {
        return [[self class] GetJustalkIDWithUid:uid ucid:ucid idType:type];
    }
    NSString *justalkID = nil;
    justalkID = [NSString stringWithFormat:@"%@_%@_%@", idPrefix, uid, ucid];
    return justalkID;
}

+ (NSString *)GetJustalkIDWithUid:(NSString *)uid ucid:(NSString *)ucid idType:(KDJustalkIdType)type {
    if (_NullString(uid) || !ucid) {
        return nil;
    }
    
    NSString *justalkID = nil;
    if (type == KDJustalkIdTypeStudent) {
        switch (_projectType) {
            case kVideoTalkProjectTypeOfFunChatStudent:
            case kVideoTalkProjectTypeOfFunChatTeacher:
            {
                justalkID = kFunChatJustalkIDFormat(uid, ucid);
            }
                break;
            case kVideoTalkProjectTypeOfQuPeiYing:
            {
                justalkID = kQuPeiYingJustalkIDFormat(uid, ucid);
            }
                break;
            case kVideoTalkProjectTypeOfShaoErQuPeiYing:
            {
                justalkID = kShaoErJustalkIDFormat(uid, ucid);
            }
                break;
                
            default:
                break;
        }
    } else {
        switch (_projectType) {
            case kVideoTalkProjectTypeOfFunChatStudent:
            case kVideoTalkProjectTypeOfFunChatTeacher:
            case kVideoTalkProjectTypeOfShaoErQuPeiYing:
            {
                justalkID = kFunChatJustalkIDFormat(uid, ucid);
            }
                break;
            case kVideoTalkProjectTypeOfQuPeiYing:
            {
                justalkID = kQuPeiYingJustalkIDFormat(uid, ucid);
            }
                break;
            default:
                break;
        }
    }
    
    
    return justalkID;
}

+ (NSString *)GetJustalkIDWithUid:(NSString *)uid ucid:(NSString *)ucid idPrefix:(NSString *)idPrefix {
    if (_NullString(uid) || !ucid) {
        return nil;
    }
    if (_NullString(idPrefix)) {
        return [[self class] GetJustalkIDWithUid:uid ucid:ucid];
    }
    NSString *justalkID = nil;
    justalkID = [NSString stringWithFormat:@"%@_%@_%@", idPrefix, uid, ucid];
    return justalkID;
}

+ (NSString *)GetJustalkIDWithUid:(NSString *)uid ucid:(NSString *)ucid {
    if (_NullString(uid) || !ucid) {
        return nil;
    }
    
    NSString *justalkID = nil;
    switch (_projectType) {
        case kVideoTalkProjectTypeOfFunChatStudent:
        case kVideoTalkProjectTypeOfFunChatTeacher:
        case kVideoTalkProjectTypeOfShaoErQuPeiYing:
        {
            justalkID = kFunChatJustalkIDFormat(uid, ucid);
        }
            break;
        case kVideoTalkProjectTypeOfQuPeiYing:
        {
            justalkID = kQuPeiYingJustalkIDFormat(uid, ucid);
        }
            break;
//        case kVideoTalkProjectTypeOfShaoErQuPeiYing:
//        {
//            justalkID = kShaoErJustalkIDFormat(uid, ucid);
//        }
//            break;
            
        default:
            break;
    }

    return justalkID;
}

+ (BOOL)IsCallOutWithType:(kVideoTalkCallInOutType)callType {
    switch (callType) {
        case kVideoTalkCallOutType:
        {
            return YES;
        }
            break;
        case kVideoTalkReceiveCallType:
        {
            return NO;
        }
            break;
            
        default:
            break;
    }
    return NO;
}

+ (BOOL)IsReceiveCallWithType:(kVideoTalkCallInOutType)callType {
    return ![[self class] IsCallOutWithType:callType];
}

#pragma mark - 接口配置

// 鉴权接口
+ (NSString *)SignCheckApi {
    NSString *api = nil;
    switch (_projectType) {
        case kVideoTalkProjectTypeOfQuPeiYing:
        case kVideoTalkProjectTypeOfShaoErQuPeiYing:
        {
            api = @"funchat_justalksign";
        }
            break;
        case kVideoTalkProjectTypeOfFunChatStudent:
        {
            api = @"user_tencentsign";
        }
            break;
        case kVideoTalkProjectTypeOfFunChatTeacher:
        {
            api = @"teacher_tencentsign";
        }
            break;
            
        default:
            break;
    }
    return api;
}

// 是否连接测试服务器
+ (BOOL)IsTestServer {
    BOOL isTestServer = YES;
    switch (_projectType) {
        case kVideoTalkProjectTypeOfFunChatStudent:
        {
            isTestServer = [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"IS_TEST_SERVER"] boolValue];
        }
            break;
        case kVideoTalkProjectTypeOfFunChatTeacher:
        {
            isTestServer = [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"APITESTModeSwitch"] boolValue];
        }
            break;
        case kVideoTalkProjectTypeOfQuPeiYing:
        case kVideoTalkProjectTypeOfShaoErQuPeiYing:
        {
            isTestServer = [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"APITestMode"] boolValue];
        }
            break;
            
        default:
            break;
    }
    return isTestServer;
}

// 是否接收到来电埋点
+ (NSString *)NoticeReceiveCall {
    NSString *api = nil;
    if (_projectType == kVideoTalkProjectTypeOfFunChatTeacher) {
        api = @"teacher_connectcall";
    }
    return api;
}

// 通话信息
+ (NSString *)RecordInfo {
    NSString *api = nil;
    if (_projectType == kVideoTalkProjectTypeOfFunChatStudent) {
        api = @"web_recordinfo";
    }
    return api;
}

// 通知服务器，老师不在线
+ (NSString *)TeacherOffline {
    NSString *api = nil;
    if (_projectType == kVideoTalkProjectTypeOfFunChatStudent) {
        api = @"user_tchoffline";
    }
    return api;
}

// 弹评论的时长
+ (NSInteger)CommentSecondsWithCallType:(kVideoTalkCallInOutType)callType {
    return callType == kVideoTalkCallOutType ? kRequestCommentSeconds : 0;
//    switch (_projectType) {
//        case kVideoTalkProjectTypeOfFunChatStudent: {
//            
//        }
//            break;
//        case kVideoTalkProjectTypeOfFunChatTeacher: {
//
//        }
//            break;
//        case kVideoTalkProjectTypeOfQuPeiYing: {
//
//        }
//            break;
//        case kVideoTalkProjectTypeOfShaoErQuPeiYing: {
//
//        }
//            break;
//            
//        default:
//            break;
//    }
}

// 根据JustalkID获取服务器的会话ID
+ (NSString *)RequestUCallID {
    NSString *api;
    switch (_projectType) {
        case kVideoTalkProjectTypeOfFunChatStudent: {
            api = @"user_getmycallid";
        }
            break;
        case kVideoTalkProjectTypeOfFunChatTeacher: {
            api = @"teacher_getmycallid";
        }
            break;
        case kVideoTalkProjectTypeOfQuPeiYing:
        case kVideoTalkProjectTypeOfShaoErQuPeiYing: {
            api = @"funchat_myCallid";
        }
            break;
            
        default:
            break;
    }
    return api;
}

// 获取通话结束的通话信息
+ (NSString *)RequestCallInfo {
    NSString *api;
    switch (_projectType) {
        case kVideoTalkProjectTypeOfFunChatStudent: {
            api = @"user_getcallinfo";
        }
            break;
        case kVideoTalkProjectTypeOfFunChatTeacher: {
            api = @"teacher_getcallinfo";
        }
            break;
        case kVideoTalkProjectTypeOfQuPeiYing:
        case kVideoTalkProjectTypeOfShaoErQuPeiYing: {
            api = @"funchat_callInfo";
        }
            break;
            
        default:
            break;
    }
    return api;
}

+ (NSString *)DefaultHeadFileName {
    NSString *fileName;
    switch (_projectType) {
        case kVideoTalkProjectTypeOfFunChatStudent: {
            fileName = @"common_avatar_student";
        }
            break;
        case kVideoTalkProjectTypeOfFunChatTeacher: {
            fileName = @"common_photo";
        }
            break;
        case kVideoTalkProjectTypeOfQuPeiYing:
        case kVideoTalkProjectTypeOfShaoErQuPeiYing: {
            
        }
            break;
            
        default:
            break;
    }
    return fileName;
}

+ (NSInteger)TalkWarnSeconds {
    return kTalkWarnSeconds;
}

// 中文?
+ (BOOL)IsChineseLanguage {
    BOOL isCh = YES;
    switch (_projectType) {
        case kVideoTalkProjectTypeOfFunChatTeacher:
        {
            isCh = NO;
        }
            break;
        default:
            break;
    }
    return isCh;
}


// 请求成功的status值
+ (BOOL)isRequestSuccessWithStatus:(NSInteger)status {
    BOOL isSuccess;
    switch (_projectType) {
        case kVideoTalkProjectTypeOfFunChatStudent:
        case kVideoTalkProjectTypeOfFunChatTeacher: {
            isSuccess = status == 0;
        }
            break;
        case kVideoTalkProjectTypeOfQuPeiYing:
        case kVideoTalkProjectTypeOfShaoErQuPeiYing: {
            isSuccess = status == 1;
        }
            break;
            
        default:
            break;
    }
    return isSuccess;
}

+ (UIColor *)GetBrushColorWithCallType:(kVideoTalkCallInOutType)callType {
    UIColor *drawColor = nil;
    switch (callType) {
        case kVideoTalkCallOutType: {
            drawColor = [UIColor colorWithHexString:@"ffd800"]; // 黄色
        }
            break;
        case kVideoTalkReceiveCallType: {
            drawColor = [UIColor colorWithHexString:@"eb0000"]; // 红色
        }
        default:
            break;
    }
    return drawColor;
}

+ (CGFloat)GetBrushLineWidthWithType:(kVideoTalkCallInOutType)callType {
    CGFloat brushWith = 4;
    return brushWith;
}

// 判断是否打开Justalk探测 (当bHaveParam为YES时，为设置方法，当bHaveParam为NO时，为获取方法)
+ (BOOL)IsOpenCheckOnline:(NSString *)bOpenString isHaveInParam:(BOOL)bHaveParam {
    static BOOL isOpen = YES;
    if (bHaveParam && bOpenString) {
        BOOL bOpen = [bOpenString isEqualToString:@"YES"];
        isOpen = bOpen;
    }
    return isOpen;
}

@end
