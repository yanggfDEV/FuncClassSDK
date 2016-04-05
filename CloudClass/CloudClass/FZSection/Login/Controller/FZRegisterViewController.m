//
//  FZRegisterViewController.m
//  CloudClass
//
//  Created by guangfu yang on 16/1/28.
//  Copyright © 2016年 yangguangfu. All rights reserved.
//

#import "FZRegisterViewController.h"
#import "FZLoginOrOthersService.h"
#import "FZPersonCenterViewController.h"
#import "FZTeacherDetailsViewController.h"
#import "FCChatCache.h"

@interface FZRegisterViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *mobileField;
@property (weak, nonatomic) IBOutlet UITextField *passWDField;
@property (weak, nonatomic) IBOutlet UITextField *verificationCodeField;
@property (weak, nonatomic) IBOutlet UILabel *verificationCodeLabel;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIButton *getCodeButton;
@property (nonatomic, strong) FZLoginOrOthersService *service;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger count;

@end

@implementation FZRegisterViewController

#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateView];
}



#pragma mark -- initialization
- (void)updateView {
    self.service = [[FZLoginOrOthersService alloc] init];
    FZStyleSheet *css = [[FZStyleSheet alloc] init];
    if (self.isForgetPassWD) {
        self.title = LOCALSTRING(@"forget_title");
        [self.submitButton setTitle:LOCALSTRING(@"forget_page_subit") forState:UIControlStateNormal];
    } else {
        self.title = LOCALSTRING(@"register_title");
        [self.submitButton setTitle:LOCALSTRING(@"register_title") forState:UIControlStateNormal];
    }
    self.view.backgroundColor = css.colorOfBackground;
    self.submitButton.layer.cornerRadius = 5;
    self.submitButton.layer.masksToBounds = YES;
    [self.submitButton setBackgroundImage:[UIImage imageWithColor: css.colorOfGreenButtonHightlighted] forState: UIControlStateNormal];
    [self.submitButton setBackgroundImage:[UIImage imageWithColor: css.colorOfBlueButtonHightlighted] forState:UIControlStateDisabled];
    [self.submitButton setEnabled:NO];
    
    self.verificationCodeLabel.textColor = css.colorOfGreenButtonHightlighted;
    self.verificationCodeLabel.font = css.fontOfBoldH7;
    self.verificationCodeLabel.text = LOCALSTRING(@"regster_code_button");
    
    self.mobileField.textColor = css.colorOfListTitle;
    self.mobileField.font = css.fontOfH7;
    self.mobileField.placeholder = LOCALSTRING(@"regster_mobile");
    self.mobileField.delegate = self;
    
    self.verificationCodeField.textColor = css.colorOfListTitle;
    self.verificationCodeField.font = css.fontOfH7;
    self.verificationCodeField.placeholder = LOCALSTRING(@"regster_code");
    self.verificationCodeField.delegate = self;
    
    self.passWDField.textColor = css.colorOfListTitle;
    self.passWDField.font = css.fontOfH7;
    self.passWDField.placeholder = LOCALSTRING(@"regster_password");
    self.passWDField.delegate = self;
    
    [self.mobileField addTarget:self  action:@selector(valueChanged)  forControlEvents:UIControlEventAllEditingEvents];
    [self.verificationCodeField addTarget:self  action:@selector(valueChanged)  forControlEvents:UIControlEventAllEditingEvents];
    [self.passWDField addTarget:self  action:@selector(valueChanged)  forControlEvents:UIControlEventAllEditingEvents];
}

#pragma mark - touch
- (void)valueChanged {
    if ([self.mobileField.text length] != 11 ||
        [self.verificationCodeField.text length] != 6 ||
        [self.passWDField.text length] < 6 ||
        [self.passWDField.text length] > 16) {
        [self.submitButton setEnabled:NO];
    } else {
        [self.submitButton setEnabled:YES];
    }
}

- (IBAction)getVerificationCode:(id)sender {
    [self hideKey];
    if ([self.mobileField.text length] != 11) {
        [self showHUDHintWithText:@"请输入正确的手机号码"];
        return;
    }
    [self onGetVerificationCode];
}

- (void)onGetVerificationCode {
    [self hideKey];
    [self.getCodeButton setEnabled:NO];
    NSString *typeStr = @"";
    NSString *mobile = self.mobileField.text;
    if (self.isForgetPassWD) {
        typeStr = @"3";
    } else {
        typeStr = @"1";
    }
    WEAKSELF
    [self.service getMobileCode:typeStr mobile:mobile success:^(NSInteger statusCode, NSString *message, id dataObject) {
        if (statusCode == kFZRequestStatusCodeSuccess) {
            [weakSelf setVerificationCodeLabelText];
            [weakSelf showHUDHintWithText:LOCALSTRING(@"regster_code_success")];
        } else {
            [weakSelf showHUDHintWithText:message];
            [self.getCodeButton setEnabled:YES];
        }
    } failure:^(id responseObject, NSError *error) {
        [weakSelf showHUDHintWithText:LOCALSTRING(@"ft_netWork_error_notice")];
    }];
}

- (void)setVerificationCodeLabelText {
    self.count = 60;
    self.timer = [NSTimer scheduledTimerWithTimeInterval: 1 target: self selector: @selector(updateVerificationCodeLavelText) userInfo: nil repeats: YES];
}

- (void)updateVerificationCodeLavelText {
    FZStyleSheet *css = [[FZStyleSheet alloc] init];
    self.verificationCodeLabel.textColor = css.colorOfCode;
    self.count--;
    if (self.count) {
        self.verificationCodeLabel.text = [NSString stringWithFormat: @"已发送(%ld)", (long)self.count];
    } else {
        self.verificationCodeLabel.textColor = css.colorOfGreenButtonHightlighted;
        self.verificationCodeLabel.text = LOCALSTRING(@"regster_code_button");
        [self.timer invalidate];
        self.timer = nil;
        [self.getCodeButton setEnabled:YES];
    }

}

- (IBAction)onSubmit:(id)sender {
    [self hideKey];
    
    BOOL isRegister = NO;
    if (self.isForgetPassWD) {
        isRegister = NO;
    } else {
        isRegister = YES;
    }
    
    NSString *mobile = self.mobileField.text;
    NSString *code = self.verificationCodeField.text;
    NSString *password = self.passWDField.text;
    
    WEAKSELF
    [self startProgressHUD];
    [self.service registerOrSetPassWD:isRegister mobile:mobile code:code password:password success:^(NSInteger statusCode, NSString *message, id dataObject) {
        [weakSelf stopProgressHUD];
        
        if (statusCode == kFZRequestStatusExpCodeError) {
            [weakSelf showHUDHintWithText:LOCALSTRING(@"regster_code_error")];
            return ;
        }
        
        if (statusCode == kFZRequestStatusCodeSuccess) {
            if (isRegister) {
                [weakSelf showHUDHintWithText:LOCALSTRING(@"regster_success")];
                if (weakSelf.mobileBlock) {
                    weakSelf.mobileBlock(mobile);
                }
            } else {
                [weakSelf showHUDHintWithText:LOCALSTRING(@"forget_passwd_success")];
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
        } else {
            [weakSelf showHUDHintWithText:message];
        }
        
        
    } failure:^(id responseObject, NSError *error) {
        [weakSelf stopProgressHUD];
        [weakSelf showHUDHintWithText:LOCALSTRING(@"ft_netWork_error_notice")];
    }];
}

//回收键盘
- (void)hideKey {
    [self.mobileField resignFirstResponder];
    [self.passWDField resignFirstResponder];
    [self.verificationCodeField resignFirstResponder];
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
