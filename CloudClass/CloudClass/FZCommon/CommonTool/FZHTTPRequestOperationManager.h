//
//  FZHTTPRequestOperationManager.h
//  EnglishTalk
//
//  Created by CyonLeuPro on 15/7/30.
//  Copyright (c) 2015年 Feizhu Tech. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

@interface FZHTTPRequestOperationManager : AFHTTPRequestOperationManager

- (void)GET:(NSString *)URLString
  needCache:(BOOL)needCache
 parameters:(id)parameters
responseClass:(Class)classType
    success:(void (^)(NSInteger statusCode, NSString *message, id dataObject))success
    failure:(void (^)( id responseObject, NSError * error))failure;

- (void)POST:(NSString *)URLString
   needCache:(BOOL)needCache
  parameters:(id)parameters
responseClass:(Class)classType
     success:(void (^)(NSInteger statusCode,NSString* message,id dataObject))success
     failure:(void (^)( id responseObject, NSError * error))failure;

@end
