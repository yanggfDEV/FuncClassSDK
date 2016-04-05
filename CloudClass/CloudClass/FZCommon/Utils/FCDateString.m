//
//  FCDateString.m
//  FunChat
//
//  Created by Feizhu Tech . on 15/6/26.
//  Copyright (c) 2015年 hanbingquan. All rights reserved.
//

#import "FCDateString.h"
#import <FZLocalization.h>

@implementation FCDateString

+ (NSString*)currentDate {
    //获取当前时间
    NSDate *now = [NSDate date];

    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    int year = [dateComponent year];
    int month = [dateComponent month];
    int day = [dateComponent day];
    int hour = [dateComponent hour];
    int minute = [dateComponent minute];
    int second = [dateComponent second];
    return [NSString stringWithFormat:@"%02d%02d%02d %02d:%02d:%02d", year, month, day, hour, minute, second];
}

+ (NSString *)hmsDateForSeconds:(NSUInteger)seconds
{
    NSUInteger second = seconds % 60;
    NSUInteger minute = seconds / 60 % 60;
    NSUInteger hour = seconds / 60 / 60;
    
    NSString *time = nil;
    if (hour > 0) {
        time = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (unsigned long)hour, (unsigned long)minute, (unsigned long)second];
    } else {
        time = [NSString stringWithFormat:@"%02ld:%02ld", (unsigned long)minute, (unsigned long)second];
    }
    return time;
}

//时分
+ (NSString *)hmsTimeLengthFromSeconds:(NSUInteger)seconds
{
//    NSUInteger second = seconds % 60;
    NSUInteger minute = seconds /60 % 60;
    NSUInteger hour = seconds /60 /60;
    
    NSString *time = nil;
    if(hour > 0){
        
        if(minute > 0){
            time = [NSString stringWithFormat:@"%ld小时%02ld分", (unsigned long)hour, (unsigned long)minute];
        }else{
            time = [NSString stringWithFormat:@"%ld小时", (unsigned long)hour];
        }
        
        return time;
    }if(minute > 0){
        time = [NSString stringWithFormat:@"%ld分", (unsigned long)minute];
    }else{
        return @"0分";
    }
    
    return time;
}
//小时分秒
+ (NSString *)hmsTimeLengthWithHMSfromSecond:(NSInteger)seconds
{
    NSUInteger second = seconds % 60;
    NSUInteger minute = seconds /60 % 60;
    NSUInteger hour = seconds /60 /60;
    
    NSString *time = nil;
    if(hour > 0){
        
        if(minute > 0){
            
            if(second > 0){
                  time = [NSString stringWithFormat:@"%ld小时%02ld分%02ld秒", (unsigned long)hour, (unsigned long)minute,(unsigned long)second];
            }else{
                time = [NSString stringWithFormat:@"%ld小时%02ld分", (unsigned long)hour, (unsigned long)minute];
            }
        }else{
            
            if(second > 0){
                time = [NSString stringWithFormat:@"%ld小时%02ld秒", (unsigned long)hour, (unsigned long)second];
            }else{
                 time = [NSString stringWithFormat:@"%ld小时", (unsigned long)hour];
            }
        }
        
        return time;
    }if(minute > 0){
        
        if(second > 0){
            time = [NSString stringWithFormat:@"%02ld分%02ld秒",  (unsigned long)minute,(unsigned long)second];
        }else{
            time = [NSString stringWithFormat:@"%02ld分", (unsigned long)minute];
        }
        
        return time;
        
    }else{
        
        if(second > 0){
            time = [NSString stringWithFormat:@"%02ld秒",(unsigned long)second];
        }else{
            return @"0秒";
        }
    }
    
    return time;
}

