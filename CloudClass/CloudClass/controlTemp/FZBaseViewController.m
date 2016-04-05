//
//  FZBaseViewController.m
//  EnglishTalk
//
//  Created by Jyh on 15/5/7.
//  Copyright (c) 2015年 ishowtalk. All rights reserved.
//

#import "FZBaseViewController.h"

@interface FZBaseViewController ()

@end

@implementation FZBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

#pragma mark - KeyBoard

- (void)clearKeyboard
{
    [self.view endEditing:YES];
}

#pragma mark - MBProgressHud
- (void)showHudWithString:(NSString *)str
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.labelText = str;
    [hud show:YES];
    [hud hide:YES afterDelay:10];
}

- (void)showText:(NSString *)str
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = str;
    
    hud.margin = 10.f;
    hud.yOffset = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1.5];
}

- (void)hideHud
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

@end
