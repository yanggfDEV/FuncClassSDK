//
//  FZTeacherDetailsCell.h
//  CloudClass
//
//  Created by guangfu yang on 16/1/27.
//  Copyright © 2016年 yangguangfu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FZTeacherDetailsModel.h"
@class FZTeacherDetailsCell;
typedef void(^ClickCellBlock) (void);
typedef void(^SpeakCourseBlock) (FZTeacherDetailsCell *cell);
typedef void(^SpeakCourseFailureBlock) (NSString *message);

@interface FZTeacherDetailsCell : UITableViewCell
@property (nonatomic, copy) ClickCellBlock isGuestTyeBlock;
@property (nonatomic, copy) ClickCellBlock isOverMaxNumBlock;
@property (nonatomic, copy) SpeakCourseBlock startCourseBlock;
@property (nonatomic, copy) SpeakCourseBlock speakCourseBlock;
@property (nonatomic, copy) SpeakCourseBlock payCourseBlock;
@property (nonatomic, copy) SpeakCourseFailureBlock speakCourseFailureBlock;

- (void)setCellData:(FZTeacherDetailsModel *)model;

- (void)setStatusBtnTitle;

@end