+ (NSString *)hmsDigitTimeLengthfromSecond:(NSInteger)seconds
{
    NSUInteger second = seconds % 60;
    NSUInteger minute = seconds /60 % 60;
    NSUInteger hour = seconds / (60 * 60);
    
    NSString *time = nil;

    if(hour > 0){
        time = [NSString stringWithFormat:@"%ld%@%02ld%@%02ld%@", (unsigned long)hour,LOCALSTRING(@"ChatRecord_hour"),(unsigned long)minute,LOCALSTRING(@"ChatRecord_minute"),(unsigned long)second,LOCALSTRING(@"ChatRecord_second")];
    }else if(minute >0 && second >0){
         time = [NSString stringWithFormat:@"%ld%@%02ld%@", (unsigned long)minute,LOCALSTRING(@"ChatRecord_minute"),(unsigned long)second,LOCALSTRING(@"ChatRecord_second")];
    }else if(minute >0){
         time = [NSString stringWithFormat:@"%ld%@", (unsigned long)minute,LOCALSTRING(@"ChatRecord_minute")];
    }else if(second >0){
         time = [NSString stringWithFormat:@"%ld%@", (unsigned long)second,LOCALSTRING(@"ChatRecord_second")];
    }
    
    return time;
}

+ (NSDate *)dateFromString:(NSInteger)date //
{
    NSString * string = [NSString stringWithFormat:@"%ld",(long)date];
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"] ];
    [inputFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* inputDate = [inputFormatter dateFromString:string];
    
    return inputDate;
}

+ (NSString *)dateFromInteger:(NSInteger)date
{
    NSString *time = [NSString stringWithFormat:@"%ld",(long)date];
    
    NSInteger num = [time integerValue]/1000;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate*confromTimesp = [NSDate dateWithTimeIntervalSince1970:num];
    NSString*confromTimespStr = [formatter stringFromDate:confromTimesp];
    
    return confromTimespStr;
}

+ (NSDate *)dateFromDateString:(NSString *)date //
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"yyyy-MM-dd"];
    NSDate *outDate = [formatter dateFromString:date];
    return outDate;
}

+(NSInteger)timeFromDate:(NSDate *)date
{
    NSTimeInterval  timeInterval = [date timeIntervalSince1970];
    return timeInterval;
}


+ (NSString *)returnStringFromInteger:(NSInteger)integer
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:integer];
    
    NSDateFormatter *ff=[[NSDateFormatter alloc] init];
    ff.dateFormat = @"yyyy-MM-dd";
    NSString * birth = [ff stringFromDate:date];
    
    return birth;
    
}


+(NSString*)getYeas:(NSInteger)timeSp
{
    if(!timeSp){
        return @"0";
    }
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timeSp];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY"];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSString *nowtimeStr = [formatter stringFromDate:datenow];
    
    NSInteger intyears = nowtimeStr.integerValue - confromTimespStr.integerValue;
    NSString* years = [NSString stringWithFormat:@"%ld",(long)intyears];
    
    
    return years;
    
}

+ (NSString *)dateToDetailDisplayStringForTimeInterval:(NSInteger)originTimeSince1970 {
  //  NSTimeZone *systemTimeZone = [NSTimeZone systemTimeZone];
  //  int secondsFromGMT = (int)[systemTimeZone secondsFromGMT];
    
    int selfSince1970 = (int)originTimeSince1970;// + secondsFromGMT;
    int nowSince1970 = (int)[[NSDate date] timeIntervalSince1970];
    int interval = nowSince1970 - selfSince1970;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *selfDateComponent = [calendar components:unitFlags fromDate:[NSDate dateWithTimeIntervalSince1970:selfSince1970]];
    NSDateComponents *nowDateComponent = [calendar components:unitFlags fromDate:[NSDate date]];
    
    
    if (interval < 0) {
        return @"";
    }else if ([selfDateComponent day] == [nowDateComponent day] && [selfDateComponent month] == [nowDateComponent month] && [selfDateComponent year] == [nowDateComponent year]) {
        // 今天，显示“HH:mm”
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];
        formater.dateFormat = @"HH:mm";
        NSString *timeStr = [formater stringFromDate:[NSDate dateWithTimeIntervalSince1970:selfSince1970]];
        return timeStr;
    }  else if ([selfDateComponent year] == [nowDateComponent year]) {
        // 本周之前，今年之内，显示“MM-dd ”
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];
        formater.dateFormat = @"yyyy-MM-dd HH:mm";
        return [formater stringFromDate:[NSDate dateWithTimeIntervalSince1970:selfSince1970]];
    } else {
        // 去年及以前，显示“yy-MM-dd”
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];
        formater.dateFormat = @"yyyy-MM-dd";
        return [formater stringFromDate:[NSDate dateWithTimeIntervalSince1970:selfSince1970]];
        return [formater stringFromDate:[NSDate dateWithTimeIntervalSince1970:selfSince1970]];
    }
}

