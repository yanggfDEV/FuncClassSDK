//
//  FZSettingService.m
//  CloudClass
//
//  Created by guangfu yang on 16/3/14.
//  Copyright © 2016年 yangguangfu. All rights reserved.
//

#import "FZSettingService.h"

@implementation FZSettingService

- (void)setPass:(NSString *)oldPass newPass:(NSString *)newPass success:(void (^)(NSInteger, NSString *, id))success failure:(void (^)(id, NSError *))failure {
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionary];
    [parameDic setValue:oldPass forKey:@"oldPass"];
    [parameDic setValue:newPass forKey:@"newPass"];
    NSString *urlString = [[FZAPIGenerate sharedInstance] API:@"change_info"];
    [[FZNetWorkManager sharedInstance] POST:urlString needCache:NO parameters:parameDic responseClass:nil success:success failure:failure];
}

@end
