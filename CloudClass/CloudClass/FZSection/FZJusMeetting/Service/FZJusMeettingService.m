//
//  FZJusMeettingService.m
//  CloudClass
//
//  Created by guangfu yang on 16/1/31.
//  Copyright © 2016年 yangguangfu. All rights reserved.
//

#import "FZJusMeettingService.h"
#import "FZJusMeettingSignModel.h"

@implementation FZJusMeettingService

- (void)getJusMeettingSign:(NSString *)identifier nonce:(NSString *)nonce success:(void (^)(NSInteger, NSString *, id))success failure:(void (^)(id, NSError *))failure {
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionary];
    [parameDic setValue:identifier forKey:@"identifier"];
    [parameDic setValue:nonce forKey:@"nonce"];
    NSString *urlString = [[FZAPIGenerate sharedInstance] API:@"std_justalksign"];
    [[FZNetWorkManager sharedInstance] GET:urlString needCache:NO parameters:parameDic responseClass:[FZJusMeettingSignModel class] success:success failure:failure];
}

@end
