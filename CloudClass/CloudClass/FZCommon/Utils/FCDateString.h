//
//  FCDateString.h
//  FunChat
//
//  Created by Feizhu Tech . on 15/6/26.
//  Copyright (c) 2015年 hanbingquan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FCDateString : NSObject

/**
 *  将秒转为hh:mm:ss
 *
 *  @param seconds 秒
 *
 *  @return 格式为hh:mm:ss的字符串
 */
+ (NSString *)hmsDateForSeconds:(NSUInteger)seconds;
/**
 *  秒数转为 时分秒
 *
 *  @param date 秒
 *
 *  @return NSString
 */
+ (NSString *)hmsTimeLengthFromSeconds:(NSUInteger)seconds;

//时分秒
+ (NSString *)hmsTimeLengthWithHMSfromSecond:(NSInteger)seconds;

//00:03:44
+ (NSString *)hmsDigitTimeLengthfromSecond:(NSInteger)seconds;

+ (NSDate *)dateFromString:(NSInteger )date;// 秒转为日期

+ (NSString *)dateFromInteger:(NSInteger)date; 

+ (NSDate *)dateFromDateString:(NSString *)date;//字符串转为日期

+(NSInteger)timeFromDate:(NSDate *)date;//日期转为秒

+ (NSString *)returnStringFromInteger:(NSInteger)integer;

+(NSString*)getYeas:(NSInteger)timeSp;//返回年龄

+ (NSString *)dateToDetailDisplayStringForTimeInterval:(NSInteger)originTimeSince1970 ;//返回日期

//UI设计要求
+ (NSString *)dateToDetailDisplayStringForTime:(NSInteger)originTimeSince1970;
+ (NSString *)dateToDigitDetailDisplayStringFromTimeInterval:(NSInteger)originTimeSince1970;
+ (NSString *)currentDate;
@end


