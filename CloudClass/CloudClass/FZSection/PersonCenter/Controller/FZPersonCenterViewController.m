//
//  FZPersonCenterViewController.m
//  CloudClass
//
//  Created by guangfu yang on 16/1/27.
//  Copyright © 2016年 yangguangfu. All rights reserved.
//

#import "FZPersonCenterViewController.h"
#import "FZLoginViewController.h"
#import "FZSetUserInformationViewController.h"
#import "FZMyCourseViewController.h"
#import "AppDelegate.h"
#import "FZJusMeettingSDKManager.h"
#import "FZSettingViewController.h"
#import "FZUserCenterSectionModel.h"
#import "FZUserCenterModel.h"

@interface FZPersonCenterViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *nameButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *array;

@property (nonatomic, strong) UIButton *seetingBtn;

@end

@implementation FZPersonCenterViewController
#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LOCALSTRING(@"personCenter_page");
    [self setInitView];
    [self getUserInfo];
}

- (void)viewWillAppear:(BOOL)animated {
    [self upDateView];
}

#pragma mark -- initialization
- (void)setInitView {
    FZStyleSheet *css = [[FZStyleSheet alloc] init];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.rowHeight = 52.0f;
    self.tableView.backgroundColor = css.colorOfBackground;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    self.tableView.separatorColor = css.colorLine;
    
    self.view.backgroundColor = css.colorOfBackground;
    self.headImage.layer.cornerRadius = 42;
    self.headImage.layer.masksToBounds = YES;
    self.headImage.contentMode = UIViewContentModeScaleAspectFill;
    self.headImage.clipsToBounds = YES;
    UITapGestureRecognizer *headTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onHeadTap)];
    [self.headImage addGestureRecognizer:headTap];
    headTap.numberOfTapsRequired = 1;
    self.headImage.contentMode = UIViewContentModeScaleAspectFill;
    self.headImage.clipsToBounds = YES;
    [self.headImage setUserInteractionEnabled:YES];
    
    self.loginButton.layer.cornerRadius = 5;
    self.loginButton.layer.masksToBounds = YES;
    
    [self upDateView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"i_iconfont_set-0"] forState:UIControlStateNormal];
    [button setTitleColor:css.colorOfLighterText forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onSetting) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 100, 44);
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 50, 0, 0)];
    button.titleLabel.font = css.fontOfH2;
    self.seetingBtn = button;
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:self.seetingBtn];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                   target:nil action:nil];
    negativeSpacer.width = -15;//这个数值可以根据情况自由变化
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, rightBarItem];
}

- (void)getUserInfo {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"cloudClass_personCenter" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSArray *sectionJSONArray = jsonDictionary[@"config_data"];
    NSArray *modelArray = [MTLJSONAdapter modelsOfClass:[FZUserCenterSectionModel class] fromJSONArray:sectionJSONArray error:nil];
    self.array = [modelArray mutableCopy];
    [self.tableView reloadData];
}


- (void)onSetting {
    FZSettingViewController *settingVC = [[FZSettingViewController alloc] init];
    settingVC.hidesBottomBarWhenPushed = YES;
    WEAKSELF
    settingVC.quitBlock = ^() {
        [[FZJusMeettingSDKManager shareInstance] jusMeettingSDKLogout];
        [[FZLoginManager sharedManager] logout];
        [weakSelf upDateView];
    };
    [self.navigationController pushViewController:settingVC animated:YES];
}

- (void)upDateView {
    if ([[FZLoginUser mobile] isEqualToString:@""] || ![FZLoginUser mobile]) {
        self.nameLabel.hidden = YES;
        self.nameButton.hidden = YES;
        self.loginButton.hidden = NO;
        self.headImage.image = [UIImage imageNamed:@"i_img_head-1"];
    } else {
        self.nameLabel.hidden = NO;
        self.nameButton.hidden = NO;
        self.loginButton.hidden = YES;
        [self.headImage sd_setImageWithURL:[NSURL URLWithString:[[FZLoginUser avatar] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"i_img_head-1"] completed:nil];
        self.nameLabel.text = [FZLoginUser nickname];
    }

}

#pragma mark -- touch
- (void)onHeadTap {
    if ([FZLoginUser mobile]) {
        [self pushSetUsetInfoPage];
    } else {
        [self pushLoginPage];
    }
}

- (IBAction)onQuit:(id)sender {
    [[FZJusMeettingSDKManager shareInstance] jusMeettingSDKLogout];
    [[FZLoginManager sharedManager] logout];
    [self upDateView];
}

- (IBAction)onMyCourses:(id)sender {
    if ([FZLoginUser mobile]) {
        [self pushSetUsetInfoPage];
    } else {
        [self pushLoginPage];
    }
}

- (IBAction)onLogin:(id)sender {
    [self pushLoginPage];
}


- (IBAction)onUserInfo:(id)sender {
    [self pushSetUsetInfoPage];
}

- (void)pushSetUsetInfoPage {
    FZSetUserInformationViewController *userInfoVC = [[FZSetUserInformationViewController alloc] init];
    userInfoVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:userInfoVC animated:YES];
}

- (void)pushLoginPage {
    WEAKSELF
    FZLoginViewController *loginVC = [[FZLoginViewController alloc] init];
    loginVC.loginSuccessBlock = ^() {
        [weakSelf upDateView];
        AppDelegate *delegate = [UIApplication sharedApplication].delegate;
        [delegate get_JpushInfoToserver];
    };
    [self.navigationController pushViewController:loginVC animated:YES];
}

- (void)pushMyCoursePage {
    FZMyCourseViewController *myCourseVC = [[FZMyCourseViewController alloc] init];
    myCourseVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:myCourseVC animated:YES];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    FZUserCenterSectionModel *centerSectionModel = [self.array objectAtIndex:section];
    return centerSectionModel.cellModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FZUserCenterSectionModel *centerSectionModel = [self.array objectAtIndex:indexPath.section];
    FZUserCenterModel *userCenterModel = [centerSectionModel.cellModels objectAtIndex:indexPath.row];
    static NSString *indentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"indentifier"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:indentifier];
    }
    cell.imageView.image = [UIImage imageNamed:userCenterModel.iconName];
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
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            if ([FZLoginUser mobile]) {
                [self pushMyCoursePage];
            } else {
                [self pushLoginPage];
            }
        }
    }
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
