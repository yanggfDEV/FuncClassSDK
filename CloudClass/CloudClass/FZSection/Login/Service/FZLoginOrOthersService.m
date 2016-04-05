//
//  FZLoginOrOthersService.m
//  CloudClass
//
//  Created by guangfu yang on 16/1/28.
//  Copyright © 2016年 yangguangfu. All rights reserved.
//

#import "FZLoginOrOthersService.h"

@implementation FZLoginOrOthersService

- (void)userLogin:(NSString *)mobile password:(NSString *)password success:(void (^)(NSInteger, NSString *, id))success failure:(void (^)(id, NSError *))failure {
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionary];
    [parameDic setValue:mobile forKey:@"mobile"];
    [parameDic setValue:password forKey:@"password"];
    [parameDic setValue:kUniqueIdentifier forKey:@"devicetoken"];
    NSString *urlString = [[FZAPIGenerate sharedInstance] API:@"user_login"];
    [[FZNetWorkManager sharedInstance] POST:urlString needCache:NO parameters:parameDic responseClass:nil success:success failure:failure];
}

- (void)getMobileCode:(NSString *)type mobile:(NSString *)mobile success:(void (^)(NSInteger, NSString *, id))success failure:(void (^)(id, NSError *))failure {
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionary];
    [parameDic setValue:mobile forKey:@"mobile"];
    [parameDic setValue:type forKey:@"type"];
    NSString *urlString = [[FZAPIGenerate sharedInstance] API:@"mobile_code"];
    [[FZNetWorkManager sharedInstance] GET:urlString needCache:NO parameters:parameDic responseClass:nil success:success failure:failure];
}

- (void)registerOrSetPassWD:(BOOL)isregister mobile:(NSString *)mobile code:(NSString *)code password:(NSString *)password success:(void (^)(NSInteger, NSString *, id))success failure:(void (^)(id, NSError *))failure {
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionary];
    [parameDic setValue:mobile forKey:@"mobile"];
    [parameDic setValue:code forKey:@"code"];
    NSString *urlString = @"";
    if (isregister) {
        [parameDic setValue:password forKey:@"password"];
        [parameDic setValue:kUniqueIdentifier forKey:@"devicetoken"];
        [parameDic setValue:@"1" forKey:@"auth_login"];
        urlString = [[FZAPIGenerate sharedInstance] API:@"register"];
    } else {
        [parameDic setValue:password forKey:@"newpassword"];
        urlString = [[FZAPIGenerate sharedInstance] API:@"reset_password"];
    }

    [[FZNetWorkManager sharedInstance] POST:urlString needCache:NO parameters:parameDic responseClass:nil success:success failure:failure];
}

- (void)get_JpushInfoToserver:(NSString *)registrationID success:(void (^)(NSInteger, NSString *, id))success failure:(void (^)(id, NSError *))failure {
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionary];
    [parameDic setValue:registrationID forKey:@"registration_id"];
    [parameDic setValue:kUniqueIdentifier forKey:@"devicetoken"];
    [parameDic setValue:@"1" forKey:@"devicetype"];
    [parameDic setValue:[FZLoginUser userID] forKey:@"uid"];
    NSString *urlString = [[FZAPIGenerate sharedInstance] API:@"user_jpushinfo"];
    [[FZNetWorkManager sharedInstance] POST:urlString needCache:NO parameters:parameDic responseClass:nil success:success failure:failure];
}

@end
