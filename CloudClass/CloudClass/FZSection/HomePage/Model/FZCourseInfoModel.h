//
//  FZCourseInfoModel.h
//  CloudClass
//
//  Created by guangfu yang on 16/3/10.
//  Copyright © 2016年 yangguangfu. All rights reserved.
//

#import "FZBaseModel.h"

@interface FZCourseInfoModel : FZBaseModel

@property (nonatomic, strong) NSString *course_id;//课程id
@property (nonatomic, strong) NSString *course_title;//标题
@property (nonatomic, strong) NSString *course_desc;//介绍
@property (nonatomic, strong) NSString *course_pic;//图片
@property (nonatomic, strong) NSString *course_price;//价格
@property (nonatomic, strong) NSString *course_sub_num;//课程节数
@property (nonatomic, strong) NSString *start_time; //开始
@property (nonatomic, strong) NSString *end_time;//结束时间
@property (nonatomic, strong) NSString *bespeak_num;//报名人数
@property (nonatomic, strong) NSString *max_num;//最大人数
@property (nonatomic, strong) NSString *statue;//课程状态
@property (nonatomic, strong) NSString *is_speak;//是否预约
@property (nonatomic, strong) NSString *nickname;//昵称
@property (nonatomic, strong) NSString *tch_id;//老师id
@property (nonatomic, strong) NSString *tid;//支付参数

@end
