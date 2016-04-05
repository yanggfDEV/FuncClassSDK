//
//  FZLoginUser.m
//  EnglishTalk
//
//  Created by CyonLeuPro on 15/6/9.
//  Copyright (c) 2015年 Feizhu Tech. All rights reserved.
//

#import "FZLoginUser.h"
#import "FXKeyChain.h"

@implementation FZLoginUser


static NSString *const kUserInfoUserID = @"kUserInfoUserID";
static NSString *const kUserInfoCommonUserID = @"kUserInfoCommonUserID";
/**
 * @guangfu yang 16-2-14
 * 密码
 **/
static NSString *const kUserInfoPassWord = @"kUserInfoPassWord";
static NSString *const kUserInfoMsgId = @"kUserInfoMsgId";
static NSString *const kUserInfoReMobile = @"kUserInfoReMobile";

static NSString *const kUserInfoNickname = @"kUserInfoNickname";
static NSString *const kUserInfoAvatar = @"kUserInfoAvatar";
static NSString *const kUserInfoEmail = @"kUserInfoEmail";
static NSString *const kLastUserName = @"kLastUserName";

static NSString *const kUserInfoType = @"kUserInfoType";

static NSString *const kUserInfoAuthToken = @"kUserInfoAuthToken";
static NSString *const kUserInfoRefreshToken = @"kUserInfoRefreshToken";

static NSString *const kUserInfoUploadToken = @"kUserInfoUploadToken";
static NSString *const kUserInfoUploadMessageToken = @"kUserInfoUploadMessageToken";
static NSString *const kUserInfoMessageLogURL = @"kUserInfoMessageLogURL";
static NSString *const kUserInfoAuthTokenExpire = @"kUserInfoAuthTokenExpire";


//user detail info keys
static NSString *const kUserInfoCover = @"kUserInfoCover";
static NSString *const kUserInfoArea = @"kUserInfoArea";
static NSString *const kUserInfoMobile = @"kUserInfoMobile";
static NSString *const kUserInfoSchool = @"kUserInfoSchool";
static NSString *const kUserInfoSchoolName = @"kUserInfoSchoolName";

static NSString *const kUserInfoBrithday = @"kUserInfoBrithday";
static NSString *const kUserInfoSex = @"kUserInfoSex";
static NSString *const kUserInfoCampus = @"kUserInfoCampus";
static NSString *const kUserInfoUserClass = @"kUserInfoUserClass";
static NSString *const kUserInfoUserClassList = @"kUserInfoUserClassList";

static NSString *const kUserInfoTeacherID = @"kUserInfoTeacherID";
static NSString *const kUserInfoImageURL = @"kUserInfoImageURL";
static NSString *const kUserInfoSignature = @"kUserInfoSignature";
static NSString *const kUserInfoUserSchoolIdentity = @"kUserInfoUserSchoolIdentity";
static NSString *const kUserInfoAvatarPrefix = @"kUserInfoAvatarPrefix";

#pragma mark - User Base info
/**
 *   uid
 *
 *  @return uid
 */
+ (NSString *)userID {
    return [self objectFromUserDefaultsKey:kUserInfoUserID];
}

+ (void)setUserID:(NSString *)userID {
    [self saveToUserDefaultsObject:userID forKey:kUserInfoUserID];
}

/**
 *   commonId
 *
 *  @return commonId
 */
+ (NSString *)commonUId {
    return [self objectFromUserDefaultsKey:kUserInfoCommonUserID];
}

+ (void)setCommonUId:(NSString *)commonUID {
    [self saveToUserDefaultsObject:commonUID forKey:kUserInfoCommonUserID];
}

/**
 * @guangfu yang 16-2-14
 * 密码
 **/
+ (NSString *)passWD {
    return [self objectFromUserDefaultsKey:kUserInfoPassWord];
}

+ (void)setPassWD:(NSString *)passWD {
    [self saveToUserDefaultsObject:passWD forKey:kUserInfoPassWord];
}

+ (NSString *)msgId {
    return [self objectFromUserDefaultsKey:kUserInfoMsgId];
}

+ (void)setMsgId:(NSString *)msgId {
    [self saveToUserDefaultsObject:msgId forKey:kUserInfoMsgId];
}

/**
 * @guangfu yang 16-3-2 14:50
 * 记录登录账号的
 **/
+ (NSString *)reMobile {
    return [self objectFromUserDefaultsKey:kUserInfoReMobile];
}

+ (void)setReMobile:(NSString *)reMobile {
    [self saveToUserDefaultsObject:reMobile forKey:kUserInfoReMobile];
}

/**
 *  user nickname
 *
 *  @return nickname
 */
+ (NSString *)nickname {
    return [self objectFromKeyChainKey:kUserInfoNickname];
}

