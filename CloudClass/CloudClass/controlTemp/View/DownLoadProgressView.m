//
//  DownLoadProgressView.m
//  EnglishTalk
//
//  Created by DING FENG on 6/7/14.
//  Copyright (c) 2014 ishowtalk. All rights reserved.
//

#import "DownLoadProgressView.h"
#import "UIImage+plus.h"

@interface DownLoadProgressView()

@property (strong, nonatomic)UILabel  *vedioLabel;
@property (strong, nonatomic)UILabel  *audioLable;
@property (strong, nonatomic)UIImageView  *progressImageView;

@end



@implementation DownLoadProgressView



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor  blackColor];
        self.audioProgressLable = [[UILabel  alloc]  initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height/2.)];
        self.audioProgressLable.backgroundColor = [UIColor  clearColor];
        self.audioProgressLable.textColor = [UIColor  lightGrayColor];
        [self.audioProgressLable  setFont:[UIFont  boldSystemFontOfSize:12]];
        [self.audioProgressLable  setTextAlignment:NSTextAlignmentLeft];
        self.audioProgressLable.text = @"背景音乐：0M/0M";
        self.videoProgressLable = [[UILabel  alloc]  initWithFrame:CGRectMake(0, frame.size.height/2, frame.size.width, frame.size.height/2.)];
        self.videoProgressLable.backgroundColor = [UIColor  clearColor];
        self.videoProgressLable.textColor = [UIColor  lightGrayColor];
        [self.videoProgressLable  setFont:[UIFont  boldSystemFontOfSize:12]];
        [self.videoProgressLable  setTextAlignment:NSTextAlignmentLeft];
        self.videoProgressLable.text = @"视频材料：0M/0M";
        
        self.backImagView = [[UIImageView  alloc]  initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.backImagView.contentMode = UIViewContentModeScaleAspectFill;
        self.backImagView.alpha = 0.3;
        self.backImagView.clipsToBounds = YES;
        self.backImagView.backgroundColor = [UIColor  blackColor];
        [self  addSubview:self.backImagView];
       // 440 168
        self.progressImageView = [[UIImageView  alloc]  initWithFrame:CGRectMake(0, 0, [FZUtils  GetScreeWidth]-40, 4)];
        self.progressImageView.center   = CGPointMake(frame.size.width/2., frame.size.height-4-30);
        self.progressImageView.backgroundColor =[UIColor  lightGrayColor];
        [self  addSubview:self.progressImageView];
        self.vedioLabel = [[UILabel  alloc]  initWithFrame:CGRectMake(0, 0, 62/2., 36/2.)];
        self.vedioLabel.backgroundColor = [UIColor  colorWithPatternImage:[UIImage   imageWithImage:[UIImage  imageNamed:@"mv"] scaledToSize:CGSizeMake(62/2., 36/2.)   ]];
        self.audioLable = [[UILabel  alloc]  initWithFrame:CGRectMake(0, 0, 62/2., 47/2.)];
        self.audioLable.backgroundColor = [UIColor  colorWithPatternImage:[UIImage   imageWithImage:[UIImage  imageNamed:@"mu"] scaledToSize:CGSizeMake(62/2., 47/2.)   ]];
        self.vedioLabel.center  = CGPointMake(0, self.progressImageView.frame.size.height/2.+10);
        self.audioLable.center  = CGPointMake(0, self.progressImageView.frame.size.height/2.-10);
        self.vedioLabel.textAlignment = NSTextAlignmentLeft;
        self.audioLable.textAlignment = NSTextAlignmentLeft;
        self.audioLable.textColor = [UIColor  whiteColor];
        self.vedioLabel.textColor = [UIColor  whiteColor];
        self.audioLable.font = [UIFont  boldSystemFontOfSize:8];
        self.vedioLabel.font = [UIFont  boldSystemFontOfSize:8];
        [self.progressImageView  addSubview:self.vedioLabel];
        [self.progressImageView  addSubview:self.audioLable];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


-(void)updataAudioProgress:(NSString *)AudioProgress
{
    float  X =  [AudioProgress    floatValue]/100.  *(self.progressImageView.frame.size.width);
    self.audioLable.center  = CGPointMake(X, self.progressImageView.frame.size.height/2.-10);
    AudioProgress = [NSString  stringWithFormat:@"       %@",AudioProgress];
    if (AudioProgress) {
        self.audioLable.text =AudioProgress;
        self.audioProgressLable.text =AudioProgress;
    }
    else
    {
        self.audioProgressLable.text =@"背景音乐：N/A";
    }
}
-(void)updataVideoProgress:(NSString *)VideoProgress
{
    float  X =  [VideoProgress    floatValue]/100.  *(self.progressImageView.frame.size.width);
    self.vedioLabel.center  = CGPointMake(X, self.progressImageView.frame.size.height/2.+10);
    VideoProgress = [NSString  stringWithFormat:@"       %@",VideoProgress];
    if (VideoProgress) {
        self.videoProgressLable.text =VideoProgress;
        self.vedioLabel.text =VideoProgress;
    }
    else
    {
        self.videoProgressLable.text =@"背景音乐：N/A";
    }
}


-(void)layoutSubviews
{
    self.progressImageView.center   = CGPointMake(self.frame.size.width/2., self.frame.size.height-4-30);
}

@end
