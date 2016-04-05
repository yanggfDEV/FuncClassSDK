//
//  FCChatWindowModel.m
//  FunChatStudent
//
//  Created by 刘滔 on 15/10/9.
//  Copyright (c) 2015年 Feizhu Tech. All rights reserved.
//

#import "FCChatWindowModel.h"
#import "FCRealmHandler.h"

@implementation FCChatWindowModel

+ (NSString *)primaryKey {
    return @"userID";
}

// Specify default values for properties
+ (NSDictionary *)defaultPropertyValues
{
    double timestamp = [[NSDate date] timeIntervalSince1970];

    return @{@"userID" : @"",
             @"userUCID" : @"",
             @"timestamp" : @(timestamp),
             @"userName" : @"",
             @"headPicPath" : @"",
             @"noReadCount" : @0,
             @"recentMessageDate" : @"",
             @"recentMessageContent" : @"",
             @"countryChstr" : @"",
             @"star" : @"",
             @"levelName" : @"",
             @"price" : @"",
             @"sex" : @0,
             @"isCollect" : @"",
             @"targetIDPrefix" : @""};
}

- (id)copyWithZone:(nullable NSZone *)zone {
    FCChatWindowModel *model = [[FCChatWindowModel alloc] init];
    
    model.userID = self.userID;
    model.userUCID = self.userUCID;
    model.userName = self.userName;
    model.headPicPath = self.headPicPath;
    model.noReadCount = self.noReadCount;
    model.recentMessageContent = self.recentMessageContent;
    model.recentMessageDate = self.recentMessageDate;
    model.timestamp = self.timestamp;
    model.countryChstr = self.countryChstr;
    model.star = self.star;
    model.levelName = self.levelName;
    model.price = self.price;
    model.sex = self.sex;
    model.isCollect = self.isCollect;
    model.targetIDPrefix = self.targetIDPrefix;
    
    return model;
}

- (void)judgeNull {
    if (!self.userID) {
        self.userID = @"";
    }
    if (!self.userUCID) {
        self.userUCID = @"";
    }
    if (!self.userName) {
        self.userName = @"";
    }
    if (!self.headPicPath) {
        self.headPicPath = @"";
    }
    if (!self.recentMessageContent) {
        self.recentMessageContent = @"";
    }
    if (!self.recentMessageDate) {
        self.recentMessageDate = @"";
    }
    if (self.timestamp == 0) {
        self.timestamp = [[NSDate date] timeIntervalSince1970];
    }
    if (!self.countryChstr) {
        self.countryChstr = @"";
    }
    if (!self.star) {
        self.star = @"";
    }
    if (!self.levelName) {
        self.levelName = @"";
    }
    if (!self.price) {
        self.price = @"";
    }
    if (!self.isCollect) {
        self.isCollect = @"";
    }
    if (!self.targetIDPrefix) {
        self.targetIDPrefix = @"";
    }
}

- (void)updateModel:(FCChatWindowModel *)model {
    if (self.userID.length == 0 && model.userID) {
        self.userID = model.userID;
    }
    if (self.userUCID.length == 0 && model.userUCID) {
        self.userUCID = model.userUCID;
    }
    if (self.userName.length == 0 && model.userName) {
        self.userName = model.userName;
    }
    if (self.headPicPath.length == 0 && model.headPicPath) {
        self.headPicPath = model.headPicPath;
    }
    if (self.recentMessageContent.length == 0 && model.recentMessageContent) {
        self.recentMessageContent = model.recentMessageContent;
    }
    if (self.recentMessageDate.length == 0 && model.recentMessageDate) {
        self.recentMessageDate = model.recentMessageDate;
    }
    if (self.timestamp == 0) {
        self.timestamp = [[NSDate date] timeIntervalSince1970];
    }
    if (self.countryChstr.length == 0 && model.countryChstr) {
        self.countryChstr = model.countryChstr;
    }
    if (self.star.length == 0 && model.star) {
        self.star = model.star;
    }
    if (self.levelName.length == 0 && model.levelName) {
        self.levelName = model.levelName;
    }
    if (self.price.length == 0 && model.price) {
        self.price = model.price;
    }
    if (self.isCollect.length == 0 && model.isCollect) {
        self.isCollect = model.isCollect;
    }
    if (self.noReadCount == 0 && model.noReadCount != 0) {
        self.noReadCount = model.noReadCount;
    }
    if (self.sex == 0 && model.sex != 0) {
        self.sex = model.sex;
    }
    if (self.targetIDPrefix.length == 0 && model.targetIDPrefix) {
        self.targetIDPrefix = model.targetIDPrefix;
    }
}

- (BOOL)isHaveUserInfo {
    if (self.countryChstr.length > 0 && self.star.length > 0 && self.levelName.length > 0) {
        return YES;
    }
    return NO;
}

// 处理兼容
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
