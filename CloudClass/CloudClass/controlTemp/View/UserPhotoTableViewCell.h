//
//  UserPhotoTableViewCell.h
//  EnglishTalk
//
//  Created by DING FENG on 10/14/14.
//  Copyright (c) 2014 ishowtalk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserPhotoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imag0;
@property (weak, nonatomic) IBOutlet UIImageView *imag1;
@property (weak, nonatomic) IBOutlet UIImageView *imag2;


@property (nonatomic)   int   indexNum;
@property (nonatomic)   int   lastPhotoNum;
@property  (nonatomic,strong)  NSArray   *imgUrlArray;


@end
