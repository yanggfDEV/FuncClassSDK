//
//  SearchNoResultView.h
//  EnglishTalk
//
//  Created by DING FENG on 1/6/15.
//  Copyright (c) 2015 ishowtalk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchNoResultView : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *replyButton;

@property (nonatomic,weak) IBOutlet UILabel * hotView;
@property (nonatomic,weak) IBOutlet UIView * line;

@end
