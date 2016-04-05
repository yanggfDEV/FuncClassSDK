//
//  DownLoadProgressView.h
//  EnglishTalk
//
//  Created by DING FENG on 6/7/14.
//  Copyright (c) 2014 ishowtalk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DownLoadProgressView : UIView

@property   (nonatomic,strong) UILabel *audioProgressLable;
@property   (nonatomic,strong) UILabel *videoProgressLable;
@property   (nonatomic,strong) UIImageView *backImagView;

//-(void)update:(NSString *)AudioPrograss  video:(NSString *)videoPrograss;

-(void)updataAudioProgress:(NSString *)AudioProgress;
-(void)updataVideoProgress:(NSString *)VideoProgress;

@end
