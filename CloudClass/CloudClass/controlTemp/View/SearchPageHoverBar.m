//
//  MorePageHoverBar.m
//  EnglishTalk
//
//  Created by DING FENG on 1/4/15.
//  Copyright (c) 2015 ishowtalk. All rights reserved.
//

#import "SearchPageHoverBar.h"

@implementation SearchPageHoverBar

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor =[UIColor colorWithRed:255./255 green:255./255 blue:255./255 alpha:0.95];
    self.contentView.backgroundColor =[UIColor colorWithRed:255./255 green:255./255 blue:255./255 alpha:0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)changeLayOut{

    
}
@end
