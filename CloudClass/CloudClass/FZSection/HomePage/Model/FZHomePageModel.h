//
//  FZHomePageModel.h
//  CloudClass
//
//  Created by guangfu yang on 16/3/8.
//  Copyright © 2016年 yangguangfu. All rights reserved.
//

#import "FZBaseModel.h"

@interface FZHomePageModel : FZBaseModel

@property (nonatomic, strong) NSString *course_id;
@property (nonatomic, strong) NSString *tch_id;
@property (nonatomic, strong) NSString *course_title;
@property (nonatomic, strong) NSString *course_type;
@property (nonatomic, strong) NSString *course_pic;
@property (nonatomic, strong) NSString *start_time;//开始时间
@property (nonatomic, strong) NSString *max_num;//最多人数
@property (nonatomic, strong) NSString *bespeak_num;//报名人数
@property (nonatomic, strong) NSString *remain_time;//剩余结束时间
@property (nonatomic, strong) NSString *statue;//课程状态
@property (nonatomic, strong) NSString *course_sub_num;//课时数
@property (nonatomic, strong) NSString *nickName;

@end
