//
//  FZMyCourseModel.h
//  CloudClass
//
//  Created by guangfu yang on 16/1/29.
//  Copyright © 2016年 yangguangfu. All rights reserved.
//

#import "FZBaseModel.h"

@interface FZMyCourseModel : FZBaseModel

@property (nonatomic, strong) NSString *course_id;
@property (nonatomic, strong) NSString *course_title;
@property (nonatomic, strong) NSString *course_desc;
@property (nonatomic, strong) NSString *course_pic;
@property (nonatomic, strong) NSString *max_num;
@property (nonatomic, strong) NSString *bespeak_num;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *tch_id;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *avater;
@property (nonatomic, strong) NSString *start_time;
@property (nonatomic, strong) NSString *course_type;
@property (nonatomic, strong) NSString *course_sub_num;
@property (nonatomic, strong) NSString *course_price;
@property (nonatomic, strong) NSString *online_num;
@property (nonatomic, strong) NSString *course_ppt;

@end
