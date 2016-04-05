//
//  FZCourseDetailsViewController.m
//  CloudClass
//
//  Created by guangfu yang on 16/3/9.
//  Copyright © 2016年 yangguangfu. All rights reserved.
//

#import "FZCourseDetailsViewController.h"
#import <GRKPageViewController/GRKPageViewController.h>
#import "FZCourseIntroViewController.h"
#import "FZCourseListViewController.h"
#import "FZHomePageService.h"
#import "FZCourseInfoModel.h"
#import "FZCourseOrderViewController.h"
#import "AppDelegate.h"
#import "FZPersonCenterService.h"
#import "FZCourseMeetingModel.h"
#import "FZCheckRemainNumModel.h"

typedef NS_ENUM(NSUInteger, CourseType) {
    CourseTypeBefore = 0,
    CourseTypeInClass= 1,
    CourseTypeFinish = 2
};

typedef NS_ENUM(NSUInteger, SpeakType) {
    SpeakTypeNO = 0,
    SpeakTypeYES = 1,
};

@interface FZCourseDetailsViewController ()<GRKPageViewControllerDataSource, GRKPageViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIImageView *courseImage;
@property (weak, nonatomic) IBOutlet UILabel *courseMaxNumber;
@property (weak, nonatomic) IBOutlet UILabel *courseIntroduce;
@property (weak, nonatomic) IBOutlet UILabel *courseList;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *coursePrice;
@property (weak, nonatomic) IBOutlet UILabel *courseNum;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (strong, nonatomic) UIView *lineView;

@property (nonatomic, strong) GRKPageViewController *mainViewController;
@property (nonatomic, strong) FZCourseIntroViewController *courseIntroVC;
@property (nonatomic, strong) FZCourseListViewController *courseListVC;
@property (nonatomic, strong) NSArray *viewControllerArray;

@property (nonatomic, strong) FZHomePageService *service;
@property (nonatomic, strong) FZCourseInfoModel *model;
@property (nonatomic, strong) FZStyleSheet *css;

@end

@implementation FZCourseDetailsViewController

#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LOCALSTRING(@"course_detail");
    [self initialization];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getResult];
}

#pragma mark --motherd
- (void)initialization {
    self.service = [[FZHomePageService alloc] init];
    self.css = [[FZStyleSheet alloc] init];
    
    self.view.backgroundColor = self.css.colorOfBackground;
    
    self.courseMaxNumber.backgroundColor = self.css.funClassMainColor;
    
    self.courseIntroVC = [[FZCourseIntroViewController alloc] init];
    self.courseListVC = [[FZCourseListViewController alloc] init];
    
    self.coursePrice.textColor =self.css.funClassMainColor;
    self.coursePrice.font = [UIFont systemFontOfSize:18];
    
    self.courseNum.textColor = self.css.color_4;
    self.courseNum.font = [UIFont systemFontOfSize:12];

    self.payBtn.layer.cornerRadius = 3;
    [self.payBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    self.viewControllerArray = @[self.courseIntroVC, self.courseListVC];
    WEAKSELF
    self.courseListVC.upScrollBlock = ^() {
        STRONGSELFFor(weakSelf)
        [strongSelf upScroll];
    };
    self.courseListVC.downScrollBlock = ^() {
        STRONGSELFFor(weakSelf)
        [strongSelf downScroll];
    };
    self.courseIntroVC.upScrollBlock = ^() {
        STRONGSELFFor(weakSelf)
        [strongSelf upScroll];
    };
    self.courseIntroVC.downScrollBlock = ^() {
        STRONGSELFFor(weakSelf)
        [strongSelf downScroll];
    };
    
    self.mainViewController = [[GRKPageViewController alloc] init];
    self.mainViewController.dataSource = self;
    self.mainViewController.delegate = self;
    self.mainViewController.scrollEnabled = NO;
    [self.contentView addSubview:self.mainViewController.view];
    
    [self.mainViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(self.contentView);
    }];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = self.css.funClassMainColor;
    [self.menuView addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.menuView);
        make.centerX.equalTo(self.menuView.mas_centerX).offset(-[FZUtils GetScreeWidth] / 4.0);
        make.width.equalTo(@(64));
        make.height.equalTo(@(1));
    }];
    
    self.courseIntroduce.textColor = self.css.funClassMainColor;
    self.courseList.textColor = self.css.color_3;
}


