//
//  FZTeacherDetailsViewController.m
//  CloudClass
//
//  Created by guangfu yang on 16/1/27.
//  Copyright © 2016年 yangguangfu. All rights reserved.
//

#import "FZTeacherDetailsViewController.h"
#import "FZArrangeClassService.h"
#import "FZSearchQuery.h"
#import "FZArrangeClassConstants.h"
#import "FZTeacherDetailsCell.h"
#import "FZLoginViewController.h"
#import "FZPersonCenterService.h"
#import "FZCourseMeetingModel.h"
#import "FZCheckRemainNumModel.h"
#import "FZHomePageService.h"
#import "FZCourseOrderViewController.h"
#import "FZCourseDetailsViewController.h"

#import "MtcMeetingDelegate.h"
#import "MeetingManager.h"
@interface FZTeacherDetailsViewController ()<UITableViewDataSource,UITableViewDelegate,MeetingDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) FZArrangeClassService *teacherDetailsService;
@property (nonatomic, strong) FZHomePageService *homePageService;
@property (nonatomic, strong) FZSearchQuery *searchQuery;
@property (nonatomic, assign) BOOL isMore;
@property (nonatomic, strong) FZJusMeettingSDKManager *meettingManager;

@end

@implementation FZTeacherDetailsViewController

#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LOCALSTRING(@"techer_details");
    [self initialization];
    [self getResult];
    [self refresh];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MeetingManager sharedManager].delegate = self;
    [[MeetingManager sharedManager] registerNotification];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(justTalkLogOut) name:@MtcLogoutedNotification object:nil];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[MeetingManager sharedManager] unregisterNotification];
}
#pragma mark --motherd
- (void)initialization {
    self.meettingManager = [FZJusMeettingSDKManager shareInstance];
    FZStyleSheet *css = [[FZStyleSheet alloc] init];
    self.view.backgroundColor = css.colorOfBackground;
    self.teacherDetailsService = [[FZArrangeClassService alloc] init];
    self.homePageService = [[FZHomePageService alloc] init];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.rowHeight = 123.0f;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    self.tableView.separatorColor = css.colorLine;
    [self.tableView registerNib:[UINib nibWithNibName:@"FZTeacherDetailsCell" bundle:nil] forCellReuseIdentifier:kFCTeacherDetailCellIndentifier];
    self.isMore = YES;
    self.searchQuery = [[FZSearchQuery alloc] init];
    self.searchQuery.rows = 10;
    self.searchQuery.start = 0;
    
    self.array = [[NSMutableArray alloc] init];
    
    self.headImage.layer.cornerRadius = 44.5f;
    self.headImage.layer.masksToBounds = YES;
    self.headImage.contentMode = UIViewContentModeScaleAspectFill;
    self.headImage.clipsToBounds = YES;
    if (self.model.avatar) {
        [self.headImage sd_setImageWithURL:[NSURL URLWithString:[self.model.avatar stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"teacher_img_head-1"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        }];
    } else {
        self.headImage.image = [UIImage imageNamed:@"teacher_img_head-1"];	 
    }
    
    if (self.model.nickName) {
        self.nameLabel.text = self.model.nickName;
        self.nameLabel.textColor = css.color_3;
        self.nameLabel.font = css.fontOfH7;
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
    }
}

#pragma mark -刷新
- (void)refresh {
    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    [self.tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
}

- (void)headerRereshing {
    [self.tableView.footer resetNoMoreData];
    self.searchQuery.start = 0;
    self.isMore = YES;
    [self getResult];
    [self.tableView.header endRefreshing];
}

- (void)footerRereshing {
    [self.tableView.footer resetNoMoreData];
    if (self.isMore) {
        self.searchQuery.start = self.searchQuery.start + 10;
    }
    [self getResult];
    [self.tableView.footer endRefreshing];
}


- (void)getResult {
    [self startProgressHUD];
    WEAKSELF
    
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
        [self showHUDHintWithText:LOCALSTRING(@"ft_network_error")];
        return;
    }
    
    [self.teacherDetailsService getResultCourseLists:self.searchQuery tch_id:self.model.teacherID success:^(NSInteger statusCode, NSString *message, id dataObject) {
        [weakSelf stopProgressHUD];
        if (statusCode == kFZRequestStatusCodeSuccess) {
            NSArray *courseListsArray = dataObject;
            if (self.searchQuery.start == 0) {
                [self.array removeAllObjects];
            }
            if (self.array.count > 0 && courseListsArray.count > 0) {
                NSMutableArray *shouldDeleteArray = [NSMutableArray array];
                // 数据排重
                for (FZTeacherDetailsModel *reloadModel in courseListsArray) {
                    for (FZTeacherDetailsModel *courseModel in self.array) {
                        if (reloadModel.course_id == courseModel.course_id) {
                            [shouldDeleteArray addObject:courseModel];
                        }
                    }
                }
                if (shouldDeleteArray.count > 0) {
                    [weakSelf.array removeObjectsInArray:shouldDeleteArray];
                }
            }
            
            [weakSelf.array addObjectsFromArray:courseListsArray];
            
            [weakSelf.tableView reloadData];
            [self.tableView layoutIfNeeded];
            
            if (courseListsArray.count < 10) {
                self.isMore = NO;
                [self.tableView.footer noticeNoMoreData];
            }
            
        } else {
            [weakSelf showHUDHintWithText:message];
        }

    } failure:^(id responseObject, NSError *error) {
         [weakSelf stopProgressHUD];
    }];
}

- (void)pushLoginPage {
    FZLoginViewController *loginView = [[FZLoginViewController alloc] init];
    loginView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:loginView animated:YES];
}

