//
//  FZTeacherDetailsCell.m
//  CloudClass
//
//  Created by guangfu yang on 16/1/27.
//  Copyright © 2016年 yangguangfu. All rights reserved.
//

#import "FZTeacherDetailsCell.h"

typedef NS_ENUM(NSUInteger, CourseType) {
    CourseTypeBefore = 0,
    CourseTypeInClass= 1,
    CourseTypeFinish = 2
};

typedef NS_ENUM(NSUInteger, SpeakType) {
    SpeakTypeNO = 0,
    SpeakTypeYES = 1,
};

typedef NS_ENUM(NSUInteger, CourseDetailsType) {
    CourseDetailsTypeDef = 0,
    CourseDetailsTypePub = 1,
    CourseDetailsTypeLong = 2,
};

@interface FZTeacherDetailsCell ()
@property (weak, nonatomic) IBOutlet UIImageView *classImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *introductionLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *personsNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *coursePriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *speakerLabel;
@property (weak, nonatomic) IBOutlet UIButton *statusButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *startTimeLabelContraintsOfWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *personsNumLabelConstraintsOfWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *coursePriceWidth;

@property (nonatomic, strong) NSString *leftTime;

@property (nonatomic, strong) FZTeacherDetailsModel *detailsModel;

@end

@implementation FZTeacherDetailsCell

