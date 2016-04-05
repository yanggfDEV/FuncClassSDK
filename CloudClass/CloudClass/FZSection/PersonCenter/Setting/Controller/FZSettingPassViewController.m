//
//  FZSettingPassViewController.m
//  CloudClass
//
//  Created by guangfu yang on 16/3/14.
//  Copyright © 2016年 yangguangfu. All rights reserved.
//

#import "FZSettingPassViewController.h"
#import "FZSettingService.h"

@interface FZSettingPassViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *oldPassField;
@property (weak, nonatomic) IBOutlet UITextField *surePassField;
@property (weak, nonatomic) IBOutlet UIButton *settingBtn;
@property (nonatomic, strong) FZSettingService *service;

@end

@implementation FZSettingPassViewController

#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LOCALSTRING(@"setting_pass");
    [self initialization];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark -- initialization
- (void)initialization {
    self.service = [[FZSettingService alloc] init];
    FZStyleSheet *css = [[FZStyleSheet alloc] init];
    self.view.backgroundColor = css.colorOfBackground;
    self.settingBtn.layer.cornerRadius = 5;
    self.settingBtn.layer.masksToBounds = YES;
    [self.settingBtn setBackgroundImage:[UIImage imageWithColor: css.colorOfGreenButtonHightlighted] forState: UIControlStateNormal];
    [self.settingBtn setBackgroundImage:[UIImage imageWithColor: css.colorOfBlueButtonHightlighted] forState:UIControlStateDisabled];
    [self.settingBtn setEnabled:NO];
    
    self.oldPassField.textColor = css.colorOfListTitle;
    self.oldPassField.font = css.fontOfH7;
    self.oldPassField.placeholder = LOCALSTRING(@"setting_pass_printOldPss");
    [self.oldPassField becomeFirstResponder];
    self.surePassField.textColor = css.colorOfListTitle;
    self.surePassField.font = css.fontOfH7;
    self.surePassField.placeholder = LOCALSTRING(@"setting_pass_printNewPss");
    [self.oldPassField addTarget:self  action:@selector(valueChanged)  forControlEvents:UIControlEventAllEditingEvents];
    [self.surePassField addTarget:self  action:@selector(valueChanged)  forControlEvents:UIControlEventAllEditingEvents];
}

#pragma mark --touch---
- (IBAction)onSettting:(id)sender {
    [self hideKey];
    [self startProgressHUD];
    WEAKSELF
    NSString *oldPass = self.oldPassField.text;
    NSString *newPass = self.surePassField.text;
    [self.service setPass:oldPass newPass:newPass success:^(NSInteger statusCode, NSString *message, id dataObject) {
        [weakSelf stopProgressHUD];
        if (statusCode == kFZRequestStatusCodeSuccess) {
        } else {
            
        }
    } failure:^(id responseObject, NSError *error) {
        [weakSelf stopProgressHUD];
        NSString *errorStr = LOCALSTRING(@"login_failure");
        [weakSelf showHUDHintWithText:errorStr];
    }];
}

- (void)valueChanged {
    if ([self.oldPassField.text length] < 6 ||
        [self.oldPassField.text length] > 16 ||
        [self.surePassField.text length] < 6 ||
        [self.surePassField.text length] > 16) {
        [self.settingBtn setEnabled:NO];
    } else {
        [self.settingBtn setEnabled:YES];
    }
}

//回收键盘
- (void)hideKey {
    [self.oldPassField resignFirstResponder];
    [self.surePassField resignFirstResponder];
}

#pragma mark -- textField
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]){
        return YES;
    }
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


@end
