//
//  FCChatModelConvertHandler.m
//  FunChatStudent
//
//  Created by 刘滔 on 15/10/13.
//  Copyright © 2015年 Feizhu Tech. All rights reserved.
//

#import "FCChatModelConvertHandler.h"
#import "FCChatCache.h"

@implementation FCChatModelConvertHandler

+ (FCChatMessageModel *)convertMessageModelToChatMessage:(MessageModel *)messageModel {
    if (!messageModel) {
        return nil;
    }
    
    FCChatMessageModel *chatMessageModel = [[FCChatMessageModel alloc] init];
    chatMessageModel.isMy = messageModel.msgFromMe;
    chatMessageModel.messageType = messageModel.msgType;
    chatMessageModel.content = messageModel.msgText;
    chatMessageModel.userID = [messageModel userTargetID];
    chatMessageModel.userUCID = [messageModel userTargetUCID];
    chatMessageModel.isFailed = messageModel.isFailed;
    chatMessageModel.timestamp = messageModel.timestamp;
    chatMessageModel.messagePicFileName = [messageModel headPicUrlName];
    chatMessageModel.messageStutus = messageModel.messageStatus;
    chatMessageModel.targetIDPrefix = messageModel.msgTargetIdentify;
    return chatMessageModel;
}

+ (FCChatWindowModel *)convertMessageModelToChatWindow:(MessageModel *)messageModel {
    if (!messageModel) {
        return nil;
    }
    
    FCChatWindowModel *windowModel = [[FCChatWindowModel alloc] init];
    windowModel.userID = [messageModel userTargetID];
    windowModel.userUCID = [messageModel userTargetUCID];
    windowModel.userName = messageModel.msgByTargetUserName;
    windowModel.headPicPath = messageModel.targetHeadPicUrlName;
    windowModel.recentMessageContent = messageModel.msgText;
    windowModel.noReadCount = messageModel.noReadMsgCount;
    windowModel.timestamp = messageModel.timestamp;
    windowModel.targetIDPrefix = [messageModel targetIDPrefix];
    return windowModel;
}

+ (FCChatListModel *)convertMessageModelToChatList:(MessageModel *)messageModel {
    if (!messageModel) {
        return nil;
    }
    
    FCChatListModel *chatList = [[FCChatListModel alloc] init];
    chatList.targetUId = [messageModel userTargetID];
    chatList.targetUcid = [messageModel userTargetUCID];
    chatList.targetIDPrefix = [messageModel targetIDPrefix];
    chatList.targetNickname = messageModel.msgByTargetUserName;
    chatList.targetAvatarImageName = messageModel.targetHeadPicUrlName;
    
    chatList.subContent = messageModel.msgText;
    chatList.myAvatarUrl = messageModel.headPicUrlName;
    chatList.myUId = [messageModel userID];
    chatList.myNickname = messageModel.msgByUserName;
    chatList.time = [[NSDate date] timeIntervalSince1970];
    return chatList;
}

+ (FCChatListModel *)convertChatWindowToChatList:(FCChatWindowModel *)chatWindow {
    if (!chatWindow) {
        return nil;
    }
    
    FCChatListModel *chatList = [[FCChatListModel alloc] init];
    chatList.targetUId = chatWindow.userID;
    chatList.targetUcid = chatWindow.userUCID;
    chatList.targetIDPrefix = chatWindow.targetIDPrefix;
    chatList.targetNickname = chatWindow.userName;
    chatList.subContent = chatWindow.recentMessageContent;
    chatList.time = chatWindow.timestamp;
    chatList.messageCount = [NSString stringWithFormat:@"%zd", chatWindow.noReadCount];
    NSString *headPicPrefix = [FCChatCache headPicPathPrefix];
    NSString *headUrlPath = chatWindow.headPicPath;
//    if ([chatWindow isNoPrefixWithHeadPictureUrl] && headPicPrefix && ![chatWindow.headPicPath hasPrefix:headPicPrefix]) {
    if (headPicPrefix && ![chatWindow.headPicPath hasPrefix:headPicPrefix]) {
        headUrlPath = [headPicPrefix stringByAppendingFormat:@"%@", chatWindow.headPicPath];
    }
    chatList.targetAvatarUrl = headUrlPath;
    return chatList;
}

//+ (MessageModel *)convertUserTextExtraModelToMessageModel:(FCUserTextExtraModel *)extraModel {
//    if (!extraModel) {
//        return nil;     
//    }
//    MessageModel *messageModel = [[MessageModel alloc] init];
//    messageModel.msgByIdentify = [extraModel identify];
//    messageModel.msgByUserName = extraModel.userName;
//    messageModel.headPicUrlName = extraModel.avatarName;
//    
//    messageModel.timestamp = [[NSDate date] timeIntervalSince1970];
//    messageModel.msgTargetIdentify = [extraModel targetIdentify];
//    messageModel.msgByTargetUserName = extraModel.targetUserName;
//    messageModel.targetHeadPicUrlName = extraModel.targetAvatarName;
//    
//    return messageModel;
//}

