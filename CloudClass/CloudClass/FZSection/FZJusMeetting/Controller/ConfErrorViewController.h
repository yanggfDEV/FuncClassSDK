//
//  ConfErrorViewController.h
//  JusTalk
//
//  Created by Cathy on 15/3/3.
//  Copyright (c) 2015年 juphoon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfErrorViewController : UIViewController

@property (nonatomic, retain) UIButton *errorButton;
@property (nonatomic, retain) UIButton *cancelButton;

- (id)initWithAutorotate:(BOOL)autorotate;
- (void)setErrorText:(NSString *)text;

@end
