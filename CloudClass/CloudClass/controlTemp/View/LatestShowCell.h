//
//  LatestShowCell.h
//  EnglishTalk
//
//  Created by DING FENG on 9/25/14.
//  Copyright (c) 2014 ishowtalk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LatestShowCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *authorName;
@property (weak, nonatomic) IBOutlet UIImageView *courserCoverImg;
@property (weak, nonatomic) IBOutlet UILabel *courseTitle;
@property (weak, nonatomic) IBOutlet UITextView *discripthion;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *clickNum;
@property (weak, nonatomic) IBOutlet UILabel *commentNum;
@property (weak, nonatomic) IBOutlet UILabel *likedNum;




@property (weak, nonatomic) IBOutlet UIImageView *triangleMask;

@property (weak, nonatomic) IBOutlet UIImageView *whiteBlockMask1;
@property (weak, nonatomic) IBOutlet UIImageView *whiteBlockMask2;


@property  (strong,nonatomic)   NSDictionary  *infoDict;


-(void)clear;
@end
