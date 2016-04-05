//
//  FZLoginViewController.m
//  CloudClass
//
//  Created by guangfu yang on 16/1/27.
//  Copyright © 2016年 yangguangfu. All rights reserved.
//

#import "FZLoginViewController.h"
#import "FZLoginOrOthersService.h"
#import "FZRegisterViewController.h"
#import "FCChatCache.h"
#import "FZSettingPassViewController.h"

@interface FZLoginViewController ()<UITextFieldDelegate,FZJusMeetingSDKDelegate>
@property (weak, nonatomic) IBOutlet UITextField *mobileField;
@property (weak, nonatomic) IBOutlet UITextField *passWDField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (nonatomic, strong) UIButton *goBackBtn;
@property (nonatomic, strong) FZLoginOrOthersService *loginService;
@property (nonatomic, strong) FZJusMeettingSDKManager *jusManager;
@property (nonatomic, assign) BOOL loginSuccess;
@end

@implementation FZLoginViewController

#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LOCALSTRING(@"login_page");
    [self updateView];
    NSArray *array = self.navigationController.viewControllers;
    if (array.count <= 1) {
        [self goback];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (!self.loginSuccess) {
        [[FZJusMeettingSDKManager shareInstance] jusMeettingSDKLogout];
        [[FZLoginManager sharedManager] logout];
    }
}

#pragma mark -- initialization
- (void)updateView {
    self.loginSuccess = NO;
    self.hidesBottomBarWhenPushed = YES;
    self.loginService = [[FZLoginOrOthersService alloc] init];
    FZStyleSheet *css = [[FZStyleSheet alloc] init];
    self.view.backgroundColor = css.colorOfBackground;
    self.loginButton.layer.cornerRadius = 5;
    self.loginButton.layer.masksToBounds = YES;
    [self.loginButton setBackgroundImage:[UIImage imageWithColor: css.colorOfGreenButtonHightlighted] forState: UIControlStateNormal];
    [self.loginButton setBackgroundImage:[UIImage imageWithColor: css.colorOfBlueButtonHightlighted] forState:UIControlStateDisabled];
    [self.loginButton setEnabled:NO];
    
    self.mobileField.textColor = css.colorOfListTitle;
    self.mobileField.font = css.fontOfH7;
    self.mobileField.placeholder = LOCALSTRING(@"login_mobile");
    self.mobileField.delegate = self;
    self.mobileField.text = [FZLoginUser reMobile];
    self.passWDField.textColor = css.colorOfListTitle;
    self.passWDField.font = css.fontOfH7;
    self.passWDField.placeholder = LOCALSTRING(@"login_password");
    self.passWDField.delegate = self;
    if ([FZLoginUser reMobile]) {
        [self.passWDField becomeFirstResponder];
    }
    [self.mobileField addTarget:self  action:@selector(valueChanged)  forControlEvents:UIControlEventAllEditingEvents];
    [self.passWDField addTarget:self  action:@selector(valueChanged)  forControlEvents:UIControlEventAllEditingEvents];
}

#pragma mark ——账号被挤下来处理
- (void)goback {
    FZStyleSheet *css = [[FZStyleSheet alloc] init];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(onGoback) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(0, 0, 100, 44);
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 40)];
    btn.titleLabel.font = css.fontOfH8;
    self.goBackBtn = btn;
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:self.goBackBtn];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                   target:nil action:nil];
    negativeSpacer.width = -15;//这个数值可以根据情况自由变化
    self.navigationItem.leftBarButtonItems = @[negativeSpacer, leftBarItem];
}

- (void)onGoback {
    if (self.loginCancelBlock) {
        self.loginCancelBlock();
    }
}

#pragma mark -- touch
- (IBAction)onRegister:(id)sender {
    [self pushPage:NO];
}

- (IBAction)onForgetPassWD:(id)sender {
    [self pushPage:YES];
}

