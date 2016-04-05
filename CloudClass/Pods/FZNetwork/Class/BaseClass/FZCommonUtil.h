//
//  FZCommonUtil.h
//  Pods
//
//  Created by yanming.huym on 15/5/21.
//
//

#import <Foundation/Foundation.h>
#import "FZNetWorkManager.h"
#import "FZAPIGenerate.h"

typedef void(^successBlock)(id responseObject);
typedef void(^faileBlock)(id responseObject, NSError *error);

typedef void(^FZSuccessBlock)(NSInteger statusCode, NSString *message, id responseDataObject);
typedef void(^FZFailureBlock)(id responseObject, NSError *error);