//
//  FZHTTPRequestOperationManager.m
//  EnglishTalk
//
//  Created by CyonLeuPro on 15/7/30.
//  Copyright (c) 2015年 Feizhu Tech. All rights reserved.
//

#import "FZHTTPRequestOperationManager.h"
#import <UIDeviceUtil.h>
#import <FZSignInStatus.h>
#import <FZiOSCache+TMCache.h>
#import "FZBaseModel.h"

@implementation FZHTTPRequestOperationManager


- (instancetype)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"html/json",@"text/plain", nil];

        NSString *deviceType = [UIDeviceUtil hardwareDescription];
        NSString *deviceSystemName = [UIDevice currentDevice].systemName;
        NSString *deviceSystemVersion = [UIDevice currentDevice].systemVersion;
 
        [[self requestSerializer] setValue:deviceType forHTTPHeaderField:@"Device-Model"];
        [[self requestSerializer] setValue:@"iOS" forHTTPHeaderField:@"User-Agent"];
        [[self requestSerializer] setValue:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"versionCode"] forHTTPHeaderField:@"versionCode"];
        [[self requestSerializer] setValue:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]  forHTTPHeaderField:@"App-Version"];
        [[self requestSerializer] setValue:[NSString  stringWithFormat:@"%@%@",deviceSystemName,deviceSystemVersion] forHTTPHeaderField:@"Client-OS"];
    }
    
    return self;
}


- (void)GET:(NSString *)URLString
  needCache:(BOOL)needCache
 parameters:(id)parameters
responseClass:(Class)classType
    success:(void (^)(NSInteger statusCode, NSString *message, id dataObject))success
    failure:(void (^)( id responseObject, NSError * error))failure;
{
    
//    if(![FZSignInStatus  isAccessTokenValid]){
//        failure(nil,nil);
//    }
    //缓存处理
    if (needCache && URLString && success) {
        id cacheObject = [FZiOSCache objectForKey:URLString];
        if (cacheObject) {
            //model对象
            if (classType) {
                //不是需要的类型，不返回缓存
                if ([cacheObject isKindOfClass:classType]) {
                    success(kFZRequestStatusCodeSuccess, nil, cacheObject);
                } else if ([cacheObject isKindOfClass:[NSArray class]]) {
                    //数组对象
                    NSArray *cacheObjestArray = (NSArray *)cacheObject;
                    if (cacheObjestArray && [cacheObjestArray count] > 0) {
                        id modelObject = [cacheObjestArray firstObject];
                        if ([modelObject isKindOfClass:classType]) {
                            success(kFZRequestStatusCodeSuccess, nil, cacheObject);
                        }
                    }
                }
            } else {
                success(kFZRequestStatusCodeSuccess, nil, cacheObject);
            }//end of if (classType
            
        }//end of if(cacheObject)
    }//end of if (needCache...
    
    [self GET:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if ([responseObject isKindOfClass:[NSDictionary class]]) {
             [self handleResponseObject:responseObject];
         }
         
         NSString *message = nil;
         NSInteger status = kFZRequestStatusCodeError;
         id responseDataObject = nil;
         if (responseObject) {
             message = [responseObject objectForKey:@"msg"];
             NSNumber* statusCode = [responseObject objectForKey:@"status"];
             if (statusCode) {
                 status = statusCode.integerValue;
             }
             responseDataObject = responseObject[@"data"];
         }
         
         
         if (success) {
             if (status == kFZRequestStatusCodeSuccess && classType && responseDataObject) {
                 if ([responseDataObject isKindOfClass:[NSArray class]]) {
                     NSArray *array = [MTLJSONAdapter modelsOfClass:classType fromJSONArray:responseDataObject error:nil];
                     if (needCache) {
                         [FZiOSCache setObject:array forKey:URLString];
                     }
                     success(status,message,array);
                 } else {
                     FZBaseModel *model = [MTLJSONAdapter modelOfClass:classType fromJSONDictionary:responseDataObject error:nil];
                     if (needCache) {
                         [FZiOSCache setObject:model forKey:URLString];
                     }
                     success(status,message,model);
                 }
             } else {
                 if (needCache) {
                     [FZiOSCache setObject:responseDataObject forKey:URLString];
                 }
                 success(status,message,responseDataObject);
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         if (failure) {
             failure(nil, error);
         }
     }];
}

- (void)POST:(NSString *)URLString
   needCache:(BOOL)needCache
  parameters:(id)parameters
responseClass:(Class)classType
     success:(void (^)(NSInteger statusCode,NSString* message,id dataObject))success
     failure:(void (^)( id responseObject, NSError * error))failure;
{
//    if(![FZSignInStatus  isAccessTokenValid]){
//        failure(nil,nil);
//    }
    //缓存处理
    if (needCache && URLString && success) {
        id cacheObject = [FZiOSCache objectForKey:URLString];
        if (cacheObject) {
            //model对象
            if (classType) {
                //不是需要的类型，不返回缓存
                if ([cacheObject isKindOfClass:classType]) {
                    success(kFZRequestStatusCodeSuccess, nil, cacheObject);
                } else if ([cacheObject isKindOfClass:[NSArray class]]) {
                    //数组对象
                    NSArray *cacheObjestArray = (NSArray *)cacheObject;
                    if (cacheObjestArray && [cacheObjestArray count] > 0) {
                        id modelObject = [cacheObjestArray firstObject];
                        if ([modelObject isKindOfClass:classType]) {
                            success(kFZRequestStatusCodeSuccess, nil, cacheObject);
                        }
                    }
                }
            } else {
                success(kFZRequestStatusCodeSuccess, nil, cacheObject);
            }//end of if (classType
            
        }//end of if(cacheObject)
    }//end of if (needCache...
    
    [self POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if ([responseObject isKindOfClass:[NSDictionary class]]) {
             [self handleResponseObject:responseObject];
         }
         NSString *message = nil;
         NSInteger status = kFZRequestStatusCodeError;
         id responseDataObject = nil;
         if (responseObject) {
             NSString *errorMessage = [responseObject objectForKey:@"msg"];
             if (errorMessage && [errorMessage length] > 0) {
                 message = errorMessage;
             }
             
             NSNumber* statusCode = [responseObject objectForKey:@"status"];
             if (statusCode) {
                 status = statusCode.integerValue;
             }
             responseDataObject = responseObject[@"data"];
         }
         
         if (success) {
             if (status == kFZRequestStatusCodeSuccess && classType && responseDataObject) {
                 if ([responseDataObject isKindOfClass:[NSArray class]]) {
                     NSArray *array = [MTLJSONAdapter modelsOfClass:classType fromJSONArray:responseObject error:nil];
                     if (needCache) {
                         [FZiOSCache setObject:array forKey:URLString];
                     }
                     
                     success(status,message,array);
                 } else {
                     FZBaseModel *model = [MTLJSONAdapter modelOfClass:classType fromJSONDictionary:responseObject error:nil];
                     if (needCache) {
                         [FZiOSCache setObject:model forKey:URLString];
                     }
                     success(status,message,model);
                 }
             } else {
                 if (needCache) {
                     [FZiOSCache setObject:responseDataObject forKey:URLString];
                 }
                 success(status,message,responseDataObject);
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         if (failure) {
             failure(nil, error);
         }
     }];
}

-(void)handleResponseObject:(id)responseObject
{
    NSString* statusCode = [responseObject objectForKey:@"status"];
    if (statusCode) {
        if([statusCode integerValue] == kFZRequestStatusCodeNotLogin) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kPostLogoutNotification object:nil userInfo:nil];
        }
    }
}

@end
