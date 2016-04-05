//
//  FZPersonCenterService.h
//  CloudClass
//
//  Created by guangfu yang on 16/1/28.
//  Copyright © 2016年 yangguangfu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FZSearchQuery.h"

@interface FZPersonCenterService : NSObject

/**
 * @guangfu yang 16-1-29 10:43
 * 修改资料
 **/
- (void)setUsetInfo:(BOOL)isSetNickName nickName:(NSString *)nickName avatar:(NSString *)avatar success:(void (^)(NSInteger statusCode, NSString* message, id dataObject))success failure:(void (^)(id responseObject, NSError * error))failure;

/**
 * @guangfu yang 16-1-29 11:36
 * 获取又拍sign,上传文件图片....
 **/
- (void)getUpyunSign:(void (^)(NSInteger statusCode, NSString* message, id dataObject))success failure:(void (^)(id responseObject, NSError * error))failure;

/**
 * @guangfu yang 16-1-29 15:14
 * 预约课程列表
 **/
- (void)getCourseBespeakList:(FZSearchQuery *)searchQuery success:(void (^)(NSInteger statusCode, NSString* message, id dataObject))success failure:(void (^)(id responseObject, NSError * error))failure;

/**
 * @guangfu yang 16-2-16 12:18
 * 进入课堂,先获取短会议号
 *
 **/
- (void)getConferenceNum:(NSString *)course_id success:(void (^)(NSInteger statusCode, NSString* message, id dataObject))success failure:(void (^)(id responseObject, NSError * error))failure;


@end
