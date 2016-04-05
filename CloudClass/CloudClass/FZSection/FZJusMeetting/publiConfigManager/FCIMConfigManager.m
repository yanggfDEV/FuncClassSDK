//
//  FCIMConfigManager.m
//  Pods
//
//  Created by patty on 15/11/23.
//
//

#import "FCIMConfigManager.h"
#import "FCJusTalkConfigHandler.h"
#import "FCChatCache.h"

@implementation FCIMConfigManager

+ (FCIMConfigManager *)shareInstance
{
    static FCIMConfigManager *configManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        configManager = [[FCIMConfigManager alloc] init];
    });
    return configManager;
}


+ (NSInteger)getNoReadCountWithJustalkID:(NSString *)justalkID {
    NSString *userID = [FCJusTalkConfigHandler GetUidWithJustalkID:justalkID];
    return [FCChatCache getNoReadCountWithUserID:userID];
}

@end
