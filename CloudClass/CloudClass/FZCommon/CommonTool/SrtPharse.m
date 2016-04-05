//
//  SrtPharse.m
//  SimpleAVPlayer
//
//  Created by DING FENG on 5/26/14.
//  Copyright (c) 2014 dinfeng. All rights reserved.
//

#import "SrtPharse.h"

@implementation SrtPharse

+(NSArray *)pharseSrtFilePath:(NSString *)pathString
{
    NSString *string = [NSString stringWithContentsOfFile:pathString encoding:NSUTF8StringEncoding error:NULL];
    return [self  pharseSrtString:string];
}
+(NSArray *)pharseSrtString:(NSString *)srtString
{
    NSString *string =srtString;
    //    NSLog(@"\n%@",string);
    NSString *stringWithEnd = [NSString  stringWithFormat:@"%@\n\n%@",string,@"99999999"];
    NSArray *lines =[stringWithEnd componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    NSMutableArray *srtDicArray;
    srtDicArray = [[NSMutableArray alloc]  init];
    NSMutableDictionary *tempD = [[NSMutableDictionary alloc]  init];
    for (id line in lines)
    {
        NSScanner* scan = [NSScanner scannerWithString:(NSString *)line];
        int  val;
        int  inIntNum =[scan scanInt:&val] && [scan isAtEnd];
        //        NSLog(@"%@       %d ",line,inIntNum);
        if (inIntNum)
        {
            if ([(NSArray *)tempD.allKeys   count] >0)
            {
                [srtDicArray  addObject:[tempD   mutableCopy]];
                [tempD  removeAllObjects];
            }
            [tempD   setObject:line forKey:@"index"];
        }else
            if ([line  rangeOfString:@"-->"].length >0)
            {
                NSString *time_B_E =line;
                NSArray *B_N_Items = [time_B_E componentsSeparatedByString:@" --> "];
                
                for (NSString *time in B_N_Items)
                {
                    
                    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
                    [dateFormatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss,SSS"];
                    dateFormatter1.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
                    NSString *dateStr = [NSString  stringWithFormat:@"2000-01-01 %@",time];
                    NSDate *date = [dateFormatter1 dateFromString:dateStr];
                    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
                    [dateFormatter2 setDateFormat:@"yyyy-MM-dd HH:mm:ss,SSS"];
                    dateFormatter2.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
                    NSString *dateStrFrom = @"2000-01-01 00:00:00,000";
                    NSDate *date2 = [dateFormatter2 dateFromString:dateStrFrom];
                    float timeSecend =[date timeIntervalSince1970]-[date2 timeIntervalSince1970];
                    
//                    NSLog(@"date2 %@  %@",date2,dateStrFrom);
//                    NSLog(@"date  %@  %@",date,dateStr);
//                    NSLog(@"%f",timeSecend);


                    switch ([B_N_Items  indexOfObject:time])
                    {
                        case 1:
                            [tempD   setObject:[NSString  stringWithFormat:@"%f",timeSecend] forKey:@"endTime"];
                            break;
                            
                        default:
                            [tempD   setObject:[NSString  stringWithFormat:@"%f",timeSecend] forKey:@"beginTime"];
                            break;
                    }
                    [tempD   setObject:line forKey:@"timeString"];
                }
            }else
                if ([line  length]>0)
                {
                    if ([tempD.allKeys  containsObject:@"contentLine2"])
                    {
                        [tempD   setObject:line forKey:@"contentLine3"];
                    }else
                        if ([tempD.allKeys  containsObject:@"contentLine1"])
                        {
                            [tempD   setObject:line forKey:@"contentLine2"];
                        }else{
                            [tempD   setObject:line forKey:@"contentLine1"];
                        }
                }
    }
    
    
    

   
    return srtDicArray;
}


@end
