//
//  searchCells.h
//  EnglishTalk
//
//  Created by apple on 15/4/15.
//  Copyright (c) 2015年 ishowtalk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface searchCells : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel1;
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView1;
@property (strong, nonatomic) UILabel *viewsLabel1;
@property (weak, nonatomic) IBOutlet UIImageView *sectionTagImg1;
@property (weak, nonatomic) IBOutlet UIImageView *micPhoneIcon1;
@property (strong,nonatomic)   NSDictionary *infoDict1;


@property (weak, nonatomic) IBOutlet UILabel *titleLabel2;
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView2;
@property (strong, nonatomic) UILabel *viewsLabel2;
@property (weak, nonatomic) IBOutlet UIImageView *sectionTagImg2;
@property (weak, nonatomic) IBOutlet UIImageView *micPhoneIcon2;
@property (strong,nonatomic)   NSDictionary *infoDict2;


@property (nonatomic,strong)NSString * groupID;

@property (nonatomic,strong) NSArray * array;


@property (nonatomic) BOOL isSelected1;
@property (nonatomic) BOOL isSelected2;

- (void)reloadData;

@end
