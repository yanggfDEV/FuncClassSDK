//
//  UserFansTableViewCell.m
//  EnglishTalk
//
//  Created by DING FENG on 10/14/14.
//  Copyright (c) 2014 ishowtalk. All rights reserved.
//

#import "UserFansTableViewCell.h"
@implementation UserFansTableViewCell
- (void)awakeFromNib {
    // Initialization code
    self.avatar.layer.cornerRadius = self.avatar.frame.size.width/2.;  // 将图层的边框设置为圆脚
    self.avatar.layer.masksToBounds = YES; // 隐藏边界
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self addGestureRecognizer:tap];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

-(void)layoutSubviews{
    
     self.followBtn.alpha = 1;
    
    
    int is_follow = [[self.infoDict   objectForKey:@"is_follow"]  intValue];
    int is_following = [[self.infoDict    objectForKey:@"is_following"]  intValue];
    
    if (is_following==0)
    {
        [self.followBtn  setTitle:@"关注" forState:UIControlStateNormal];
    }else{
        [self.followBtn  setTitle:@"已关注" forState:UIControlStateNormal];
    }
    if (is_follow+is_following==2) {
        
        [self.followBtn  setTitle:@"相互关注" forState:UIControlStateNormal];
        if ([[self.infoDict   objectForKey:@"uid"]   intValue]==[[FZLoginUser userID] intValue]) {
            self.followBtn.alpha = 0;
        }
    }
    
    
    
    
    
    
}
- (IBAction)followButton:(UIButton *)sender {
    
    NSLog(@"%@",sender.titleLabel.text);
    NSMutableDictionary *d= [[NSMutableDictionary  alloc] init];
    [d setValue:[NSString stringWithFormat:@"%@",sender.titleLabel.text] forKey:@"buttonTitle"];
    [d setValue:self.infoDict forKey:@"userInfo"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Notice_followBtnTap" object:nil userInfo:d];
}
-(void)tap:(id)sender{
    NSLog(@"taptaptaptaptap%@",self.infoDict);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Notice_FansCellTaped" object:nil userInfo:self.infoDict];
}

@end
