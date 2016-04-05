//
//  FZUtils.h
//  EnglishTalk
//
//  Created by Jyh on 15/4/15.
//  Copyright (c) 2015年 ishowtalk. All rights reserved.
//

#import <Foundation/Foundation.h>

/** check if object is empty
 if an object is nil, NSNull, or length == 0, return True
 */
static inline BOOL FBIsEmpty(id thing)
{
    return thing == nil ||
    ([thing isEqual:[NSNull null]]) ||
    ([thing respondsToSelector:@selector(length)] && [(NSData *)thing length] == 0) ||
    ([thing respondsToSelector:@selector(count)]  && [(NSArray *)thing count] == 0);
}

@interface FZUtils : NSObject

/*
 * 获得屏幕的分辨率
 */
+ (int)GetScreeWidth;
+ (int)GetScreeHeight;

/**
 *  去掉状态栏，导航栏的高度
 */
+ (int)getContentViewHeight;

/**
 * @brief   iOS 系统版本
 */
+ (NSString *)systemVersion;

/**
 * @brief   APP version
 */
+ (NSString *)appVersion;

/**
 * @brief   获得设备型号
 */
+ (NSString*)devicePlatform;

/**
 * @brief   设备是否连接到网络
 */
//+ (BOOL)networkDetect;

/**
 * @brief   设备是否越狱
 */
+ (BOOL)isJailbroken;

/*
 *  Name    : colorWithHexString
 *  Param   : NSString
 *  Note    : html颜色值转化UIColor  如#FF9900,0XFF9900
 */
+ (UIColor *)colorWithHexString: (NSString *) stringToConvert;

@end
