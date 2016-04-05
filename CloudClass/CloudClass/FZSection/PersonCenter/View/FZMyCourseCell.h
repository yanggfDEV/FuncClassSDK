//
//  FZMyCourseCell.h
//  CloudClass
//
//  Created by guangfu yang on 16/1/29.
//  Copyright © 2016年 yangguangfu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FZMyCourseModel.h"
@class FZMyCourseCell;
typedef void(^ClickCellBlock) (void);
typedef void(^StartCourseBlock) (FZMyCourseCell *cell);
typedef void(^StartCourseFailureBlock) (NSString *message);

@interface FZMyCourseCell : UITableViewCell

@property (nonatomic, copy) ClickCellBlock isGuestTyeBlock;
@property (nonatomic, copy) StartCourseBlock startCourseBlock;
@property (nonatomic, copy) StartCourseFailureBlock startCourseFailureBlock;

- (void)setCellData:(FZMyCourseModel *)model;

@end