- (void)getResult {
    [self startProgressHUD];
    WEAKSELF
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
        [weakSelf showHUDHintWithText:LOCALSTRING(@"ft_network_error")];
        [weakSelf stopProgressHUD];
        return;
    }
    [self.service getPubCourseInfo:self.course_id success:^(NSInteger statusCode, NSString *message, id dataObject) {
        [weakSelf stopProgressHUD];
        if (statusCode == kFZRequestStatusCodeSuccess) {
            STRONGSELFFor(weakSelf)
            strongSelf.model = dataObject;
            [weakSelf setUpView];
        } else {
            [weakSelf showHUDHintWithText:message];
        }
    } failure:^(id responseObject, NSError *error) {
        [weakSelf stopProgressHUD];
    }];
}

- (void)setUpView {
    /**
     *  传值给课程介绍页
     */
    [self.courseIntroVC setUpDataWithModel:self.model];
    
    self.courseListVC.course_id = self.model.course_id;
    self.courseListVC.tch_id = self.tch_id;
    [self.courseImage sd_setImageWithURL:[NSURL URLWithString:[self.model.course_pic stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"common_img_index_poster"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    }];
    
    self.coursePrice.text = [NSString stringWithFormat:@"￥%0.2f", [self.model.course_price floatValue]];
    NSInteger lastNumb = [self.model.max_num integerValue] - [self.model.bespeak_num integerValue];
    NSString *numberStatus = @"";
    if (lastNumb == 0) {
        numberStatus = [NSString stringWithFormat:@"已停售"];
    } else if (lastNumb <= 10) {
        NSString *lastNumbstr = [NSString stringWithFormat:@"%ld", lastNumb];
        numberStatus = [NSString stringWithFormat:@"仅剩余%ld个名额",lastNumb];
        self.courseNum.attributedText = [FZCommonTool getLengthWithString:numberStatus withFont:12 local:3 length:lastNumbstr.length + 1 colorWithHex:[UIColor colorWithHex:0xff6b00] othercolorWithHex:self.css.color_4];
    } else {
        numberStatus = [NSString stringWithFormat:@"已有%@人购买",self.model.bespeak_num];
        self.courseNum.text = numberStatus;
    }
    
    self.courseMaxNumber.text = [NSString stringWithFormat:@"%ld人班",(long)self.model.max_num.integerValue];
    
    BOOL isOverTime = [self onTimeOver:self.model.end_time];
    NSString *courseSpeak = [NSString stringWithFormat:@"%@", self.model.is_speak];
    NSString *courseStatue = [NSString stringWithFormat:@"%@", self.model.statue];
    NSInteger isSpeak = [courseSpeak integerValue];
    NSInteger statue = [courseStatue integerValue];
    NSString *title = @"";
    NSInteger payBtnBK = 0;//0为无色 1为绿色 2为黄色 3为灰色
    NSInteger payBtnTitleBK = 0;//0为灰色 1为白色
    if (isSpeak == SpeakTypeNO) {
        if (isOverTime) {
            title = @"已停售";
            payBtnBK = 0;
            payBtnTitleBK = 0;
        } else {
            if (!lastNumb) {
                title = @"已售磬";
                payBtnBK = 0;
                payBtnTitleBK = 0;
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
            payBtnTitleBK = 1;
        } else if (statue == CourseTypeInClass) {
            title = @"进入课堂";
            payBtnBK = 1;
            payBtnTitleBK = 1;
        } else if (statue == CourseTypeFinish) {
            title = @"课堂结束";
            payBtnBK = 3;
            payBtnTitleBK = 1;
        }
    }
    
    if (isSpeak == SpeakTypeYES ||
        (isSpeak == SpeakTypeNO && isOverTime) ||
        (isSpeak == SpeakTypeNO && !isOverTime && !lastNumb)) {
        self.courseNum.hidden = YES;
    } else {
        self.courseNum.hidden = NO;
    }
    if (payBtnBK == 0) {
        self.coursePrice.hidden = YES;
        [self.payBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 52, 0, 0)];
    }
    [self.payBtn setTitle:title forState:UIControlStateNormal];
    [self.payBtn setTitleColor:[self payBtnBK:payBtnTitleBK payBtnBK:NO] forState:UIControlStateNormal];
    [self.payBtn setBackgroundColor:[self payBtnBK:payBtnBK payBtnBK:YES]];
}

- (UIColor *)payBtnBK:(NSInteger)index payBtnBK:(BOOL)payBtnBK {
    if (!payBtnBK) {
        switch (index) {
            case 0:
                return self.css.color_4;
                break;
            case 1:
                return self.css.colorOfLighterText;
                break;
            default:
                return self.css.colorOfLighterText;
                break;
        }
    } else {
        switch (index) {
            case 0:
                return [UIColor clearColor];
                break;
            case 1:
                return self.css.courseBtnOfSignUp;
                break;
            case 2:
                return self.css.courseBtnOfWait;
                break;
            case 3:
                return self.css.courseBtnOfTimeOver;
                break;
            default:
                return self.css.courseBtnOfSignUp;
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


- (void)upScroll {
    [UIView animateWithDuration:1 animations:^{
        [self.headView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.top.equalTo(self.view);
            make.height.equalTo(@0);
        }];
    }];
}

- (void)downScroll {
    [UIView animateWithDuration:1 animations:^{
        [self.headView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.top.equalTo(self.view);
            make.height.equalTo(@191);
        }];
    }];
}

- (IBAction)onCourseIntroduce:(id)sender {
    [self viewChanged:0];
}

- (IBAction)onCourseList:(id)sender {
    [self viewChanged:1];
}

- (IBAction)onPay:(id)sender {
    if (![FZLoginUser mobile]) {
        [self pushLoginPage];
        return;
    }
    NSInteger lastNumb = [self.model.max_num integerValue] - [self.model.bespeak_num integerValue];
    BOOL isOverTime = [self onTimeOver:self.model.end_time];
    NSString *courseSpeak = [NSString stringWithFormat:@"%@", self.model.is_speak];
    NSString *courseStatue = [NSString stringWithFormat:@"%@", self.model.statue];
    NSInteger isSpeak = [courseSpeak integerValue];
    NSInteger statue = [courseStatue integerValue];
    if (isSpeak == SpeakTypeNO) {
        if (isOverTime) {
            [self showHUDHintWithText:LOCALSTRING(@"course_long_stopsall")];
        } else {
            if (!lastNumb) {
                [self showHUDHintWithText:LOCALSTRING(@"course_long_nocourse")];
            } else {
                [self pushToPay];
            }
        }
     } else if (isSpeak == SpeakTypeYES) {
        if (statue == CourseTypeBefore) {
            [self showHUDHintWithText:LOCALSTRING(@"course_long_wait")];
        } else if (statue == CourseTypeInClass) {
            [self joinCourse];
        } else if (statue == CourseTypeFinish) {
            [self showHUDHintWithText:LOCALSTRING(@"course_long_over")];
        }
    }
}

- (void)pushLoginPage {
    FZLoginViewController *loginVC = [[FZLoginViewController alloc] init];
    loginVC.loginSuccessBlock = ^() {
        AppDelegate *delegate = [UIApplication sharedApplication].delegate;
        [delegate get_JpushInfoToserver];
    };
    [self.navigationController pushViewController:loginVC animated:YES];
}

- (void)joinCourse {
    FZPersonCenterService *service = [[FZPersonCenterService alloc] init];
        WEAKSELF
     [self startProgressHUD];
     [service getConferenceNum:self.model.course_id success:^(NSInteger statusCode, NSString *message, id dataObject) {
        [weakSelf stopProgressHUD];
        if (statusCode == kFZRequestStatusCodeSuccess) {
            FZCourseMeetingModel *model = dataObject;
            //进入课堂
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"StudentIn"];
            [[FZJusMeettingSDKManager shareInstance] jusJoinMeeting:model.conference_number dispName:[FZLoginUser nickname] password:@""];
        } else {
            [weakSelf showHUDHintWithText:message];
        }
    } failure:^(id responseObject, NSError *error) {
        [weakSelf stopProgressHUD];
        [weakSelf showHUDHintWithText:LOCALSTRING(@"ft_netWork_error_notice")];
    }];
}

- (void)pushToPay {
    WEAKSELF
    [self startProgressHUD];
    NSString *course_id = self.model.course_id;
    [self.service checkremainnumWithCourseID:course_id success:^(NSInteger statusCode, NSString *message, id dataObject) {
        [weakSelf stopProgressHUD];
        if (statusCode == kFZRequestStatusCodeSuccess) {
            FZCheckRemainNumModel *remainNumModel = dataObject;
            if ([remainNumModel.remain_num integerValue]) {
                STRONGSELFFor(weakSelf)
                [strongSelf toPay:course_id orderID:remainNumModel.order_id];
            }
        } else {
            [weakSelf showHUDHintWithText:message];
        }
    } failure:^(id responseObject, NSError *error) {
        [weakSelf stopProgressHUD];
        [weakSelf showHUDHintWithText:LOCALSTRING(@"ft_netWork_error_notice")];
    }];
}

- (void)toPay:(NSString *)courseID orderID:(NSString *)orderID {
    FZCourseOrderViewController *orderVC = [[FZCourseOrderViewController alloc] init];
    orderVC.course_id = courseID;
    orderVC.order_id = orderID;
    WEAKSELF
    orderVC.aliPaySuccessBlock = ^() {
        [weakSelf showHUDHintWithText:LOCALSTRING(@"order_success")];
    };
    
    orderVC.aliPayFailBlock = ^() {
        [weakSelf showHUDHintWithText:LOCALSTRING(@"order_fail")];
    };
    orderVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:orderVC animated:YES];
}

