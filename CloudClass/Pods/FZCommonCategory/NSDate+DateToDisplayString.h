//
//  NSDate+DateToDisplayString.h
//
//
//  Created by  liuyong.
//  Copyright (c) 2015年 . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (DateToDisplayString)

//转换时间为刚刚，几小时，，，
+ (NSString *)dateToDisplayStringForTimeInterval:(NSInteger)originTimeSince1970;
+ (NSString *)dateToDetailDisplayStringForTimeInterval:(NSInteger)originTimeSince1970;

+ (instancetype)parseISODateFormat:(NSString *)raw;

+ (NSString *)dateToDisplayStringForDateString:(NSString *)dateString;
+ (NSString *)weekDayStringInthisWeekWithSelfSince1970:(NSInteger)selfSince1970;

/**
 *  时间转换：HH:MM:SS
 *
 *  @param timeInterval 秒
 *
 *  @return HH:MM:SS 如 00:23:45
 */
+ (NSString *)dateHHMMSSStringForTimeInterval:(NSInteger)timeInterval;

/**
 *  时间转换：HH小时MM分SS秒
 *
 *  @param timeInterval 秒
 *
 *  @return HH:MM:SS 如 00:23:45
 */
+ (NSString *)dateHHMMSSzhCNStringForTimeInterval:(NSInteger)timeInterval;
// @"yyyy-MM-dd HH:mm:ss";
+ (NSString *)dateDetailStringForTimeIntervalSince1970:(NSTimeInterval)timeInterval;
//yyyy.MM.dd
+(NSString *)dateStringForTimeIntervalSince1970:(NSTimeInterval)timeInterval;
@end
