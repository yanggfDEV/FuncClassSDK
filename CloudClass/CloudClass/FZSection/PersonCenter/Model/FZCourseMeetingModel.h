//
//  FZCourseMeetingModel.h
//  CloudClass
//
//  Created by guangfu yang on 16/2/16.
//  Copyright © 2016年 yangguangfu. All rights reserved.
//

#import "FZBaseModel.h"

@interface FZCourseMeetingModel : FZBaseModel

@property (nonatomic, strong) NSString *course_id;
@property (nonatomic, strong) NSString *room_id;
@property (nonatomic, strong) NSString *conference_number;

@end
