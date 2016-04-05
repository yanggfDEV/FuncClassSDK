//
//  FZLoginViewController.h
//  CloudClass
//
//  Created by guangfu yang on 16/1/27.
//  Copyright © 2016年 yangguangfu. All rights reserved.
//

#import "FZCommonViewController.h"

typedef void(^FZLoginSuccessBlock)(void);
typedef void(^FZLoginFailureBlock)(NSString *errorMessage);
typedef void(^FZLoginCancelBlock)(void);

@interface FZLoginViewController : FZCommonViewController

@property (assign, nonatomic) BOOL showCancelButton;//default is NO
@property (strong, nonatomic) NSString *loginTip;//提示登录原因

@property (nonatomic, copy) FZLoginSuccessBlock loginSuccessBlock;
@property (nonatomic, copy) FZLoginCancelBlock loginCancelBlock;
@property (nonatomic, copy) FZLoginFailureBlock loginFailureBlock;

@property (nonatomic, copy) FZLoginSuccessEventBlock loginSuccessEventBlock;

@end
