//
//  FZMyCourseCell.m
//  CloudClass
//
//  Created by guangfu yang on 16/1/29.
//  Copyright © 2016年 yangguangfu. All rights reserved.
//

#import "FZMyCourseCell.h"

@interface FZMyCourseCell ()
@property (weak, nonatomic) IBOutlet UIImageView *courseImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *speakerLabel;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (nonatomic, strong) NSString *leftTime;

@property (nonatomic, strong) FZMyCourseModel *detailsModel;

@end

@implementation FZMyCourseCell

- (void)awakeFromNib {
    FZStyleSheet *css = [[FZStyleSheet alloc] init];
    self.courseImage.layer.cornerRadius = 5;
    self.courseImage.layer.masksToBounds = YES;
    self.courseImage.contentMode = UIViewContentModeScaleAspectFill;
    self.courseImage.clipsToBounds = YES;
    
    self.titleLabel.textColor = css.colorOfListTitle;
    self.titleLabel.font = css.fontOfH4;
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    
    self.descLabel.numberOfLines = 2;
    self.descLabel.textColor = css.colorOfListSubtitle;
    self.descLabel.font = css.fontOfH6;
    self.descLabel.textAlignment = NSTextAlignmentLeft;
    
    self.startTimeLabel.textColor = css.colorOfListSubtitle;
    self.startTimeLabel.font = css.fontOfH6;
    self.startTimeLabel.textAlignment = NSTextAlignmentLeft;
    
    self.speakerLabel.textColor = css.colorOfListSubtitle;
    self.speakerLabel.font = css.fontOfH6;
    self.speakerLabel.textAlignment = NSTextAlignmentLeft;
    
    self.status.textColor = css.colorOfListSubtitle;
    self.status.font = css.fontOfH6;
    self.status.textAlignment = NSTextAlignmentRight;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setCellData:(FZMyCourseModel *)model {
    self.detailsModel = model;
    NSInteger status = [model.status integerValue];
    NSString *title = @"";
        if (status == 0) {
            title = @"等待上课";
        } else if (status == 1) {
            title = @"进入课堂";
        } else if (status == 2) {
            title = @"已经结束";
        }
    self.status.text = title;
    
    if ([model.course_pic isKindOfClass:[NSString class]]) {
        [self.courseImage sd_setImageWithURL:[NSURL URLWithString:[model.course_pic stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"common_img_index_poster"] completed:nil];
    }
    self.titleLabel.text = model.course_title;
    if (model.course_desc) {
        self.descLabel.text = [NSString stringWithFormat:@"简介 : %@", model.course_desc];
    }
    self.speakerLabel.text = [NSString stringWithFormat:@"主讲 : %@", model.nickname];
    self.startTimeLabel.text = [NSString stringWithFormat:@"开课时间 : %@（ %@课时 )", [self getTimeString:[model.start_time integerValue]], model.course_sub_num];
 
    self.leftTime = [self leftTime:model.start_time];
}

- (BOOL)onTimeOver:(NSString *)startTime {
    NSTimeInterval newDate = [[NSDate date] timeIntervalSince1970];
    NSString *newTimeStr = [NSString stringWithFormat:@"%f", newDate];
    NSInteger newTime = [newTimeStr integerValue];
    if (newTime > [startTime integerValue]) {
        return YES;
    } else {
        return NO;
    }
}

- (NSString *)leftTime:(NSString *)startTime {
    NSTimeInterval newDate = [[NSDate date] timeIntervalSince1970];
    NSString *newTimeStr = [NSString stringWithFormat:@"%f", newDate];
    NSInteger newTime = [newTimeStr integerValue];
    NSString *leftTimeTemp = @"距离上课时间还有";
    if (newTime < [startTime integerValue]) {
        NSInteger left = [startTime integerValue] - newTime;
        NSInteger day = left / (24 * 60 * 60);
        NSInteger hour = (left - (day * 24 * 60 * 60)) / (60 * 60);
        NSInteger minus =  (left - (day * 24 * 60 * 60) - (hour * 60 * 60)) / (60);
        
        if (day) {
            //天
            leftTimeTemp = [leftTimeTemp stringByAppendingString:[NSString stringWithFormat:@"%ld天", day]];
        }
        if (hour) {
            // 小时
            leftTimeTemp = [leftTimeTemp stringByAppendingString:[NSString stringWithFormat:@"%ld小时", hour]];
        }
        if (minus) {
            //分钟
            leftTimeTemp = [leftTimeTemp stringByAppendingString:[NSString stringWithFormat:@"%ld分钟", minus]];
        }
        return leftTimeTemp;
    } else {
        leftTimeTemp = @"请等待老师电话";
        return leftTimeTemp;
    }
}


- (NSString *)getTimeString:(int64_t)startTime {
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:startTime];
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSString *resultString = nil;
    NSDateComponents *startDateComponents = [currentCalendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitWeekday) fromDate:startDate];
    NSDateComponents *todayComments = [currentCalendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
    if (startDateComponents.year == todayComments.year && startDateComponents.month == todayComments.month && startDateComponents.day == todayComments.day) {
        resultString = @"今天";
    } else if(startDateComponents.year == todayComments.year && startDateComponents.month == todayComments.month && startDateComponents.day - todayComments.day == -1) {
        resultString = @"昨天";
    }
    
    else {
        resultString = [NSString stringWithFormat:@"%ld月%ld日", (long)startDateComponents.month, (long)startDateComponents.day];
    }
//    resultString = [NSString stringWithFormat:@"%@ %02ld:%02ld", resultString, (long)startDateComponents.hour, (long)startDateComponents.minute];
    return resultString;
}

#pragma mark --进入课堂
- (IBAction)onStartCourse:(id)sender {
    if (![FZLoginUser mobile]) {
        if (self.isGuestTyeBlock) {
            self.isGuestTyeBlock();
        }
    } else if ([self.detailsModel.status integerValue] == 0) {
        if (self.startCourseFailureBlock) {
            self.startCourseFailureBlock(self.leftTime);
        }
    } else if ([self.detailsModel.status integerValue] == 1) {
        if (self.startCourseBlock) {
            self.startCourseBlock(self);
        }
    } else if ([self.detailsModel.status integerValue] == 2) {
        if (self.startCourseFailureBlock) {
            self.startCourseFailureBlock(LOCALSTRING(@"speak_had_timeOver"));
        }
    }

}

@end
