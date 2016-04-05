//
//  CommonViewController.m
//  EnglishTalk
//
//  Created by apple on 15/3/26.
//  Copyright (c) 2015年 ishowtalk. All rights reserved.
//

#import "CommonViewController.h"
#import "UIColor+Hex.h"

#define Search_space 15

@interface CommonViewController ()

@end

@implementation CommonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self initData];
    
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initData
{
    _dataSource=[[NSMutableArray alloc] init];
    
//    uid = [[User  sharedInstance].userinfoDict  objectForKey:@"uid"];
//    authtoken = [[User  sharedInstance].userinfoDict  objectForKey:@"auth_token"];
    uid = [FZLoginUser userID];
    authtoken = [FZLoginUser authToken];
}

/*
- (void)getView:(NSArray *)tag
{
    
    _hotView=[[UIView alloc] initWithFrame:CGRectMake(0, 64+40, self.view.frame.size.width,50)];
    [self.view addSubview:_hotView];
    _hotView.userInteractionEnabled=YES;
    
    
    UILabel * ls=[self getLabelWithFrame:CGRectMake(20, 5, 150, 15)];
    ls.text=@"热门搜索";
    [_hotView addSubview:ls];
    
    CGFloat height = 30;
    CGFloat width=20;
    
    CGFloat my_width;
    
    for (NSInteger i=0; i<tag.count;i++) {
        
        NSString * str=tag[i];
        
        CGRect rect=[self getRectwithtext:str];
        
        my_width=rect.size.width+35;//加20
        NSLog(@"myrect:%f-%f",rect.size.width,rect.size.height);
        
        if(width+rect.size.width > _hotView.frame.size.width){
            width=0;
            height+=23;//第二行
        }
        
        if(rect.size.width>150){
            my_width+=20;//再加10
        }
        
        MoreButton * btn=[self getButtonWithFrame:CGRectMake(width,height, my_width, 20) withstring:str];
        
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [_hotView addSubview:btn];
        
        width+=btn.frame.size.width+10;
        
    }
    
    CGRect rr=_hotView.frame;
    rr.size.height=height;
    _hotView.frame=rr;
    
}*/

//输入...
- (UIView *)createView
{
    UIView * vs=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    
    
    UIImageView  *fieldBack = [[UIImageView  alloc]  initWithFrame:CGRectMake(Search_space, 10, [FZUtils GetScreeWidth]-Search_space * 2, 30)];// 64+10
    fieldBack.userInteractionEnabled=YES;
    fieldBack.image =[UIImage   imageNamed:@"SearchPage_SearchFeildBack.png"];
    
    UIButton  *searchIcon = [[UIButton  alloc]  initWithFrame:CGRectMake(fieldBack.frame.size.width-50,-7, 44., 44.)];
    [searchIcon  setImage:[UIImage  imageNamed:@"SearchPage_SearchButton.png"] forState:UIControlStateNormal];
    [searchIcon  addTarget:self action:@selector(searchButtonTaped) forControlEvents:UIControlEventTouchUpInside];
    
    
    _textField = [[UITextField  alloc]  initWithFrame:CGRectMake(10,0, fieldBack.frame.size.width-44, 30)];// (320-285)/2+5+10., 64+10, 280.-44, 30)
    _textField.placeholder = @"搜索小组号或小组名";
    _textField.textColor = [UIColor   grayColor];
    _textField.backgroundColor = [UIColor clearColor];
    _textField.returnKeyType = UIReturnKeySearch;
    _textField.delegate =self;
    _textField.font =[UIFont   boldSystemFontOfSize:14];
    

    [fieldBack  addSubview:searchIcon];
    
    [fieldBack addSubview:_textField];
    
    [vs addSubview:fieldBack];
    
    return vs;
}


//搜索。。。
- (UIView *)createSearch
{
    UIView * view=[[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 40)];
    view.backgroundColor=[UIColor colorWithHexString:@"efefef"];
    
    UIImageView  *fieldBack = [[UIImageView  alloc]  initWithFrame:CGRectMake((320-285)/2., 5, 285., 30)];
    fieldBack.userInteractionEnabled=YES;
    fieldBack.image =[UIImage   imageNamed:@"SearchPage_SearchFeildBack.png"];
    
    UIButton  *searchIcon = [[UIButton  alloc]  initWithFrame:CGRectMake(self.view.frame.size.width/4,-7, 44., 44.)];
    [searchIcon  setImage:[UIImage  imageNamed:@"搜索icon"] forState:UIControlStateNormal];
    [searchIcon  addTarget:self action:@selector(searchButtonTaped:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton * sssss=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, fieldBack.frame.size.width, fieldBack.frame.size.height)];
    [sssss  addTarget:self action:@selector(searchButtonTaped:) forControlEvents:UIControlEventTouchUpInside];
    [fieldBack addSubview:sssss];
    
    searchname=[[UILabel alloc] initWithFrame:CGRectMake(searchIcon.frame.origin.x+44, -5, 100, 40)];
    searchname.text=@"搜索小组号或小组名";
    searchname.font=[UIFont systemFontOfSize:14];
    searchname.textColor=[UIColor lightGrayColor];
    searchname.textAlignment=NSTextAlignmentLeft;
    
    [fieldBack  addSubview:searchIcon];
    [fieldBack addSubview:searchname];
    
    [view addSubview:fieldBack];
    view.userInteractionEnabled=YES;
    fieldBack.userInteractionEnabled=YES;
    // [self.view addSubview:view];
  
    return view;
}

- (void)searchButtonTaped
{
    NSLog(@"搜索小组");
    
    
}

#pragma mark -创建UITableView
- (void)createTableViewwithFrame:(CGRect)rect
{
    //:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height)
    _tableView=[[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
    [self otherCode];
}
- (void)otherCode
{
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.editing=NO;
    _tableView.allowsSelectionDuringEditing=YES;
    
    [self.view addSubview:_tableView];
    self.view.backgroundColor=[UIColor colorWithHexString:@"efefef"];
    
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
        
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return nil;
}

@end
