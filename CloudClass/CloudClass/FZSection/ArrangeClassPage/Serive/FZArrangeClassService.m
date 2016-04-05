//
//  FZArrangeClassService.m
//  CloudClass
//
//  Created by guangfu yang on 16/1/27.
//  Copyright © 2016年 yangguangfu. All rights reserved.
//

#import "FZArrangeClassService.h"
#import "FZArrangeClassTeacherModel.h"
#import "FZTeacherDetailsModel.h"

@implementation FZArrangeClassService

- (void)getResultArrangeClassLists:(FZSearchQuery *)searchQuery success:(void (^)(NSInteger, NSString *, id))success failure:(void (^)(id, NSError *))failure {
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionary];
    if (searchQuery.start) {
        [parameDic setValue:[NSString stringWithFormat:@"%zi",searchQuery.start] forKey:@"start"];
    }
    if (searchQuery.rows) {
        [parameDic setValue:[NSString stringWithFormat:@"%zi",searchQuery.rows] forKey:@"rows"];
    }
    NSString *urlString = [[FZAPIGenerate sharedInstance] API:@"teacher_list"];
    [[FZNetWorkManager sharedInstance] GET:urlString needCache:NO parameters:parameDic responseClass:[FZArrangeClassTeacherModel class] success:success failure:failure];
}

- (void)getResultCourseLists:(FZSearchQuery *)searchQuery tch_id:(NSString *)tch_id success:(void (^)(NSInteger, NSString *, id))success failure:(void (^)(id, NSError *))failure {
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionary];
    [parameDic setValue:tch_id forKey:@"tch_id"];
    [parameDic setValue:[NSString stringWithFormat:@"%zi",searchQuery.rows] forKey:@"rows"];
    if (searchQuery.start) {
        [parameDic setValue:[NSString stringWithFormat:@"%zi",searchQuery.start] forKey:@"start"];
    }
    NSString *urlString = [[FZAPIGenerate sharedInstance] API:@"course_list"];
    [[FZNetWorkManager sharedInstance] GET:urlString needCache:NO parameters:parameDic responseClass:[FZTeacherDetailsModel class] success:success failure:failure];
}

- (void)getCourseBespeak:(NSString *)course_id success:(void (^)(NSInteger statusCode, NSString* message, id dataObject))success failure:(void (^)(id responseObject, NSError * error))failure {
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionary];
    [parameDic setValue:course_id forKey:@"course_id"];
    NSString *urlString = [[FZAPIGenerate sharedInstance] API:@"course_bespeak"];
    [[FZNetWorkManager sharedInstance] GET:urlString needCache:NO parameters:parameDic responseClass:nil success:success failure:failure];
}

@end
