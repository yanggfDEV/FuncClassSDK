//
//  FZJusMeettingConfigHandler.h
//  CloudClass
//
//  Created by guangfu yang on 16/1/31.
//  Copyright © 2016年 yangguangfu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FZJusMeettingConfigHandler : NSObject
//获取JusMeettingID
+ (NSString *)getJusMeettingIDWithUid:(NSString *)uid;

//获取server
+ (NSString *)getJusMeettingServer:(BOOL)isDev;

@end
