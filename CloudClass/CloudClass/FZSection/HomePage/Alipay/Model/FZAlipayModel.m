//
//  FZAlipayModel.m
//  CloudClass
//
//  Created by guangfu yang on 16/3/9.
//  Copyright © 2016年 yangguangfu. All rights reserved.
//

#import "FZAlipayModel.h"

@implementation FZAlipayModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"orderId"         : @"order_id",
             @"title"           : @"title",
             @"desc"            : @"desc",
             @"amount"          : @"amount",
             @"callbackUrl"     : @"return_url",
             @"alipayPid"       : @"alipay_pid",
             @"alipayAccount"   : @"alipay_account",
             @"alipayPublicKey" : @"alipay_public_key",
             @"alipayPrivateKey": @"alipay_private_key"
             };
}

@end
