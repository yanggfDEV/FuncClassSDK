//
//  FZCoursePayFailViewController.h
//  CloudClass
//
//  Created by guangfu yang on 16/3/15.
//  Copyright © 2016年 yangguangfu. All rights reserved.
//

#import "FZCommonViewController.h"
#import "FZCourseInfoModel.h"

typedef void (^RepayBlock) (void);

@interface FZCoursePayFailViewController : FZCommonViewController

@property (nonatomic, strong) FZCourseInfoModel *courseInfoModel;

@property (nonatomic, copy) RepayBlock repayBlock;

@end
