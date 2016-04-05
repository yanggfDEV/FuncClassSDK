//
//  LatestShowCell.m
//  EnglishTalk
//
//  Created by DING FENG on 9/25/14.
//  Copyright (c) 2014 ishowtalk. All rights reserved.
//

#import "LatestShowCell.h"
@implementation LatestShowCell


- (void)awakeFromNib {
    // Initialization code
    self.avatarImageView.layer.cornerRadius = self.avatarImageView.bounds.size.height/2.;  // 将图层的边框设置为圆脚
    self.avatarImageView.layer.masksToBounds = YES; // 隐藏边界
    self.discripthion.scrollEnabled = NO;
    self.discripthion.editable = NO;
    self.courserCoverImg.clipsToBounds =YES;
    self.avatarImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *avatarTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarTap:)];
    [self.avatarImageView  addGestureRecognizer:avatarTap];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)clear{
    self.avatarImageView.image = nil;
    self.courserCoverImg.image = nil;
    self.authorName.text = nil;
    self.courseTitle.text = nil;
    self.discripthion.text = nil;
    self.timeLabel.text = nil;
    self.clickNum.text = nil;
    self.likedNum.text = nil;
    self.commentNum.text = nil;
}

-(void)avatarTap:(id)sender{
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.avatarImageView.alpha = 0.2;
    } completion:^(BOOL finished)
     {
         self.avatarImageView.alpha = 1;
         if (self.infoDict) {
             [[NSNotificationCenter defaultCenter] postNotificationName:@"Notice_LatestShowCellAvatarTaped" object:nil userInfo:self.infoDict];
         }
     }];
}


@end
