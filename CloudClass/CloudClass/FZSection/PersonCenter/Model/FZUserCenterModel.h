//
//  FZUserCenterModel.h
//  CloudClass
//
//  Created by guangfu yang on 16/1/28.
//  Copyright © 2016年 yangguangfu. All rights reserved.
//

#import "FZBaseModel.h"
typedef NS_ENUM(NSUInteger, FZUserCenterShowUnread) {
    FZUserCenterShowUnreadNone,
    FZUserCenterShowUnreadFlag,
    FZUserCenterShowUnreadCount
};

@interface FZUserCenterModel : FZBaseModel

@property (copy, nonatomic) NSString *identifier;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *iconName;
@property (assign, nonatomic) NSInteger count;
@property (assign, nonatomic) FZUserCenterShowUnread showUnread;


@end
