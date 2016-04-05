//
//  FZHomePageModel.m
//  CloudClass
//
//  Created by guangfu yang on 16/3/8.
//  Copyright © 2016年 yangguangfu. All rights reserved.
//

#import "FZHomePageModel.h"

@implementation FZHomePageModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"course_id"  : @"course_id",
             @"tch_id" : @"tch_id",
             @"course_title" : @"course_title",
             @"course_type" : @"course_type",
             @"course_pic" : @"course_pic",
             @"start_time" : @"start_time",
             @"max_num" : @"max_num",
             @"bespeak_num" : @"bespeak_num",
             @"remain_time" : @"remain_time",
             @"statue" : @"statue",
             @"course_sub_num" : @"course_sub_num",
             @"nickName" : @"nickname",
             };
}

@end
