//
//  RapidResponseButton.m
//  EnglishTalk
//
//  Created by DING FENG on 9/24/14.
//  Copyright (c) 2014 ishowtalk. All rights reserved.
//

#import "RapidResponseButton.h"

@implementation RapidResponseButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.layer.cornerRadius =self.bounds.size.width/2.;  // 将图层的边框设置为圆脚
    self.layer.masksToBounds = YES; // 隐藏边界
    UIColor  *oldColor = self.backgroundColor;
    [UIView animateWithDuration:0.03 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.backgroundColor = [UIColor colorWithRed:82./255 green:168./255 blue:92./255 alpha:0.3];
    } completion:^(BOOL finished)
     {
         self.backgroundColor = oldColor;
         self.layer.cornerRadius =0;  // 将图层的边框设置为圆脚
         self.layer.masksToBounds = NO; // 隐藏边界
     }];
    [super touchesBegan:touches withEvent:event];
}


@end
