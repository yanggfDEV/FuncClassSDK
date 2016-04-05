//
//  TopShowTableViewCell.h
//  EnglishTalk
//
//  Created by DING FENG on 10/28/14.
//  Copyright (c) 2014 ishowtalk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopShowTableViewCell : UITableViewCell
@property  (nonatomic,strong)   NSDictionary *attachData;
@property  (nonatomic,strong)   UIImageView *coverImageView;
@property  (nonatomic,strong)   UILabel *titleLabel;
@property  (nonatomic,strong)   UILabel *hotLabel;
@property  (nonatomic,strong)   UILabel *authorLabel;
@property  (nonatomic,strong)   UILabel *descriptionLabel;
@property  (nonatomic,strong)   NSString *cellType;  //两种cell   course   and  show  ！！！  //?
@property  (nonatomic,strong)   UIImageView *avatar;
@property  (nonatomic,strong)   UILabel *namelabel;
@property  (nonatomic,strong)   UILabel *ranklabel;
@property  (nonatomic,strong)   UILabel *collegeName;
@property  (nonatomic,strong)   UILabel *commentNum;
@property  (nonatomic,strong)   UILabel *timeMark;

-(void)clearContents;


-(void)addTheSubViews;

@end
