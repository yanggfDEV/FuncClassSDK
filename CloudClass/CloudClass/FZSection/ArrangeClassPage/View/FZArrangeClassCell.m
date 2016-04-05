//
//  FZArrangeClassCell.m
//  CloudClass
//
//  Created by guangfu yang on 16/1/27.
//  Copyright © 2016年 yangguangfu. All rights reserved.
//

#import "FZArrangeClassCell.h"

@interface FZArrangeClassCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation FZArrangeClassCell

- (void)awakeFromNib {
    FZStyleSheet *css = [[FZStyleSheet alloc] init];
    self.headImage.layer.cornerRadius = 5;
    self.headImage.layer.masksToBounds = YES;
    self.headImage.contentMode = UIViewContentModeScaleAspectFill;
    self.headImage.clipsToBounds = YES;
    
    self.nameLabel.textColor = css.colorOfListTitle;
    self.nameLabel.font = css.fontOfH7;
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setCellData:(FZArrangeClassTeacherModel *)model {
    if (model.avatar) {
        [self.headImage sd_setImageWithURL:[NSURL URLWithString:[model.avatar stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"yueke_img_head"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        }];
    } else {
        self.headImage.image = [UIImage imageNamed:@"yueke_img_head"];
    }
    
    if (model.nickName) {
        self.nameLabel.text = model.nickName;
    }
}

@end
