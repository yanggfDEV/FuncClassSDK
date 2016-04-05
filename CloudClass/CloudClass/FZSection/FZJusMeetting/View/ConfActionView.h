//
//  ConfActionView.h
//  JusTalk
//
//  Created by Cathy on 14-8-6.
//  Copyright (c) 2014年 juphoon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfActionView : UIView

@property (nonatomic, retain) IBOutlet UIButton *button;
@property (nonatomic, retain) IBOutlet UILabel *label;

- (BOOL)selected;
- (void)setSelected:(BOOL)selected;
- (void)setEnabled:(BOOL)enabled;

- (void)setText:(NSString *)text;
- (void)setImage:(NSString *)image;

@end
