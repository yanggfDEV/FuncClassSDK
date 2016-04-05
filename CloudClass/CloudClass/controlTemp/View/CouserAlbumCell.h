//
//  CouserAlbumCell.h
//  EnglishTalk
//
//  Created by DING FENG on 10/9/14.
//  Copyright (c) 2014 ishowtalk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CouserAlbumCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *discription;
@property (weak, nonatomic) IBOutlet UILabel *views;

@property (weak, nonatomic) IBOutlet UIButton *collectionBtn;
@property (weak, nonatomic) IBOutlet UIButton *downBtn;
@property (weak, nonatomic) IBOutlet UIImageView *heartIcon;
@property (weak, nonatomic) IBOutlet UIImageView *downIcon;
@property (nonatomic,strong)  NSDictionary *courseInfoDict;






@end
