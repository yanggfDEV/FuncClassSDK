//
//  CommonWebViewController.m
//  EnglishTalk
//
//  Created by apple on 15/5/20.
//  Copyright (c) 2015年 ishowtalk. All rights reserved.
//

#import "FZCommonWebViewController.h"
#import "Masonry.h"
@interface FZCommonWebViewController ()

@property (strong, nonatomic) UIWebView *webView;

@end

@implementation FZCommonWebViewController
{
    UIButton * _backButton;
}


-(instancetype)initControllerWithRemoteNotificationParameters:(NSDictionary *)parameters{
    self = [super initControllerWithRemoteNotificationParameters:parameters];
    if(self){
        self.urlString = [parameters objectForKey:@"url"];
        self.titleStr = @"课时说明";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title=_titleStr;
    self.view.backgroundColor = [UIColor redColor];
//    FZStyleSheet *css = [[FZStyleSheet alloc]init];
//    self.view.backgroundColor =css.color_6;
    [self createWebView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)createBackButton
{
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _backButton.frame =CGRectMake(5, 20, 44, 44);
   // [_backButton  setTitleColor:[UIColor lightGrayColor]forState:UIControlStateNormal];
   // [_backButton  setTitleColor:[UIColor  lightGrayColor] forState:UIControlStateHighlighted];
    [_backButton  addTarget:self action:@selector(backButtonTaped:) forControlEvents:UIControlEventTouchUpInside];
  
    
    [_backButton setBackgroundImage:[UIImage imageNamed:@"rightBack"] forState:UIControlStateNormal];
    
    //[_backButton  setTitleColor:[UIColor colorWithRed:124./255 green:226./255 blue:73./255 alpha:1] forState:UIControlStateHighlighted];
    //[_backButton.titleLabel  setFont:[UIFont  systemFontOfSize:15]];
    [self.view  addSubview:_backButton];
}

- (void)createWebView
{
//    [self showLoadingViewWithCompletedBlock:^(BOOL finished) {
//        
//    }];

    UIWebView *webView = [[UIWebView  alloc] initWithFrame:self.view.bounds];
    webView.backgroundColor=[UIColor whiteColor];
    webView.delegate =self;
    self.webView = webView;
    [self.view addSubview:webView];

    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    NSURL *url = [NSURL URLWithString:self.urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    
//    [self.loadingView hide];
}

- (void)backButtonTaped:(UIButton *)bb
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *requestPath = [[request URL] absoluteString];
    if ([requestPath hasPrefix:@"enlishtalk://"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:requestPath]];
    }
   
    return YES;
}




@end
