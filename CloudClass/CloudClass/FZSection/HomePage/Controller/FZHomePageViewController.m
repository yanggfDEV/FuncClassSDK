//
//  FZHomePageViewController.m
//  CloudClass
//
//  Created by guangfu yang on 16/3/8.
//  Copyright © 2016年 yangguangfu. All rights reserved.
//

#import "FZHomePageViewController.h"
#import "FZHomePageService.h"
#import "FZHomePageCell.h"
#import "FZHomePageModel.h"
#import "FZHomePageConstants.h"
#import "FZSearchQuery.h"
#import "FZCourseDetailsViewController.h"
 
@interface FZHomePageViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) FZSearchQuery *searchQuery;
@property (nonatomic, strong) FZHomePageService *homePageService;
@property (nonatomic, assign) BOOL isMore;

@end

@implementation FZHomePageViewController

#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LOCALSTRING(@"homepage_title");
    [self initialization];
    [self getResult];
    [self refresh];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark --motherd
- (void)initialization {
    FZStyleSheet *css = [[FZStyleSheet alloc] init];
    self.homePageService = [[FZHomePageService alloc] init];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.rowHeight = 133.0f;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorColor = css.colorLine;
    [self.tableView registerNib:[UINib nibWithNibName:@"FZHomePageCell" bundle:nil] forCellReuseIdentifier:kFCHomePageCellIndentifier];
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
    [self startProgressHUD];
    WEAKSELF
    
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
        [weakSelf showHUDHintWithText:LOCALSTRING(@"ft_network_error")];
        [weakSelf stopProgressHUD];
        //暂时不要的代码
        //        FZStyleSheet *css = [[FZStyleSheet alloc] init];
        //        [self.loadingView emptyWithTitle:@"加载失败，点击按钮重新加载!" subTitle:nil image:[UIImage imageNamed:@"common_nocontent"] buttonHidden: NO];
        //        [self.loadingView.button addTarget:self action:@selector(getResultAgain) forControlEvents:UIControlEventTouchUpInside];
        //        [self.loadingView.button setTitle:@"点击加载" forState:UIControlStateNormal];
        //        [self.loadingView.button setTitleColor:css.color_1 forState:UIControlStateNormal];
        //        self.loadingView.button.layer.cornerRadius = 17;
        //        self.loadingView.button.layer.masksToBounds = YES;
        
        return;
    }
    [self.homePageService getPubCourseList:self.searchQuery course_type:@"2" success:^(NSInteger statusCode, NSString *message, id dataObject) {
        [weakSelf stopProgressHUD];
        if (statusCode == kFZRequestStatusCodeSuccess) {
            NSArray *courseListArray = dataObject;
            if (self.searchQuery.start == 0) {
                [self.array removeAllObjects];
            }
            if (self.array.count > 0 && courseListArray.count > 0) {
                NSMutableArray *shouldDeleteArray = [NSMutableArray array];
                // 数据排重
                for (FZHomePageModel *reloadModel in courseListArray) {
                    for (FZHomePageModel *courseListModel in self.array) {
                        if (reloadModel.course_id == courseListModel.course_id) {
                            [shouldDeleteArray addObject:courseListModel];
                        }
                    }
                }
                if (shouldDeleteArray.count > 0) {
                    [weakSelf.array removeObjectsInArray:shouldDeleteArray];
                }
            }
            
            [weakSelf.array addObjectsFromArray:courseListArray];
            [weakSelf.tableView reloadData];
            [self.tableView layoutIfNeeded];
            
            if (courseListArray.count < 10) {
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

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FZHomePageCell *cell = [tableView dequeueReusableCellWithIdentifier:kFCHomePageCellIndentifier];
    FZHomePageModel *model = [self.array objectAtIndex:indexPath.row];
    [cell setCellData: model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
        [self showHUDHintWithText:LOCALSTRING(@"ft_network_error")];
        return;
    }
    FZHomePageModel *model = [self.array objectAtIndex:indexPath.row];
    FZCourseDetailsViewController *courseDetailsVC = [[FZCourseDetailsViewController alloc] init];
    courseDetailsVC.course_id = model.course_id;
    courseDetailsVC.tch_id = model.tch_id;
    [self.navigationController pushViewController:courseDetailsVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
