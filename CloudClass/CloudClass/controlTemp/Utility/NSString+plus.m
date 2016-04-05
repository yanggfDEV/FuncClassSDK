//
//  NSString+plus.m
//  EnglishTalk
//
//  Created by DING FENG on 6/7/14.
//  Copyright (c) 2014 ishowtalk. All rights reserved.
//

#import "NSString+plus.h"

@implementation NSString (plus)


-(BOOL)isKindOfURL

{
    NSURL *candidateURL = [NSURL URLWithString:self];
    if (candidateURL && candidateURL.scheme && candidateURL.host)
    {
        return YES;
    }
    return NO;
}
+ (NSString *)getTimeString:(int64_t)startTime {
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:startTime];
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSString *resultString = nil;
    NSDateComponents *startDateComponents = [currentCalendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitWeekday) fromDate:startDate];
    NSDateComponents *todayComments = [currentCalendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
    resultString = [NSString stringWithFormat:@"%ld月%ld日", (long)startDateComponents.month, (long)startDateComponents.day];
    //    resultString = [NSString stringWithFormat:@"%@ %02ld:%02ld", resultString, startDateComponents.hour, startDateComponents.minute];
    return resultString;
}

@end
