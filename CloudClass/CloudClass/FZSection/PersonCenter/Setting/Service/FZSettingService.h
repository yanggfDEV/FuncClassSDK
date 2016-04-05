//
//  FZSettingService.h
//  CloudClass
//
//  Created by guangfu yang on 16/3/14.
//  Copyright © 2016年 yangguangfu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FZSettingService : NSObject

/**
 * @guangfu yang, 16-3-14
 *
 *
 **/
- (void)setPass:(NSString *)oldPass newPass:(NSString *)newPass success:(void (^)(NSInteger statusCode, NSString* message, id dataObject))success failure:(void (^)(id responseObject, NSError * error))failure;

@end
