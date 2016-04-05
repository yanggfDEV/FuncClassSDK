//
//  FZCourseOrderViewController.h
//  CloudClass
//
//  Created by guangfu yang on 16/3/10.
//  Copyright © 2016年 yangguangfu. All rights reserved.
//

#import "FZCommonViewController.h"
typedef void (^AliPayBlock) (void);
@interface FZCourseOrderViewController : FZCommonViewController
@property (nonatomic, copy) AliPayBlock aliPaySuccessBlock;
@property (nonatomic, copy) AliPayBlock aliPayFailBlock;
@property (nonatomic, strong) NSString *course_id;
@property (nonatomic, strong) NSString *order_id;

@end
