//
//  FZSetNickNameViewController.h
//  CloudClass
//
//  Created by guangfu yang on 16/1/28.
//  Copyright © 2016年 yangguangfu. All rights reserved.
//

#import "FZCommonViewController.h"
typedef void(^SetNickNameSuccessBlock) (void);

@interface FZSetNickNameViewController : FZCommonViewController
@property (nonatomic, copy) SetNickNameSuccessBlock setNickNameSuccessBlock;
@end
