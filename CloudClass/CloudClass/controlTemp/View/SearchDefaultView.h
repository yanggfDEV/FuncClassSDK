//
//  SearchDefaultView.h
//  EnglishTalk
//
//  Created by DING FENG on 9/24/14.
//  Copyright (c) 2014 ishowtalk. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef void(^HashTagBlock)(NSString  *title);

@interface SearchDefaultView : UIView
@property (weak, nonatomic) IBOutlet UIButton *hotWord0;
@property (weak, nonatomic) IBOutlet UIButton *hotWord1;
@property (weak, nonatomic) IBOutlet UIButton *hotWord2;
@property (weak, nonatomic) IBOutlet UIButton *hotWord3;
@property (weak, nonatomic) IBOutlet UIButton *hotWord4;


@property (weak, nonatomic) IBOutlet UILabel *searchLabel;

@property (weak, nonatomic) IBOutlet UILabel *tag0;

@property (weak, nonatomic) IBOutlet UILabel *tag1;

@property (weak, nonatomic) IBOutlet UILabel *tag2;

@property (weak, nonatomic) IBOutlet UILabel *tag3;

@property (weak, nonatomic) IBOutlet UILabel *tag4;


@property (nonatomic,strong)  HashTagBlock  hashTagBlock;

@end
