//
//  ConfActionView.m
//  JusTalk
//
//  Created by Cathy on 14-8-6.
//  Copyright (c) 2014年 juphoon. All rights reserved.
//

#import "ConfActionView.h"

@implementation ConfActionView
@synthesize button = _button, label = _label;

- (BOOL)selected
{
    return self.button.selected;
}

- (void)setSelected:(BOOL)selected
{
    self.button.selected = selected;
}

- (void)setEnabled:(BOOL)enabled
{
    self.button.enabled = enabled;
    self.label.textColor = enabled ? [UIColor whiteColor] : [UIColor lightTextColor];
}

- (void)setText:(NSString *)text
{
    self.label.text = text;
}

- (void)setImage:(NSString *)image
{
    [self.button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
