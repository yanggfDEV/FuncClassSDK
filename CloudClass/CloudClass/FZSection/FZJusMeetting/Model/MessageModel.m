//
//  MessageModel.m
//  CloudSample
//
//  Created by Fiona on 7/14/15.
//  Copyright (c) 2015 young. All rights reserved.
//

#import "MessageModel.h"
#import "FCChatMessageModel.h"
//#import "FCJusTalkConfigHandler.h"

@implementation MessageModel

- (NSString *)picFileName {
    if (self.thumbnailPicPath.length > 0 || self.originPicPath.length > 0) {
        NSString *picPath = self.thumbnailPicPath.length > 0 ? self.thumbnailPicPath : self.originPicPath;
        if (!picPath || picPath.length == 0) {
            return nil;
        }
        NSString *fileName = [picPath lastPathComponent];
        NSString *homePath = NSHomeDirectory();
        if (fileName.length > 0 && picPath.length > homePath.length && [picPath hasPrefix:homePath]) {
            NSRange range = [fileName rangeOfString:@"_"];
            if (range.location < fileName.length) {
                fileName = [fileName substringFromIndex:(range.location + range.length)];
            }
        }
        return fileName;
    }
    return nil;
}

- (NSString *)userID {
    if (!self.msgByIdentify) {
        return nil;
    }
    NSString *userID = [FCJusTalkConfigHandler GetUidWithJustalkID:self.msgByIdentify];
    return userID;
}

- (NSString *)userUCID {
    if (!self.msgByIdentify) {
        return nil;
    }
    NSString *userUCID = [FCJusTalkConfigHandler GetUCIDWithJustalkID:self.msgByIdentify];
    return userUCID;
}

- (NSString *)userTargetID {
    if (!self.msgTargetIdentify) {
        return nil;
    }
    NSString *userID = [FCJusTalkConfigHandler GetUidWithJustalkID:self.msgTargetIdentify];
    return userID;
}

- (NSString *)userTargetUCID {
    if (!self.msgTargetIdentify) {
        return nil;
    }
    NSString *userUCID = [FCJusTalkConfigHandler GetUCIDWithJustalkID:self.msgTargetIdentify];
    return userUCID;
}

- (NSString *)targetIDPrefix {
    if (!self.msgTargetIdentify) {
        return nil;
    }
    NSString *targetIDPrefix = [FCJusTalkConfigHandler GetIDPrefixWithJustalkID:self.msgTargetIdentify];
    return targetIDPrefix;
}

@end