//UI设计要求
+ (NSString *)dateToDetailDisplayStringForTime:(NSInteger)originTimeSince1970 {
    //  NSTimeZone *systemTimeZone = [NSTimeZone systemTimeZone];
    //  int secondsFromGMT = (int)[systemTimeZone secondsFromGMT];
    
    int selfSince1970 = (int)originTimeSince1970;// + secondsFromGMT;
    int nowSince1970 = (int)[[NSDate date] timeIntervalSince1970];
    int interval = nowSince1970 - selfSince1970;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *selfDateComponent = [calendar components:unitFlags fromDate:[NSDate dateWithTimeIntervalSince1970:selfSince1970]];
    NSDateComponents *nowDateComponent = [calendar components:unitFlags fromDate:[NSDate date]];
    
    
    if (interval < 0) {
        return @"";
    }else if ([selfDateComponent day] == [nowDateComponent day] && [selfDateComponent month] == [nowDateComponent month] && [selfDateComponent year] == [nowDateComponent year]) {
        // 今天，显示“HH:mm”
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];
        formater.dateFormat = @"HH:mm";
        NSString *timeStr = [formater stringFromDate:[NSDate dateWithTimeIntervalSince1970:selfSince1970]];
        return timeStr;
    }  else if ([selfDateComponent year] == [nowDateComponent year]) {
        // 本周之前，今年之内，显示“MM-dd ”
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];
        formater.dateFormat = @"yyyy-MM-dd";
        return [formater stringFromDate:[NSDate dateWithTimeIntervalSince1970:selfSince1970]];
    }
    
    return @"";
}

+ (NSString *)dateToDigitDetailDisplayStringFromTimeInterval:(NSInteger)originTimeSince1970 {
    //  NSTimeZone *systemTimeZone = [NSTimeZone systemTimeZone];
    //  int secondsFromGMT = (int)[systemTimeZone secondsFromGMT];
    
    int selfSince1970 = (int)originTimeSince1970;// + secondsFromGMT;
    int nowSince1970 = (int)[[NSDate date] timeIntervalSince1970];
    int interval = nowSince1970 - selfSince1970;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *selfDateComponent = [calendar components:unitFlags fromDate:[NSDate dateWithTimeIntervalSince1970:selfSince1970]];
    NSDateComponents *nowDateComponent = [calendar components:unitFlags fromDate:[NSDate date]];
    
    
    if (interval < 0) {
        return @"";
    }else if ([selfDateComponent day] == [nowDateComponent day] && [selfDateComponent month] == [nowDateComponent month] && [selfDateComponent year] == [nowDateComponent year]) {
        // 今天，显示“HH:mm”
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];
        formater.dateFormat = @"HH:mm";
        NSString *timeStr = [formater stringFromDate:[NSDate dateWithTimeIntervalSince1970:selfSince1970]];
        return timeStr;
    }else if ([selfDateComponent year] == [nowDateComponent year]) {
        // 本周之前，今年之内，显示“MM-dd ”
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];
        formater.dateFormat = @"MM-dd HH:mm";
        return [formater stringFromDate:[NSDate dateWithTimeIntervalSince1970:selfSince1970]];
    }{
        // 去年及以前，显示“yy-MM-dd”
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];
        formater.dateFormat = @"yy-MM-dd HH:mm";
        return [formater stringFromDate:[NSDate dateWithTimeIntervalSince1970:selfSince1970]];
        return [formater stringFromDate:[NSDate dateWithTimeIntervalSince1970:selfSince1970]];
    }
}

@end
