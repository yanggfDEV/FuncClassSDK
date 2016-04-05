//
//  FCChatMessageModel.m
//  FunChatStudent
//
//  Created by 刘滔 on 15/10/9.
//  Copyright (c) 2015年 Feizhu Tech. All rights reserved.
//

#import "FCChatMessageModel.h"
#import "FCRealmHandler.h"

@implementation FCChatMessageModel

+ (NSString *)primaryKey {
    return @"timestamp";
}

// Specify default values for properties
+ (NSDictionary *)defaultPropertyValues
{
    double time = [NSDate timeIntervalSinceReferenceDate];
    NSString *dateTime = [NSString stringWithFormat:@"%f", time];
    
    double timestamp = [[NSDate date] timeIntervalSince1970];
    
    return @{@"timestamp" : @(timestamp),
             @"content" : @"",
             @"isFailed" : @NO,
             @"messageDate" : dateTime ,
             @"messagePicFileName" : @"",
             @"userID" : @"",
             @"userUCID" : @"",
             @"targetIDPrefix" : @""};
}

- (id)copyWithZone:(nullable NSZone *)zone {
    FCChatMessageModel *model = [[FCChatMessageModel alloc] init];
    model.userID = self.userID;
    model.userUCID = self.userUCID;
    model.timestamp = self.timestamp;
    model.isMy = self.isMy;
    model.messageType = self.messageType;
    model.content = self.content;
    model.isFailed = self.isFailed;
    model.messageDate = self.messageDate;
    model.messagePicFileName = self.messagePicFileName;
    model.messageStutus = self.messageStutus;
    model.targetIDPrefix = self.targetIDPrefix;
    return model;
}

- (void)judgeNull {
    if (self.timestamp == 0) {
        self.timestamp = [[NSDate date] timeIntervalSince1970];
    }
    if (!self.userID) {
        self.userID = @"";
    }
    if (!self.userUCID) {
        self.userUCID = @"";
    }
    if (!self.content) {
        self.content = @"";
    }
    if (!self.messageDate) {
        self.messageDate = @"";
    }
    if (!self.messagePicFileName) {
        self.messagePicFileName = @"";
    }
    if (!self.targetIDPrefix) {
        self.targetIDPrefix = @"";
    }
}

- (NSString *)thumbnailPicPath {
    if (self.messagePicFileName) {
        NSString *fileName = [NSString stringWithFormat:kPicMessageThumbnailName, self.messagePicFileName];
        NSString *filePath = [kPicMessageCacheDirPath stringByAppendingPathComponent:fileName];
        return filePath;
    }
    return @"";
}

- (NSString *)originPicPath {
    if (self.messagePicFileName) {
        NSString *fileName = [NSString stringWithFormat:kPicMessageOriginName, self.messagePicFileName];
        NSString *filePath = [kPicMessageCacheDirPath stringByAppendingPathComponent:fileName];
        return filePath;
    }
    return @"";
}

// 旧版本兼容处理
- (void)handlerCompatible {
    if (_userID && _userID.length > 1) {
        if ([_userID hasPrefix:@"t"] || [_userID hasPrefix:@"u"]) {
            _userID = [_userID substringFromIndex:1];
        }
    }
    if (_userUCID && [_userUCID isEqualToString:@"(null)"]) {
        _userUCID = @"";
    }
    if (!_targetIDPrefix) {
        _targetIDPrefix = @"ql";
    }
    if (_targetIDPrefix && [_targetIDPrefix isEqualToString:@"(null)"]) {
        _targetIDPrefix = @"";
    }
}

@end
