//
//  FZPersonCenterService.m
//  CloudClass
//
//  Created by guangfu yang on 16/1/28.
//  Copyright © 2016年 yangguangfu. All rights reserved.
//

#import "FZPersonCenterService.h"
#import "FZUpYunSignModel.h"
#import "FZMyCourseModel.h"
#import "FZCourseMeetingModel.h"

@implementation FZPersonCenterService

- (void)setUsetInfo:(BOOL)isSetNickName nickName:(NSString *)nickName avatar:(NSString *)avatar success:(void (^)(NSInteger statusCode, NSString* message, id dataObject))success failure:(void (^)(id responseObject, NSError * error))failure {
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionary];
    if (isSetNickName) {
        [parameDic setValue:nickName forKey:@"nickname"];
    } else {
        [parameDic setValue:avatar forKey:@"avatar"];
    }
    NSString *urlString = [[FZAPIGenerate sharedInstance] API:@"change_info"];
    [[FZNetWorkManager sharedInstance] POST:urlString needCache:NO parameters:parameDic responseClass:nil success:success failure:failure];
}

- (void)getUpyunSign:(void (^)(NSInteger, NSString *, id))success failure:(void (^)(id, NSError *))failure {
    NSString *urlString = [[FZAPIGenerate sharedInstance] API:@"upyun_sign"];
    [[FZNetWorkManager sharedInstance] GET:urlString needCache:NO parameters:nil responseClass:[FZUpYunSignModel class] success:success failure:failure];
}

- (void)getCourseBespeakList:(FZSearchQuery *)searchQuery success:(void (^)(NSInteger, NSString *, id))success failure:(void (^)(id, NSError *))failure {
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionary];
    if (searchQuery.start) {
        [parameDic setValue:[NSString stringWithFormat:@"%zi",searchQuery.start] forKey:@"start"];
    }
    if (searchQuery.rows) {
        [parameDic setValue:[NSString stringWithFormat:@"%zi",searchQuery.rows] forKey:@"rows"];
    }
    NSString *urlString = [[FZAPIGenerate sharedInstance] API:@"course_bespeak_list"];
    [[FZNetWorkManager sharedInstance] GET:urlString needCache:NO parameters:parameDic responseClass:[FZMyCourseModel class] success:success failure:failure];
}

- (void)getConferenceNum:(NSString *)course_id success:(void (^)(NSInteger, NSString *, id))success failure:(void (^)(id, NSError *))failure {
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionary];
    [parameDic setValue:course_id forKey:@"course_id"];
    NSString *urlString = [[FZAPIGenerate sharedInstance] API:@"in_course_meeting"];
    [[FZNetWorkManager sharedInstance] GET:urlString needCache:NO parameters:parameDic responseClass:[FZCourseMeetingModel class] success:success failure:failure];
}

@end
