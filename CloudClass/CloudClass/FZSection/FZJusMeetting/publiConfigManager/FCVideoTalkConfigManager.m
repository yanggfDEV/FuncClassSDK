//
//  FCVideoTalkConfigManager.m
//  Pods
//
//  Created by patty on 15/11/23.
//
//

#import "FCVideoTalkConfigManager.h"

@implementation FCVideoTalkConfigManager

+ (FCVideoTalkConfigManager *)shareInstance
{
    static FCVideoTalkConfigManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[FCVideoTalkConfigManager alloc] init];
    });
    return manager;
}

- (NSUInteger)chatSeconds
{
//    if (self.sessTimer) {
//        return self.sessTimer.mintues * 60 + self.sessTimer.seconds;
//    }
    return 0;
}

@end
