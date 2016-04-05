//
//  ConfErrorViewController.m
//  JusTalk
//
//  Created by Cathy on 15/3/3.
//  Copyright (c) 2015年 juphoon. All rights reserved.
//

#import "ConfErrorViewController.h"
#import "ConfSettings.h"

#define kErrorTextMinHeight 30
#define kErrorTextInset UIEdgeInsetsMake(5, 20, 5, 20)
#define kCancelButtonWidth 40

@interface ConfErrorViewController () {
    BOOL _shouldAutorotate;
}

@end

@implementation ConfErrorViewController
@synthesize errorButton = _errorButton;

- (UIButton *)errorButton
{
    if (!_errorButton) {
        _errorButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, kErrorTextMinHeight)];
        _errorButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _errorButton.backgroundColor = [ConfSettings skinColor];
        _errorButton.titleLabel.textColor = [UIColor whiteColor];
        _errorButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _errorButton.titleLabel.numberOfLines = 0;
        _errorButton.titleEdgeInsets = kErrorTextInset;
        _errorButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [self.view addSubview:_errorButton];
    }
    
    return _errorButton;
}

- (UIButton *)cancelButton
{
    if (!_cancelButton) {
        CGSize size = self.errorButton.frame.size;
        _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(size.width - kCancelButtonWidth, 0, kCancelButtonWidth, size.height)];
        _cancelButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        _cancelButton.backgroundColor = [UIColor clearColor];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.errorButton addSubview:_cancelButton];
    }
    
    return _cancelButton;
}

- (void)setErrorText:(NSString *)text
{
    [self.errorButton setTitle:text forState:UIControlStateNormal];
    
    CGRect frame = self.errorButton.frame;
    CGSize size = [text sizeWithFont:self.errorButton.titleLabel.font constrainedToSize:CGSizeMake(frame.size.width, FLT_MAX) lineBreakMode:self.errorButton.titleLabel.lineBreakMode];
    if (size.height < kErrorTextMinHeight) {
        size.height = kErrorTextMinHeight;
    }
    frame.size.height = size.height;
    self.errorButton.frame = frame;
    
    [self.cancelButton setTitle:@"✕" forState:UIControlStateNormal];
}

- (id)initWithAutorotate:(BOOL)autorotate
{
    self = [super init];
    if (self) {
        // Custom initialization
        _shouldAutorotate = autorotate;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    } else {
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate
{
    return _shouldAutorotate;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
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
