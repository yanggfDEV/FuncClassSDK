//
//  FZCourseListViewController.h
//  CloudClass
//
//  Created by guangfu yang on 16/3/14.
//  Copyright © 2016年 yangguangfu. All rights reserved.
//

#import "FZCommonViewController.h"
typedef void (^ScrollBlock) (void);

@interface FZCourseListViewController : FZCommonViewController

@property (nonatomic, copy) ScrollBlock upScrollBlock;
@property (nonatomic, copy) ScrollBlock downScrollBlock;
@property (nonatomic, strong) NSString *course_id;
@property (nonatomic, strong) NSString *tch_id;
@end
