//
//  FZCourseIntroViewController.h
//  CloudClass
//
//  Created by guangfu yang on 16/3/14.
//  Copyright © 2016年 yangguangfu. All rights reserved.
//

#import "FZCommonViewController.h"
#import "FZCourseInfoModel.h"
typedef void (^ScrollBlock) (void);
@interface FZCourseIntroViewController : FZCommonViewController
@property (nonatomic, copy) ScrollBlock upScrollBlock;
@property (nonatomic, copy) ScrollBlock downScrollBlock;
- (void)setUpDataWithModel:(FZCourseInfoModel*)infoModel;
@end
