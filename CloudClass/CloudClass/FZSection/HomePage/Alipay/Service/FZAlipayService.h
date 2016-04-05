//
//  FZAlipayService.h
//  CloudClass
//
//  Created by guangfu yang on 16/3/9.
//  Copyright © 2016年 yangguangfu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FZAlipayService : NSObject

/**
 *  @guangfu yang , 16-3-9 17:19
 *
 *  完成代付款的订单
 *
 *  @param params
 *  @param success
 *  @param failure
 */
- (void)finishOrderWithParams:(NSDictionary *)params success:(void (^)(NSInteger statusCode, NSString* message, id dataObject))success failure:(void (^)(id responseObject, NSError * error))failure;


/**
*  @guangfu yang, 15-09-18 17:09:50
*
*  生成课程订单
*
*  @param params
*  @param success
*  @param failure
*/
- (void)getCourseOrderWithParams:(NSDictionary *)params success:(void (^)(NSInteger statusCode, NSString* message, id dataObject))success failure:(void (^)(id responseObject, NSError * error))failure;


@end
