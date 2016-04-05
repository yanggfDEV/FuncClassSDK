//
//  NSDate+DateToDisplayString.m
//  
//
//  Created by liuyong.
//  Copyright (c) 2015年 . All rights reserved.
//

#import "NSDate+DateToDisplayString.h"

@implementation NSDate (DateToDisplayString)

+ (NSString *)dateToDisplayStringForTimeInterval:(NSInteger)originTimeSince1970 {
    
//    NSTimeZone *systemTimeZone = [NSTimeZone systemTimeZone];
//    int secondsFromGMT = (int)[systemTimeZone secondsFromGMT];
    
//    int selfSince1970 = (int)originTimeSince1970;// + secondsFromGMT;
//    int nowSince1970 = (int)[[NSDate date] timeIntervalSince1970];
//    
//    int interval = nowSince1970 - selfSince1970;
//    
//    if (interval > 60 * 60 * 24 * 30 * 365) {
//        return [NSString stringWithFormat:@"%d年前", interval / (60 * 60 * 24 * 30 * 365)];
//    } else if (interval > 60 * 60 * 24 * 30) {
//        return [NSString stringWithFormat:@"%d个月前", interval / (60 * 60 * 24 * 30)];
//    } else if (interval > 60 * 60 * 24) {
//        return [NSString stringWithFormat:@"%d天前", interval / (60 * 60 * 24)];
//    } else if (interval > 60 * 60) {
//        return [NSString stringWithFormat:@"%d小时前", interval / (60 * 60)];
//    } else if (interval > 60) {
//        return [NSString stringWithFormat:@"%d分钟前", interval / 60];
//    } else if (interval >= 0){
//        return @"刚刚";
//    } else {
//        return @"";
//    }
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:originTimeSince1970];
    NSDateComponents *dateComponent = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    NSDateComponents *nowComponent = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
    if (dateComponent.year == nowComponent.year && dateComponent.month == nowComponent.month && dateComponent.day == nowComponent.day) {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        df.dateFormat = @"HH:mm";
        return [df stringFromDate:date];
    } else if (dateComponent.year == nowComponent.year) {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        df.dateFormat = @"MM-dd HH:mm";
        return [df stringFromDate:date];
    } else {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        df.dateFormat = @"yyyy-MM-dd HH:mm";
        return [df stringFromDate:date];
    }
}

+ (NSString *)dateToDetailDisplayStringForTimeInterval:(NSInteger)originTimeSince1970 {
//    NSTimeZone *systemTimeZone = [NSTimeZone systemTimeZone];
//    int secondsFromGMT = (int)[systemTimeZone secondsFromGMT];
    
    int selfSince1970 = (int)originTimeSince1970;// + secondsFromGMT;
    int nowSince1970 = (int)[[NSDate date] timeIntervalSince1970];
    int yesterdaySince1970 = nowSince1970 - 60 * 60 * 24;
    int beforeYesterdaySince1970 = nowSince1970 - 2 * 60 * 60 * 24;
    
    int interval = nowSince1970 - selfSince1970;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *selfDateComponent = [calendar components:unitFlags fromDate:[NSDate dateWithTimeIntervalSince1970:selfSince1970]];
    NSDateComponents *nowDateComponent = [calendar components:unitFlags fromDate:[NSDate date]];
    NSDateComponents *yesterdayComponent = [calendar components:unitFlags fromDate:[NSDate dateWithTimeIntervalSince1970:yesterdaySince1970]];
    NSDateComponents *beforeYesterdayComponent = [calendar components:unitFlags fromDate:[NSDate dateWithTimeIntervalSince1970:beforeYesterdaySince1970]];
    
    NSString *isThisWeekString = [NSDate weekDayStringInthisWeekWithSelfSince1970:selfSince1970];
    
    if (interval < 0) {
        return @"";
    } else if (interval <= 60) {
        // 60S及以内，显示“刚刚”
        return @"刚刚";
    } else if (interval <= 60 * 60) {
        // 60分钟及以内，显示“XX分钟前”
        return [NSString stringWithFormat:@"%d分钟前", (int)interval / 60];
    } else if ([selfDateComponent day] == [nowDateComponent day] && [selfDateComponent month] == [nowDateComponent month] && [selfDateComponent year] == [nowDateComponent year]) {
        // 今天，显示“HH:mm”
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];
        formater.dateFormat = @"HH:mm";
        NSString *timeStr = [formater stringFromDate:[NSDate dateWithTimeIntervalSince1970:selfSince1970]];
        return timeStr;
    } else if ([selfDateComponent day] == [yesterdayComponent day] && [selfDateComponent month] == [yesterdayComponent month] && [selfDateComponent year] == [yesterdayComponent year]) {
        // 昨天，显示“昨天 HH:mm”
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];
        formater.dateFormat = @"HH:mm";
        NSString *timeStr = [formater stringFromDate:[NSDate dateWithTimeIntervalSince1970:selfSince1970]];
        return [NSString stringWithFormat:@"昨天 %@", timeStr];
    } else if ([selfDateComponent day] == [beforeYesterdayComponent day] && [selfDateComponent month] == [beforeYesterdayComponent month] && [selfDateComponent year] == [beforeYesterdayComponent year]) {
        // 前天，显示“前天 HH:mm”
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];
        formater.dateFormat = @"HH:mm";
        NSString *timeStr = [formater stringFromDate:[NSDate dateWithTimeIntervalSince1970:selfSince1970]];
        return [NSString stringWithFormat:@"前天 %@", timeStr];
    } else if (![isThisWeekString isEqualToString:@""]) {
        // 前天之前，本周以内，显示“”
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];
        formater.dateFormat = @"HH:mm";
        NSString *timeStr = [formater stringFromDate:[NSDate dateWithTimeIntervalSince1970:selfSince1970]];
        return [NSString stringWithFormat:@"%@ %@", isThisWeekString, timeStr];
    } else if ([selfDateComponent year] == [nowDateComponent year]) {
        // 本周之前，今年之内，显示“MM-dd HH:mm”
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];
        formater.dateFormat = @"MM-dd HH:mm";
        return [formater stringFromDate:[NSDate dateWithTimeIntervalSince1970:selfSince1970]];
    } else {
        // 去年及以前，显示“yy-MM-dd HH:mm”
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];
        formater.dateFormat = @"yy-MM-dd HH:mm";
        return [formater stringFromDate:[NSDate dateWithTimeIntervalSince1970:selfSince1970]];
        return [formater stringFromDate:[NSDate dateWithTimeIntervalSince1970:selfSince1970]];
    }
}

