//
//  FZPullRefreshTableViewController.m
//  EnglishTalk
//
//  Created by Jyh on 15/5/26.
//  Copyright (c) 2015年 Feizhu Tech. All rights reserved.
//

#import "FZPullRefreshTableViewController.h"

@interface FZPullRefreshTableViewController ()

@property (nonatomic, strong) XHRefreshControl *customRefreshControl;

@end

@implementation FZPullRefreshTableViewController

- (void)startPullDownRefreshing {
    [self.customRefreshControl startPullDownRefreshing];
}

- (void)endPullDownRefreshing {
    [self.customRefreshControl endPullDownRefreshing];
}

- (void)endLoadMoreRefreshing {
    [self.customRefreshControl endLoadMoreRefresing];
}

- (void)endMoreOverWithMessage:(NSString *)message {
    [self.customRefreshControl endMoreOverWithMessage:message];
}

- (void)endMoreOverWithMessageTipsView:(UIView *)messageTipsView {
    [self.customRefreshControl endMoreOverWithMessageTipsView:messageTipsView];
}

/**
 *  重置是否有更多翻页数据要加载
 */
- (void)resetLoadMoreStatue:(BOOL)noMoreDataForLoaded {
    [self.customRefreshControl resetLoadMoreStatue:noMoreDataForLoaded];
}

- (void)handleLoadMoreError {
    [self.customRefreshControl handleLoadMoreError];
}

- (BOOL)isLoadingDataSource {
    return [self.customRefreshControl isLoading];
}

#pragma mark - Life Cycle

- (void)setupRefreshControl {
    if (!_customRefreshControl) {
        _customRefreshControl = [[XHRefreshControl alloc] initWithScrollView:self.tableView delegate:self];
        _customRefreshControl.hasStatusLabelShowed = self.hasStatusLabelShowed;
        _customRefreshControl.circleColor = self.circleColor;
        _customRefreshControl.circleLineWidth = self.circleLineWidth;
        _customRefreshControl.indicatorColor = self.indicatorColor;
    }
}

- (id)init {
    self = [super init];
    if (self) {
        self.pullDownRefreshed = YES;
        self.loadMoreRefreshed = YES;
        self.circleColor = [UIColor colorWithHexString:@"89ca30"];
        self.circleLineWidth = 1.0;
        self.indicatorColor = [UIColor colorWithHexString:@"89ca30"];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.pullDownRefreshed) {
        [self setupRefreshControl];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
}

#pragma mark - XHRefreshControl Delegate

- (void)beginPullDownRefreshing {
    self.requestCurrentPage = 0;
    [self loadDataSource];
}

- (void)beginLoadMoreRefreshing {
    self.requestCurrentPage ++;
    [self loadDataSource];
}

- (NSDate *)lastUpdateTime {
    return [NSDate date];
}

- (NSInteger)autoLoadMoreRefreshedCountConverManual {
    return 2;
}

- (BOOL)isPullDownRefreshed {
    return self.pullDownRefreshed;
}

- (BOOL)isLoadMoreRefreshed {
    return self.loadMoreRefreshed;
}

- (XHRefreshViewLayerType)refreshViewLayerType {
    return XHRefreshViewLayerTypeOnScrollViews;
}

- (XHPullDownRefreshViewType)pullDownRefreshViewType {
    return XHPullDownRefreshViewTypeActivityIndicator;
}

- (NSString *)displayAutoLoadMoreRefreshedMessage {
    return @"点击显示下20条";
}

@end
