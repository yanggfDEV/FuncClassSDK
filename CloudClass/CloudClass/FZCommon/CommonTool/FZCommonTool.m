//
//  FZCommonTool.m
//  EnglishTalk
//
//  Created by huyanming on 15/6/6.
//  Copyright (c) 2015年 Feizhu Tech. All rights reserved.
//
#define PI 3.1415926
#import "FZCommonTool.h"
#import <AdSupport/ASIdentifierManager.h>
//#import "UIAlertView+Blocks.h"
#import "FZLoginViewController.h"

#include <sys/param.h>
//#import "CellPhoneViewController.h"
//#import "FZBindingMobileViewController.h"
#include <sys/mount.h>
#import "AppDelegate.h"
//#import "GotyeOCAPI.h"
//#import "FZTeacherOnlineService.h"
#import "FZLoginManager.h"
#import "RIButtonItem.h"


@implementation FZCommonTool

//计算两个经纬度之间的距离。
+(double) LantitudeLongitudeDist:(double)lon1 other_Lat:(double)lat1 self_Lon:(double)lon2 self_Lat:(double)lat2{
    double er = 6378137; // 6378700.0f;
    //ave. radius = 6371.315 (someone said more accurate is 6366.707)
    //equatorial radius = 6378.388
    //nautical mile = 1.15078
    double radlat1 = PI*lat1/180.0f;
    double radlat2 = PI*lat2/180.0f;
    //now long.
    double radlong1 = PI*lon1/180.0f;
    double radlong2 = PI*lon2/180.0f;
    if( radlat1 < 0 ) radlat1 = PI/2 + fabs(radlat1);// south
    if( radlat1 > 0 ) radlat1 = PI/2 - fabs(radlat1);// north
    if( radlong1 < 0 ) radlong1 = PI*2 - fabs(radlong1);//west
    if( radlat2 < 0 ) radlat2 = PI/2 + fabs(radlat2);// south
    if( radlat2 > 0 ) radlat2 = PI/2 - fabs(radlat2);// north
    if( radlong2 < 0 ) radlong2 = PI*2 - fabs(radlong2);// west
    //spherical coordinates x=r*cos(ag)sin(at), y=r*sin(ag)*sin(at), z=r*cos(at)
    //zero ag is up so reverse lat
    double x1 = er * cos(radlong1) * sin(radlat1);
    double y1 = er * sin(radlong1) * sin(radlat1);
    double z1 = er * cos(radlat1);
    double x2 = er * cos(radlong2) * sin(radlat2);
    double y2 = er * sin(radlong2) * sin(radlat2);
    double z2 = er * cos(radlat2);
    double d = sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2)+(z1-z2)*(z1-z2));
    //side, side, side, law of cosines and arccos
    double theta = acos((er*er+er*er-d*d)/(2*er*er));
    double dist  = theta*er;
    return dist;
}

+ (NSString *)IDFAString
{
    return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
}


/**
 *  绑定手机号码
 *  @param navigationController
 *  @param successBlock 绑定成功回调
 *  @param title 提示信息
 *  @param canleText 取消按钮标题
 *  @param okText  确定按钮标题
 */
+(void)bindCellPhoneWithSuccessBlock:(FZBindCellPhoneSuccessBlock)successBlock
                navigationController:(UINavigationController*)navigationController
                               title:(NSString*)title
                          cancleText:(NSString*)canleText
                              okText:(NSString*)okText{
    
//    [[[UIAlertView alloc] initWithTitle:nil
//                                message:title
//                       cancelButtonItem:[RIButtonItem itemWithLabel:canleText action:^{
//        [navigationController dismissViewControllerAnimated:YES completion:^{
            //先让老师下线
//            if ([FZLoginUser userSchoolIdentity] == 1) {
//                FZTeacherOnlineService *onLineService = [[FZTeacherOnlineService alloc] init];
//                [onLineService setTeacherOnline:NO success:^(id responseObject) {
//                } failure:^(id responseObject, NSError *error) {
//                }];
//            }
//            
//            [GotyeOCAPI logout];
//            [[FZLoginManager sharedManager] logout];
//        }];
//        
//    }]
//                       otherButtonItems:[RIButtonItem itemWithLabel:okText action:^{
////        FZBindingMobileViewController *bindingVC = [[FZBindingMobileViewController alloc] init];
////        bindingVC.successBlock = successBlock;
////        navigationController.navigationBarHidden = NO;
////        [navigationController presentViewController:bindingVC animated:YES completion:^{
////        }];
//    }], nil] show];
}