#pragma mark - 计算时间换算
#pragma mark 判断时间显示方式
+ (NSString *)getMonthTime:(NSTimeInterval)timestamp isChStyle:(BOOL)isCh
{
    NSDate *date = [NSDate date];
    NSDate *myAccountDate = [NSDate dateWithTimeIntervalSince1970:timestamp];
    
    NSDateFormatter *year = [[NSDateFormatter alloc] init];
    NSDateFormatter *month = [[NSDateFormatter alloc] init];
    NSDateFormatter *day = [[NSDateFormatter alloc] init];
    
    year.dateFormat = @"yyyy";
    month.dateFormat = @"MM";
    day.dateFormat = @"dd";
    NSString *timeYear = [year stringFromDate:myAccountDate];
    NSString *timeMonth = [month stringFromDate:myAccountDate];
    NSString *timeDay = [day stringFromDate:myAccountDate];
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *yesterday = [date dateByAddingTimeInterval: -secondsPerDay];
    NSString *dateString = [[myAccountDate description] substringToIndex:10];
    NSString *yesterdayString = [[yesterday description] substringToIndex:10];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:date];
    NSInteger todayYear = [dateComponent year];
    NSInteger todayMonth = [dateComponent month];
    NSInteger todayDay = [dateComponent day];
    if (isCh) {
        if (timestamp < 1) {
            return @"";
        }
        int selfSince1970 = timestamp;// + secondsFromGMT;
        if (selfSince1970 == 0) {
            return @"";
        }
        if (![timeYear isEqualToString:[NSString stringWithFormat:@"%ld", (long)todayYear]]) {
            NSDateFormatter *showFormat = [[NSDateFormatter alloc] init];
            showFormat.dateFormat = @"yyyy-MM-dd HH:mm";
            NSString *time = [showFormat stringFromDate:myAccountDate];
            NSString *birth = [time substringFromIndex:2];
            return birth;
        } else if([dateString isEqualToString:yesterdayString]) {
            NSDateFormatter *showFormat = [[NSDateFormatter alloc] init];
            showFormat.dateFormat = @"HH:mm";
            NSString *birthTime = [showFormat stringFromDate:myAccountDate];
            NSString *birth = [NSString stringWithFormat:@"昨天 %@", birthTime];
            return birth;
        } else if (([timeYear isEqualToString:[NSString stringWithFormat:@"%ld", (long)todayYear]]) && ((todayMonth != [timeMonth intValue] || (todayDay != [timeDay intValue])))) {
            NSDateFormatter *showFormat = [[NSDateFormatter alloc] init];
            showFormat.dateFormat = @"MM-dd HH:mm";
            NSString *birth = [showFormat stringFromDate:myAccountDate];
            return birth;
        } else {
            NSDateFormatter *showFormat = [[NSDateFormatter alloc] init];
            showFormat.dateFormat = @"HH:mm";
            NSString *birth = [showFormat stringFromDate:myAccountDate];
            return birth;
        }
        
    } else {
        if (timestamp < 1) {
            return @"";
        }
        int selfSince1970 = timestamp;// + secondsFromGMT;
        if (selfSince1970 == 0) {
            return @"";
        }
        int nowSince1970 = (int)[[NSDate date] timeIntervalSince1970];
        int interval = nowSince1970 - selfSince1970;
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
        NSDateComponents *selfDateComponent = [calendar components:unitFlags fromDate:[NSDate dateWithTimeIntervalSince1970:selfSince1970]];
        NSDateComponents *nowDateComponent = [calendar components:unitFlags fromDate:[NSDate date]];
        
        
        if (interval < 0) {
            return @"";
        }else if ([selfDateComponent day] == [nowDateComponent day] && [selfDateComponent month] == [nowDateComponent month] && [selfDateComponent year] == [nowDateComponent year]) {
            // 今天，显示“05:21 PM”
            NSDateFormatter *formater = [[NSDateFormatter alloc] init];
            formater.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
            formater.dateFormat = @"hh:mm a";
            NSString *timeStr = [formater stringFromDate:[NSDate dateWithTimeIntervalSince1970:selfSince1970]];
            return timeStr;
        }else if ([selfDateComponent year] == [nowDateComponent year]) {
            // 本周之前，今年之内，显示“09/04 05:21 PM”
            NSDateFormatter *formater = [[NSDateFormatter alloc] init];
            formater.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
            formater.dateFormat = @"MM/dd hh:mm a";
            return [formater stringFromDate:[NSDate dateWithTimeIntervalSince1970:selfSince1970]];
        }{
            // 去年及以前，显示“09/12/14 05:21 AM”
            NSDateFormatter *formater = [[NSDateFormatter alloc] init];
            formater.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
            formater.dateFormat = @"MM/dd/yy hh:mm a";
            return [formater stringFromDate:[NSDate dateWithTimeIntervalSince1970:selfSince1970]];
            return [formater stringFromDate:[NSDate dateWithTimeIntervalSince1970:selfSince1970]];
        }
    }
    return @"";
}

