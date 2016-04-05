//
//  FZTypeCourseInfoModel.m
//  CloudClass
//
//  Created by guangfu yang on 16/3/10.
//  Copyright © 2016年 yangguangfu. All rights reserved.
//

#import "FZTypeCourseInfoModel.h"

@implementation FZTypeCourseInfoModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"course_id"  : @"course_id",
             @"course_sub_id" : @"course_sub_id",
             @"tch_id" : @"tch_id",
             @"course_type" : @"course_type",
             @"course_title" : @"course_title",
             @"statue" : @"status",
             @"start_time" : @"start_time",
             @"end_time" : @"end_time",
             @"nickname" : @"nickname",
             @"create_time" : @"create_time",
             @"section_sort" : @"section_sort",
             };
}

@end