+ (instancetype)parseISODateFormat:(NSString *)raw{
    NSTimeZone *timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [dateFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss ZZZ"];
    
    return [dateFormatter dateFromString:raw];
}

+ (NSString *)dateToDisplayStringForDateString:(NSString *)dateString {
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"Asia/Shanghai"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSDate *date = [dateFormatter dateFromString:dateString];
    NSTimeInterval timeInterval = [date timeIntervalSince1970];
    return [self dateToDisplayStringForTimeInterval:timeInterval];
}

// @"yyyy-MM-dd HH:mm:ss";

+ (NSString *)dateDetailStringForTimeIntervalSince1970:(NSTimeInterval)timeInterval {
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"Asia/Shanghai"]];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    return dateString;
}

+ (NSString *)weekDayStringInthisWeekWithSelfSince1970:(NSInteger)selfSince1970  {
    BOOL isThisWeek = NO;
    int nowSince1970 = (int)[[NSDate date] timeIntervalSince1970];
    NSInteger sixDaysAgoSince1970 = nowSince1970 - 60 * 60 * 24 * 6;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit;
    
    NSDateComponents *sixDaysAgoComponents = [calendar components:unitFlags fromDate:[NSDate dateWithTimeIntervalSince1970:sixDaysAgoSince1970]];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSDate *sixDaysAgoDate = [df dateFromString:[NSString stringWithFormat:@"%d-%d-%d %d:%d:%d", (int)[sixDaysAgoComponents year], (int)[sixDaysAgoComponents month], (int)[sixDaysAgoComponents day], 0 , 0, 0]];
    
    NSDateComponents *selfDateComponents = [calendar components:unitFlags fromDate:[NSDate dateWithTimeIntervalSince1970:selfSince1970]];
    
    NSDate *selfDate = [df dateFromString:[NSString stringWithFormat:@"%d-%d-%d %d:%d:%d", (int)[selfDateComponents year], (int)[selfDateComponents month], (int)[selfDateComponents day], 0 , 0, 0]];
    
    NSInteger sixDaysAgoForCompare = [sixDaysAgoDate timeIntervalSince1970];
    NSInteger selfDateForCompare = [selfDate timeIntervalSince1970];
    
    NSDateComponents *nowDateComponents = [calendar components:unitFlags fromDate:[NSDate date]];
    
    if (selfDateForCompare < sixDaysAgoForCompare) {
        isThisWeek = NO;
    } else {
        if ([nowDateComponents weekday] == 1) {
            isThisWeek = YES;
        } else if ([selfDateComponents weekday] == 1) {
            if ([nowDateComponents weekday] == 1) {
                isThisWeek = YES;
            } else {
                isThisWeek = NO;
            }
        } else if ([selfDateComponents weekday] <= [nowDateComponents weekday]) {
            isThisWeek = YES;
        } else {
            isThisWeek = NO;
        }
    }

    if (isThisWeek) {
        switch ([selfDateComponents weekday]) {
            case 1:
                return @"周日";
                break;
            case 2:
                return @"周一";
                break;
            case 3:
                return @"周二";
                break;
            case 4:
                return @"周三";
                break;
            case 5:
                return @"周四";
                break;
            case 6:
                return @"周五";
                break;
            case 7:
                return @"周六";
                break;
            default:
                return @"";
                break;
        }
    } else {
        return @"";
    }
}


+ (NSString *)dateHHMMSSStringForTimeInterval:(NSInteger)timeInterval {
    
    NSString *timeString = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(long int)timeInterval / 3600, (long int)timeInterval % 3600 / 60, (long int)timeInterval % 3600 % 60];
    
    return timeString;
}

+ (NSString *)dateHHMMSSzhCNStringForTimeInterval:(NSInteger)timeInterval {
    NSInteger hours = timeInterval / 3600;
    NSInteger minutes = (timeInterval % 3600) / 60;
    
    NSString *hourString = hours > 0 ? [NSString stringWithFormat:@"%ld小时", (long int)hours] : @"";
    NSString *minuteString = minutes > 0 ? [NSString stringWithFormat:@"%ld分", (long int)minutes] : @"";
    
    NSString *retVal = [NSString stringWithFormat:@"%@%@", hourString, minuteString];
    return [retVal isEqualToString:@""] ? @"0分" : retVal;
}


+(NSString *)dateStringForTimeIntervalSince1970:(NSTimeInterval)timeInterval{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter  setTimeStyle:NSDateFormatterShortStyle];
    dateFormatter.dateFormat = @"yyyy.MM.dd";
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}


@end
