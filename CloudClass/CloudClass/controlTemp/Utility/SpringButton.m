//
//  SpringButton.m
//  EnglishTalk
//
//  Created by DING FENG on 7/26/14.
//  Copyright (c) 2014 ishowtalk. All rights reserved.
//

#import "SpringButton.h"

@implementation SpringButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [UIView animateWithDuration:0.01 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.transform = CGAffineTransformMakeScale(0.86, 0.86);
    } completion:^(BOOL finished)
     {
         [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
             self.transform = CGAffineTransformMakeScale(1., 1.);
         } completion:^(BOOL finished)
          {}];
     }];
    [super touchesBegan:touches withEvent:event];
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
