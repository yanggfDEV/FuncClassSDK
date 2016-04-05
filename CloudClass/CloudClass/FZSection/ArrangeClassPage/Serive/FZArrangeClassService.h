//
//  FZArrangeClassService.h
//  CloudClass
//
//  Created by guangfu yang on 16/1/27.
//  Copyright © 2016年 yangguangfu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FZSearchQuery.h"

@interface FZArrangeClassService : NSObject
/**
 * @guangfu yang 16-1-28
 * 获取约课列表
 **/
- (void)getResultArrangeClassLists:(FZSearchQuery *)searchQuery success:(void (^)(NSInteger statusCode, NSString* message, id dataObject))success failure:(void (^)(id responseObject, NSError * error))failure;

/**
 * @guangfu yang 16-1-28
 * 获取课程列表
 **/
- (void)getResultCourseLists:(FZSearchQuery *)searchQuery tch_id:(NSString *)tch_id success:(void (^)(NSInteger statusCode, NSString* message, id dataObject))success failure:(void (^)(id responseObject, NSError * error))failure;

/**
 * @guangfu yang 16-1-29
 * 预约课程
 **/
- (void)getCourseBespeak:(NSString *)course_id success:(void (^)(NSInteger statusCode, NSString* message, id dataObject))success failure:(void (^)(id responseObject, NSError * error))failure;

@end
