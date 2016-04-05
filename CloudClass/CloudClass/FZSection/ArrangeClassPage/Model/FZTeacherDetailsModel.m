//
//  FZTeacherDetailsModel.m
//  CloudClass
//
//  Created by guangfu yang on 16/1/27.
//  Copyright © 2016年 yangguangfu. All rights reserved.
//

#import "FZTeacherDetailsModel.h"

@implementation FZTeacherDetailsModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"course_id" : @"course_id",
             @"tch_id" : @"tch_id",
             @"course_title": @"course_title",
             @"course_desc": @"course_desc",
             @"course_pic": @"course_pic",
             @"start_time": @"start_time",
             @"max_num": @"max_num",
             @"bespeak_num": @"bespeak_num",
             @"statue": @"statue",
             @"is_speak": @"is_speak",
             @"course_type" : @"course_type",
             @"course_sub_num" : @"course_sub_num",
             @"course_price" : @"course_price",
             @"remain_time" : @"remain_time",
             @"nickname" : @"nickname",
             };
}

@end
