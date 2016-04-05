//
//  CommonViewController.h
//  EnglishTalk
//
//  Created by apple on 15/3/26.
//  Copyright (c) 2015年 ishowtalk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FZUmengStatisticalKeyConstants.h"
#import "FZCommonViewController.h"
@interface CommonViewController : FZCommonViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

{
    UITableView * _tableView;
    
    NSMutableArray * _dataSource;
    
    UITextField * _textField;
    
    UILabel * searchname;
    NSString * uid;
    NSString * authtoken;
}

@property (nonatomic,strong) NSString * groupId;

- (void)createTableViewwithFrame:(CGRect)rect;

- (UIView *)createSearch;
- (UIView *)createView;

- (void)searchButtonTaped:(UIButton *)bb;
- (void)searchButtonTaped;

@end
