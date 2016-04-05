//
//  FZJusMeettingService.h
//  CloudClass
//
//  Created by guangfu yang on 16/1/31.
//  Copyright © 2016年 yangguangfu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FZJusMeettingService : NSObject

/**
 * @gaungfu yang 16-1-31
 * 获取justalk签名
 **/
- (void)getJusMeettingSign:(NSString *)identifier nonce:(NSString *)nonce success:(void (^)(NSInteger statusCode, NSString* message, id dataObject))success failure:(void (^)(id responseObject, NSError * error))failure;

@end
