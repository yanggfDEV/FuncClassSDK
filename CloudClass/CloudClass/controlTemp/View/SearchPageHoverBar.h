//
//  MorePageHoverBar.h
//  EnglishTalk
//
//  Created by DING FENG on 1/4/15.
//  Copyright (c) 2015 ishowtalk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchPageHoverBar : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UILabel *hotLevel;

@property (weak, nonatomic) IBOutlet UIButton *pullButton;




@property (weak, nonatomic) IBOutlet UILabel *typeLable;

@property (weak, nonatomic) IBOutlet UILabel *typeDotLabel;





-(void)changeLayOut;

@end
