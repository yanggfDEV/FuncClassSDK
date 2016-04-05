//
//  CountdownButton.h
//  EnglishTalk
//
//  Created by DING FENG on 8/16/14.
//  Copyright (c) 2014 ishowtalk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CountdownButton : UIButton

@property  (nonatomic,strong) UILabel  *timelabel;
@property  (nonatomic,strong) NSTimer  *timer;


-(void)resetTheState;

@end
