//
//  FZHomePageService.h
//  CloudClass
//
//  Created by guangfu yang on 16/3/8.
//  Copyright © 2016年 yangguangfu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FZSearchQuery.h"

/**
 * @guangfu yang, 16-3-9 17:41
 *
 * 支付结果的参数，用于支付之后的操作
 **/
typedef NS_ENUM(NSUInteger, FZAlipayResult) {
    FZAlipayResultSuccess       = 9000,
    FZAlipayResultCancel        = 6001,
    FZAlipayResultFail          = 4000,
    FZAlipayResultNetworkError  = 6002,
    FZAlipayResultProcessing    = 8000
};

@interface FZHomePageService : NSObject

/**
 * @gaungfu yang 16-3-9 17:42
 *
 * 获取首页的详情
 **/
- (void)getPubCourseList:(FZSearchQuery *)searchQuery course_type:(NSString *)course_type success:(void (^)(NSInteger statusCode, NSString* message, id dataObject))success failure:(void (^)(id responseObject, NSError * error))failure;

/**
 * @gaungfu yang 16-3-9 17:42
 *
 * 获取课程的详情
 **/
- (void)getPubCourseInfo:(NSString *)course_id success:(void (^)(NSInteger statusCode, NSString* message, id dataObject))success failure:(void (^)(id responseObject, NSError * error))failure;

/**
 * @guangfu yang, 16-3-10 17:05
 *
 * 获取课程详情的课程表
 **/
- (void)getTypeCourseInfo:(NSString *)course_id tch_id:(NSString *)tch_id success:(void (^)(NSInteger statusCode, NSString* message, id dataObject))success failure:(void (^)(id responseObject, NSError * error))failure;

/**
 * @guangfu yang 16-3-8 18:00
 * 课程支付
 *
 **/
- (void)courseWithAmount:(CGFloat)amount tid:(NSString *)tid pid:(NSString *)pid type:(NSString *)type success:(void (^)(NSInteger statusCode, NSString* message, id dataObject))success failure:(void (^)(id responseObject, NSError * error))failure alipayCallback:(void (^)(FZAlipayResult result))callback alipayNotInstallBlock:(void (^)(void))notInstall;

- (void)courseWithOrderId:(NSString *)orderId success:(void (^)(NSInteger statusCode, NSString* message, id dataObject))success failure:(void (^)(id responseObject, NSError * error))failure alipayCallback:(void (^)(FZAlipayResult result))callback alipayNotInstallBlock:(void (^)(void))notInstall;

/**
 * @guangfu yang, 16-3-16 11:47
 * 立即支付判断剩余人数
 **/
- (void)checkremainnumWithCourseID:(NSString *)course_id success:(void (^)(NSInteger statusCode, NSString* message, id dataObject))success failure:(void (^)(id responseObject, NSError * error))failure;

@end
