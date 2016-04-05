//
//  FCChatListModel.m
//  FunChat
//
//  Created by Jyh on 15/10/10.
//  Copyright © 2015年 FeiZhu Tech. All rights reserved.
//

#import "FCChatListModel.h"

@implementation FCChatListModel

- (NSString *)unitePlatformID {
    if (!self.targetUId || !self.targetUcid) {
        return @"";
    }
    if (!self.targetIDPrefix || self.targetIDPrefix.length == 0) {
        self.targetIDPrefix = @"ql";
    }
    return [NSString stringWithFormat:@"%@_%@_%@", self.targetIDPrefix, self.targetUId, self.targetUcid];
}

@end
