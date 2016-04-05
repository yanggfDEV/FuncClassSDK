//
//  UserFansTableViewCell.h
//  EnglishTalk
//
//  Created by DING FENG on 10/14/14.
//  Copyright (c) 2014 ishowtalk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserFansTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *signature;
@property (weak, nonatomic) IBOutlet UIButton *followBtn;
@property (weak, nonatomic) IBOutlet UILabel *shows;
@property  (nonatomic,strong)  NSDictionary  *infoDict;




@property (weak, nonatomic) IBOutlet UIImageView *micIcon;




@end
