//
//  FZPullRefreshTableViewController.h
//  EnglishTalk
//
//  Created by Jyh on 15/5/26.
//  Copyright (c) 2015年 Feizhu Tech. All rights reserved.
//

#import "FZBaseTableViewController.h"

#import "XHRefreshControl.h"

/**
 *  支持下拉刷新，上拉刷新的TableView
 */
@interface FZPullRefreshTableViewController : FZBaseTableViewController <XHRefreshControlDelegate>

/**
 *  是否支持下拉刷新
 */
@property (nonatomic, assign) BOOL pullDownRefreshed;

/**
 *  是否支持上拉刷新
 */
@property (nonatomic, assign) BOOL loadMoreRefreshed;

/**
 *  下拉刷新的样式
 */
@property (nonatomic, assign) XHPullDownRefreshViewType refreshViewType;

/**
 *  加载数据的页码
 */
@property (nonatomic, assign) NSInteger requestCurrentPage;

/**
 *  加载数据的个数
 */
@property (nonatomic, assign) NSInteger requestCount;

/**
 *  是否显示下拉刷新的标签文本,如果返回YES，按照正常排版,如果返回NO,那转圈居中,默认是YES
 */
@property (nonatomic, assign) BOOL hasStatusLabelShowed;

/**
 *  圆圈的颜色，默认是[UIColor colorWithHexString:@"89ca30"];
 */
@property (nonatomic, strong) UIColor *circleColor;

/**
 *  圆圈的线条粗细,默认为1, 最大为2
 */
@property (nonatomic, assign) CGFloat circleLineWidth;

/**
 *  菊花的颜色
 */
@property (nonatomic, strong) UIColor *indicatorColor;

/**
 *  自动下拉刷新调用的方法，必须放在viewDidAppear方法内，别把这行代码放到别处，然后导致了错误，那就不好了嘛！
 */
- (void)startPullDownRefreshing;

/**
 *  当下拉加载数据完成后，你必须调用该方法哦！
 */
- (void)endPullDownRefreshing;

/**
 *  当上拉加载数据完成后，你也得调用该方法哦！然后你可能会问，那我要怎么判断是下拉还是上拉啊？requestCurrentPage看这个变量，会跟着变化哦！
 */
- (void)endLoadMoreRefreshing;

/**
 *  当上拉加载数据回调告诉我们，已经没有下一页了，那你可以调用该方法，告诉用户你已经没有数据了哦！
 *
 *  @param message 提示用户的信息
 */
- (void)endMoreOverWithMessage:(NSString *)message;

/**
 *  当上拉加载数据回调告诉我们，已经没有下一页了，那你可以调用该方法，告诉用户你已经没有数据了哦！
 *
 *  @param messageTipsView 提示用户的视图
 */
- (void)endMoreOverWithMessageTipsView:(UIView *)messageTipsView;

/**
 *  重置是否有更多翻页数据要加载
 */
- (void)resetLoadMoreStatue:(BOOL)noMoreDataForLoaded;

/**
 *  当网络加载失败的时候，你必须调用该方法，如果你不调用，我也帮不了你了
 */
- (void)handleLoadMoreError;

/**
 *  获取当前是否在加载数据中
 *
 *  @return 返回预期结果
 */
- (BOOL)isLoadingDataSource;

@end
