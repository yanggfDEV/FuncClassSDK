//
//  FZCourseInfoModel.m
//  CloudClass
//
//  Created by guangfu yang on 16/3/10.
//  Copyright © 2016年 yangguangfu. All rights reserved.
//

#import "FZCourseInfoModel.h"

@implementation FZCourseInfoModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"course_id"  : @"course_id",
             @"course_title" : @"course_title",
             @"course_desc" : @"course_desc",
             @"course_pic" : @"course_pic",
             @"course_price" : @"course_price",
             @"course_sub_num" : @"course_sub_num",
             @"start_time" : @"start_time",
             @"end_time" : @"end_time",
             @"bespeak_num" : @"bespeak_num",
             @"max_num" : @"max_num",
             @"statue" : @"statue",
             @"is_speak" : @"is_speak",
             @"nickname" : @"nickname",
             @"tch_id" : @"tch_id",
             @"tid" : @"tid",
             };
}


@end
