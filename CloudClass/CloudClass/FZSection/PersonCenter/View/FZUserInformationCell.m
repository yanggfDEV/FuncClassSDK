//
//  FZUserInformationCell.m
//  CloudClass
//
//  Created by guangfu yang on 16/1/28.
//  Copyright © 2016年 yangguangfu. All rights reserved.
//

#import "FZUserInformationCell.h"

@interface FZUserInformationCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;

@end

@implementation FZUserInformationCell

- (void)awakeFromNib {
    FZStyleSheet *css = [[FZStyleSheet alloc] init];
    self.titleLabel.textColor = css.colorOfListTitle;
    self.titleLabel.font = css.fontOfH7;
    self.nameLabel.textColor = css.colorOfListTitle;
    self.nameLabel.font = css.fontOfH7;
    self.headImage.layer.cornerRadius = 17;
    self.headImage.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellData:(FZUserCenterModel *)model {
    self.titleLabel.text = model.title;
    if ([model.identifier isEqualToString:@"user_head"]) {
        self.nameLabel.hidden = YES;
        [self.headImage sd_setImageWithURL:[NSURL URLWithString:[FZLoginUser avatar]] placeholderImage:[UIImage imageNamed:@"yueke_img_head"] completed:nil];
    } else {
        self.headImage.hidden = YES;
        self.nameLabel.text = [FZLoginUser nickname];
    }
}

@end
