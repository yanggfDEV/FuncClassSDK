//
//  FCIMConfigManager.h
//  Pods
//
//  Created by patty on 15/11/23.
//
// 处理消息

#import <Foundation/Foundation.h>

@interface FCIMConfigManager : NSObject

+ (FCIMConfigManager *)shareInstance;
+ (NSInteger)getNoReadCountWithJustalkID:(NSString *)justalkID;

@end
