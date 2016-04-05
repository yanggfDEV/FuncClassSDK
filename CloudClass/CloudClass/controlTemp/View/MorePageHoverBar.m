//
//  MorePageHoverBar.m
//  EnglishTalk
//
//  Created by DING FENG on 1/4/15.
//  Copyright (c) 2015 ishowtalk. All rights reserved.
//

#import "MorePageHoverBar.h"

@implementation MorePageHoverBar

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor =[UIColor colorWithRed:255./255 green:255./255 blue:255./255 alpha:0.95];
    self.contentView.backgroundColor =[UIColor colorWithRed:255./255 green:255./255 blue:255./255 alpha:0];
    //NSLog(@"awakeFromNibawakeFromNibawakeFromNibawakeFromNibawakeFromNibawakeFromNibawakeFromNibawakeFromNibawakeFromNibawakeFromNibawakeFromNibawakeFromNibawakeFromNibawakeFromNibawakeFromNibawakeFromNibawakeFromNibawakeFromNibawakeFromNibawakeFromNibawakeFromNibawakeFromNibawakeFromNibawakeFromNibawakeFromNibawakeFromNibawakeFromNibawakeFromNibawakeFromNibawakeFromNibawakeFromNibawakeFromNibawakeFromNibawakeFromNibawakeFromNibawakeFromNibawakeFromNibawakeFromNibawakeFromNibawakeFromNibawakeFromNibawakeFromNibawakeFromNibawakeFromNibawakeFromNibawakeFromNibawakeFromNibawakeFromNibawakeFromNibawakeFromNibawakeFromNibawakeFromNibawakeFromNibawakeFromNibawakeFromNibawakeFromNibawakeFromNibawakeFromNibawakeFromNibawakeFromNibawakeFromNibawakeFromNibawakeFromNib");
    
    
    
    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)changeLayOut{

    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        for (UIView *v in self.contentView.subviews) {
            if ([v  isKindOfClass:[UILabel  class]]||[v  isKindOfClass:[UIImageView  class]]) {
               
                if (self.typeLable.frame.origin.x<70) {
                    
                    v.center = CGPointMake(v.center.x+30, v.center.y);
                    
                }
            }
        }
        [self  layoutSubviews];
    });
    
}
@end
