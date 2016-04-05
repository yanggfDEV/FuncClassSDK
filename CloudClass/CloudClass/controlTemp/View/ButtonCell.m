//
//  ButtonCell.m
//  EnglishTalk
//
//  Created by DING FENG on 9/22/14.
//  Copyright (c) 2014 ishowtalk. All rights reserved.
//

#import "ButtonCell.h"

@implementation ButtonCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.title = [[UILabel  alloc]  initWithFrame:self.bounds];
        self.title.textAlignment = NSTextAlignmentCenter;
        self.title.textColor = [UIColor  grayColor];
        self.title.backgroundColor =[UIColor  clearColor];
         self.layer.borderWidth = 0.5;  // 给图层添加一个有色边框
         self.layer.borderColor = [UIColor colorWithRed:201./255 green:201./255 blue:201./255 alpha:0.5].CGColor;
        [self  addSubview:self.title];
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.title.backgroundColor = [UIColor  greenColor];
    } completion:^(BOOL finished)
     {
         
         self.title.backgroundColor = [UIColor  clearColor];
     }];
    
    
    // NSLog(@" self.attachData %@",self.attachData);
    
    [super touchesBegan:touches withEvent:event];
}
@end