#pragma mark - grkviewcontroller datasource
- (NSUInteger)pageCountForPageViewController:(GRKPageViewController *)controller {
    return self.viewControllerArray.count;
}

- (UIViewController *)viewControllerForIndex:(NSUInteger)index forPageViewController:(GRKPageViewController *)controller {
    UIViewController *vc = self.viewControllerArray[index];
    return vc;
}

#pragma mark - grkviewcontroller delegate
- (void)changedIndex:(NSUInteger)index forPageViewController:(GRKPageViewController *)controller {
}

#pragma mark --Event
- (void)viewChanged:(NSInteger)index {
    if (index == 0) {
        [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.menuView);
            make.centerX.equalTo(self.menuView.mas_centerX).offset(-[FZUtils GetScreeWidth] / 4.0);
            make.width.equalTo(@(64));
            make.height.equalTo(@(1));
        }];
        self.courseIntroduce.textColor = self.css.funClassMainColor;
        self.courseList.textColor = self.css.color_3;
    } else {
        [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.menuView);
            make.centerX.equalTo(self.menuView.mas_centerX).offset([FZUtils GetScreeWidth] / 4.0);
            make.width.equalTo(@(64));
            make.height.equalTo(@(1));
        }];
        self.courseIntroduce.textColor = self.css.color_3;
        self.courseList.textColor = self.css.funClassMainColor;
    }
         
    [self.mainViewController setCurrentIndex:index animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
