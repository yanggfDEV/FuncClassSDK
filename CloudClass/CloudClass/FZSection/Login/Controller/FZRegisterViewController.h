//
//  FZRegisterViewController.h
//  CloudClass
//
//  Created by guangfu yang on 16/1/28.
//  Copyright © 2016年 yangguangfu. All rights reserved.
//

#import "FZCommonViewController.h"

typedef void(^MobileBlock) (NSString *mobile);

@interface FZRegisterViewController : FZCommonViewController

@property (nonatomic, copy) MobileBlock mobileBlock;

@property (nonatomic, assign) BOOL isForgetPassWD;

@end
