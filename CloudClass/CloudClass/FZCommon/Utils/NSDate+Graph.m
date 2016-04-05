//
//  NSDate+Graph.m
//  easycost
//
//  Created by zhou on 13-5-15.
//  Copyright (c) 2013年 mifeng. All rights reserved.
//

#import "NSDate+Graph.h"

@implementation NSDate (Graph)
- (NSDate *)dateWithDaysAhead:(NSInteger)days{
    
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = days;
    
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    NSDate *newDate = [theCalendar dateByAddingComponents:dayComponent toDate:self options:0];
    
    return newDate;
}

//下一天
- (NSDate *)nextDay{
    
    return [self dateWithDaysAhead:1];
}

//前一天
- (NSDate *)previousDay{
    
    return [self dateWithDaysAhead:-1];
}

//前半小时
- (NSDate*)previousHalfHour{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self];
    [components setMinute:([components minute] - 30)];
    return [cal dateFromComponents:components];
}

//下一小时
- (NSDate*)nextHour{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self];
    [components setHour:([components hour] + 1)];
    return [cal dateFromComponents:components];
}

//上一小时
- (NSDate*)previousHour{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self];
    [components setHour:([components hour] - 1)];
    return [cal dateFromComponents:components];
}

//下一周
- (NSDate*)nextWeek{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self];
    [components setDay:([components day] + 7)];
    return [cal dateFromComponents:components];
}

//下一月
- (NSDate*)nextMonth{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self];
    [components setMonth:([components month] + 1)];
    return [cal dateFromComponents:components];
}

//下一年
- (NSDate*)nextYear{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self];
    [components setYear:([components year] + 1)];
    return [cal dateFromComponents:components];
}

- (NSString *)dateFormatYYYYMMDDEEEEAAHHMM{//转化日期:2013年9月9日 星期日 上午11:45
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日 EEEE aahh:mm"];
    NSString *showtimeNew = [formatter stringFromDate:self];
    return showtimeNew;
}

- (NSString *)dateFormatYYMMDDEEEAAHHMM{//转化日期:13/9/9周日 上午11:45
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yy/MM/ddEEE aahh:mm"];
    NSString *showtimeNew = [formatter stringFromDate:self];
    return showtimeNew;
}

- (BOOL)isSameDay:(NSDate*)otherDate{//判断两个日期是否是同一天
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSString *current = [formatter stringFromDate:self];
    NSString *other = [formatter stringFromDate:otherDate];
    return [current isEqualToString:other];
}
- (int)compareTo:(NSDate*)otherDate{//比较两个日期的大小(0相等，-1当前日期较小，1当前日期较大)
    NSTimeInterval interval = [self timeIntervalSince1970];
    long long current = [[NSNumber numberWithDouble:interval] longLongValue];
    interval = [otherDate timeIntervalSince1970];
    long long other = [[NSNumber numberWithDouble:interval] longLongValue];
    if(current == other){
        return 0;
    }else if(current < other){
        return -1;
    }else{
        return 1;
    }
}

- (NSInteger)compareHHmmTo:(NSDate *)otherDate{//比较两个日期的小时和分钟的大小(0相等，-1当前日期较小，1当前日期较大)
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:otherDate];
    
    NSDateComponents *selfComponents = [cal components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self];
    
    [components setYear:([selfComponents year])];
    [components setMonth:([selfComponents month])];
    [components setDay:([selfComponents day])];
    
    return [self compareTo:[cal dateFromComponents:components]];
}

//两个日期之间的天数
+ (NSInteger)daysBetweenDate:(NSDate *)startDate endDate:(NSDate *)endDate{
    NSUInteger unitFlags = NSDayCalendarUnit;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:unitFlags fromDate:startDate toDate:endDate options:0];
    return [components day];
}

//两个日期之间的小时数
+ (NSInteger)hoursBetweenDate:(NSDate *)startDate endDate:(NSDate *)endDate{
    NSInteger oneHour = 60 * 60;
    NSInteger startHour = [self getTimeIntervalSince1970:startDate];
    NSInteger endHour = [self getTimeIntervalSince1970:endDate];
    return (endHour - startHour) / oneHour;
}

//两个日期之间的秒数
+ (NSInteger)secondsBetweenDate:(NSDate *)startDate endDate:(NSDate *)endDate{
    NSInteger startSecond = [self getTimeIntervalSince1970:startDate];
    NSInteger endSecond = [self getTimeIntervalSince1970:endDate];
    return (endSecond - startSecond);
}

//获取自1970年以来的秒数
+ (NSInteger) getTimeIntervalSince1970:(NSDate*)date{
    NSTimeInterval interval;
    if(!date){
       interval = [[NSDate date] timeIntervalSince1970];
    }else{
       interval = [date timeIntervalSince1970];
    }
    return [@(interval) longValue];
}

//获取指定日期的年，月，周(一年中的第几周)，日(一年中的第几日)
+ (NSMutableArray*) getYearMonthWeekForTime:(long long)time firstWeekDayValueIs2:(BOOL)firstWeekDayValueIs2{
    NSDate *curDate = [NSDate dateWithTimeIntervalSince1970:time];
    return [self getYearMonthWeekForDate:curDate firstWeekDayValueIs2:firstWeekDayValueIs2];
}

//获取日期(只有年月日)
+ (NSString*) getYMDByDate:(NSDate*) date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *showtimeNew = [formatter stringFromDate:date];
    return showtimeNew;
}

//根据NSdate返回格式的时间字符串
+ (NSString*) getFormatDate:(NSDate*) date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:NSLocalizedString(@"yyyy年MM月dd日 HH:mm", nil)];
    NSString *showtimeNew = [formatter stringFromDate:date];
    return showtimeNew;
}

@end
