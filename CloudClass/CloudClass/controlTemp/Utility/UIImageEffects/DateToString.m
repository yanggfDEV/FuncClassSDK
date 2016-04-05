//
//  DateToString.m
//  EnglishTalk
//
//  Created by DING FENG on 2/9/15.
//  Copyright (c) 2015 ishowtalk. All rights reserved.
//

#import "DateToString.h"

@implementation DateToString


//当天信息统一显示为“上午10:05”、“下午12:08”这样的形式，12：00起算下午，昨天的信息显示为“昨天”，再早之前在当月的显示为“1月4日”这样的月+日，非当月显示“2014年12月30日”的年月日格式。

+(NSString *)getDateDetailStringFrom:(NSDate *)date{
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    
    NSCalendarUnit units = NSDayCalendarUnit|NSMonthCalendarUnit;
    // if `date` is before "now" (i.e. in the past) then the components will be positive
    NSDateComponents *components = [[NSCalendar currentCalendar] components:units
                                                                   fromDate:date
                                                                     toDate:[NSDate date]
                                                                    options:0];


if (components.month > 0)
{
        NSString  *timeShow;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY年MM月dd日"];
        NSString *currentDateStr = [dateFormatter stringFromDate:date];
        timeShow = currentDateStr;
        return timeShow;
        
}
else
if (components.day > 0)
{
        if (components.day > 1)
        {
            
            NSString  *timeShow;
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"YYYY年MM月dd日"];
            NSString *currentDateStr = [dateFormatter stringFromDate:date];
            timeShow = currentDateStr;
            NSLog(@"getDateDetailStringFrom:  %@",timeShow);
            NSDateFormatter *dateFormatter_now = [[NSDateFormatter alloc] init];
            [dateFormatter_now setDateFormat:@"YYYY年MM月"];
            NSString *timeShow_now = [dateFormatter_now stringFromDate:[NSDate  date]];
            NSLog(@"getDateDetailStringFrom:  %@",timeShow_now);
            if([timeShow rangeOfString:timeShow_now].location!=NSNotFound){
                
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"MM月dd日"];
                NSString *currentDateStr = [dateFormatter stringFromDate:date];
                timeShow = currentDateStr;
            }
            return timeShow;

        } else {
            return @"昨天";
        }
} else
{
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm a"];
        NSString  *timeShow;
        timeShow =[formatter stringFromDate:date];
        
        if([timeShow rangeOfString:@"PM"].location!=NSNotFound){
            timeShow = [timeShow   stringByReplacingOccurrencesOfString:@"PM" withString:@""];
            timeShow = [NSString  stringWithFormat:@"下午 %@",timeShow];
        }

        if([timeShow rangeOfString:@"AM"].location!=NSNotFound){
            timeShow = [timeShow   stringByReplacingOccurrencesOfString:@"AM" withString:@""];
            timeShow = [NSString  stringWithFormat:@"上午 %@",timeShow];
        }
        return timeShow;
}

}


@end
