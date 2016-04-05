//
//  CommentAudioPlayView.m
//  EnglishTalk
//
//  Created by DING FENG on 12/16/14.
//  Copyright (c) 2014 ishowtalk. All rights reserved.
//

#import "CommentAudioPlayView.h"
#import <AVFoundation/AVFoundation.h>



#define  NoticeDidPlay   @"NoticeDidPlay"
#define  NoticeEndPlay   @"NoticeEndPlay"


#define defaultWidth  (200-40)
@interface CommentAudioPlayView()<AVAudioPlayerDelegate>
{
    UIImageView  *_backImgView;
    UIImageView  *_wifi_static;
    UIImageView  *_wifi_gif;
    NSString  *_audioLength;
    AVAudioPlayer   *player;
    UIButton  *playButton;
    AVPlayer *anAudioStreamer;
    AVPlayerItem *aPlayerItem;
    NSString  *_backImgName;
    NSString  *_wifi_static_string;
    NSString  *_wifi_gif_string;
    UIView  *audioUnReadSign;
}
@end

@implementation CommentAudioPlayView
@synthesize audioLength=_audioLength;
@synthesize backImgName=_backImgName;
@synthesize wifi_gif=_wifi_gif;
@synthesize wifi_static=_wifi_static;
@synthesize wifi_gif_string =_wifi_gif_string;
@synthesize wifi_static_string =_wifi_static_string;
@synthesize secendsLabel=_secendsLabel;
@synthesize color_string=_color_string;
@synthesize backImgView=_backImgView;

- (id)init
{
    
    
    FZLog(@"FZLog----------------");
    self = [super init];
    if (self)
    {
        self.frame = CGRectMake(0, 0, defaultWidth, 30);
        _backImgName =@"语音条1秒底板@2x.png";
        _wifi_static_string =@"wifi_static";
        _wifi_gif_string =@"wifi.gif";
        self.backgroundColor = [UIColor  clearColor];
       // self.userInteractionEnabled=YES;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    FZLog(@"FZLog----------------");

    self = [super initWithFrame:frame];
    if (self)
    {
        self.frame = CGRectMake(0, 5, defaultWidth, 35);
        _backImgName =@"语音条1秒底板@2x.png";
        _wifi_static_string =@"wifi_static";
        _wifi_gif_string =@"wifi.gif";

        self.backgroundColor = [UIColor  clearColor];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NoticeDidPlay_fun:) name:NoticeDidPlay object:nil];

    }
    return self;
}

- (id)initWithPointX:(NSInteger)pointX pointY:(NSInteger)pointY width:(NSInteger)width{
    self = [super initWithFrame:CGRectMake(pointX, pointY, width, 35)];
    if (self)
    {
        _backImgName =@"语音条1秒底板@2x.png";
        _wifi_static_string =@"wifi_static";
        _wifi_gif_string =@"wifi.gif";
        self.backgroundColor = [UIColor  clearColor];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NoticeDidPlay_fun:) name:NoticeDidPlay object:nil];
        
    }
    return self;
}


