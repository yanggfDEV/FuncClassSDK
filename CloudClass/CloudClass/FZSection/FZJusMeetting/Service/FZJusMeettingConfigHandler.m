//
//  FZJusMeettingConfigHandler.m
//  CloudClass
//
//  Created by guangfu yang on 16/1/31.
//  Copyright © 2016年 yangguangfu. All rights reserved.
//

#import "FZJusMeettingConfigHandler.h"

@interface FZJusMeettingConfigHandler ()

@end

@implementation FZJusMeettingConfigHandler

+ (NSString *)getJusMeettingIDWithUid:(NSString *)uid {
    NSString *uidStr = [NSString stringWithFormat:@"std_%@", uid];
    return uidStr;
}

+ (NSString *)getJusMeettingServer:(BOOL)isTestMode {
    if (isTestMode) {
        return @"sudp:172.16.3.201:9851";
        //return @"sudp:ae.justalkcloud.com:9851";
    } else {
        return @"sudp:ae.justalkcloud.com:9851";
    }
}

@end