- (void)awakeFromNib {
    FZStyleSheet *css = [[FZStyleSheet alloc] init];
    self.classImage.layer.cornerRadius = 5;
    self.classImage.layer.masksToBounds = YES;
    self.classImage.contentMode = UIViewContentModeScaleAspectFill;
    self.classImage.clipsToBounds = YES;
    
    self.titleLabel.textColor = css.colorOfListTitle;
    self.titleLabel.font = css.fontOfH4;
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    
    self.introductionLabel.numberOfLines = 2;
    self.introductionLabel.textColor = css.colorOfListSubtitle;
    self.introductionLabel.font = css.fontOfH6;
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    
    self.startTimeLabel.textColor = css.colorOfListSubtitle;
    self.startTimeLabel.font = css.fontOfH6;
    self.startTimeLabel.textAlignment = NSTextAlignmentLeft;
    
    self.personsNumLabel.textColor = css.colorOfListSubtitle;
    self.personsNumLabel.font = css.fontOfH6;
    self.personsNumLabel.textAlignment = NSTextAlignmentLeft;
    
    self.coursePriceLabel.textColor = css.funClassRedBtnColor;
    self.coursePriceLabel.font = css.fontOfH4;
    self.coursePriceLabel.textAlignment = NSTextAlignmentRight;
    
    self.speakerLabel.textColor = css.colorOfListSubtitle;
    self.speakerLabel.font = css.fontOfH6;
    self.speakerLabel.textAlignment = NSTextAlignmentLeft;
    
    self.statusButton.layer.cornerRadius = 2;
    self.statusButton.layer.masksToBounds = YES;
    self.statusButton.layer.borderWidth = 1;
    self.statusButton.titleLabel.font = css.fontOfH4;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setCellData:(FZTeacherDetailsModel *)model{
    self.detailsModel = model;
    NSInteger lastNumb = [model.max_num integerValue] - [model.bespeak_num integerValue];
    NSString *courseSpeak = [NSString stringWithFormat:@"%@", model.is_speak];
    NSString *courseStatue = [NSString stringWithFormat:@"%@", model.statue];
    NSInteger isSpeak = [courseSpeak integerValue];
    NSInteger statue = [courseStatue integerValue];
    NSInteger remainTime = [[NSString stringWithFormat:@"%@", model.remain_time] integerValue];
    NSString *title = @"";
    NSInteger payBtnBK = 0;//0为无色 1为绿色 2为黄色 3为灰色
    NSInteger payBtnTitleBK = 0;//0为无色 1为绿色 2为黄色 3为灰色
    if (isSpeak == SpeakTypeNO) {
        if (!remainTime) {
            title = @"已停售";
            payBtnBK = 0;
            payBtnTitleBK = 3;
        } else {
            if (!lastNumb) {
                title = @"已售磬";
                payBtnBK = 0;
                payBtnTitleBK = 3;
            } else {
                title = @"立即购买";
                payBtnBK = 1;
                payBtnTitleBK = 1;
            }
        }
    } else if (isSpeak == SpeakTypeYES) {
        if (statue == CourseTypeBefore) {
            title = @"等待上课";
            payBtnBK = 2;
            payBtnTitleBK = 2;
        } else if (statue == CourseTypeInClass) {
            title = @"进入课堂";
            payBtnBK = 1;
            payBtnTitleBK = 1;
        } else if (statue == CourseTypeFinish) {
            title = @"课堂结束";
            payBtnBK = 3;
            payBtnTitleBK = 3;
        }
    }
    if (payBtnBK == 0) {
        [self.statusButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -20)];
    } else {
        [self.statusButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    [self.statusButton setTitle:title forState:UIControlStateNormal];
    [self.statusButton setTitleColor:[self statusButton:payBtnTitleBK payBtnBK:NO] forState:UIControlStateNormal];
    self.statusButton.layer.borderColor = [self statusButton:payBtnBK payBtnBK:YES].CGColor;

    [self.classImage sd_setImageWithURL:[NSURL URLWithString:[model.course_pic stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"common_img_index_poster"] completed:nil];
    self.titleLabel.text = model.course_title;
    if (model.course_desc) {
        self.introductionLabel.text = [NSString stringWithFormat:@"课程简介 : %@", model.course_desc];
    }
    
    float price = [model.course_price floatValue];
    self.coursePriceLabel.text = [NSString stringWithFormat:@"￥%0.2f", price];
    self.personsNumLabel.text = [NSString stringWithFormat:@"班级人数 : %@人", model.max_num];
    self.speakerLabel.text = [NSString stringWithFormat:@"主讲老师 : %@", model.nickname];
    self.startTimeLabel.text = [NSString stringWithFormat:@"开课时间 : %@（ %@课 )", [self getTimeString:[model.start_time integerValue]], model.course_sub_num];
    CGFloat startTimeLabelOfWidth = [FZCommonTool updateConstraintsOfView:self.startTimeLabel.text font:10].size.width;
    CGFloat personsNameLabelOfWidth = [FZCommonTool updateConstraintsOfView:self.personsNumLabel.text font:10].size.width;
    CGFloat coursePriceLabelOfWidth = [FZCommonTool updateConstraintsOfView:self.coursePriceLabel.text font:12].size.width;
    self.startTimeLabelContraintsOfWidth.constant = startTimeLabelOfWidth+5;
    self.personsNumLabelConstraintsOfWidth.constant = personsNameLabelOfWidth+5;
    self.coursePriceWidth.constant = coursePriceLabelOfWidth+5;
    self.leftTime = [self leftTime:model.start_time];
}

- (UIColor *)statusButton:(NSInteger)index payBtnBK:(BOOL)payBtnBK {
    FZStyleSheet *css = [[FZStyleSheet alloc] init];
    if (!payBtnBK) {
        switch (index) {
            case 0:
                return [UIColor clearColor];
                break;
            case 1:
                return css.courseBtnOfSignUp;
                break;
            case 2:
                return css.courseBtnOfWait;
                break;
            case 3:
                return css.courseBtnOfTimeOver;
                break;
            default:
                return css.colorOfLighterText;
                break;
        }
    } else {
        switch (index) {
            case 0:
                return [UIColor clearColor];
                break;
            case 1:
                return css.courseBtnOfSignUp;
                break;
            case 2:
                return css.courseBtnOfWait;
                break;
            case 3:
                return css.courseBtnOfTimeOver;
                break;
            default:
                return css.courseBtnOfSignUp;
                break;
        }
    }
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
            leftTimeTemp = [leftTimeTemp stringByAppendingString:[NSString stringWithFormat:@"%ld天", (long)day]];
        }
        if (hour) {
            // 小时
            leftTimeTemp = [leftTimeTemp stringByAppendingString:[NSString stringWithFormat:@"%ld小时", (long)hour]];
        }
        if (minus) {
            //分钟
            leftTimeTemp = [leftTimeTemp stringByAppendingString:[NSString stringWithFormat:@"%ld分钟", (long)minus]];
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
    } else {
        resultString = [NSString stringWithFormat:@"%ld月%ld日", startDateComponents.month, startDateComponents.day];
    }
//    resultString = [NSString stringWithFormat:@"%@ %02ld:%02ld", resultString, startDateComponents.hour, startDateComponents.minute];
    return resultString;
}


#pragma mark --touch

- (IBAction)onCourseBespeak:(id)sender {
    if (![FZLoginUser mobile]) {
        if (self.isGuestTyeBlock) {
            self.isGuestTyeBlock();
        }
        return;
    }
    NSInteger lastNumb = [self.detailsModel.max_num integerValue] - [self.detailsModel.bespeak_num integerValue];
    NSString *courseSpeak = [NSString stringWithFormat:@"%@", self.detailsModel.is_speak];
    NSString *courseStatue = [NSString stringWithFormat:@"%@", self.detailsModel.statue];
    NSString *courseType = [NSString stringWithFormat:@"%@", self.detailsModel.course_type];
    NSInteger remainTime = [[NSString stringWithFormat:@"%@", self.detailsModel.remain_time] integerValue];
    NSInteger isSpeak = [courseSpeak integerValue];
    NSInteger statue = [courseStatue integerValue];
    NSInteger coursetype = [courseType integerValue];
    if (isSpeak == SpeakTypeNO) {
        if (!remainTime) {
            if (self.speakCourseFailureBlock) {
                self.speakCourseFailureBlock(LOCALSTRING(@"course_long_stopsall"));
            }
        } else {
            if (!lastNumb) {
                if (self.speakCourseFailureBlock) {
                    self.speakCourseFailureBlock(LOCALSTRING(@"course_long_nocourse"));
                }
            } else {
                if (coursetype == CourseDetailsTypePub) {
                    if (self.speakCourseBlock) {
                        self.speakCourseBlock(self);
                    }
                } else if (coursetype == CourseDetailsTypeLong) {
                    if (self.payCourseBlock) {
                        self.payCourseBlock(self);
                    }
                } else if (coursetype == CourseDetailsTypeDef) {
                    return;
                }
            }
        }
    } else if (isSpeak == SpeakTypeYES) {
        if (statue == CourseTypeBefore) {
            if (self.speakCourseFailureBlock) {
                self.speakCourseFailureBlock(self.leftTime);
            }
        } else if (statue == CourseTypeInClass) {
            if (self.startCourseBlock) {
                self.startCourseBlock(self);
            }
        } else if (statue == CourseTypeFinish) {
            if (self.speakCourseFailureBlock) {
                self.speakCourseFailureBlock(LOCALSTRING(@"speak_had_timeOver"));
            }
        }
    }
}

- (void)setStatusBtnTitle {
    FZStyleSheet *css = [[FZStyleSheet alloc] init];
    [self.statusButton setTitle:@"课程结束" forState:UIControlStateNormal];
    [self.statusButton setBackgroundColor:css.courseBtnOfTimeOver];
}

@end
