//
//  FCUserTalkTransferModel.h
//  Pods
//
//  Created by 刘滔 on 15/9/17.
//
//

#import <Foundation/Foundation.h>
#import "FCVideoTalkProtocol.h"

#define kPeerAvatarKey @"peer_avatar"
#define kRemainTimeKey @"remain_time"
#define kLessonTitleKey @"lsn_title"        // 课程详情title
#define kCourseTitleKey @"course_title"     // 课程列表title
#define kLessonIDKey    @"lsn_id"
#define kCourseDownloadUrlKey   @"lsn_downloadurl"  // 卡片下载url

@interface FCUserTalkTransferModel : NSObject

@property (strong, nonatomic) NSString *targetUcid;
@property (strong, nonatomic) NSString *targetPicUrl;//对方图片
@property (strong, nonatomic) NSString *myAvatarUrl;
@property (strong, nonatomic) NSString *limitTime;
@property (strong, nonatomic) NSString *packageAvaibleTime;
@property (assign, nonatomic) kVideoTalkCallInOutType callType;
@property (strong, nonatomic) NSString *courseName;//小标题
@property (strong, nonatomic) NSString *courseName_En;
@property (strong, nonatomic) NSString *courseID;
@property (strong, nonatomic) NSString *courseDownloadUrl;
@property (strong, nonatomic) NSString *titleName;//大标题
@property (strong, nonatomic) NSString *titleName_En;
@property (strong, nonatomic) NSArray *imagePaths;  // 图片所有路径
@property (strong, nonatomic) NSString *targetName; //对方name
- (NSData *)jsonData;
- (NSData *)courseInfoJsonData;

@end


#define kUserTextExtraModelKey  @"kUserTextExtraModelKey"
#define kUserVideoTalkSecsKey   @"kUserVideoTalkSecsKey"

@interface FCUserTextExtraModel : NSObject

@property (strong, nonatomic) NSString *uid;    // 当前平台ID
@property (nonatomic, strong) NSString *confid; //会议id
@property (nonatomic, strong) NSString *ucid;   // 全平台ID
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *avatarName;
@property (strong, nonatomic) NSString *picMessageName;

@property (strong, nonatomic) NSString *targetUid;
@property (strong, nonatomic) NSString *targetUcid;
@property (strong, nonatomic) NSString *targetIDPrefix;
@property (strong, nonatomic) NSString *targetUserName;
@property (strong, nonatomic) NSString *targetAvatarName;
@property (assign, nonatomic) kVideoTalkCallInOutType targetType;

- (void)judgeNull;
- (NSString *)identify;
- (NSString *)targetIdentify;

@end
