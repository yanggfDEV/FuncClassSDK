//
//  FZCoursePayViewController.m
//  CloudClass
//
//  Created by guangfu yang on 16/3/9.
//  Copyright © 2016年 yangguangfu. All rights reserved.
//

#import "FZCoursePayViewController.h"
#import "FZCourseDetailsViewController.h"
#import "FZTeacherDetailsViewController.h"

@interface FZCoursePayViewController ()
@property (weak, nonatomic) IBOutlet UIView *statusView;
@property (weak, nonatomic) IBOutlet UIImageView *paymentImage;
@property (weak, nonatomic) IBOutlet UILabel *payStatusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *courseImage;
@property (weak, nonatomic) IBOutlet UILabel *courseTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *speakerLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalCourseLabel;
@property (weak, nonatomic) IBOutlet UIButton *gobackCourseBtn;

@end

@implementation FZCoursePayViewController

#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LOCALSTRING(@"order_success");
    [self setUpView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark --motherd
- (void)setUpView {
    FZStyleSheet *css = [[FZStyleSheet alloc] init];
    self.view.backgroundColor = css.colorOfBackground;
    
    [self.courseImage sd_setImageWithURL:[NSURL URLWithString:[self.courseInofoModel.course_pic stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"common_img_index_poster"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    }];
    
    NSString *courseTitle = [NSString stringWithFormat:@"购买课程：%@",self.courseInofoModel.course_title];
    self.courseTitleLabel.attributedText = [FZCommonTool getLengthWithString:courseTitle withFont:12 local:5 length:self.courseInofoModel.course_title.length colorWithHex:css.color_4 othercolorWithHex:css.color_3];
    
    NSString *speaker = [NSString stringWithFormat:@"主讲老师：%@", self.courseInofoModel.nickname];
    self.speakerLabel.attributedText = [FZCommonTool getLengthWithString:speaker withFont:12 local:5 length:self.courseInofoModel.nickname.length colorWithHex:css.color_4 othercolorWithHex:css.color_3];
    
    NSString *totalCourse = [NSString stringWithFormat:@"课程课时：%@课时", self.courseInofoModel.course_sub_num];
    NSString *totalCourseStr = [NSString stringWithFormat:@"%@课时",self.courseInofoModel.course_sub_num];
    self.totalCourseLabel.attributedText = [FZCommonTool getLengthWithString:totalCourse withFont:12 local:5 length:totalCourseStr.length colorWithHex:css.color_4 othercolorWithHex:css.color_3];
    
    self.gobackCourseBtn.layer.borderColor = css.funClassMainColor.CGColor;
    self.gobackCourseBtn.layer.borderWidth = 1;
    [self.gobackCourseBtn setTitle:LOCALSTRING(@"aliyay_success_goCourselist") forState:UIControlStateNormal];
    [self.gobackCourseBtn setTitleColor:css.funClassMainColor forState:UIControlStateNormal];
}

- (IBAction)onGobackCourse:(id)sender {
    NSArray *array = self.navigationController.viewControllers;
    for (FZCommonViewController *commonView in array) {
        if ([commonView isKindOfClass:[FZCourseDetailsViewController class]] ||
            [commonView isKindOfClass:[FZTeacherDetailsViewController class]]) {
            [self.navigationController popToViewController:commonView animated:YES];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