+ (NSString *)getCommentMonthTime:(NSTimeInterval)timestamp isChStyle:(BOOL)isCh
{
    NSDate *date = [NSDate date];
    NSDate *myAccountDate = [NSDate dateWithTimeIntervalSince1970:timestamp];
    
    NSDateFormatter *year = [[NSDateFormatter alloc] init];
    NSDateFormatter *month = [[NSDateFormatter alloc] init];
    NSDateFormatter *day = [[NSDateFormatter alloc] init];
    
    year.dateFormat = @"yyyy";
    month.dateFormat = @"MM";
    day.dateFormat = @"dd";
    NSString *timeYear = [year stringFromDate:myAccountDate];
    NSString *timeMonth = [month stringFromDate:myAccountDate];
    NSString *timeDay = [day stringFromDate:myAccountDate];
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *yesterday = [date dateByAddingTimeInterval: -secondsPerDay];
    NSString *dateString = [[myAccountDate description] substringToIndex:10];
    NSString *yesterdayString = [[yesterday description] substringToIndex:10];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:date];
    NSInteger todayYear = [dateComponent year];
    NSInteger todayMonth = [dateComponent month];
    NSInteger todayDay = [dateComponent day];
    if (isCh) {
        if (![timeYear isEqualToString:[NSString stringWithFormat:@"%ld", (long)todayYear]]) {
            NSDateFormatter *showFormat = [[NSDateFormatter alloc] init];
            showFormat.dateFormat = @"yyyy-MM-dd HH:mm";
            NSString *time = [showFormat stringFromDate:myAccountDate];
            NSString *birth = [time substringFromIndex:2];
            return birth;
        } else if([dateString isEqualToString:yesterdayString]) {
            NSDateFormatter *showFormat = [[NSDateFormatter alloc] init];
            showFormat.dateFormat = @"MM-dd HH:mm";
            NSString *birthTime = [showFormat stringFromDate:myAccountDate];
            NSString *birth = [NSString stringWithFormat:@"%@", birthTime];
            return birth;
        } else if (([timeYear isEqualToString:[NSString stringWithFormat:@"%ld", (long)todayYear]]) && ((todayMonth != [timeMonth intValue] || (todayDay != [timeDay intValue])))) {
            NSDateFormatter *showFormat = [[NSDateFormatter alloc] init];
            showFormat.dateFormat = @"MM-dd HH:mm";
            NSString *birth = [showFormat stringFromDate:myAccountDate];
            return birth;
        } else {
            NSDateFormatter *showFormat = [[NSDateFormatter alloc] init];
            showFormat.dateFormat = @"HH:mm";
            NSString *birth = [showFormat stringFromDate:myAccountDate];
            return birth;
        }
        
    } else {
        if (timestamp < 1) {
            return @"";
        }
        int selfSince1970 = timestamp;// + secondsFromGMT;
        if (selfSince1970 == 0) {
            return @"";
        }
        int nowSince1970 = (int)[[NSDate date] timeIntervalSince1970];
        int interval = nowSince1970 - selfSince1970;
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
        NSDateComponents *selfDateComponent = [calendar components:unitFlags fromDate:[NSDate dateWithTimeIntervalSince1970:selfSince1970]];
        NSDateComponents *nowDateComponent = [calendar components:unitFlags fromDate:[NSDate date]];
        
        
        if (interval < 0) {
            return @"";
        }else if ([selfDateComponent day] == [nowDateComponent day] && [selfDateComponent month] == [nowDateComponent month] && [selfDateComponent year] == [nowDateComponent year]) {
            // 今天，显示“05:21 PM”
            NSDateFormatter *formater = [[NSDateFormatter alloc] init];
            formater.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
            formater.dateFormat = @"hh:mm a";
            NSString *timeStr = [formater stringFromDate:[NSDate dateWithTimeIntervalSince1970:selfSince1970]];
            return timeStr;
        }else if ([selfDateComponent year] == [nowDateComponent year]) {
            // 本周之前，今年之内，显示“09/04 05:21 PM”
            NSDateFormatter *formater = [[NSDateFormatter alloc] init];
            formater.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
            formater.dateFormat = @"MM/dd hh:mm a";
            return [formater stringFromDate:[NSDate dateWithTimeIntervalSince1970:selfSince1970]];
        }{
            // 去年及以前，显示“09/12/14 05:21 AM”
            NSDateFormatter *formater = [[NSDateFormatter alloc] init];
            formater.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
            formater.dateFormat = @"MM/dd/yy hh:mm a";
            return [formater stringFromDate:[NSDate dateWithTimeIntervalSince1970:selfSince1970]];
            return [formater stringFromDate:[NSDate dateWithTimeIntervalSince1970:selfSince1970]];
        }
    }
    return @"";
}

@end
