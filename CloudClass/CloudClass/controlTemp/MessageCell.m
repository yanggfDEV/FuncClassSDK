//
//  MessageCell.m
//  EnglishTalk
//
//  Created by DING FENG on 8/6/14.
//  Copyright (c) 2014 ishowtalk. All rights reserved.
//

#import "MessageCell.h"
//#import "PureLayout.h"

@implementation MessageCell

- (void)awakeFromNib
{
    // Initialization code
    self.avatarIV.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.avatarIV  addGestureRecognizer:tap];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}
-(void)tap:(id)sender{
    [UIView animateWithDuration:0.05 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.avatarIV.alpha = 0.3;
    } completion:^(BOOL finished)
     {
         self.avatarIV.alpha = 1;
         if (self.infoDict)
         {
             self.headerImageClickedBlock(self.infoDict);
             //[[NSNotificationCenter defaultCenter] postNotificationName:@"Notice_AvatarImagPressed" object:nil userInfo:self.infoDict];
         }
     }];
}




@end