+ (void)setNickname:(NSString *)nickname{
    [self saveToKeyChainObject:nickname forKey:kUserInfoNickname];
}


+ (NSString *)avatar {
    return [self objectFromUserDefaultsKey:kUserInfoAvatar];
}

+ (void)setAvatar:(NSString *)avatar {
    [self saveToUserDefaultsObject:avatar forKey:kUserInfoAvatar];
}

+ (NSString *)email {
    return [self objectFromUserDefaultsKey:kUserInfoEmail];
}

+ (void)setEmail:(NSString *)email {
    [self saveToUserDefaultsObject:email forKey:kUserInfoEmail];
}

+ (NSString *)lastUserName {
    return [self objectFromKeyChainKey:kLastUserName];
}

+ (void)setLastUserName:(NSString *)lastUserName {
    [self saveToKeyChainObject:lastUserName forKey:kLastUserName];
}

+ (NSString *)type {
    return [self objectFromUserDefaultsKey:kUserInfoType];
}
+ (void)setType:(NSString *)type {
    [self saveToUserDefaultsObject:type forKey:kUserInfoType];
}

+ (BOOL)isUserType:(FZLoginUserType)userType {
    NSString *currentSaveUserType = [self objectFromUserDefaultsKey:kUserInfoType];
    if (!currentSaveUserType) {
        if(userType == FZLoginUserTypeGuest){
            return YES;
        }
        return NO;
    }
    
    NSString *userTypeSting = [NSString stringWithFormat:@"%d", (int)userType];
    if ([currentSaveUserType containsString:userTypeSting]) {
        return YES;
    }
    
    return NO;
}

+ (BOOL)isGuest{
    return [FZLoginUser isUserType:FZLoginUserTypeGuest];
}


#pragma mark -  token info

/**
 *  用户登录后授权令牌
 *
 *  @return token
 */
+ (NSString *)authToken {
    return [self objectFromKeyChainKey:kUserInfoAuthToken];
}
+ (void)setAuthToken:(NSString *)authToken {
    [self saveToKeyChainObject:authToken forKey:kUserInfoAuthToken];
}

+ (NSString *)refreshToken {
    return [self objectFromKeyChainKey:kUserInfoRefreshToken];
}
+ (void)setRefreshToken:(NSString *)refreshToken {
    [self saveToKeyChainObject:refreshToken forKey:kUserInfoRefreshToken];
}

+ (NSString *)authTokenExpire
{
    return [self objectFromKeyChainKey:kUserInfoAuthTokenExpire];
    
}
+ (void)setAuthTokenExpire:(NSString *)authTokenExpire
{
    [self saveToKeyChainObject:authTokenExpire forKey:kUserInfoAuthTokenExpire];
    
}


/**
 *  七牛上传授权
 *
 *  @return token
 */
+ (NSString *)uploadToken {
    return [self objectFromKeyChainKey:kUserInfoUploadToken];
}
+ (void)setUploadToken:(NSString *)uploadToken {
    [self saveToKeyChainObject:uploadToken forKey:kUserInfoUploadToken];
}


/**
 *  聊天文件上传七牛token
 *
 *  @return token
 */
+ (NSString *)uploadMessageToken {
    return [self objectFromKeyChainKey:kUserInfoUploadMessageToken];
}
+ (void)setUploadMessageToken:(NSString *)uploadMessageToken {
    [self saveToKeyChainObject:uploadMessageToken forKey:kUserInfoUploadMessageToken];
}

/**
 *  聊天文件前缀
 *
 *  @return url
 */
+ (NSString *)messageLogURL {
    return [self objectFromUserDefaultsKey:kUserInfoMessageLogURL];
}
+ (void)setMessageLogURL:(NSString *)messageLogURL {
    [self saveToUserDefaultsObject:messageLogURL forKey:kUserInfoMessageLogURL];
}


#pragma mark - User detail info
/**
 *  用户主页背景
 *
 *  @return
 */
+ (NSString *)cover {
    return [self objectFromUserDefaultsKey:kUserInfoCover];
}
+ (void)setCover:(NSString *)cover  {
    [self saveToUserDefaultsObject:cover forKey:kUserInfoCover];
}

+ (NSString *)area {
    return [self objectFromUserDefaultsKey:kUserInfoArea];
}
+ (void)setArea:(NSString *)area  {
    [self saveToUserDefaultsObject:area forKey:kUserInfoArea];
}

+ (NSString *)mobile {
    return [self objectFromUserDefaultsKey:kUserInfoMobile];
}
+ (void)setMobile:(NSString *)mobile  {
    [self saveToUserDefaultsObject:mobile forKey:kUserInfoMobile];
}

