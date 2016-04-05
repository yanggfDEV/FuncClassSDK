//
//  FCMtcCallConfigManager.m
//  Pods
//
//  Created by patty on 15/11/23.
//
//

#import "FCMtcCallConfigManager.h"

@implementation FCMtcCallConfigManager

+ (FCMtcCallConfigManager *)shareInstance
{
    static FCMtcCallConfigManager *configManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        configManager = [[FCMtcCallConfigManager alloc] init];
    });
    return configManager;
}



@end
