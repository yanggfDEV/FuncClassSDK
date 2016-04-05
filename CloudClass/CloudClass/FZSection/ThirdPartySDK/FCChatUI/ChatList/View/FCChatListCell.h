//
//  FCChatListCell.h
//  FunChat
//
//  Created by Jyh on 15/10/12.
//  Copyright © 2015年 FeiZhu Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FCChatListModel.h"

typedef enum : NSUInteger {
    StudentType,
    TeacherType,
    FubDubbingType
} ShowType;

@interface FCChatListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;

@property (weak, nonatomic) IBOutlet UILabel *bubbleLabel;

@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;

@property (weak, nonatomic) IBOutlet UILabel *subContentLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (strong, nonatomic) FCChatListModel *model;

//@property (strong, nonatomic) UIColor *selectedBackgroundColor;

/**
 *  配置页面数据
 *
 *  @param model 数据model
 */
- (void)configureViewWithData:(FCChatListModel *)model type:(ShowType)type;

@end
