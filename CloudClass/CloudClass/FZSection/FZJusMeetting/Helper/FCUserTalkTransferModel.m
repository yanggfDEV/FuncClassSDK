//
//  FCUserTalkTransferModel.m
//  Pods
//
//  Created by 刘滔 on 15/9/17.
//
//

#import "FCUserTalkTransferModel.h"
#import "FCJusTalkConfigHandler.h"

@implementation FCUserTalkTransferModel

- (NSData *)jsonData {
    NSData *data = [NSJSONSerialization dataWithJSONObject:@{kPeerAvatarKey : self.myAvatarUrl, kRemainTimeKey : self.limitTime} options:0 error:nil];
    return data;
}

- (NSData *)courseInfoJsonData {
    [self judgeNull];
    NSData *data = [NSJSONSerialization dataWithJSONObject:@{kPeerAvatarKey : self.myAvatarUrl,
                                                             kRemainTimeKey : self.limitTime,
                                                             kLessonTitleKey : self.courseName_En,
                                                             kCourseTitleKey : self.titleName_En,
                                                             kLessonIDKey : self.courseID,
                                                             kCourseDownloadUrlKey : self.courseDownloadUrl
                                                             }
                                                   options:0 error:nil];
    return data;
}

- (void)judgeNull {
    if (!self.targetUcid) {
        self.targetUcid = @"";
    }
    if (!self.targetPicUrl) {
        self.targetPicUrl = @"";
    }
    if (!self .myAvatarUrl) {
        self.myAvatarUrl = @"";
    }
    if (!self.limitTime) {
        self.limitTime = @"0";
    }
    if (!self.packageAvaibleTime) {
        self.packageAvaibleTime = @"0";
    }
    if (!self.courseName) {
        self.courseName = @"";
    }
    if (!self.courseID) {
        self.courseID = @"";
    }
    if (!self.courseDownloadUrl) {
        self.courseDownloadUrl = @"";
    }
    if (!self.titleName) {
        self.titleName = @"";
    }
    if (!self.titleName_En) {
        self.titleName_En = @"";
    }
    if (!self.courseName_En) {
        self.courseName_En = @"";
    }
}

@end

@implementation FCUserTextExtraModel

- (void)judgeNull {
    if (!self.uid) {
        self.uid = @"";
    }
    if (!self.ucid) {
        self.ucid = @"";
    }
    if (!self.userName) {
        self.userName = @"";
    }
    if (!self.avatarName) {
        self.avatarName = @"";
    }
    if (!self.picMessageName) {
        self.picMessageName = @"";
    }
    if (!self.targetUid) {
        self.targetUid = @"";
    }
    if (!self.targetUserName) {
        self.targetUserName = @"";
    }
    if (!self.targetAvatarName) {
        self.targetAvatarName = @"";
    }
}

- (NSString *)identify {
    if (!self.uid || !self.ucid) {
        return nil;
    }
    NSString *identify = [FCJusTalkConfigHandler GetJustalkIDWithUid:self.uid ucid:self.ucid idType:KDJustalkIdTypeStudent];
    return identify;
}

- (NSString *)targetIdentify {
//    if (!self.targetUid || !self.targetUcid) {
//        return nil;
//    }
//    NSString *identify = [FCJusTalkConfigHandler GetJustalkIDWithUid:self.targetUid ucid:self.targetUcid idPrefix:self.targetIDPrefix idType:KDJustalkIdTypeTeacher];
    NSString *identify = [NSString stringWithFormat:@"std_%@", [FZLoginUser userID]];
    return identify;
}

@end
