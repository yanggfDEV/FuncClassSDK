//
//  FZUserCenterModel.m
//  CloudClass
//
//  Created by guangfu yang on 16/1/28.
//  Copyright © 2016年 yangguangfu. All rights reserved.
//

#import "FZUserCenterModel.h"

@implementation FZUserCenterModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"identifier"  : @"identifier",
             @"title"       : @"title",
             @"iconName"    : @"icon",
             @"count"       : NSNull.null,
             @"showUnread"  : NSNull.null
             };
}

@end
