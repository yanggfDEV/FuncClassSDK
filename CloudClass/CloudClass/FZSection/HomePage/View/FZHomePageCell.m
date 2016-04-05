//
//  FZHomePageCell.m
//  CloudClass
//
//  Created by guangfu yang on 16/3/8.
//  Copyright © 2016年 yangguangfu. All rights reserved.
//

#import "FZHomePageCell.h"

@interface FZHomePageCell ()

@property (weak, nonatomic) IBOutlet UIImageView *courseImage;
@property (weak, nonatomic) IBOutlet UILabel *courseTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *courseTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *speakerLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *signUpStatusLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *signUpStatusWidthCon;
@property (weak, nonatomic) IBOutlet UILabel *classNumberLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *speakerContraintsWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *courseTitleHeight;

@end

@implementation FZHomePageCell

- (void)awakeFromNib {
    FZStyleSheet *css = [[FZStyleSheet alloc] init];
    
    self.courseTitleLabel.numberOfLines = 2;
    self.courseTitleLabel.textColor = css.color_3;
    self.courseTitleLabel.font = css.fontOfH7;
    
    self.courseTimeLabel.textColor = css.color_4;
    self.courseTimeLabel.font = css.fontOfH6;
    
    self.speakerLabel.textColor = css.color_4;
    self.speakerLabel.font = css.fontOfH4;
    
    self.numberStatusLabel.textColor = css.color_4;
    self.numberStatusLabel.font = css.fontOfH6;
    
    self.signUpStatusLabel.textColor = css.color_4;
    self.signUpStatusLabel.font = css.fontOfH6;
    
    self.classNumberLabel.textColor = css.color_4;
    self.classNumberLabel.font = css.fontOfH4;
    
    self.contentView.backgroundColor = css.colorOfBackground;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setCellData:(FZHomePageModel *)model {
    FZStyleSheet *css = [[FZStyleSheet alloc] init];
    
    [self.courseImage sd_setImageWithURL:[NSURL URLWithString:[model.course_pic stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"common_img_index_poster"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    }];

    self.courseTitleLabel.text = model.course_title;
//    CGFloat courseTitleWidth = [FZCommonTool updateConstraintsOfView:model.course_title font:16].size.width;
//    if (courseTitleWidth > [FZUtils GetScreeWidth] - 158) {
//        self.courseTitleHeight.constant = 39;
//    }
    self.speakerLabel.text = [NSString stringWithFormat:@"主讲 : %@",model.nickName];
    self.classNumberLabel.text = [NSString stringWithFormat:@"班级人数 : %@人", model.max_num];
    CGFloat speakerWidth = [FZCommonTool updateConstraintsOfView:self.speakerLabel.text font:12].size.width;
    self.speakerContraintsWidth.constant = speakerWidth + 5;
    
    NSInteger lastNumb = [model.max_num integerValue] - [model.bespeak_num integerValue];
    NSString *numberStatus = @"";
    if (lastNumb == 0) {
        numberStatus = [NSString stringWithFormat:@"已停售"];
    } else if (lastNumb <= 10) {
        NSString *lastNumbstr = [NSString stringWithFormat:@"%ld", lastNumb];
        numberStatus = [NSString stringWithFormat:@"仅剩余%ld个名额",lastNumb];
        self.numberStatusLabel.attributedText = [FZCommonTool getLengthWithString:numberStatus withFont:10 local:3 length:lastNumbstr.length + 1 colorWithHex:[UIColor colorWithHex:0xff6b00] othercolorWithHex:css.color_4];
    } else {
        numberStatus = [NSString stringWithFormat:@"已有%@人购买",model.bespeak_num];
        self.numberStatusLabel.text = numberStatus;
    }
    
    self.courseTimeLabel.text = [NSString stringWithFormat:@"开课时间 : %@ ( %ld课时 )", [self getTimeString:[model.start_time integerValue]], [model.course_sub_num integerValue]];
    
    NSString *signUpStatus = @"";
    if (![model.remain_time integerValue]) {
        self.numberStatusLabel.text = @"";
        signUpStatus = @"已停售";
        self.signUpStatusLabel.textColor = [UIColor colorWithHex:0xff6b00];
        self.signUpStatusLabel.text = signUpStatus;
    } else {
        if (!lastNumb) {
            self.numberStatusLabel.text = @"";
            signUpStatus = @"已售磬";
            self.signUpStatusLabel.textColor = [UIColor colorWithHex:0xff6b00];
            self.signUpStatusLabel.text = signUpStatus;
        } else {
            signUpStatus = [NSString stringWithFormat:@"距离停售%@", [self leftTime:model.remain_time]];
            self.signUpStatusLabel.attributedText = [FZCommonTool getLengthWithString:signUpStatus withFont:10 local:4 length:[self leftTime:model.remain_time].length colorWithHex:[UIColor colorWithHex:0xff6b00] othercolorWithHex:css.color_4];
        }
    }
    CGFloat signUpStatusWidth = [FZCommonTool updateConstraintsOfView:self.signUpStatusLabel.text font:10].size.width;
    self.signUpStatusWidthCon.constant = signUpStatusWidth + 5;

}

- (NSString *)getTimeString:(int64_t)startTime {
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:startTime];
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSString *resultString = nil;
    NSDateComponents *startDateComponents = [currentCalendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitWeekday) fromDate:startDate];
    NSDateComponents *todayComments = [currentCalendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
    if (startDateComponents.year == todayComments.year && startDateComponents.month == todayComments.month && startDateComponents.day == todayComments.day) {
        resultString = @"今天";
    } else {
        resultString = [NSString stringWithFormat:@"%ld月%ld日", startDateComponents.month, startDateComponents.day];
    }
//    resultString = [NSString stringWithFormat:@"%@ %02ld:%02ld", resultString, startDateComponents.hour, startDateComponents.minute];
    return resultString;
}

- (NSString *)leftTime:(NSString *)remain_time {
    NSString *leftTimeTemp = @"";
    NSInteger left = [remain_time integerValue];
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
}

@end
