//
//  FZArrangeClassViewController.m
//  CloudClass
//
//  Created by guangfu yang on 16/1/27.
//  Copyright © 2016年 yangguangfu. All rights reserved.
//

#import "FZArrangeClassViewController.h"
#import "FZArrangeClassService.h"
#import "FZSearchQuery.h"
#import "FZArrangeClassCell.h"
#import "FZArrangeClassConstants.h"
#import "FZArrangeClassTeacherModel.h"
#import "FZTeacherDetailsViewController.h"

@interface FZArrangeClassViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) FZSearchQuery *searchQuery;
@property (nonatomic, strong) FZArrangeClassService *arrangeClassService;
@property (nonatomic, assign) BOOL isMore;

@end

@implementation FZArrangeClassViewController

#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LOCALSTRING(@"arrange_class_page");
    [self initialization];
    [self getResult];
    [self refresh];
}

#pragma mark --motherd
- (void)initialization {
    FZStyleSheet *css = [[FZStyleSheet alloc] init];
    self.touchedZoneFrame = self.view.bounds;
    
    self.arrangeClassService = [[FZArrangeClassService alloc] init];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.rowHeight = 113.0f;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    self.tableView.separatorColor = css.colorLine;
    [self.tableView registerNib:[UINib nibWithNibName:@"FZArrangeClassCell" bundle:nil] forCellReuseIdentifier:kFCArrangeClassCellIndentifier];
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
    
    [self.arrangeClassService getResultArrangeClassLists:self.searchQuery success:^(NSInteger statusCode, NSString *message, id dataObject) {
        [weakSelf stopProgressHUD];
        if (statusCode == kFZRequestStatusCodeSuccess) {
            NSArray *rangeClassTeachersArray = dataObject;
            if (self.searchQuery.start == 0) {
                [self.array removeAllObjects];
            }
            if (self.array.count > 0 && rangeClassTeachersArray.count > 0) {
                NSMutableArray *shouldDeleteArray = [NSMutableArray array];
                // 数据排重
//                for (FZArrangeClassTeacherModel *reloadModel in rangeClassTeachersArray) {
//                    for (FZArrangeClassTeacherModel *teacherModel in self.array) {
//                        if (reloadModel.teacherID == teacherModel.teacherID) {
//                            [shouldDeleteArray addObject:teacherModel];
//                        }
//                    }
//                }
                if (shouldDeleteArray.count > 0) {
                    [weakSelf.array removeObjectsInArray:shouldDeleteArray];
                }
            }
            
            [weakSelf.array addObjectsFromArray:rangeClassTeachersArray];
            [weakSelf.tableView reloadData];
            [self.tableView layoutIfNeeded];
            
            if (rangeClassTeachersArray.count < 1) {
                self.isMore = NO;
                [self.tableView.footer noticeNoMoreData];
            }

        } else if (statusCode == kFZRequestStatusCodeError) {
            
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
    FZArrangeClassCell *cell = [tableView dequeueReusableCellWithIdentifier:kFCArrangeClassCellIndentifier];
    FZArrangeClassTeacherModel *teacherModel = [self.array objectAtIndex:indexPath.row];
    [cell setCellData: teacherModel];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
        [self showHUDHintWithText:LOCALSTRING(@"ft_network_error")];
        return;
    }
    FZArrangeClassTeacherModel *model = [self.array objectAtIndex:indexPath.row];
    FZTeacherDetailsViewController *teacherDetailsVC = [[FZTeacherDetailsViewController alloc] init];
    teacherDetailsVC.model = model;
    teacherDetailsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:teacherDetailsVC animated:YES];
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
