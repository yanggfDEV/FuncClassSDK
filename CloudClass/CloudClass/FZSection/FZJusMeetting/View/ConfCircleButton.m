//
//  ConfCircleButton.m
//  JusTalk
//
//  Created by Cathy on 14-8-14.
//  Copyright (c) 2014年 juphoon. All rights reserved.
//

#import "ConfCircleButton.h"
#import "ConfUIImage+Tint.h"

@implementation ConfCircleButton

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    
    self.layer.borderColor = enabled ? [[UIColor whiteColor] CGColor] : [[[UIColor whiteColor] colorWithAlphaComponent:0.3] CGColor];
}

- (void)awakeFromNib
{
    self.adjustsImageWhenHighlighted = NO;
    
    self.clipsToBounds = YES;
    self.layer.cornerRadius = self.frame.size.width / 2;
    self.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.layer.borderWidth = IS_IPAD ? 1.5f : 1.0f;
    
    UIImage *image = [self imageForState:UIControlStateNormal];
    [self setImage:[image confImageWithColor:[UIColor blackColor]] forState:UIControlStateSelected];
    
    CGSize size = self.frame.size;
    [self setBackgroundImage:[UIImage confColoredImage:[UIColor clearColor] size:size] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage confColoredImage:[[UIColor whiteColor] colorWithAlphaComponent:0.5] size:size] forState:UIControlStateHighlighted];
    [self setBackgroundImage:[UIImage confColoredImage:[UIColor whiteColor] size:size] forState:UIControlStateSelected];
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
