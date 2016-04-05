//
//  FZTeacherDetailsModel.h
//  CloudClass
//
//  Created by guangfu yang on 16/1/27.
//  Copyright © 2016年 yangguangfu. All rights reserved.
//

#import "FZBaseModel.h"

@interface FZTeacherDetailsModel : FZBaseModel

@property (nonatomic, strong) NSString *course_id;
@property (nonatomic, strong) NSString *tch_id;
@property (nonatomic, strong) NSString *course_title;
@property (nonatomic, strong) NSString *course_desc;
@property (nonatomic, strong) NSString *course_pic;
@property (nonatomic, strong) NSString *start_time;
@property (nonatomic, strong) NSString *max_num;
@property (nonatomic, strong) NSString *bespeak_num;
@property (nonatomic, strong) NSString *statue;
@property (nonatomic, strong) NSString *is_speak;
@property (nonatomic, strong) NSString *course_type;
@property (nonatomic, strong) NSString *course_sub_num;
@property (nonatomic, strong) NSString *course_price;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *remain_time;

@end
