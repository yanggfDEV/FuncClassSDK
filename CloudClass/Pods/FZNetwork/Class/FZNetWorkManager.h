//
//  FLNetWorkExecute.h
//  VideoPlayer
//
//  Created by huyangming on 14-11-7.
//  Copyright (c) 2014年 feili. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FZNetWorkManager : NSObject


+ (FZNetWorkManager *)sharedInstance;

//sc使用默认不需要设置agent,如需设置，覆盖该函数，初始化时候修改
-(void)setAgent:(NSString*)agent;


- (void)GET:(NSString *)URLString
  needCache:(BOOL)needCache
 parameters:(id)parameters
responseClass:(Class)classType
    success:(void (^)(NSInteger statusCode,NSString* message,id dataObject))success
    failure:(void (^)( id responseObject, NSError * error))failure;



- (void)POST:(NSString *)URLString
   needCache:(BOOL)needCache
  parameters:(id)parameters
responseClass:(Class)classType
     success:(void (^)(NSInteger statusCode,NSString* message,id dataObject))success
     failure:(void (^)( id responseObject, NSError * error))failure;

/**
 *  上传文件
 *
 *  @param URLString
 *  @param fileName
 *  @param formFileName
 *  @param fileData
 *  @param parameters
 *  @param classType
 *  @param success
 *  @param failure
 */
- (void)POST:(NSString *)URLString
    formFileName:(NSString*)formFileName
    fileName:(NSString*)fileName
    fileData:(NSData*)fileData
    mimeType:(NSString*)mimeType
  parameters:(id)parameters
responseClass:(Class)classType
     success:(void (^)(NSInteger statusCode,NSString* message,id dataObject))success
     failure:(void (^)( id responseObject, NSError * error))failure;

- (void)GET:(NSString *)URLString
 parameters:(id)parameters  responseDtoClassType:(Class)classType
    success:(void (^)(id responseObject))success
    failure:(void (^)( id responseObject, NSError * error))failure;



- (void)POST:(NSString *)URLString
  parameters:(id)parameters responseDtoClassType:(Class)classType
     success:(void (^)( id responseObject))success
     failure:(void (^)( id responseObject, NSError * error))failure;



//- (void)GETWithCache:(NSString *)URLString
//          parameters:(id)parameters  responseDtoClassType:(Class)classType
//             success:(void (^)(id responseObject))success
//             failure:(void (^)( id responseObject, NSError * error))failure;
//
//- (void)POSTWithCache:(NSString *)URLString
//  parameters:(id)parameters responseDtoClassType:(Class)classType
//     success:(void (^)( id responseObject))success
//     failure:(void (^)( id responseObject, NSError * error))failure;

- (void)GETWithNoDefaultParam:(NSString *)URLString
                   parameters:(id)parameters  responseDtoClassType:(Class)classType
                      success:(void (^)(id responseObject))success
                      failure:(void (^)( id responseObject, NSError * error))failure;

- (void)POSTWithSyc:(NSString *)URLString
         parameters:(id)parameters;


//-(void)downloadFile:(NSString *)UrlAddress  success:(void (^)(id responseObject))success
//            failure:(void (^)( id responseObject, NSError * error))failure;
//
//-(void)downVideoToCrach:(NSString *)videoUrl  success:(void (^)(id responseObject))success
//                failure:(void (^)( id responseObject, NSError * error))failure;
//
//
//-(void)getvideoDetailFromID:(NSString*)voideid success:(void (^)(id responseObject))success
//                    failure:(void (^)( id responseObject, NSError * error))failure;


@end
