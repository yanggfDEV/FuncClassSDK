//
//  FCUtil.h
//  FunChat
//
//  Created by Feizhu Tech . on 15/5/28.
//  Copyright (c) 2015年 hanbingquan. All rights reserved.
//

#import <UIKit/UIKit.h>

/** check if object is empty
 if an object is nil, NSNull, or length == 0, return True
 */
static inline BOOL FCIsEmpty(id thing)
{
    return thing == nil ||
    ([thing isEqual:@"null"])||
    ([thing isEqual:@"nil"])||
    ([thing isEqual:[NSNull null]]) ||
    ([thing respondsToSelector:@selector(length)] && [(NSData *)thing length] == 0) ||
    ([thing respondsToSelector:@selector(count)]  && [(NSArray *)thing count] == 0);
}

@interface FCUtil : NSObject

+ (NSString *)bundleShortVersionString;
+ (NSString *)bundleVersion;

/**
 *  MD5加密算法
 *
 *  @param string 要加密的字符串
 *
 *  @return 返回加密好的字符串
 */
+ (NSString *)md5HexString:(NSString *)string;

/**
 *  Base64 加密算法
 *
 *  @param string 要加密的字符串
 *
 *  @return 经过Base64加密过的字符串
 */
+ (NSString *)encodeBase64String:(NSString *)string;

/**
 *  Base64 解密算法
 *
 *  @param string 需要解密的字符串
 *
 *  @return 经过Base64解密过的字符串
 */
+ (NSString *)decodeBase64String:(NSString *)base64String;

/**
 *  获取屏幕宽度
 *
 *  @return 屏幕宽度
 */
+ (CGFloat)screenWidth;

/**
 *  获取屏幕高度
 *
 *  @return 屏幕高度
 */
+ (CGFloat)screenHeight;

/**
 *  获取当前屏幕大小
 *
 *  @return 屏幕大小
 */
+ (CGRect)bounds;

/**
 *  将object转为JSON格式的NSString
 *
 *  @param object 可以为NSString、NSDictionary、NSArray
 *
 *  @return JSON格式的NSString
 */
+ (NSString *)jsonStringWithObject:(id)object;

/**
 *  将JSON格式的NSString转为NSDictionary
 *
 *  @param jsonString JSON格式的NSString
 *
 *  @return NSDictionary
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

/**
 *  验证邮箱的合法性
 *
 *  @param email 邮箱地址
 *
 *  @return 
 */
+ (BOOL)isValidateEmail:(NSString *)email;

/**
 *  验证手机号合法性 只判断是否1开头，11位
 *
 *  @param mobiePhoneNumber
 *
 *  @return 
 */
+ (BOOL)isValidateMobilePhoneNumber:(NSString *)mobiePhoneNumber;

/**
 *  验证密码合法性 只能包含数字跟密码，并且6-16位
 *
 *  @param password
 *
 *  @return
 */
+ (BOOL)isValidatePassword:(NSString *)password;


//自定义头像的处理
+ (UIImage*)rotateImage:(UIImage *)image;
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;

/**
 *  把秒转成  yyyy-MM-dd HH:mm 格式
 *
 *  @param dateStr 秒的字符串
 *
 *  @return  yyyy-MM-dd HH:mm
 */
+ (NSString *)secondChangToDateString:(NSString *)dateStr;

/**
 *  把秒转成 MM-dd HH:mm 格式
 *
 *  @param dateStr 秒的字符串
 *
 *  @return  MM-dd HH:mm
 */
+ (NSString *)secondChangToMonthTimeString:(NSString *)dateStr;

/**
 *  把秒转成  yyyy-MM-dd 格式
 *
 */
+ (NSString *)secondChangToDate:(NSString *)dateStr;

+(BOOL)isPureNumandCharacters:(NSString *)string;
+ (BOOL)isPureLetterChacacters:(NSString *)string;

/**
 *  返回Rect
 *
 *  @param string 文本
 *  @param font   字号
 *  @param width  最大宽度
 *
 *  @return rect
 */
+ (CGRect)getRectwithString:(NSString *)string withFont:(CGFloat)font withWidth:(CGFloat)width;

+ (NSString *)IDFA;

@end
