//
//  FZBaseTableViewController.m
//  EnglishTalk
//
//  Created by Jyh on 15/5/26.
//  Copyright (c) 2015年 Feizhu Tech. All rights reserved.
//

#import "FZBaseTableViewController.h"

@interface FZBaseTableViewController ()

/**
 *  判断tableView是否支持iOS7的api方法
 *
 *  @return 返回预想结果
 */
- (BOOL)validateSeparatorInset;

@end

@implementation FZBaseTableViewController

#pragma mark - Publish Method

- (void)configuraTableViewNormalSeparatorInset {
    if ([self validateSeparatorInset]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
}

- (void)configuraSectionIndexBackgroundColorWithTableView:(UITableView *)tableView {
    if ([tableView respondsToSelector:@selector(setSectionIndexBackgroundColor:)]) {
        tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    }
}

- (void)loadDataSource {
    // subClasse
}

#pragma mark - Propertys

- (UITableView *)tableView {
    if (!_tableView) {
        CGRect tableViewFrame = self.view.bounds;
        tableViewFrame.size.height -= (self.navigationController.viewControllers.count > 1 ? 0 : (CGRectGetHeight(self.tabBarController.tabBar.bounds)));
        _tableView = [[UITableView alloc] initWithFrame:tableViewFrame style:self.tableViewStyle];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        if (![self validateSeparatorInset]) {
            if (self.tableViewStyle == UITableViewStyleGrouped) {
                UIView *backgroundView = [[UIView alloc] initWithFrame:_tableView.bounds];
                backgroundView.backgroundColor = _tableView.backgroundColor;
                _tableView.backgroundView = backgroundView;
            }
        }
    }
    return _tableView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return _dataSource;
}

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
}

- (void)dealloc {
//    self.dataSource = nil;
//    self.tableView.delegate = nil;
//    self.tableView.dataSource = nil;
//    self.tableView = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Helper Method

- (BOOL)validateSeparatorInset {
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        return YES;
    }
    return NO;
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // in subClass
    return nil;
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
