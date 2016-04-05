//
//  FZCommonTool.h
//  EnglishTalk
//
//  Created by huyanming on 15/6/6.
//  Copyright (c) 2015年 Feizhu Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//#import <ASIdentifierManager.h>

typedef void(^FZBindCellPhoneSuccessBlock)();
typedef void(^FZLoginSuccessEventBlock)();

@interface FZCommonTool : NSObject

+(double) LantitudeLongitudeDist:(double)lon1 other_Lat:(double)lat1 self_Lon:(double)lon2 self_Lat:(double)lat2;

+ (NSString *)IDFAString;

/**
 *  绑定手机号码
 *  @param navigationController
 *  @param successBlock 绑定成功回调
 *  @param title 提示信息
 *  @param canleText
 *  @param okText
 */
+(void)bindCellPhoneWithSuccessBlock:(FZBindCellPhoneSuccessBlock)successBlock
                navigationController:(UINavigationController*)navigationController
                               title:(NSString*)title
                          cancleText:(NSString*)canleText
                              okText:(NSString*)okText;

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
                              okText:(NSString*)okText;

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
                          okText:(NSString*)okText;

+(long long)freeSpace;

+(float)getTotalDiskSpaceInBytes;

+ (NSString *)getNoPrefixUserID:(NSString *)userID;

+ (NSString *)addPrefixForUserID:(NSString *)userID prefix:(NSString *)prefix;

+ (CGRect)getRectwithString:(NSString *)string withFont:(CGFloat)font withWidth:(CGFloat)width;//Label的Rect
/**
 * @guangfu yang 15-12-25
 * 名称限制，字符串设置
 **/
+ (NSString *)getSubStrWithString: (NSString *)string withFont:(CGFloat)font;
+ (NSString *)getSubStringWithString: (NSString *)string withFont:(CGFloat)font;

/**
 * @guangfu yang 16-1-29 16:22
 * 获取字符串的CGRect
 **/
+ (CGRect)updateConstraintsOfView:(NSString *)string font:(CGFloat)font;


/**
 * @guangfu yang 16-2-22 11:35
 * 趣课堂课程时间筛选
 **/
+ (BOOL)onTimeOver:(NSString *)startTime;
+ (NSString *)getTimeString:(int64_t)startTime;

/**
 * @guangfu yang, 16-3-15 11:20
 * 丰富的label
 **/
+ (NSMutableAttributedString *)getLengthWithString:(NSString*)string withFont:(CGFloat)font local:(NSInteger)local length:(NSInteger)length colorWithHex:(UIColor *)colorWithHex othercolorWithHex:(UIColor *)othercolorWithHex;
@end
