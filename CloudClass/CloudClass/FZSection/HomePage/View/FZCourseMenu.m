//
//  FZCourseMenu.m
//  CloudClass
//
//  Created by Asuna on 16/3/17.
//  Copyright © 2016年 yangguangfu. All rights reserved.
//

#import "FZCourseMenu.h"

@interface FZCourseMenu()

@property (weak, nonatomic) IBOutlet UILabel *courseTitle;

@property (weak, nonatomic) IBOutlet UILabel *teacher;
@property (weak, nonatomic) IBOutlet UILabel *courseTime;
@property (weak, nonatomic) IBOutlet UILabel *courseStatus;

@end

@implementation FZCourseMenu

- (void)awakeFromNib {
    FZStyleSheet *css = [FZStyleSheet currentStyleSheet];
    
    [self.courseTitle setTextColor:css.color_3];
    [self.courseTitle setFont:[UIFont systemFontOfSize:16]];
    
    [self.teacher setTextColor:css.color_4];
    [self.teacher setFont:[UIFont systemFontOfSize:12]];
    
    [self.courseTime setTextColor:css.color_4];
    [self.courseTime setFont:[UIFont systemFontOfSize:12]];

    [self.courseStatus setTextColor:css.color_4];
    [self.courseStatus setFont:[UIFont systemFontOfSize:12]];
    self.courseStatus.textAlignment = NSTextAlignmentRight;
}

- (void)setCourseInfoModel:(FZTypeCourseInfoModel *)courseInfoModel
{
    _courseInfoModel = courseInfoModel;
    
    self.courseTitle.text = courseInfoModel.course_title;
    self.teacher.text = courseInfoModel.nickname;
    NSString *startTime = [FZCommonTool getTimeString:courseInfoModel.start_time.integerValue];
    NSString *endTime = [FZCommonTool getTimeString:courseInfoModel.start_time.integerValue];
    NSArray *arrayStart = [startTime componentsSeparatedByString:@" "];
    NSArray *arrayEnd = [endTime componentsSeparatedByString:@" "];
    NSString *time = @"";
    if (arrayStart.count && arrayEnd.count &&
        [[arrayStart firstObject] isEqualToString:[arrayEnd firstObject]]) {
        NSInteger endLength = [[arrayEnd firstObject] length] + 1;
        time = [NSString stringWithFormat:@"%@ ~ %@", startTime, [endTime substringFromIndex: endLength]];
    } else {
        time = [NSString stringWithFormat:@"%@ ~ %@", startTime, endTime];
    }
    self.courseTime.text = time;
 
    if (courseInfoModel.statue.integerValue == 0) {
        self.courseStatus.text = @"未开始";
        [self.courseStatus setTextColor:[FZStyleSheet currentStyleSheet].color_4];
    } else if(courseInfoModel.statue.integerValue == 1){
        self.courseStatus.text = @"正在上课";
        [self.courseStatus setTextColor:[UIColor colorWithHex:0xffb42d]];
    } else if (courseInfoModel.statue.integerValue == 2) {
        self.courseStatus.text = @"已结束";
        [self.courseStatus setTextColor:[FZStyleSheet currentStyleSheet].color_4];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
