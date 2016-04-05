//
//  FZAlipayModel.h
//  CloudClass
//
//  Created by guangfu yang on 16/3/9.
//  Copyright © 2016年 yangguangfu. All rights reserved.
//

#import "FZBaseModel.h"

@interface FZAlipayModel : FZBaseModel

@property (copy, nonatomic) NSString *orderId;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *desc;
@property (copy, nonatomic) NSString *amount;
@property (copy, nonatomic) NSString *callbackUrl;
@property (copy, nonatomic) NSString *alipayPid;
@property (copy, nonatomic) NSString *alipayAccount;
@property (copy, nonatomic) NSString *alipayPublicKey;
@property (copy, nonatomic) NSString *alipayPrivateKey;

@end
