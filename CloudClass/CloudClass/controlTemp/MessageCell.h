//
//  MessageCell.h
//  EnglishTalk
//
//  Created by DING FENG on 8/6/14.
//  Copyright (c) 2014 ishowtalk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarIV;
@property (weak, nonatomic) IBOutlet UILabel *fromLabel;
@property (weak, nonatomic) IBOutlet UITextView *messageContent;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property  (nonatomic,strong)   NSDictionary  *infoDict;

@property (copy, nonatomic) void (^headerImageClickedBlock)(NSDictionary *);

@end
