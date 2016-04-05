//
//  FZCourseMeetingModel.m
//  CloudClass
//
//  Created by guangfu yang on 16/2/16.
//  Copyright © 2016年 yangguangfu. All rights reserved.
//

#import "FZCourseMeetingModel.h"

@implementation FZCourseMeetingModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"course_id"  : @"course_id",
             @"room_id" : @"room_id",
             @"conference_number" : @"conference_number",
             };
}


@end
