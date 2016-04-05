//
//  FZTypeCourseInfoModel.h
//  CloudClass
//
//  Created by guangfu yang on 16/3/10.
//  Copyright © 2016年 yangguangfu. All rights reserved.
//

#import "FZBaseModel.h"

@interface FZTypeCourseInfoModel : FZBaseModel

@property (nonatomic, strong) NSString *course_id;
@property (nonatomic, strong) NSString *course_sub_id;
@property (nonatomic, strong) NSString *tch_id;
@property (nonatomic, strong) NSString *course_type;
@property (nonatomic, strong) NSString *course_title;
@property (nonatomic, strong) NSString *statue;
@property (nonatomic, strong) NSString *start_time;
@property (nonatomic, strong) NSString *end_time;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *create_time;
@property (nonatomic, strong) NSString *section_sort;

@end