/**
 *  引导登录
 *  @param navigationController
 *  @param successBlock 绑定成功回调
 *  @param title 提示信息
 *  @param canleText
 *  @param okText
 */
+(void)loginWithSuccessBlock:(FZLoginSuccessEventBlock)successBlock
        navigationController:(UINavigationController*)navigationController
                       title:(NSString*)title
                  cancleText:(NSString*)canleText
                      okText:(NSString*)okText{
//    [[[UIAlertView alloc] initWithTitle:nil
//                                message:title
//                       cancelButtonItem:[RIButtonItem itemWithLabel:canleText action:^{
//        
//    }]
//                       otherButtonItems:[RIButtonItem itemWithLabel:okText action:^{
////        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
////        [delegate setupLoginViewControllerWithLoginSuccessEventBlock:nil];
//    }], nil] show];
}

/**
 *  @author Victor Ji, 15-11-18 11:11:30
 *
 *  登录必须调用block
 *
 *  @param successBlock
 *  @param navigationController
 *  @param title
 *  @param canleText
 *  @param okText
 */
+(void)loginWithNeedSuccessBlock:(FZLoginSuccessEventBlock)successBlock
        navigationController:(UINavigationController*)navigationController
                       title:(NSString*)title
                  cancleText:(NSString*)canleText
                      okText:(NSString*)okText{
//    [[[UIAlertView alloc] initWithTitle:nil
//                                message:title
//                       cancelButtonItem:[RIButtonItem itemWithLabel:canleText action:^{
//        
//    }]
//                       otherButtonItems:[RIButtonItem itemWithLabel:okText action:^{
////        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
////        [delegate setupLoginViewControllerWithLoginSuccessEventBlock:successBlock];
//    }], nil] show];
}


+(long long)freeSpace{
    struct statfs buf;
    long long freespace = -1;
    if(statfs("/var", &buf) >= 0){
        freespace = (long long)buf.f_bsize * buf.f_bfree;
    }
    return freespace;
}

+(float)getTotalDiskSpaceInBytes {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    struct statfs tStats;
    statfs([[paths lastObject] cString], &tStats);
    float totalSpace = (float)(tStats.f_blocks * tStats.f_bsize);
    return totalSpace;
}

+ (NSString *)getNoPrefixUserID:(NSString *)userID {
    if (!userID || userID.length <= 2) {
        return nil;
    }
    NSString *prefix = @"t";
    if ([userID hasPrefix:prefix]) {
        return [userID substringFromIndex:1];
    }
    prefix = @"u";
    if ([userID hasPrefix:prefix]) {
        return [userID substringFromIndex:1];
    }
    return userID;
}

+ (NSString *)addPrefixForUserID:(NSString *)userID prefix:(NSString *)prefix{
    if (!userID || userID.length <= 2 || !prefix) {
        return nil;
    }
    if (![userID hasPrefix:prefix]) {
        return [NSString stringWithFormat:@"%@%@", prefix, userID];
    }
    return userID;
}

#pragma mark -获得给定字符串的宽高

