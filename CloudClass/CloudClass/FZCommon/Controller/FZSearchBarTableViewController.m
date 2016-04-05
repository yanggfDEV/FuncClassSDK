//
//  FZSearchBarTableViewController.m
//  EnglishTalk
//
//  Created by Jyh on 15/5/26.
//  Copyright (c) 2015年 Feizhu Tech. All rights reserved.
//

#import "FZSearchBarTableViewController.h"

@interface FZSearchBarTableViewController ()

@property(nonatomic, strong) UISearchDisplayController *strongSearchDisplayController;

@end

@implementation FZSearchBarTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
    self.searchBar.placeholder = @"搜索";
    self.searchBar.delegate = self;
    self.searchBar.tintColor = [UIColor colorWithHexString:@"77C516"];
    [self.searchBar sizeToFit];
    
    self.strongSearchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    self.searchDisplayController.searchResultsDataSource = self;
    self.searchDisplayController.searchResultsDelegate = self;
    self.searchDisplayController.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Search Delegate

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{

}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{

}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    return YES;
}

/**
 *  点击键盘上搜索按钮会触发
 *
 *  @param searchBar
 */
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{

}

/**
 *  点击右上角的“取消／cancel”按钮，就会触发
 *
 *  @param searchBar
 */
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{

}

@end
