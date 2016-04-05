//
//  FLNetWorkExecute.m
//  VideoPlayer
//
//  Created by huyangming on 14-11-7.
//  Copyright (c) 2014年 feili. All rights reserved.
//

#import "FZNetWorkManager.h"
#import "AFURLSessionManager.h"
#import "AFHTTPRequestOperationManager.h"
#import "UIDeviceUtil.h"
#import "FZBaseRootModel.h"

//#import "ALIVoiceRecorderBase.h"
#import "FZBaseModel.h"
#import "MTLJSONAdapter.h"
#import "FZiOSCache+TMCache.h"

#import "FZLoginUser.h"
#import "FZSignInStatus.h"


#define kFZNetworkRequestStatusOK 1
#define kFZNetworkRequestStatusFailed 0

static NSString *const kUserInfoUID = @"uid";
static NSString *const kUserInfoAuthToken = @"auth_token";

@interface FZNetWorkManager ()

@property (strong, nonatomic) NSString *userAgent;

@end

@implementation FZNetWorkManager


+ (FZNetWorkManager *) sharedInstance
{
    static  FZNetWorkManager *sharedInstance = nil ;
    static  dispatch_once_t onceToken;
    dispatch_once (& onceToken, ^ {
        sharedInstance = [[self  alloc] init];
    });
    return  sharedInstance;
}

// 默认初始化方法,放些默认设置，同时如果有特殊参数，比如agent等需要设置部分，做特殊设置
- (instancetype)init
{
    self = [super init];
    
    if (self) {
        return self;
    }
    return self;
}

-(void)setAgent:(NSString*)agent {
    if (_userAgent != agent) {
        _userAgent = agent;
    }
}


- (void)GET:(NSString *)URLString
  needCache:(BOOL)needCache
 parameters:(id)parameters
