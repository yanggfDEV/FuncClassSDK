//
//  FZPasswordWithShowButtonView.m
//  KidDubbing
//
//  Created by Victor Ji on 15/11/25.
//  Copyright © 2015年 Feizhu Tech. All rights reserved.
//

#import "FZPasswordWithShowButtonView.h"

@interface FZPasswordWithShowButtonView ()

@property (strong, nonatomic) UIButton *showPasswordButton;

@property (assign, nonatomic) BOOL passwordShown;

@end

@implementation FZPasswordWithShowButtonView

#pragma mark - init

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupView];
        [self setupConstraints];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupView];
        [self setupConstraints];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
        [self setupConstraints];
    }
    return self;
}

- (void)setupView {
    self.textField = [[FZPasswordTextField alloc] init];
    [self addSubview:self.textField];
    
    self.showPasswordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.showPasswordButton setImage:[UIImage imageNamed:@"icon_hidepassword"] forState:UIControlStateNormal];
    [self.showPasswordButton addTarget:self action:@selector(showPasswordButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.showPasswordButton];
    
}

- (void)setupConstraints {
    [self.showPasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(self.mas_height);
        make.trailing.equalTo(self);
        make.centerY.equalTo(self);
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.bottom.equalTo(self);
        make.trailing.equalTo(self.showPasswordButton.mas_leading);
    }];
}

//- (void)setNeedsLayout {
//    [super setNeedsLayout];
//    
//    [self setupConstraints];
//}
//
//- (void)setNeedsDisplay {
//    [super setNeedsDisplay];
//    
//    [self setupConstraints];
//}

#pragma mark - actions

- (void)showPasswordButtonClickAction:(UIButton *)button {
    self.passwordShown = !self.passwordShown;
    if (self.passwordShown) {
        NSString *text = self.textField.text;
        self.textField.secureTextEntry = NO;
        NSDictionary *attributes = @{NSFontAttributeName : [UIFont fontWithName:@"Courier" size:17.0f]};
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:text attributes:attributes];
        self.textField.attributedText = attrString;
        [self.showPasswordButton setImage:[UIImage imageNamed:@"icon_showpassword"] forState:UIControlStateNormal];
    } else {
        self.textField.secureTextEntry = YES;
        [self.showPasswordButton setImage:[UIImage imageNamed:@"icon_hidepassword"] forState:UIControlStateNormal];
    }
}



@end