- (void)uploadCell:(NSInteger)index {
    FZTeacherDetailsModel *model = [self.array objectAtIndex:index];
    model.is_speak = @"1";
    model.bespeak_num = [NSString stringWithFormat: @"%ld", [model.bespeak_num integerValue] + 1];
    [self.array replaceObjectAtIndex:index withObject:model];
    [self.tableView reloadData];
    
}

- (void)uploadedCell:(NSInteger)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    FZTeacherDetailsCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
}

- (void)onStartCourse:(FZTeacherDetailsModel *)model index:(NSInteger)row {
    WEAKSELF
    if (![[FZJusMeettingSDKManager shareInstance] getHasLoginJustalk]) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil
                                                             message:LOCALSTRING(@"justale_login_fail")
                                                    cancelButtonItem:[RIButtonItem itemWithLabel:@"取消" action:^(){ return ;}]
                                                    otherButtonItems:[RIButtonItem itemWithLabel:@"确定" action:^(){
            [[FZJusMeettingSDKManager shareInstance] jusMeettingSDKLogin:[FZLoginUser userID] passWD:[FZLoginUser passWD] development:NO];}], nil];
        
        [alertView show];
    } else {
        [self startProgressHUD];
        FZPersonCenterService *service = [[FZPersonCenterService alloc] init];
        [service getConferenceNum:model.course_id success:^(NSInteger statusCode, NSString *message, id dataObject) {
            [weakSelf stopProgressHUD];
            if (statusCode == kFZRequestStatusCodeSuccess) {
                FZCourseMeetingModel *model = dataObject;
                //进入课堂
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"StudentIn"];
                NSString *conference_number = [NSString stringWithFormat:@"%@", model.conference_number];
                
                if (conference_number.integerValue == 0) {
                    [MBProgressHUD showError:@"老师已经离开课堂"];
                } else {
                    [[MeetingManager sharedManager] queryMeeting:conference_number password:@"" displayName:[FZLoginUser nickname] retryCount:0];
                }
                
            } else {
                [weakSelf showHUDHintWithText:message];
                [weakSelf uploadedCell:row];
            }
        } failure:^(id responseObject, NSError *error) {
            [weakSelf stopProgressHUD];
            [weakSelf showHUDHintWithText:LOCALSTRING(@"ft_netWork_error_notice")];
        }];
    }
}


- (void)onSpeakCourse:(FZTeacherDetailsModel *)model index:(NSInteger)index{
    WEAKSELF
    [self startProgressHUD];
    NSString *course_id = model.course_id;
    [self.teacherDetailsService getCourseBespeak:course_id success:^(NSInteger statusCode, NSString *message, id dataObject) {
        [weakSelf stopProgressHUD];
        if (statusCode == kFZRequestStatusCodeSuccess) {
            [weakSelf showHUDHintWithText:LOCALSTRING(@"speak_success")];
            [weakSelf uploadCell:index];
        } else {
            [weakSelf showHUDHintWithText:message];
        }
    } failure:^(id responseObject, NSError *error) {
        [weakSelf stopProgressHUD];
        [weakSelf showHUDHintWithText:LOCALSTRING(@"ft_netWork_error_notice")];
    }];
}

