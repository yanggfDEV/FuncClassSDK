//
//  FZArrangeClassTeacherModel.m
//  CloudClass
//
//  Created by guangfu yang on 16/1/27.
//  Copyright © 2016年 yangguangfu. All rights reserved.
//

#import "FZArrangeClassTeacherModel.h"

@implementation FZArrangeClassTeacherModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"teacherID": @"id",
             @"nickName": @"nickname",
             @"avatar": @"avatar",
             };
}

@end

