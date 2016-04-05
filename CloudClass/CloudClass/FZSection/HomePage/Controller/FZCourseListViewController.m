//
//  FZCourseListViewController.m
//  CloudClass
//
//  Created by guangfu yang on 16/3/14.
//  Copyright © 2016年 yangguangfu. All rights reserved.
//

#import "FZCourseListViewController.h"
#import "FZSearchQuery.h"
#import "FZCourseListCell.h"
#import "FZHomePageConstants.h"
#import "FZHomePageService.h"
#import "FZTypeCourseInfoModel.h"
#import "FZCourseMenu.h"
@interface FZCourseListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) FZSearchQuery *searchQuery;
@property (nonatomic, assign) BOOL isMore;
@property (nonatomic, strong) FZHomePageService *service;

@end

@implementation FZCourseListViewController

#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialization];
    [self getResult];
    [self refresh];
}

#pragma mark --motherd

- (void)initialization {
    FZStyleSheet *css = [[FZStyleSheet alloc] init];
    self.service = [[FZHomePageService alloc] init];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.rowHeight = 97.0f;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    self.tableView.separatorColor = css.colorLine;
    [self.tableView registerNib:[UINib nibWithNibName:@"FZCourseMenu" bundle:nil] forCellReuseIdentifier:kFCCourseListCellIndentifier];
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
    if (self.downScrollBlock) {
        self.downScrollBlock();
    }
    [self.tableView.footer resetNoMoreData];
    self.searchQuery.start = 0;
    self.isMore = YES;
    [self getResult];
    [self.tableView.header endRefreshing];
}

- (void)footerRereshing {
    if (self.upScrollBlock) {
        self.upScrollBlock();
    }
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
    [self.service getTypeCourseInfo:self.course_id tch_id:self.tch_id success:^(NSInteger statusCode, NSString *message, id dataObject) {
        [weakSelf stopProgressHUD];
        if (statusCode == kFZRequestStatusCodeSuccess) {
            NSArray *courseInfoArray = dataObject;
            if (self.searchQuery.start == 0) {
                [self.array removeAllObjects];
            }
            if (self.array.count > 0 && courseInfoArray.count > 0) {
                NSMutableArray *shouldDeleteArray = [NSMutableArray array];
                // 数据排重
                for (FZTypeCourseInfoModel *reloadModel in courseInfoArray) {
                    for (FZTypeCourseInfoModel *courseModel in self.array) {
                        if (reloadModel.course_sub_id == courseModel.course_sub_id) {
                            [shouldDeleteArray addObject:courseModel];
                        }
                    }
                }
                if (shouldDeleteArray.count > 0) {
                    [weakSelf.array removeObjectsInArray:shouldDeleteArray];
                }
            }
            
            [weakSelf.array addObjectsFromArray:courseInfoArray];
            [weakSelf.tableView reloadData];
            [self.tableView layoutIfNeeded];
            
            if (courseInfoArray.count < 10) {
                self.isMore = NO;
                [self.tableView.footer noticeNoMoreData];
            }
            
        } else {
            
        }
        
    } failure:^(id responseObject, NSError *error) {
        [weakSelf stopProgressHUD];
    }];
    
}


#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FZCourseMenu *cell = [tableView dequeueReusableCellWithIdentifier:kFCCourseListCellIndentifier];
    cell.courseInfoModel = self.array[indexPath.row];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
        [self showHUDHintWithText:LOCALSTRING(@"ft_network_error")];
        return;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
