//
//  FZLoginOrOthersService.h
//  CloudClass
//
//  Created by guangfu yang on 16/1/28.
//  Copyright © 2016年 yangguangfu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FZLoginOrOthersService : NSObject

/**
 * @guangfu yang 16-1-28
 * 用户登录
 **/
- (void)userLogin:(NSString *)mobile password:(NSString *)password success:(void (^)(NSInteger statusCode, NSString* message, id dataObject))success failure:(void (^)(id responseObject, NSError * error))failure;

/**
 * @guangfu yang 16-1-28
 * 获取验证码
 **/
- (void)getMobileCode:(NSString *)type mobile:(NSString *)mobile success:(void (^)(NSInteger statusCode, NSString* message, id dataObject))success failure:(void (^)(id responseObject, NSError * error))failure;

/**
 * @guangfu yang 16-1-28
 * 用户注册 和 重置密码
 **/
- (void)registerOrSetPassWD:(BOOL)isregister mobile:(NSString *)mobile code:(NSString *)code password:(NSString *)password success:(void (^)(NSInteger statusCode, NSString* message, id dataObject))success failure:(void (^)(id responseObject, NSError * error))failure;

/**
 * @guangfu yang 16-1-30 9:55
 * 上传极光设备号
 **/
- (void)get_JpushInfoToserver:(NSString *)registrationID success:(void (^)(NSInteger statusCode, NSString* message, id dataObject))success failure:(void (^)(id responseObject, NSError * error))failure;

@end
