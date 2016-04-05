//
//  WeekSettingCityCell.m
//  EnglishTalk
//
//  Created by kim on 14/12/22.
//  Copyright (c) 2014年 ishowtalk. All rights reserved.
//

#import "WeekSettingCityCell.h"

@implementation WeekSettingCityCell

- (void)awakeFromNib {

    self.WeekSettingCityButton.layer.cornerRadius = self.WeekSettingCityButton.bounds.size.height/2.;  // 将图层的边框设置为圆脚
    self.WeekSettingCityButton.layer.masksToBounds = YES; // 隐藏边界
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