- (void)pushPage:(BOOL)isForgetPW {
    FZRegisterViewController *registerVC = [[FZRegisterViewController alloc] init];
    registerVC.isForgetPassWD = isForgetPW;
    WEAKSELF
    registerVC.mobileBlock = ^(NSString *mobile) {
        weakSelf.mobileField.text = mobile;
        [weakSelf.passWDField becomeFirstResponder];
    };
    [self.navigationController pushViewController:registerVC animated:YES];
}

//回收键盘
- (void)hideKey {
    [self.mobileField resignFirstResponder];
    [self.passWDField resignFirstResponder];
}

//调整登录按钮
- (void)valueChanged {
    if ([self.mobileField.text length] != 11 ||
        [self.passWDField.text isEqualToString:@""]) {
        [self.loginButton setEnabled:NO];
    } else {
        [self.loginButton setEnabled:YES];
    }
}

- (IBAction)onLogin:(id)sender {
    WEAKSELF
    [self hideKey];
    if ([self.mobileField.text length] < 11 || !self.mobileField ||
        [self.passWDField.text isEqualToString:@""] || !self.passWDField) {
        [self showHUDHintWithText:LOCALSTRING(@"login_input_error")];
        return;
    }
    [self startProgressHUDWithText:LOCALSTRING(@"login_httping")];
    NSString *mobile = self.mobileField.text;
    NSString *password = self.passWDField.text;
    [self.loginService userLogin:mobile password:password success:^(NSInteger statusCode, NSString *message, id dataObject) {
        if (statusCode == kFZRequestStatusCodeSuccess) {
            [FZLoginUser setReMobile:mobile];
            [FZLoginUser setLastUserName:mobile];
            [FZLoginUser setPassWD:password];
            
            /**
             *  设置登录账号密码
             */
            [[FZLoginManager sharedManager] updateUserInfo:dataObject];
            //[weakSelf exitWithSuccess];
            //jusTalk登录
            [FZJusMeettingSDKManager shareInstance].jusDelegate = self;
            [[FZJusMeettingSDKManager shareInstance] jusMeettingSDKLogin:[FZLoginUser userID] passWD:[FZLoginUser passWD] development:NO];

            [FCChatCache setCurrentAppUserID:[FZLoginUser userID]];
        } else {
            [weakSelf stopProgressHUD];
            [weakSelf showHUDHintWithText:message];
        }
    } failure:^(id responseObject, NSError *error) {
        [weakSelf stopProgressHUD];
        [weakSelf exitWithFailure:nil];
        NSString *errorStr = LOCALSTRING(@"login_failure");
        [weakSelf showHUDHintWithText:errorStr];
        [weakSelf exitWithFailure:errorStr];
    }];
}
 

- (void)exitWithSuccess {
    WEAKSELF
    if (weakSelf.loginSuccessBlock) {
        weakSelf.loginSuccessBlock();
    }
    if (weakSelf.loginSuccessEventBlock) {
        weakSelf.loginSuccessEventBlock();
    }
}
- (void)exitWithFailure:(NSString *)errorMessage {
    WEAKSELF
    if (weakSelf.loginFailureBlock) {
        weakSelf.loginFailureBlock(errorMessage);
    }
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

#pragma mark ——justMettingdelegate登录情况——
- (void)jusMettingLoginSuccess {
    [self stopProgressHUD];
    [self showHUDHintWithText:LOCALSTRING(@"login_success")];
    [self exitWithSuccess];
    self.loginSuccess = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

- (void)jusMettingLoginfail {
    [self stopProgressHUD];
    [self exitWithFailure:nil];
    NSString *errorStr = LOCALSTRING(@"login_failure");
    [self showHUDHintWithText:errorStr];
    [self exitWithFailure:errorStr];
    self.loginSuccess = NO;
    [[FZJusMeettingSDKManager shareInstance] jusMeettingSDKLogout];
    [[FZLoginManager sharedManager] logout];
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
