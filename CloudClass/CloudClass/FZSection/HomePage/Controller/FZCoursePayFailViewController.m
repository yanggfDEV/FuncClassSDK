//
//  FZCoursePayFailViewController.m
//  CloudClass
//
//  Created by guangfu yang on 16/3/15.
//  Copyright © 2016年 yangguangfu. All rights reserved.
//

#import "FZCoursePayFailViewController.h"
#import "FZCourseDetailsViewController.h"
#import "FZTeacherDetailsViewController.h"

@interface FZCoursePayFailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *courseTitle;
@property (weak, nonatomic) IBOutlet UILabel *speakerLabel;
@property (weak, nonatomic) IBOutlet UILabel *courseNumLabel;
@property (weak, nonatomic) IBOutlet UIImageView *courseImage;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *rePayBtn;
@property (nonatomic, strong) UIButton *goBackBtn;

@end

@implementation FZCoursePayFailViewController

#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LOCALSTRING(@"order_fail");
    [self setUpView];
}

#pragma mark --motherd
- (void)setUpView {
    FZStyleSheet *css = [[FZStyleSheet alloc] init];
    self.view.backgroundColor = css.colorOfBackground;
    
    [self.courseImage sd_setImageWithURL:[NSURL URLWithString:[self.courseInfoModel.course_pic stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"common_img_index_poster"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    }];
    
    NSString *courseTitle = [NSString stringWithFormat:@"购买课程：%@",self.courseInfoModel.course_title];
    self.courseTitle.attributedText = [FZCommonTool getLengthWithString:courseTitle withFont:12 local:5 length:self.courseInfoModel.course_title.length colorWithHex:css.color_4 othercolorWithHex:css.color_3];
    
    NSString *speaker = [NSString stringWithFormat:@"主讲老师：%@", self.courseInfoModel.nickname];
    self.speakerLabel.attributedText = [FZCommonTool getLengthWithString:speaker withFont:12 local:5 length:self.courseInfoModel.nickname.length colorWithHex:css.color_4 othercolorWithHex:css.color_3];
    
    NSString *totalCourse = [NSString stringWithFormat:@"课程课时：%@课时", self.courseInfoModel.course_sub_num];
    NSString *totalCourseStr = [NSString stringWithFormat:@"%@课时",self.courseInfoModel.course_sub_num];
    self.courseNumLabel.attributedText = [FZCommonTool getLengthWithString:totalCourse withFont:12 local:5 length:totalCourseStr.length colorWithHex:css.color_4 othercolorWithHex:css.color_3];
    
    self.cancelBtn.layer.borderColor = css.funClassMainColor.CGColor;
    self.cancelBtn.layer.borderWidth = 1;
    [self.cancelBtn setTitle:LOCALSTRING(@"aplipay_fail_cancel") forState:UIControlStateNormal];
    [self.cancelBtn setTitleColor:css.funClassMainColor forState:UIControlStateNormal];
    
    self.rePayBtn.layer.borderColor = css.funClassMainColor.CGColor;
    self.rePayBtn.layer.borderWidth = 1;
    [self.rePayBtn setTitle:LOCALSTRING(@"aplipay_fail_repay") forState:UIControlStateNormal];
    [self.rePayBtn setTitleColor:css.funClassMainColor forState:UIControlStateNormal];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"返回" forState:UIControlStateNormal];
    [button setTitleColor:css.colorOfLighterText forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"common_icon_leftarrow"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onGoBack) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 100, 44);
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
    button.titleLabel.font = css.fontOfH2;
    self.goBackBtn = button;
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:self.goBackBtn];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                   target:nil action:nil];
    negativeSpacer.width = -15;//这个数值可以根据情况自由变化
    self.navigationItem.leftBarButtonItems = @[negativeSpacer, leftBarItem];
}

- (void)onGoBack {
    [self alertViewCancelPay];
}

- (void)alertViewCancelPay {
    WEAKSELF
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil
                                                         message:LOCALSTRING(@"aplipay_fail_cancel")
                                                cancelButtonItem:[RIButtonItem itemWithLabel:@"确定" action:^(){ [weakSelf cancelPay];}]
                                                otherButtonItems:[RIButtonItem itemWithLabel:@"取消" action:^(){ return ;}], nil];
    
    [alertView show];
}

#pragma mark --touch--
- (IBAction)onCancel:(id)sender {
    [self alertViewCancelPay];
}

- (void)cancelPay {
    NSArray *array = self.navigationController.viewControllers;
    for (FZCommonViewController *commonView in array) {
        if ([commonView isKindOfClass:[FZCourseDetailsViewController class]] ||
            [commonView isKindOfClass:[FZTeacherDetailsViewController class]]) {
            [self.navigationController popToViewController:commonView animated:YES];
        }
    }
}

- (IBAction)onRePay:(id)sender {
    if (self.repayBlock) {
        self.repayBlock();
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
