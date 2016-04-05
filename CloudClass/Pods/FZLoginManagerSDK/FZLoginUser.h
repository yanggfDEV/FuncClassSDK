//
//  FZLoginUser.h
//  EnglishTalk
//
//  Created by CyonLeuPro on 15/6/9.
//  Copyright (c) 2015年 Feizhu Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  用户身份类型
 */
typedef NS_ENUM(NSInteger, FZLoginUserType){
    /**
     *  none
     */
    FZLoginUserTypeNone = -1,
    /**
     *  游客
     */
    FZLoginUserTypeGuest = 0,
    /**
     *  手机
     */
    FZLoginUserTypeMobile,
    /**
     *  QQ
     */
    FZLoginUserTypeQQ,
    /**
     *  微博
     */
    FZLoginUserTypeWeibo,
    /**
     *  微信
     */
    FZLoginUserTypeWeixin,
    /**
     *  iShow学员
     */
    FZLoginUserTypeiShowMember
};


@interface FZLoginUser : NSObject

//@property (strong, nonatomic) NSString *uid;
//@property (strong, nonatomic) NSString *nickname;
//@property (strong, nonatomic) NSString *avatar;
//@property (strong, nonatomic) NSString *email;

#pragma mark - User Base info
/**
 *   uid
 *
 *  @return uid
 */
+ (NSString *)userID;
+ (void)setUserID:(NSString *)userID;

/**
 *  @author Victor Ji, 15-12-07 16:12:08
 *
 *  common uid
 *
 *  @return common uid
 */
+ (NSString *)commonUId;
+ (void)setCommonUId:(NSString *)commonUID;

/**
 *  user nickname
 *
 *  @return nickname
 */
+ (NSString *)nickname;
+ (void)setNickname:(NSString *)nickname;

+ (NSString *)avatar;
+ (void)setAvatar:(NSString *)avatar;

+ (NSString *)email;
+ (void)setEmail:(NSString *)email;

/**
 * @guangfu yang 16-2-14 17:10
 * 密码
 **/
+ (NSString *)passWD;
+ (void)setPassWD:(NSString *)passWD;

/**
 * @gaungfu yang 16-2-23 11:03
 * msgId
 **/
+ (NSString *)msgId;
+ (void)setMsgId:(NSString *)msgId;

/**
 * @guangfu yang 16-3-2 14:50
 * 记录登录账号的
 **/
+ (NSString *)reMobile;
+ (void)setReMobile:(NSString *)reMobile;

/**
 *  上次登录用户名
 *
 *  @return 用户名：昵称或手机号
 */
+ (NSString *)lastUserName;
+ (void)setLastUserName:(NSString *)lastUserName;

/**
 *  用户身份信息:
 0 游客
 1 手机
 2 qq
 3 微博
 4 微信
 5  ishow学员
 自由组合判断
 *
 *  @return string
 */
+ (NSString *)type;
+ (void)setType:(NSString *)type;

+ (BOOL)isUserType:(FZLoginUserType)userType;

/**
 *  是否是游客
 *
 *  @return
 */
+ (BOOL)isGuest;

#pragma mark -  token info

/**
 *  用户登录后授权令牌
 *
 *  @return token
 */
+ (NSString *)authToken;
+ (void)setAuthToken:(NSString *)authToken;

+ (NSString *)refreshToken;
+ (void)setRefreshToken:(NSString *)refreshToken;

+ (NSString *)authTokenExpire;
+ (void)setAuthTokenExpire:(NSString *)authTokenExpire;


/**
 *  七牛上传授权
 *
 *  @return token
 */
+ (NSString *)uploadToken;
+ (void)setUploadToken:(NSString *)uploadToken;

/**
 *  聊天文件上传七牛token
 *
 *  @return token
 */
+ (NSString *)uploadMessageToken;
+ (void)setUploadMessageToken:(NSString *)uploadMessageToken;

/**
 *  聊天文件前缀
 *
 *  @return url
 */
+ (NSString *)messageLogURL;
+ (void)setMessageLogURL:(NSString *)messageLogURL;


#pragma mark - User detail info
/**
 *  用户主页背景
 *
 *  @return
 */
+ (NSString *)cover;
+ (void)setCover:(NSString *)cover;

+ (NSString *)area;
+ (void)setArea:(NSString *)area;

+ (NSString *)mobile;
+ (void)setMobile:(NSString *)mobile;

+ (NSString *)school;
+ (void)setSchool:(NSString *)school;

+ (NSString *)schoolName;
+ (void)setSchoolName:(NSString *)schoolName;

+ (NSString *)birthday;
+ (void)setBirthday:(NSString *)birthday;

/**
 *  1男 2女 0无
 *
 *  @return int
 */
+ (NSInteger)sex;
+ (void)setSex:(NSInteger)sex;

/**
 *  用户签名
 *
 *  @return
 */
+ (NSString *)signature;
+ (void)setSignature:(NSString *)signature;


/**
 *  校区
 *
 *  @return
 */
+ (NSString *)campus;
+ (void)setCampus:(NSString *)campus;

/**
 *  用户班级
 *
 *  @return
 */
+ (NSString *)userClass;
+ (void)setUserClass:(NSString *)userClass;

/**
 *  ishow 学员班级列表
 *
 *  @return
 */
+ (NSArray *)userClassList;
+ (void)setUserClassList:(NSArray *)userClassList;

+ (NSString *)teacherID;
+ (void)setTeacherID:(NSString *)teacherID;


/**
 *  用于截取和拼接头像
 *
 *  @return url
 */
+ (NSString *)imageURL;
+ (void)setImageURL:(NSString *)imageURL;

/**
 *  用户身份：0 普通学生 1 老师
 *
 *  @return int
 */
+ (NSInteger)userSchoolIdentity;
+ (void)setUserSchoolIdentity:(NSInteger)userSchoolIdentity;

// 头像url前缀
+ (NSString *)avatarPrefix;
+ (void)setAvatarPrefix:(NSString *)avatarPrefix;

@end