responseClass:(Class)classType
    success:(void (^)(NSInteger statusCode, NSString *message, id dataObject))success
    failure:(void (^)( id responseObject, NSError * error))failure;
{
//    if(![FZSignInStatus  isAccessTokenValid]){
//        if (failure) {
//            failure(nil, nil);
//        }
//        return;
//    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"html/json",@"text/plain", nil];
    AFJSONResponseSerializer *jsonReponseSerializer = [AFJSONResponseSerializer serializer];
    jsonReponseSerializer.acceptableContentTypes = nil;
    manager.responseSerializer = jsonReponseSerializer;

    
    [self setHttpHeader:manager];
    
    NSString *requestURLString = [self urlStringAddCommonParamForSourceURLString:URLString];
    
    NSLog(@"GET--requestURLString: %@",requestURLString);
    
    //缓存处理
    if (needCache && URLString && success) {
        id cacheObject = [FZiOSCache objectForKey:URLString];
        if (cacheObject) {
            //model对象
            if (classType) {
                //不是需要的类型，不返回缓存
                if ([cacheObject isKindOfClass:classType]) {
                    success(kFZNetworkRequestStatusOK, nil, cacheObject);
                } else if ([cacheObject isKindOfClass:[NSArray class]]) {
                    //数组对象
                    NSArray *cacheObjestArray = (NSArray *)cacheObject;
                    if (cacheObjestArray && [cacheObjestArray count] > 0) {
                        id modelObject = [cacheObjestArray firstObject];
                        if ([modelObject isKindOfClass:classType]) {
                            success(kFZNetworkRequestStatusOK, nil, cacheObject);
                        }
                    }
                }
            } else {
                success(kFZNetworkRequestStatusOK, nil, cacheObject);
            }//end of if (classType
            
        }//end of if(cacheObject)
    }//end of if (needCache...
    
    [manager GET:requestURLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         NSLog(@"=======%@======",responseObject);
         if ([responseObject isKindOfClass:[NSDictionary class]]) {
             [self handleResponseObject:responseObject];
         }
         NSString *message = nil;
         NSInteger status = kFZNetworkRequestStatusFailed;
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
             if (status == kFZNetworkRequestStatusOK && classType && responseDataObject) {
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
//        if (failure) {
//            failure(nil, nil);
//        }
//        return;
//    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"html/json",@"text/plain", nil];
    AFJSONResponseSerializer *jsonReponseSerializer = [AFJSONResponseSerializer serializer];
    jsonReponseSerializer.acceptableContentTypes = nil;
    manager.responseSerializer = jsonReponseSerializer;

    
    [self setHttpHeader:manager];
    
    NSString *requestURLString = [self urlStringAddCommonParamForSourceURLString:URLString];
    
     NSLog(@"POST--requestURLString: %@",requestURLString);
    
    //缓存处理
    if (needCache && URLString && success) {
        id cacheObject = [FZiOSCache objectForKey:URLString];
        if (cacheObject) {
            //model对象
            if (classType) {
                //不是需要的类型，不返回缓存
                if ([cacheObject isKindOfClass:classType]) {
                    success(kFZNetworkRequestStatusOK, nil, cacheObject);
                } else if ([cacheObject isKindOfClass:[NSArray class]]) {
                    //数组对象
                    NSArray *cacheObjestArray = (NSArray *)cacheObject;
                    if (cacheObjestArray && [cacheObjestArray count] > 0) {
                        id modelObject = [cacheObjestArray firstObject];
                        if ([modelObject isKindOfClass:classType]) {
                            success(kFZNetworkRequestStatusOK, nil, cacheObject);
                        }
                    }
                }
            } else {
                success(kFZNetworkRequestStatusOK, nil, cacheObject);
            }//end of if (classType
            
        }//end of if(cacheObject)
    }//end of if (needCache...
    
    [manager POST:requestURLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if ([responseObject isKindOfClass:[NSDictionary class]]) {
             [self handleResponseObject:responseObject];
         }
         NSString *message = nil;
         NSInteger status = kFZNetworkRequestStatusFailed;
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
             if (status == kFZNetworkRequestStatusOK && classType && responseDataObject) {
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

/**
 *  上传文件
 *
 *  @param URLString
 *  @param fileName
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
     failure:(void (^)( id responseObject, NSError * error))failure{
    
    if(![FZLoginUser isGuest] && ![FZSignInStatus  isAccessTokenValid]){
        if (failure) {
            failure(nil, nil);
        }
        return;
    }
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *requestURLString = [self urlStringAddCommonParamForSourceURLString:URLString];
    
     NSLog(@"POST-UploadFile--requestURLString: %@",requestURLString);
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:requestURLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:fileData name:formFileName fileName:fileName mimeType:mimeType];
    } error:nil];
    
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        if(error){
            if (failure) {
                failure(nil, error);
            }
            return;
        }
        
        NSData * data = responseObject;
        NSString *result = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
        NSError *parserError;
        NSDictionary *jsonValue = [NSJSONSerialization JSONObjectWithData:[(NSString *)result  dataUsingEncoding:NSUTF8StringEncoding]options:kNilOptions error:&parserError];
        
        if(parserError){
            if (failure) {
                failure(nil, error);
            }
            return;
        }
        [self handleResponseObject:jsonValue];
        NSString *message = nil;
        NSInteger status = kFZNetworkRequestStatusFailed;
        id responseDataObject = nil;
        if (jsonValue) {
            message = [jsonValue objectForKey:@"msg"];
            NSNumber* statusCode = [jsonValue objectForKey:@"status"];
            if (statusCode) {
                status = statusCode.integerValue;
            }
            responseDataObject = jsonValue[@"data"];
        }
        if (success) {
            if (status == kFZNetworkRequestStatusOK && classType && responseDataObject) {
                if ([responseDataObject isKindOfClass:[NSArray class]]) {
                    NSArray *array = [MTLJSONAdapter modelsOfClass:classType fromJSONArray:responseDataObject error:nil];
                    success(status,message,array);
                } else {
                    FZBaseModel *model = [MTLJSONAdapter modelOfClass:classType fromJSONDictionary:responseDataObject error:nil];
                    success(status,message,model);
                }
            } else {
                success(status,message,responseDataObject);
            }
        }
    }];
    
    [uploadTask resume];
}


- (void)POST:(NSString *)URLString
  parameters:(id)parameters responseDtoClassType:(Class)classType
     success:(void (^)( id responseObject))success
     failure:(void (^)( id responseObject,NSError * error))failure
{
    if(![FZLoginUser isGuest] && ![FZSignInStatus  isAccessTokenValid]){
        if (failure) {
            failure(nil, nil);
        }
        return;
    }
    AFHTTPRequestOperationManager * manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"html/json",@"text/plain", nil];
    AFJSONResponseSerializer *jsonReponseSerializer = [AFJSONResponseSerializer serializer];
    jsonReponseSerializer.acceptableContentTypes = nil;
    manager.responseSerializer = jsonReponseSerializer;

    
    [self setHttpHeader:manager];
    URLString = [self urlStringAddCommonParamForSourceURLString:URLString];
    [manager POST:URLString parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject){
              if ([responseObject isKindOfClass:[NSDictionary class]]) {
                  [self handleResponseObject:responseObject];
              }
              if (success) {
                  //解析数据
                  if (classType) {
                      if ([responseObject isKindOfClass:[NSArray class]]) {
                          NSArray *array = [MTLJSONAdapter modelsOfClass:classType fromJSONArray:responseObject error:nil];
                          success(array);
                      } else {
                          FZBaseModel *model = [MTLJSONAdapter modelOfClass:classType fromJSONDictionary:responseObject error:nil];
                          success(model);
                      }
                  } else {
                      success(responseObject);
                  }
              }
          }failure:^(AFHTTPRequestOperation *operation, NSError *error){
              if (failure) {
                 failure(operation.responseObject, error);
              }
          }];
}

- (void)GETWithNoDefaultParam:(NSString *)URLString
                   parameters:(id)parameters  responseDtoClassType:(Class)classType
                      success:(void (^)(id responseObject))success
                      failure:(void (^)( id responseObject, NSError * error))failure
{
    

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"html/json",@"text/plain", nil];
    AFJSONResponseSerializer *jsonReponseSerializer = [AFJSONResponseSerializer serializer];
    jsonReponseSerializer.acceptableContentTypes = nil;
    manager.responseSerializer = jsonReponseSerializer;

    
    [self setHttpHeader:manager];
    
    [manager GET:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if (classType) {
             if ([responseObject isKindOfClass:[NSArray class]]) {
                 NSArray *array = [MTLJSONAdapter modelsOfClass:classType fromJSONArray:responseObject error:nil];
                 success(array);
             } else {
                 FZBaseModel *model = [MTLJSONAdapter modelOfClass:classType fromJSONDictionary:responseObject error:nil];
                 success(model);
             }
         } else {
             success(responseObject);
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         failure(nil, error);
     }];
}

- (void)handleResponseObject:(id)responseObject {
    NSString* statusCode = [responseObject objectForKey:@"status"];
    if (statusCode != nil ) {
        if([statusCode integerValue] == 403 || [statusCode integerValue] == 10020) {
            if ([statusCode integerValue] == 10020) {
                [FZSignInStatus  isAccessTokenValid];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:kPostLogoutNotification object:nil userInfo:nil];
        }  
    }
}

- (void)GET:(NSString *)URLString
 parameters:(id)parameters  responseDtoClassType:(Class)classType
    success:(void (^)(id responseObject))success
    failure:(void (^)( id responseObject, NSError * error))failure
{
    if(![FZLoginUser isGuest] && ![FZSignInStatus  isAccessTokenValid]){
        if (failure) {
            failure(nil, nil);
        }
        return;
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"html/json",@"text/plain", nil];
//    AFJSONResponseSerializer *jsonReponseSerializer = [AFJSONResponseSerializer serializer];
//    // This will make the AFJSONResponseSerializer accept any content type
//    jsonReponseSerializer.acceptableContentTypes = nil;
//    manager.responseSerializer = jsonReponseSerializer;
    AFJSONResponseSerializer *jsonReponseSerializer = [AFJSONResponseSerializer serializer];
    jsonReponseSerializer.acceptableContentTypes = nil;
    manager.responseSerializer = jsonReponseSerializer;

    
    [self setHttpHeader:manager];

    URLString = [self urlStringAddCommonParamForSourceURLString:URLString];
    
     NSLog(@"GET--URLString: %@",URLString);
    [manager GET:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            [self handleResponseObject:responseObject];
        }
        if (success) {
            if (classType) {
                if ([responseObject isKindOfClass:[NSArray class]]) {
                    NSArray *array = [MTLJSONAdapter modelsOfClass:classType fromJSONArray:responseObject error:nil];
                    success(array);
                } else {
                    FZBaseModel *model = [MTLJSONAdapter modelOfClass:classType fromJSONDictionary:responseObject error:nil];
                    success(model);
                }
            } else {
                success(responseObject);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(nil, error);
        }
    }];
}


- (void)GETWithCache:(NSString *)URLString
          parameters:(id)parameters  responseDtoClassType:(Class)classType
             success:(void (^)(id responseObject))success
             failure:(void (^)( id responseObject, NSError * error))failure
{
    NSString *requestURLString = [self urlStringAddCommonParamForSourceURLString:URLString];
    if (URLString) {
        [FZiOSCache objectForKey:URLString block:^(TMCache *cache, NSString *key, id object) {
            if (object && [object isKindOfClass:classType] && success) {
                success(object);
            }
        }];
    }
    
    [self GET:requestURLString parameters:parameters responseDtoClassType:classType success:^(id responseObject) {
        if (classType) {
            FZBaseRootModel *model = responseObject;
            if (model && model.status == 1) {
                [FZiOSCache setObject:responseObject forKey:URLString];
            }
        }
        
        if (success) {
            success(responseObject);
        }
    } failure:^(id responseObject, NSError *error) {
        id cacheObject = [FZiOSCache objectForKey:URLString];
        if (!cacheObject && failure) {
            failure(responseObject, error);
        }
    }];
}

- (void)POSTWithSyc:(NSString *)URLString
          parameters:(id)parameters
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"html/json",@"text/plain", nil];
    AFJSONResponseSerializer *jsonReponseSerializer = [AFJSONResponseSerializer serializer];
    jsonReponseSerializer.acceptableContentTypes = nil;
    manager.responseSerializer = jsonReponseSerializer;

    [self setHttpHeader:manager];
    URLString = [self urlStringAddCommonParamForSourceURLString:URLString];
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"POST" URLString:URLString parameters:parameters error:nil];
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [requestOperation setResponseSerializer:manager.responseSerializer];
    [requestOperation start];
    [requestOperation waitUntilFinished];
    
    

}


- (void)POSTWithCache:(NSString *)URLString
           parameters:(id)parameters responseDtoClassType:(Class)classType
              success:(void (^)( id responseObject))success
              failure:(void (^)( id responseObject, NSError * error))failure
{
    NSString *requestURLString = [self urlStringAddCommonParamForSourceURLString:URLString];
    if (URLString) {
        [FZiOSCache objectForKey:URLString block:^(TMCache *cache, NSString *key, id object) {
            if (object && [object isKindOfClass:classType] && success) {
                success(object);
            }
        }];
    }
    [self POST:requestURLString parameters:parameters responseDtoClassType:classType success:^(id responseObject) {
        if (classType) {
            FZBaseRootModel *model = responseObject;
            if (model && model.status == 1) {
                [FZiOSCache setObject:responseObject forKey:URLString];
            }
        }
        
        if (success&&classType) {
            success(responseObject);
        }
    } failure:^(id responseObject, NSError *error) {
        id cacheObject = [FZiOSCache objectForKey:URLString];
        if (!cacheObject && failure) {
            failure(responseObject, error);
        }
    }];
}

-(void)setHttpHeader:(AFHTTPRequestOperationManager*) manger
{
    NSString *deviceType = [UIDeviceUtil hardwareDescription];
    NSString *deviceSystemName = [UIDevice currentDevice].systemName;
    NSString *deviceSystemVersion = [UIDevice currentDevice].systemVersion;

    [[manger requestSerializer] setValue:deviceType forHTTPHeaderField:@"Device-Model"];
    [[manger requestSerializer] setValue:@"iOS" forHTTPHeaderField:@"User-Agent"];
    [[manger requestSerializer] setValue:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"versionCode"] forHTTPHeaderField:@"versionCode"];
    [[manger requestSerializer] setValue:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]  forHTTPHeaderField:@"App-Version"];
    [[manger requestSerializer] setValue:[NSString  stringWithFormat:@"%@%@",deviceSystemName,deviceSystemVersion] forHTTPHeaderField:@"Client-OS"];
    
}


- (NSString *)urlStringAddCommonParamForSourceURLString:(NSString *)urlString {
    if (!urlString) {
        return nil;
    }
    
    NSMutableString *addString = [NSMutableString string];
//    NSString *uid = [FZLoginUser userID];
//    NSString *authToken = [FZLoginUser authToken];
    //添加uid
    if (![urlString containsString:kUserInfoUID] && [FZLoginUser userID]) {
        [addString appendFormat:@"&%@=%@", kUserInfoUID, [FZLoginUser userID]];
    }
    
    //添加token
    if (![urlString containsString:kUserInfoAuthToken] && [FZLoginUser authToken]) {
        [addString appendFormat:@"&%@=%@", kUserInfoAuthToken, [FZLoginUser authToken]];
    }
    
    NSString *resultUrlString = [urlString stringByAppendingString:addString];
    return resultUrlString;
}


@end
