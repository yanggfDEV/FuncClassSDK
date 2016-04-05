//
//  FZSettingViewController.m
//  CloudClass
//
//  Created by guangfu yang on 16/3/14.
//  Copyright © 2016年 yangguangfu. All rights reserved.
//

#import "FZSettingViewController.h"
#import "FZUserCenterSectionModel.h"
#import "FZUserCenterModel.h"
#import "AppDelegate.h"
#import "FZSettingPassViewController.h"
#import "FZAssessmentViewController.h"
#import "FZContactUsViewController.h"
#import "FZAboutUsViewController.h"

@interface FZSettingViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) UIButton *quitBtn;

@end

@implementation FZSettingViewController
#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LOCALSTRING(@"setting_page");
    [self initialization];
    [self getUserInfo];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - initialization
- (void)initialization {
    FZStyleSheet *css = [[FZStyleSheet alloc] init];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.rowHeight = 44.0f;
    self.tableView.backgroundColor = css.colorOfBackground;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    self.tableView.separatorColor = css.colorLine;
    self.view.backgroundColor = css.colorOfBackground;
    
    self.quitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.quitBtn];
    [self.quitBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    self.quitBtn.backgroundColor = css.funClassMainColor;
    self.quitBtn.layer.cornerRadius = 5;
    self.quitBtn.layer.masksToBounds = YES;
    [self.quitBtn addTarget:self action:@selector(onQuitBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.quitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(4*44 + 34 + 20);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.equalTo(@45);
        make.width.equalTo(@149);
    }];
}

- (void)getUserInfo {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"cloudClass_setting" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSArray *sectionJSONArray = jsonDictionary[@"config_data"];
    NSArray *modelArray = [MTLJSONAdapter modelsOfClass:[FZUserCenterSectionModel class] fromJSONArray:sectionJSONArray error:nil];
    self.array = [modelArray mutableCopy];
    [self.tableView reloadData];
}

- (void)onQuitBtn {
    if ([FZLoginUser mobile]) {
        if (self.quitBlock) {
            self.quitBlock();
        }
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self showHUDHintWithText:LOCALSTRING(@"setting_quit_fail")];
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    FZUserCenterSectionModel *centerSectionModel = [self.array objectAtIndex:section];
    if ([centerSectionModel.type isEqualToString:@"user_settingPassWord"]) {
        return 1;
    } else {
        return centerSectionModel.cellModels.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FZUserCenterSectionModel *centerSectionModel = [self.array objectAtIndex:indexPath.section];
    static NSString *indentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"indentifier"];
    FZUserCenterModel *userCenterModel = [centerSectionModel.cellModels objectAtIndex:indexPath.row];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    cell.textLabel.text = userCenterModel.title;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
     [tableView deselectRowAtIndexPath:indexPath animated:YES]; 
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
        [self showHUDHintWithText:LOCALSTRING(@"ft_network_error")];
        return;
    }
    if (![FZLoginUser mobile]) {
        [self pushLoginPage];
        return;
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self onPushToSettingPassPage];
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [self onPushToAssessmentPage];
        } else if (indexPath.row == 1) {
            [self onPushToContactUsPage];
        } else if (indexPath.row == 2) {
            [self onPushToAboutUsPage];
        }
    }
}

#pragma mark ---跳转页面---
- (void)onPushToSettingPassPage {
    FZSettingPassViewController *settingPass = [[FZSettingPassViewController alloc] init];
    [self pushPage:settingPass];
}

- (void)onPushToAssessmentPage {
    NSString *appID = @"1078574076"; // 用developer账户登陆itunes connect创建应用时会产生一个app id
    NSString *appURL = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",appID];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appURL]];
}

- (void)onPushToContactUsPage {
    FZContactUsViewController *contactUs = [[FZContactUsViewController alloc] init];
    [self pushPage:contactUs];
}

- (void)onPushToAboutUsPage {
    FZAboutUsViewController *aboutUs = [[FZAboutUsViewController alloc] init];
    [self pushPage:aboutUs];
}

- (void)pushPage:(FZCommonViewController *)commonViewController {
    commonViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:commonViewController animated:YES];
}

- (void)pushLoginPage {
    FZLoginViewController *loginVC = [[FZLoginViewController alloc] init];
    loginVC.loginSuccessBlock = ^() {
        AppDelegate *delegate = [UIApplication sharedApplication].delegate;
        [delegate get_JpushInfoToserver];
    };
    [self.navigationController pushViewController:loginVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