- (void)onCheckremainnum:(FZTeacherDetailsModel *)model index:(NSInteger)index {
    WEAKSELF
    [self startProgressHUD];
    NSString *course_id = model.course_id;
    [self.homePageService checkremainnumWithCourseID:course_id success:^(NSInteger statusCode, NSString *message, id dataObject) {
        [weakSelf stopProgressHUD];
        if (statusCode == kFZRequestStatusCodeSuccess) {
            FZCheckRemainNumModel *remainNumModel = dataObject;
            if ([remainNumModel.remain_num integerValue]) {
                STRONGSELFFor(weakSelf)
                [strongSelf alipay:course_id orderID:remainNumModel.order_id index:index];
            }
        } else {
            [weakSelf showHUDHintWithText:message];
        }
    } failure:^(id responseObject, NSError *error) {
        [weakSelf stopProgressHUD];
        [weakSelf showHUDHintWithText:LOCALSTRING(@"speak_fail")];
    }];
}

- (void)alipay:(NSString *)courseID orderID:(NSString *)orderID index:(NSInteger)index {
    FZCourseOrderViewController *orderVC = [[FZCourseOrderViewController alloc] init];
    orderVC.course_id = courseID;
    orderVC.order_id = orderID;
    
    WEAKSELF
    orderVC.aliPaySuccessBlock = ^() {
        [weakSelf uploadCell:index];
        [weakSelf showHUDHintWithText:LOCALSTRING(@"order_success")];
    };
    
    orderVC.aliPayFailBlock = ^() {
        [weakSelf showHUDHintWithText:LOCALSTRING(@"order_fail")];
    };
    
    orderVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:orderVC animated:YES];
}

/**
 * @guangfu yang 16-3-28 14:21
 * 报名0  购买1  进入2
 */
- (void)payOrStartOrSpeak:(FZTeacherDetailsCell *)cell indexModth:(NSInteger)indexModth {
    NSIndexPath *index = [self.tableView indexPathForCell:cell];
    FZTeacherDetailsModel *model = [self.array objectAtIndex:index.row];
    switch (indexModth) {
        case 0:
            [self onSpeakCourse:model index:index.row];
            break;
        case 1:
            [self onCheckremainnum:model index:index.row];
            break;
        case 2:
            [self onStartCourse:model index:index.row];
            break;
        default:
            break;
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FZTeacherDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:kFCTeacherDetailCellIndentifier];
    FZTeacherDetailsModel *courseModel = [self.array objectAtIndex:indexPath.row];
    [cell setCellData: courseModel];
    
    WEAKSELF
    cell.isGuestTyeBlock = ^() {
        [weakSelf pushLoginPage];
    };
    
    cell.isOverMaxNumBlock = ^() {
        [weakSelf showHUDHintWithText:LOCALSTRING(@"speak_timeover")];
    };
    
    cell.speakCourseBlock = ^(FZTeacherDetailsCell *cell) {
        STRONGSELFFor(weakSelf)
        [strongSelf payOrStartOrSpeak:cell indexModth:0];
    };
    
    cell.payCourseBlock = ^(FZTeacherDetailsCell *cell) {
        STRONGSELFFor(weakSelf)
        [strongSelf payOrStartOrSpeak:cell indexModth:1];
    };
    
	cell.speakCourseFailureBlock = ^(NSString * message) {
        [weakSelf showHUDHintWithText:message];
    };
    
    cell.startCourseBlock = ^(FZTeacherDetailsCell *cell) {
        STRONGSELFFor(weakSelf)
        [strongSelf payOrStartOrSpeak:cell indexModth:2];
    };
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
        [self showHUDHintWithText:LOCALSTRING(@"ft_network_error")];
        return;
    }
    FZTeacherDetailsModel *model = [self.array objectAtIndex:indexPath.row];
    FZCourseDetailsViewController *courseDetailsVC = [[FZCourseDetailsViewController alloc] init];
    courseDetailsVC.course_id = model.course_id;
    courseDetailsVC.tch_id = model.tch_id;
    [self.navigationController pushViewController:courseDetailsVC animated:YES];
}

-(void)justTalkLogOut
{
   // [MBProgressHUD showMessage:@"已经退出justalk"];
}

#pragma mark - MeetingDelegate Callback
- (void)meetingQueryOk {
    // [MBProgressHUD showSuccess:@"加入教室....."];
    
}

- (void)meetingQueryFail {
    if ([FZLoginManager sharedManager].hasLogin) {
        [MBProgressHUD showError:@"教室不存在，请稍等片刻..."];
    }
}

- (void)meetingJoinFail:(int)reason {
    if (reason == EN_MTC_CONF_REASON_INVALID_PASSWORD) {
        [MBProgressHUD showError:@"教室已经消失,请重新进入"];
    }
}

- (void)cliLoginFail:(int)reason {
    if (reason == MTC_CLI_REG_ERR_NETWORK) {
        [MBProgressHUD showError:@"网络不好,请稍等片刻...."];
    }
}

- (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)buttonTitle {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 9.0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:buttonTitle otherButtonTitles:nil];
        [alert show];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:buttonTitle style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:NO completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end




