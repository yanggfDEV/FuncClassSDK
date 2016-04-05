//
//  FZAboutUsViewController.m
//  CloudClass
//
//  Created by guangfu yang on 16/3/14.
//  Copyright © 2016年 yangguangfu. All rights reserved.
//

#import "FZAboutUsViewController.h"

@interface FZAboutUsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *appVersion;
@end

@implementation FZAboutUsViewController

#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LOCALSTRING(@"setting_aboutUs");
    FZStyleSheet *css = [[FZStyleSheet alloc] init];
    self.view.backgroundColor = css.colorOfBackground;
    self.appVersion.text = [NSString stringWithFormat:@"版本：%@", APPVersion];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


#pragma mark -- initialization
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