+ (NSString *)school {
    return [self objectFromUserDefaultsKey:kUserInfoSchool];
}
+ (void)setSchool:(NSString *)school {
    [self saveToUserDefaultsObject:school forKey:kUserInfoSchool];
}

+ (NSString *)schoolName {
    return [self objectFromUserDefaultsKey:kUserInfoSchoolName];
}

+ (void)setSchoolName:(NSString *)schoolName {
    [self saveToUserDefaultsObject:schoolName forKey:kUserInfoSchoolName];
}


+ (NSString *)birthday {
    return [self objectFromUserDefaultsKey:kUserInfoBrithday];
}
+ (void)setBirthday:(NSString *)birthday {
    [self saveToUserDefaultsObject:birthday forKey:kUserInfoBrithday];
}

/**
 *  1男 2女 0无
 *
 *  @return int
 */
+ (NSInteger)sex {
    return [self integerFromUserDefaultsKey:kUserInfoSex];
}
+ (void)setSex:(NSInteger)sex {
    [self saveToUserDefaultsInteger:sex forKey:kUserInfoSex];
}

/**
 *  用户签名
 *
 *  @return
 */
+ (NSString *)signature {
    return [self objectFromUserDefaultsKey:kUserInfoSignature];
}

+ (void)setSignature:(NSString *)signature {
    [self saveToUserDefaultsObject:signature forKey:kUserInfoSignature];
}


/**
 *  校区
 *
 *  @return
 */
+ (NSString *)campus {
    return [self objectFromUserDefaultsKey:kUserInfoCampus];
}
+ (void)setCampus:(NSString *)campus {
    [self saveToUserDefaultsObject:campus forKey:kUserInfoCampus];
}

/**
 *  用户班级
 *
 *  @return
 */
+ (NSString *)userClass {
    return [self objectFromUserDefaultsKey:kUserInfoUserClass];
}

+ (void)setUserClass:(NSString *)userClass {
    [self saveToUserDefaultsObject:userClass forKey:kUserInfoUserClass];
}

/**
 *  ishow 学员班级列表
 *
 *  @return
 */
+ (NSArray *)userClassList {
    return [[FXKeychain defaultKeychain] objectForKey:kUserInfoUserClassList];
}
+ (void)setUserClassList:(NSArray *)userClassList {
    [[FXKeychain defaultKeychain] setObject:userClassList forKey:kUserInfoUserClassList];
}

+ (NSString *)teacherID {
    return [self objectFromUserDefaultsKey:kUserInfoTeacherID];
}
+ (void)setTeacherID:(NSString *)teacherID {
    [self saveToUserDefaultsObject:teacherID forKey:kUserInfoTeacherID];
}


/**
 *  用于截取和拼接头像
 *
 *  @return url
 */
+ (NSString *)imageURL {
    return [self objectFromUserDefaultsKey:kUserInfoImageURL];
}
+ (void)setImageURL:(NSString *)imageURL {
    [self saveToUserDefaultsObject:imageURL forKey:kUserInfoImageURL];
}

/**
 *  用户身份：0 普通学生 1 老师
 *
 *  @return int
 */
+ (NSInteger)userSchoolIdentity{
    return [self integerFromUserDefaultsKey:kUserInfoUserSchoolIdentity];
}
+ (void)setUserSchoolIdentity:(NSInteger)userSchoolIdentity{
    [self saveToUserDefaultsInteger:userSchoolIdentity forKey:kUserInfoUserSchoolIdentity];
}

+ (NSString *)avatarPrefix {
    return [self objectFromUserDefaultsKey:kUserInfoAvatarPrefix];
}

+ (void)setAvatarPrefix:(NSString *)avatarPrefix {
    [self saveToUserDefaultsObject:avatarPrefix forKey:kUserInfoAvatarPrefix];
}

#pragma mark - Common Method

+ (id)objectFromUserDefaultsKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+ (void)saveToUserDefaultsObject:(id)object forKey:(NSString *)key {
    if (object && ![object isKindOfClass:[NSNull class]]) {
        [[NSUserDefaults standardUserDefaults] setObject:object forKey:key];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+ (NSInteger)integerFromUserDefaultsKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] integerForKey:key];
}

+ (void)saveToUserDefaultsInteger:(NSInteger)intValue forKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setInteger:intValue forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)saveToKeyChainObject:(id)object forKey:(NSString *)key {
//    if (object) {
//        [[FXKeychain defaultKeychain] setObject:object forKey:key];
//    } else {
//        [[FXKeychain defaultKeychain] removeObjectForKey:key];
//    }
    if (object && ![object isKindOfClass:[NSNull class]]) {
        [[NSUserDefaults standardUserDefaults] setObject:object forKey:key];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id)objectFromKeyChainKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

@end
