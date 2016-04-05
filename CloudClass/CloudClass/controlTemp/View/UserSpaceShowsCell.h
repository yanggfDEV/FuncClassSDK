//
//  UserSpaceShowsCell.h
//  EnglishTalk
//
//  Created by DING FENG on 10/14/14.
//  Copyright (c) 2014 ishowtalk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserSpaceShowsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *coverImag;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *comment;
@property (weak, nonatomic) IBOutlet UILabel *liked;



@end
