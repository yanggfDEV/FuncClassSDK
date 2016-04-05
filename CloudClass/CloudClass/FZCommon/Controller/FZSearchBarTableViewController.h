//
//  FZSearchBarTableViewController.h
//  EnglishTalk
//
//  Created by Jyh on 15/5/26.
//  Copyright (c) 2015年 Feizhu Tech. All rights reserved.
//

#import "FZPullRefreshTableViewController.h"

@interface FZSearchBarTableViewController : FZPullRefreshTableViewController <UISearchBarDelegate,UISearchDisplayDelegate>

@property(nonatomic, strong) UISearchBar *searchBar;

@end