+ (CGRect)getRectwithString:(NSString *)string withFont:(CGFloat)font withWidth:(CGFloat)width
{
    CGRect rect=[string boundingRectWithSize:CGSizeMake(width, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    
    return rect;
}

/**
 * @guangfu yang 15-12-25
 * 名称限制，字符串设置
 **/
+ (NSString *)getSubStrWithString: (NSString *)string withFont:(CGFloat)font{
    
    NSArray *array = [string componentsSeparatedByString:@" "];
    NSString *lastNameStr = @"";
    if (![[array lastObject] isEqualToString:string]) {
        lastNameStr = [NSString stringWithFormat:@"%@", [array lastObject]];
    }
    CGRect rect = [self getRectwithString:string withFont:font withWidth:MAXFLOAT];
    float widthFloat = [FZUtils GetScreeWidth] > 320 ? 145: 120;
    if (rect.size.width > widthFloat) {
        NSString *temp = @"";
        for(int i =0 ; i < [string length]; i++)
        {
            NSString *tempStr = [string substringWithRange:NSMakeRange(i, 1)];
            temp = [temp stringByAppendingString:tempStr];
            CGRect comentRect = [self getRectwithString:temp withFont:font withWidth:MAXFLOAT];
            if (comentRect.size.width > (widthFloat - 15 - [self getRectwithString:lastNameStr withFont:font withWidth:MAXFLOAT].size.width)) {
                NSString *logStr = [NSString stringWithFormat:@"%@... %@", temp, lastNameStr];
                return logStr;
            }
            
        }
    }
    return string;
}

+ (NSString *)getSubStringWithString: (NSString *)string withFont:(CGFloat)font{
    
    NSArray *array = [string componentsSeparatedByString:@" "];
    NSString *lastNameStr = @"";
    if (![[array lastObject] isEqualToString:string]) {
        lastNameStr = [NSString stringWithFormat:@"%@", [array lastObject]];
    }
    CGRect rect = [self getRectwithString:string withFont:font withWidth:MAXFLOAT];
    float widthFloat = [FZUtils GetScreeWidth] > 320 ? 120: 95;
    if (rect.size.width > widthFloat) {
        NSString *temp = @"";
        for(int i =0 ; i < [string length]; i++)
        {
            NSString *tempStr = [string substringWithRange:NSMakeRange(i, 1)];
            temp = [temp stringByAppendingString:tempStr];
            CGRect comentRect = [self getRectwithString:temp withFont:font withWidth:MAXFLOAT];
            if (comentRect.size.width > (widthFloat - 15 - [self getRectwithString:lastNameStr withFont:font withWidth:MAXFLOAT].size.width)) {
                NSString *logStr = [NSString stringWithFormat:@"%@... %@", temp, lastNameStr];
                return logStr;
            }
            
        }
    }
    return string;
}

+ (CGRect)updateConstraintsOfView:(NSString *)string font:(CGFloat)font {
    CGRect rect = [string boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    return rect;
}

+ (BOOL)onTimeOver:(NSString *)startTime {
    NSTimeInterval newDate = [[NSDate date] timeIntervalSince1970];
    NSString *newTimeStr = [NSString stringWithFormat:@"%f", newDate];
    NSInteger newTime = [newTimeStr integerValue];
    if (newTime > [startTime integerValue]) {
        return YES;
    } else {
        return NO;
    }
}

+ (NSString *)getTimeString:(int64_t)startTime {
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:startTime];
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSString *resultString = nil;
    NSDateComponents *startDateComponents = [currentCalendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitWeekday) fromDate:startDate];
    NSDateComponents *todayComments = [currentCalendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
    if (startDateComponents.year == todayComments.year && startDateComponents.month == todayComments.month && startDateComponents.day == todayComments.day) {
        resultString = @"今天";
    } else {
        resultString = [NSString stringWithFormat:@"%ld月%ld日", startDateComponents.month, startDateComponents.day];
    }
    resultString = [NSString stringWithFormat:@"%@ %02ld:%02ld", resultString, startDateComponents.hour, startDateComponents.minute];
    return resultString;
}

+ (NSMutableAttributedString *)getLengthWithString:(NSString*)string withFont:(CGFloat)font local:(NSInteger)local length:(NSInteger)length colorWithHex:(UIColor *)colorWithHex othercolorWithHex:(UIColor *)othercolorWithHex {
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",string] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font],NSForegroundColorAttributeName:othercolorWithHex}];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:colorWithHex range:NSMakeRange(local, length)];
    return attributedStr;
}

@end
