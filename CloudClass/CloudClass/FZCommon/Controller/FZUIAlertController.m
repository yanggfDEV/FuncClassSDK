//
//  FZUIAlertController.m
//  EnglishTalk
//
//  Created by 周咏 on 15/10/29.
//  Copyright © 2015年 Feizhu Tech. All rights reserved.
//

#import "FZUIAlertController.h"

@implementation FZUIAlertController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.tintColor =[FZStyleSheet currentStyleSheet].funClassMainColor;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeRight;
}

@end
