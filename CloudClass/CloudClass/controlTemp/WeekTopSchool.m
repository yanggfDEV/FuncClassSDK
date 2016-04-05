//
//  WeekTopSchool.m
//  EnglishTalk
//
//  Created by kim on 14/12/22.
//  Copyright (c) 2014年 ishowtalk. All rights reserved.
//

#import "WeekTopSchool.h"
//#import "UserPromotionViewController.h"

@implementation WeekTopSchool

- (void)awakeFromNib {

    self.WeekTopSchoolButton.layer.cornerRadius = self.WeekTopSchoolButton.bounds.size.height/2.;  // 将图层的边框设置为圆脚
    self.WeekTopSchoolButton.layer.masksToBounds = YES; // 隐藏边界
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
