//
//  FCChatListCell.m
//  FunChat
//
//  Created by Jyh on 15/10/12.
//  Copyright © 2015年 FeiZhu Tech. All rights reserved.
//

#import "FCChatListCell.h"
#import <UIColor+Hex.h>
#import "UIImageView+WebCache.h"
#import <Masonry.h>
#import "FCChatModelConvertHandler.h"
#import "FCChatListViewController.h"
#import "FZUtils.h"

@implementation FCChatListCell

- (void)awakeFromNib {
    // Initialization code
    self.nicknameLabel.text = @"";
    self.timeLabel.text = @"";
    self.subContentLabel.text = @"";
    self.bubbleLabel.text =@"";
    self.avatarImage.layer.cornerRadius = 8;
    self.avatarImage.layer.masksToBounds = YES;
    self.avatarImage.contentMode = UIViewContentModeScaleAspectFill;
    
    self.bubbleLabel.layer.cornerRadius = CGRectGetWidth(self.bubbleLabel.frame)/2;
    self.bubbleLabel.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];

    if (highlighted) {
        self.backgroundColor = [UIColor colorWithHexString:@"efeff4"];
        self.bubbleLabel.backgroundColor = [UIColor colorWithHexString:@"f94427"];
    } else {
        self.backgroundColor = [UIColor whiteColor];
    }
}

- (void)configureViewWithData:(FCChatListModel *)model type:(ShowType)type
{
    if (_model !=model) {
        _model = model;
    }
    // 显示app logo
    if ([model.targetAvatarUrl length] == 0 && [model.targetAvatarImageName length] > 0) {
        self.avatarImage.image = [UIImage imageNamed:@"icon_logo"];
    } else {
        NSArray *avatarArray = [model.targetAvatarUrl componentsSeparatedByString:@"."];
        if ([[avatarArray lastObject] isEqualToString:@"jpg"]) {
            [self.avatarImage sd_setImageWithURL:[NSURL URLWithString:model.targetAvatarUrl] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
        } else {
            self.avatarImage.image = [UIImage imageNamed:@"icon_logo"];
        }
    }
    
    self.nicknameLabel.text = [self getSubStrWithString:model.targetNickname withFont:17];
    NSString *redCount = nil;
    // 规则：99以及以下显示数字，以上只显示红点
    if ([model.messageCount integerValue] > 99 && model.messageCount) {
        [self.bubbleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(58);
            make.top.equalTo(self.mas_top).offset(10);
            make.width.equalTo(@12);
            make.height.equalTo(@12);
        }];
        redCount = @"";
        self.bubbleLabel.layer.cornerRadius = 6;
        self.bubbleLabel.hidden = NO;
    } else if ([model.messageCount integerValue] > 0) {
        [self.bubbleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(52);
            make.top.equalTo(self.mas_top).offset(8);
            make.width.equalTo(@20);
            make.height.equalTo(@20);
        }];
        self.bubbleLabel.layer.cornerRadius = CGRectGetWidth(self.bubbleLabel.frame)/2;
        self.bubbleLabel.hidden = NO;
        redCount = model.messageCount;
    } else {
        self.bubbleLabel.hidden = YES;
    }
    
    self.bubbleLabel.text = redCount;
    self.timeLabel.text = [FCChatModelConvertHandler getMonthTime:model.time isChStyle:(type == StudentType)];
    self.subContentLabel.text = model.subContent;
}

/**
 * @guangfu yang 15-12-25
 * 名称限制
 **/
- (NSString *)getSubStrWithString: (NSString *)string withFont:(CGFloat)font{
    
    NSArray *array = [string componentsSeparatedByString:@" "];
    NSString *lastNameStr = [NSString stringWithFormat:@"... %@", [array lastObject]];
    CGRect rect = [self getRectwithString:string withFont:font withWidth:MAXFLOAT];
    float widthFloat = [FZUtils GetScreeWidth] > 320 ? 145: 120;
    if (rect.size.width > widthFloat) {
        NSString *temp = @"";
        for(int i =0 ; i < [string length]; i++)
        {
            NSString *tempStr = [string substringWithRange:NSMakeRange(i, 1)];
            temp = [temp stringByAppendingString:tempStr];
            CGRect comentRect = [self getRectwithString:temp withFont:font withWidth:MAXFLOAT];
            if (comentRect.size.width > (widthFloat - 15 - [self getRectwithString:lastNameStr withFont:font withWidth:MAXFLOAT].size.width)) {
                NSString *logStr = [NSString stringWithFormat:@"%@... %@", temp, [array lastObject]];
                return logStr;
            }
            
        }
    }
    return string;
}

- (CGRect)getRectwithString:(NSString *)string withFont:(CGFloat)font withWidth:(CGFloat)width
{
    CGRect rect=[string boundingRectWithSize:CGSizeMake(width, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    
    return rect;
}




@end
