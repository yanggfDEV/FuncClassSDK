//
//  FZContactUsViewController.m
//  CloudClass
//
//  Created by guangfu yang on 16/3/14.
//  Copyright © 2016年 yangguangfu. All rights reserved.
//

#import "FZContactUsViewController.h"
#import "FZSettingService.h"

@interface FZContactUsViewController ()<UITextFieldDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *contactLabel;
@property (weak, nonatomic) IBOutlet UITextField *contactField;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (nonatomic, strong) SZTextView *contentTextView;
@property (nonatomic, strong) FZSettingService *service;

@end

@implementation FZContactUsViewController

#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LOCALSTRING(@"setting_contactUs");
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
    self.submitBtn.layer.cornerRadius = 5;
    self.submitBtn.layer.masksToBounds = YES;
    [self.submitBtn setBackgroundImage:[UIImage imageWithColor: css.colorOfGreenButtonHightlighted] forState: UIControlStateNormal];
    [self.submitBtn setBackgroundImage:[UIImage imageWithColor: css.colorOfBlueButtonHightlighted] forState:UIControlStateDisabled];
    [self.submitBtn setEnabled:NO];
    
    self.contentView.layer.cornerRadius = 5;
    self.contentView.layer.masksToBounds = YES;
    self.contentTextView = [[SZTextView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.contentTextView];
    [self.contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    self.contentTextView.delegate = self;
    self.contentTextView.placeholder = LOCALSTRING(@"setting_contact_content");
    self.contentTextView.textContainerInset = UIEdgeInsetsMake(13, 5, 13, 5);
    self.contentTextView.layer.cornerRadius = 5;
    self.contentTextView.layer.masksToBounds = YES;
    self.contentTextView.returnKeyType = UIReturnKeySend;
    self.contentTextView.font = css.fontOfH4;
    self.contentTextView.keyboardType = UIKeyboardTypeDefault;
    [self.contentTextView becomeFirstResponder];
    
    self.contactField.textColor = css.colorOfListTitle;
    self.contactField.font = css.fontOfH4;
    self.contactField.layer.cornerRadius = 5;
    self.contactField.layer.masksToBounds = YES;
    self.contactField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 9, 12)];
    self.contactField.leftViewMode = UITextFieldViewModeAlways;
    self.contactField.placeholder = LOCALSTRING(@"setting_contact_phone");
    self.contactField.backgroundColor = css.colorOfLighterText;
    
    self.contactLabel.text = LOCALSTRING(@"setting_contact_label");
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKey)];
    [self.view addGestureRecognizer:tap];
    tap.numberOfTapsRequired = 1;
    
    [self.contactField addTarget:self  action:@selector(valueChanged)  forControlEvents:UIControlEventAllEditingEvents];
}

- (IBAction)onSubmit:(id)sender {
}

- (void)valueChanged {
    if ([self.contentTextView.text length] == 0) {
        [self.submitBtn setEnabled:NO];
    } else {
        [self.submitBtn setEnabled:YES];
    }
}

//回收键盘
- (void)hideKey {
    [self.contentTextView resignFirstResponder];
    [self.contactField resignFirstResponder];
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

- (void)textViewDidChange:(UITextView *)textView {
    [self valueChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
