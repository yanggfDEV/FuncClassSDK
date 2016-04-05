//
//  ButtonWithBottomBar.m
//  EnglishTalk
//
//  Created by DING FENG on 3/21/15.
//  Copyright (c) 2015 ishowtalk. All rights reserved.
//

#import "ButtonWithBottomBar.h"


@interface ButtonWithBottomBar()
{
    UIView  *bottomBar;

}

@end

@implementation ButtonWithBottomBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(void)setSelected:(BOOL)selected{

    [super  setSelected:selected];
    
    if (selected) {
        [bottomBar  removeFromSuperview];
        bottomBar = [[UIView  alloc]  initWithFrame:CGRectMake(0, self.frame.size.height-2, self.frame.size.width, 2)];
        bottomBar.backgroundColor =[UIColor colorWithRed:137./255 green:202./255 blue:57./255 alpha:1];
        [self  addSubview:bottomBar];
    }else{
        [bottomBar  removeFromSuperview];
    }


}

@end
