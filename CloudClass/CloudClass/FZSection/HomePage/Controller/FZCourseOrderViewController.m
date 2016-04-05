//
//  FZCourseOrderViewController.m
//  CloudClass
//
//  Created by guangfu yang on 16/3/10.
//  Copyright © 2016年 yangguangfu. All rights reserved.
//

#import "FZCourseOrderViewController.h"
#import "FZHomePageService.h"
#import "FZCourseInfoModel.h"
#import "FZCoursePayViewController.h"
#import "FZCoursePayFailViewController.h"

@interface FZCourseOrderViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *courseImage;
@property (weak, nonatomic) IBOutlet UILabel *courseTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *speakerLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalCourseLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (weak, nonatomic) IBOutlet UILabel *course_numLabel;

@property (nonatomic, strong) FZHomePageService *service;
@property (nonatomic, strong) FZCourseInfoModel *courseInfoModel;


@end

@implementation FZCourseOrderViewController

#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LOCALSTRING(@"order_page");
    [self initialization];
    [self setDataView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark --motherd
- (void)initialization {
    self.service = [[FZHomePageService alloc] init];
}

- (void)setUpView {
    FZStyleSheet *css = [[FZStyleSheet alloc] init];
    
    [self.courseImage sd_setImageWithURL:[NSURL URLWithString:[self.courseInfoModel.course_pic stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"common_img_index_poster"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    }];
    
    NSString *courseTitle = [NSString stringWithFormat:@"购买课程：%@",self.courseInfoModel.course_title];
    self.courseTitleLabel.attributedText = [FZCommonTool getLengthWithString:courseTitle withFont:12 local:5 length:self.courseInfoModel.course_title.length colorWithHex:css.color_4 othercolorWithHex:css.color_3];
    
    NSString *speaker = [NSString stringWithFormat:@"主讲老师：%@", self.courseInfoModel.nickname];
    self.speakerLabel.attributedText = [FZCommonTool getLengthWithString:speaker withFont:12 local:5 length:self.courseInfoModel.nickname.length colorWithHex:css.color_4 othercolorWithHex:css.color_3];
    
    NSString *totalCourse = [NSString stringWithFormat:@"课程课时：%@课时", self.courseInfoModel.course_sub_num];
    NSString *totalCourseStr = [NSString stringWithFormat:@"%@课时",self.courseInfoModel.course_sub_num];
    self.totalCourseLabel.attributedText = [FZCommonTool getLengthWithString:totalCourse withFont:12 local:5 length:totalCourseStr.length colorWithHex:css.color_4 othercolorWithHex:css.color_3];

    NSString *price = [NSString stringWithFormat:@"课程价格：￥%0.2f", [self.courseInfoModel.course_price floatValue]];
    NSString *priceStr = [NSString stringWithFormat:@"￥%0.2f", [self.courseInfoModel.course_price floatValue]];
    self.priceLabel.attributedText = [FZCommonTool getLengthWithString:price withFont:14 local:5 length:priceStr.length colorWithHex:css.funClassMainColor othercolorWithHex:css.color_3];
    
    self.course_numLabel.backgroundColor = css.funClassMainColor;
    self.course_numLabel.font = [UIFont systemFontOfSize:13];
    self.course_numLabel.textColor = css.colorOfLighterText;
    self.course_numLabel.textAlignment = NSTextAlignmentCenter;
    self.course_numLabel.text = [NSString stringWithFormat:@"%@人班", self.courseInfoModel.max_num];
    
    self.payBtn.layer.cornerRadius = 5;
    self.payBtn.layer.masksToBounds = YES;
    [self.payBtn setBackgroundColor:css.funClassMainColor];
    [self.payBtn setTitle:LOCALSTRING(@"order_pay") forState:UIControlStateNormal];
    [self.payBtn setTitleColor:css.colorOfLighterText forState:UIControlStateNormal];
}

- (void)setDataView {
    WEAKSELF
    [self startProgressHUD];
    [self.service getPubCourseInfo:self.course_id success:^(NSInteger statusCode, NSString *message, id dataObject) {
        [weakSelf stopProgressHUD];
        if (statusCode == kFZRequestStatusCodeSuccess) {
            STRONGSELFFor(weakSelf)
           strongSelf.courseInfoModel = dataObject;
            [strongSelf setUpView];
        } else {
            [weakSelf showHUDHintWithText:message];
        }
    } failure:^(id responseObject, NSError *error) {
        [weakSelf stopProgressHUD];
    }];
}

- (IBAction)onPay:(id)sender {
    [self alipay];
}

- (void)alipay {
    [self startProgressHUD];
    WEAKSELF
    NSString *amount = self.courseInfoModel.course_price;
    NSString *tid = self.order_id;
    NSString *pid = self.courseInfoModel.course_id;
    NSString *type = @"1";
    [self.service courseWithAmount:[amount floatValue] tid:tid pid:pid type:type success:^(NSInteger statusCode, NSString *message, id dataObject) {
        STRONGSELFFor(weakSelf)
        [strongSelf stopProgressHUD];
        if (!statusCode == kFZRequestStatusCodeSuccess) {
            [strongSelf showHUDErrorMessage:message];
        }
    } failure:^(id responseObject, NSError *error) {
        STRONGSELFFor(weakSelf)
        [strongSelf stopProgressHUD];
        [strongSelf showHUDErrorMessage:LOCALSTRING(@"ft_network_error")];
    } alipayCallback:^(FZAlipayResult result) {
        STRONGSELFFor(weakSelf)
        if (result == FZAlipayResultFail) {
            [strongSelf showHUDErrorMessage:LOCALSTRING(@"alipay_fail")];
            if (strongSelf.aliPayFailBlock) {
                strongSelf.aliPayFailBlock();
            }
            [strongSelf pushToAlipayFail];
        } else if (result == FZAlipayResultNetworkError) {
            [strongSelf showHUDErrorMessage:LOCALSTRING(@"alipay_network_error")];
            if (strongSelf.aliPayFailBlock) {
                strongSelf.aliPayFailBlock();
            }
            [strongSelf pushToAlipayFail];
        } else if (result == FZAlipayResultCancel) {
            [strongSelf showHUDErrorMessage:LOCALSTRING(@"alipay_cancel")];
            if (strongSelf.aliPayFailBlock) {
                strongSelf.aliPayFailBlock();
            }
            [strongSelf pushToAlipayFail];
        } else if (result == FZAlipayResultProcessing) {
            [strongSelf showHUDErrorMessage:LOCALSTRING(@"alipay_processing")];
        } else if (result == FZAlipayResultSuccess) {
            [strongSelf showHUDHintWithText:LOCALSTRING(@"alipay_success")];
            if (strongSelf.aliPaySuccessBlock) {
                strongSelf.aliPaySuccessBlock();
            }
            [strongSelf pushToAlipaySuccess];
        }
    } alipayNotInstallBlock:^{
        STRONGSELFFor(weakSelf)
        [strongSelf stopProgressHUD];
    }];
}

- (void)pushToAlipaySuccess {
    FZCoursePayViewController *paySuccess = [[FZCoursePayViewController alloc] init];
    paySuccess.courseInofoModel = self.courseInfoModel;
    paySuccess.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:paySuccess animated:YES];
}

- (void)pushToAlipayFail {
    FZCoursePayFailViewController *payFail = [[FZCoursePayFailViewController alloc] init];
    payFail.courseInfoModel = self.courseInfoModel;
    WEAKSELF
    payFail.repayBlock = ^() {
        STRONGSELFFor(weakSelf)
        [strongSelf alipay];
    };
    payFail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:payFail animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
