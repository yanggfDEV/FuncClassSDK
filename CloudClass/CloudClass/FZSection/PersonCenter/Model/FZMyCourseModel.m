//
//  FZMyCourseModel.m
//  CloudClass
//
//  Created by guangfu yang on 16/1/29.
//  Copyright © 2016年 yangguangfu. All rights reserved.
//

#import "FZMyCourseModel.h"

@implementation FZMyCourseModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"course_id"  : @"course_id",
             @"course_title" : @"course_title",
             @"course_desc" : @"course_desc",
             @"course_pic" : @"course_pic",
             @"max_num" : @"max_num",
             @"bespeak_num" : @"bespeak_num",
             @"status" : @"statue",
             @"tch_id" : @"tch_id",
             @"nickname" : @"nickname",
             @"avater" : @"avater",
             @"start_time" : @"start_time",
             @"course_type" : @"course_type",
             @"course_sub_num" : @"course_sub_num",
             @"course_price" : @"course_price",
             @"online_num" : @"online_num",
             @"course_ppt" : @"course_ppt",
             };
}

@end
