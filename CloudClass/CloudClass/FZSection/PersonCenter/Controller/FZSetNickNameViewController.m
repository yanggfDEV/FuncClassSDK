//
//  FZSetNickNameViewController.m
//  CloudClass
//
//  Created by guangfu yang on 16/1/28.
//  Copyright © 2016年 yangguangfu. All rights reserved.
//

#import "FZSetNickNameViewController.h"
#import "FZPersonCenterService.h"

@interface FZSetNickNameViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UITextField *nickNameField;
@property (nonatomic, strong) FZPersonCenterService *service;

@end

@implementation FZSetNickNameViewController

#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LOCALSTRING(@"person_set_nickname");
    [self initialization];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - initialization
- (void)initialization {
    FZStyleSheet *css = [[FZStyleSheet alloc] init];
    self.service = [[FZPersonCenterService alloc] init];
    self.view.backgroundColor = css.colorOfBackground;
    
    self.nickNameField.text = [FZLoginUser nickname];
    self.nickNameField.textColor = css.colorOfListTitle;
    self.nickNameField.font = css.fontOfH7;
    self.nickNameField.delegate = self;
    self.nickNameField.tintColor = css.colorOfGreenButtonHightlighted;
    [self.nickNameField becomeFirstResponder];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"保存" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(onSave) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(0, 0, 100, 44);
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -40)];
    btn.titleLabel.font = css.fontOfH8;
    self.saveBtn = btn;
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:self.saveBtn];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                   target:nil action:nil];
    negativeSpacer.width = -15;//这个数值可以根据情况自由变化
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, rightBarItem];
}

#pragma mark -- touch
- (void)onSave {
    WEAKSELF
    [self hideKey];
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
        [weakSelf showHUDHintWithText:LOCALSTRING(@"ft_network_error")];
        return;
    }

    if ([self.nickNameField.text isEqualToString:[FZLoginUser nickname]]) {
//        [self showHUDHintWithText:LOCALSTRING(@"person_set_nickname_failure")];
        return;
    }
    [self startProgressHUD];
    NSString *nickName = self.nickNameField.text;
    BOOL isSetNickName = YES;
    [self.service setUsetInfo:isSetNickName nickName:nickName avatar:nil success:^(NSInteger statusCode, NSString *message, id dataObject) {
        [weakSelf stopProgressHUD];
        if (statusCode == kFZRequestStatusCodeSuccess) {
            [weakSelf showHUDHintWithText:LOCALSTRING(@"person_set_nickname_success")];
            [FZLoginUser setNickname:nickName];
            if (weakSelf.setNickNameSuccessBlock) {
                weakSelf.setNickNameSuccessBlock();
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
        } else {
            [weakSelf showHUDHintWithText:message];
        }
    } failure:^(id responseObject, NSError *error) {
        [weakSelf stopProgressHUD];
        [weakSelf showHUDHintWithText:LOCALSTRING(@"ft_network_error")];
    }];
    
}

//回收键盘
- (void)hideKey {
    [self.nickNameField resignFirstResponder];
}

#pragma mark -- textField
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]){
        return YES;
    }
    //    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    //    if (self.mobileField == textField){
    //        if ([toBeString length] >= 11) {
    //            [self hideKey];
    //            [self showHUDHintWithText:@"请输入正确的手机号~"];
    //            textField.text = [toBeString substringToIndex:11];
    //            return NO;
    //        }
    //    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self hideKey];
    return NO;
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

@end