-(void)setAudioLength:(NSString *)audioLength{
    FZLog(@"FZLog----------------");

    _audioLength = audioLength;
    float  rate =[audioLength    integerValue]/60.;
    float width_ =defaultWidth*rate +70;
    if (width_>defaultWidth) {
        width_=defaultWidth;
    }
    self.bubbleWidth=width_;
    _backImgView = [[UIImageView  alloc]  initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 30)];
    _backImgView.contentMode =  UIViewContentModeRedraw;
    _backImgView.userInteractionEnabled=YES;
    [self  addSubview:_backImgView];
    UIImage  *greenImage = [UIImage  imageNamed:_backImgName];
    UIImage *sourceImage = greenImage;
    // Cap sizes should be carefully chosen for an appropriate part of the image.
    UIImage *cappedImage = [sourceImage resizableImageWithCapInsets:UIEdgeInsetsMake(0,40, 0, 44) resizingMode:UIImageResizingModeStretch];//top,left,bottom,right
    _backImgView.image =cappedImage;
    _wifi_static = [[UIImageView  alloc]  initWithFrame:CGRectMake(0, 0, 130/2., 30)];
    
    
    _wifi_static.image = [UIImage  imageNamed:_wifi_static_string];
    _wifi_gif = [[UIImageView  alloc]  initWithFrame:CGRectMake(0, 0, 130/2., 30)];
    _wifi_gif.image = [UIImage  imageNamed:_wifi_gif_string];
    [_backImgView  addSubview:_wifi_static];
    [_backImgView  addSubview:_wifi_gif];
    
    _secendsLabel = [[UILabel  alloc] initWithFrame:CGRectMake(39, 0, 44, 30)];
    _secendsLabel.text = @"0 \"";
    _secendsLabel.backgroundColor =[UIColor  clearColor];
    _secendsLabel.textColor =[UIColor  colorWithHexString:_color_string];
    _secendsLabel.textColor = [UIColor whiteColor];
    _secendsLabel.font =[UIFont  boldSystemFontOfSize:12];
    [_backImgView  addSubview:_secendsLabel];
    
    
    float  audioLength_float = [audioLength  floatValue];
    
    int    audioLength_int =(int)audioLength_float;
    
    if (audioLength_int<1) {
        audioLength_int =1;
    }
    
    if (audioLength_int>60) {
        audioLength_int=60;
    }
    
    
    _secendsLabel.text = [NSString  stringWithFormat:@"%d\"",audioLength_int];
    playButton   = [[UIButton  alloc]  initWithFrame:self.bounds];
    [playButton  addTarget:self action:@selector(playRecord:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:playButton];
    
}
- (void)playRecord:(UIButton *)sender {
   
    FZLog(@"FZLog----------------");

    if (!sender.selected) {
        
        NSDictionary  *userInfo = [[NSDictionary  alloc]  initWithObjectsAndKeys:self, @"sender", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:NoticeDidPlay object:nil userInfo:userInfo];

        sender.selected = YES;
        NSLog(@"响应事件 %@",self.audioUrl);
        _wifi_static.alpha =0;
        
        
        NSURL *videoUrl = [NSURL fileURLWithPath:self.audioUrl];
        
        if(self.widths <=480){
            
            if ([self.audioUrl  rangeOfString:@"http"].location!=NSNotFound) {// 4
                videoUrl = [NSURL URLWithString:self.audioUrl];
            }
        }else if ([self.audioUrl  rangeOfString:@"http"].location!=NSNotFound) {// 4以上
            videoUrl = [NSURL URLWithString:self.audioUrl];
        }else{
        
        
            if([[NSFileManager defaultManager] fileExistsAtPath:[videoUrl absoluteString]])
            {
                
                
                NSLog(@"videoUrl存在");
            }
        }
        AVAsset *asset = [AVURLAsset URLAssetWithURL:videoUrl options:nil];
        AVPlayerItem *anItem = [AVPlayerItem playerItemWithAsset:asset];
        anAudioStreamer = [AVPlayer playerWithPlayerItem:anItem];
       
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:anItem];
        
        AVAudioSession *session = [AVAudioSession sharedInstance];
        NSError *setCategoryError = nil;
        if (![session setCategory:AVAudioSessionCategoryPlayback
                      withOptions:AVAudioSessionCategoryOptionMixWithOthers
                            error:&setCategoryError]) {
            // handle error
        }
        [anAudioStreamer play];
        if (self.playDidStartBlock) {
            self.playDidStartBlock();
        }
        
    }else{
        [anAudioStreamer pause];
        if (self.playDidFinishBlock) {
            self.playDidFinishBlock();
        }
        _wifi_static.alpha =1;
        playButton.selected =NO;
    }
    
}

-(void)moviePlayDidEnd:(NSNotification *) notification {
    FZLog(@"FZLog----------------");

    // Will be called when AVPlayer finishes playing playerItem
    playButton.selected =NO;
    _wifi_static.alpha =1;
    if (self.playDidFinishBlock) {
        self.playDidFinishBlock();
    }

}


- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    FZLog(@"FZLog----------------");

    _wifi_static.alpha =1;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)NoticeDidPlay_fun:(NSNotification *)notification
{
    FZLog(@"FZLog----------------");

    NSLog(@" [notification userInfo]  %@",[notification userInfo]);
    if ([[notification userInfo]  objectForKey:@"sender"]!=self)
    {
        
        [anAudioStreamer pause];
        playButton.selected =NO;
        _wifi_static.alpha =1;
    }
}
-(void)changBackImgForMessageSendedMySelf{





}

-(void)addUnreadSign{


    audioUnReadSign = [[UIView  alloc]  initWithFrame:CGRectMake(self.backImgView.frame.size.width+3, 0, 4, 4)];
    audioUnReadSign.backgroundColor =[UIColor  redColor];
    [self.backImgView  addSubview:audioUnReadSign];
    audioUnReadSign.layer.cornerRadius = 2;  // 将图层的边框设置为圆脚
    audioUnReadSign.layer.masksToBounds = YES; // 隐藏边界
    
    
    
}
-(void)removeUnreadSign{

    [audioUnReadSign  removeFromSuperview];
}



-(void)dealloc{
    FZLog(@"FZLog----------------");

    
    NSLog(@"CommentAudioPlayView dealloc");

    [[NSNotificationCenter defaultCenter]  removeObserver:self name:NoticeDidPlay object:nil];
}
@end
