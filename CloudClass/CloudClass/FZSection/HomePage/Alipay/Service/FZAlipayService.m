//
//  FZAlipayService.m
//  CloudClass
//
//  Created by guangfu yang on 16/3/9.
//  Copyright © 2016年 yangguangfu. All rights reserved.
//

#import "FZAlipayService.h"
#import "FZAlipayModel.h"

@implementation FZAlipayService

- (void)finishOrderWithParams:(NSDictionary *)params success:(void (^)(NSInteger, NSString *, id))success failure:(void (^)(id, NSError *))failure {
    NSString *urlString = [[FZAPIGenerate sharedInstance] API:@"funds_payDeposit"];
    FZNetWorkManager *manager = [[FZNetWorkManager alloc] init];
    [manager POST:urlString needCache:NO parameters:params responseClass:[FZAlipayModel class] success:success failure:failure];
}

- (void)getCourseOrderWithParams:(NSDictionary *)params success:(void (^)(NSInteger statusCode, NSString* message, id dataObject))success failure:(void (^)(id responseObject, NSError * error))failure {
    NSString *urlString = [[FZAPIGenerate sharedInstance] API:@"course_deposit"];
    FZNetWorkManager *manager = [[FZNetWorkManager alloc] init];
    [manager POST:urlString needCache:NO parameters:params responseClass:[FZAlipayModel class] success:success failure:failure];
}

@end
