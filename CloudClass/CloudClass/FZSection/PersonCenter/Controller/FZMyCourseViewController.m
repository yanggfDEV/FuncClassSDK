//
//  FZMyCourseViewController.m
//  CloudClass
//
//  Created by guangfu yang on 16/1/29.
//  Copyright © 2016年 yangguangfu. All rights reserved.
//

#import "FZMyCourseViewController.h"
#import "FZSearchQuery.h"
#import "FZMyCourseCell.h"
#import "FZPersonCenterConstants.h"
#import "FZMyCourseModel.h"
#import "FZPersonCenterService.h"
#import "FZJusMeettingSDKManager.h"
#import "FZCourseMeetingModel.h"
#import "FZCourseDetailsViewController.h"

@interface FZMyCourseViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) FZPersonCenterService *service;
@property (nonatomic, assign) BOOL isMore;
@property (nonatomic, strong) FZSearchQuery *searchQuery;
@property (nonatomic, strong) FZJusMeettingSDKManager *meettingManager;
@end

@implementation FZMyCourseViewController

#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LOCALSTRING(@"mycourse_title");
    [self setInitView];
    [self getResult];
    [self refresh];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark -- initialization
- (void)setInitView {
    self.meettingManager = [FZJusMeettingSDKManager shareInstance];
    self.service = [[FZPersonCenterService alloc] init];
    FZStyleSheet *css = [[FZStyleSheet alloc] init];
    
    self.tableView.backgroundColor = css.colorOfBackground;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.rowHeight = 133.0f;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"FZMyCourseCell" bundle:nil] forCellReuseIdentifier:kFCMyCourseListCellIndentifier];
    self.isMore = YES;
    self.searchQuery = [[FZSearchQuery alloc] init];
    self.searchQuery.rows = 10;
    self.searchQuery.start = 0;
    
    self.array = [[NSMutableArray alloc] init];
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
    WEAKSELF
    [self startProgressHUD];
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
        [weakSelf stopProgressHUD];
        [weakSelf showHUDHintWithText:LOCALSTRING(@"ft_network_error")];
        //暂时不要的代码
//                FZStyleSheet *css = [[FZStyleSheet alloc] init];
//                [self.loadingView emptyWithTitle:@"加载失败，点击按钮重新加载!" subTitle:nil image:[UIImage imageNamed:@"common_nocontent"] buttonHidden: NO];
//                [self.loadingView.button addTarget:self action:@selector(getResultAgain) forControlEvents:UIControlEventTouchUpInside];
//                [self.loadingView.button setTitle:@"点击加载" forState:UIControlStateNormal];
//                [self.loadingView.button setTitleColor:css.color_1 forState:UIControlStateNormal];
//                self.loadingView.button.layer.cornerRadius = 17;
//                self.loadingView.button.layer.masksToBounds = YES;
        
        return;
    }
    
    [self.service getCourseBespeakList:self.searchQuery success:^(NSInteger statusCode, NSString *message, id dataObject) {
        [weakSelf stopProgressHUD];
        if (statusCode == kFZRequestStatusCodeSuccess) {
            NSArray *rangeClassTeachersArray = dataObject;
            if (self.searchQuery.start == 0) {
                [self.array removeAllObjects];
                if (rangeClassTeachersArray.count == 0) {
                    [weakSelf.loadingView emptyWithTitle:LOCALSTRING(@"course_list_empty") subTitle:nil image:[UIImage imageNamed:@"i_myclass_img_notice"]];
                }
            }
            if (self.array.count > 0 && rangeClassTeachersArray.count > 0) {
                NSMutableArray *shouldDeleteArray = [NSMutableArray array];
                // 数据排重
                for (FZMyCourseModel *reloadModel in rangeClassTeachersArray) {
                    for (FZMyCourseModel *myCourseModel in self.array) {
                        if (reloadModel.course_id == myCourseModel.course_id) {
                            [shouldDeleteArray addObject:myCourseModel];
                        }
                    }
                }
                if (shouldDeleteArray.count > 0) {
                    [weakSelf.array removeObjectsInArray:shouldDeleteArray];
                }
            }
            
            [weakSelf.array addObjectsFromArray:rangeClassTeachersArray];
            [weakSelf.tableView reloadData];
            [self.tableView layoutIfNeeded];
            
            if (rangeClassTeachersArray.count < 10) {
                self.isMore = NO;
                [self.tableView.footer noticeNoMoreData];
            }
        } else {
            [weakSelf showHUDHintWithText:message];
        }
    } failure:^(id responseObject, NSError *error) {
        [weakSelf stopProgressHUD];
        [weakSelf showHUDHintWithText:LOCALSTRING(@"ft_netWork_error_notice")];
    }];
}

- (void)pushLoginPage {
    FZLoginViewController *loginView = [[FZLoginViewController alloc] init];
    loginView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:loginView animated:YES];
}

- (void)onStartCourse:(FZMyCourseModel *)model index:(NSInteger)row {
    WEAKSELF
    [self startProgressHUD];
    [self.service getConferenceNum:model.course_id success:^(NSInteger statusCode, NSString *message, id dataObject) {
        [weakSelf stopProgressHUD];
        if (statusCode == kFZRequestStatusCodeSuccess) {
            FZCourseMeetingModel *model = dataObject;
            //进入课堂
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"StudentIn"];
            [MtcMeetingManager queryMeeting:model.conference_number displayName:[FZLoginUser nickname] password:@""];
//            [weakSelf.meettingManager jusJoinMeeting:model.conference_number dispName:[FZLoginUser nickname] password:@""];
        } else {
            [weakSelf showHUDHintWithText:message];
            [weakSelf uploadedCell:row];
        }
    } failure:^(id responseObject, NSError *error) {
        [weakSelf stopProgressHUD];
        [weakSelf showHUDHintWithText:LOCALSTRING(@"ft_netWork_error_notice")];
    }];
}

- (void)uploadedCell:(NSInteger)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    FZMyCourseCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
//    [cell setStatusBtnTitle];
}


#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FZMyCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:kFCMyCourseListCellIndentifier];
    FZMyCourseModel *myCourseModel = [self.array objectAtIndex:indexPath.row];
    [cell setCellData: myCourseModel];
    
    WEAKSELF
    cell.isGuestTyeBlock = ^() {
        [weakSelf pushLoginPage];
    };
    
    cell.startCourseBlock = ^(FZMyCourseCell *cell) {
        NSIndexPath *index = [tableView indexPathForCell:cell];
        FZMyCourseModel *model = [self.array objectAtIndex:index.row];
        [weakSelf onStartCourse:model index:index.row];
    };
    
    cell.startCourseFailureBlock = ^(NSString *message) {
        [weakSelf showHUDHintWithText:message];
    };

    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
        [self showHUDHintWithText:LOCALSTRING(@"ft_network_error")];
        return;
    }
    FZMyCourseModel *model = [self.array objectAtIndex:indexPath.row];
    FZCourseDetailsViewController *courseDetailsVC = [[FZCourseDetailsViewController alloc] init];
    courseDetailsVC.course_id = model.course_id;
    courseDetailsVC.tch_id = model.tch_id;
    [self.navigationController pushViewController:courseDetailsVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
