//
//  VideoCompositeProgress.m
//  EnglishTalk
//
//  Created by DING FENG on 7/21/14.
//  Copyright (c) 2014 ishowtalk. All rights reserved.
//
#import "VideoCompositeProgress.h"
@interface VideoCompositeProgress()
{
    UIWindow *_window;
    UIView *_hud;
    float _audioJointProgress;
    float _audioCompressProgress;
    float _videoCompositingProgress;
    
    UIImageView *gear;
    UILabel *_titleLabel;

    UISlider *_uislide1;
    UISlider *_uislide2;
    UISlider *_uislide3;
}
@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UIView *hud;

@end
@implementation VideoCompositeProgress
@synthesize window=_window;
@synthesize titleLabel=_titleLabel;
@synthesize uislide1=_uislide1,uislide2=_uislide2,uislide3=_uislide3;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)init
{
	self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	id<UIApplicationDelegate> delegate = [[UIApplication sharedApplication] delegate];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if ([delegate respondsToSelector:@selector(window)])
		_window = [delegate performSelector:@selector(window)];
	else _window = [[UIApplication sharedApplication] keyWindow];
	self.alpha = 0;
	//---------------------------------------------------------------------------------------------------------------------------------------------
    _hud = [[UIView alloc]  initWithFrame:CGRectMake(0, 0, 200, 160*0.618)];
    _hud.center =  self.center;
    _hud.backgroundColor = [UIColor  whiteColor];
    //layer.contents = (id)[UIImage imageNamed:@"view_BG.png"].CGImage; // 给图层添加背景图片
    _hud.layer.cornerRadius = 2;  // 将图层的边框设置为圆脚
    _hud.layer.masksToBounds = YES; // 隐藏边界
    _hud.layer.shadowOffset = CGSizeMake(2, 3);  // 设置阴影的偏移量
    _hud.layer.shadowRadius = 3.0;  // 设置阴影的半径
    _hud.layer.shadowColor = [UIColor grayColor].CGColor; // 设置阴影的颜色为黑色
    _hud.layer.shadowOpacity = 1; // 设置阴影的不透明度
    
    
    gear  = [[UIImageView  alloc]  initWithFrame:CGRectMake(0, 0, 12, 12)];
    gear.image = [UIImage  imageNamed:@"gear.png"];
    gear.center =CGPointMake(20, 16);
    [_hud  addSubview:gear];
    
    _titleLabel = [[UILabel  alloc]  initWithFrame:CGRectMake(0, 0, 200, 30)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = [UIFont  boldSystemFontOfSize:12];
    _titleLabel.textColor = [UIColor  grayColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.text=@"正在拼接音频";
    [_hud  addSubview:_titleLabel];

    UIColor *grc = [UIColor colorWithRed:238./255 green:238./255 blue:238./255 alpha:1];

    _uislide1 = [[UISlider alloc] initWithFrame:CGRectMake(0.0f, 50.0f, 180.0f, 35.0f)];
    _uislide1.minimumValue = 0.0f;
    _uislide1.maximumValue = 100.0f;
    _uislide1.value =40;
    _uislide1.center = CGPointMake(100, 40);
    _uislide1.minimumTrackTintColor = [UIColor colorWithRed:54./255 green:113./255 blue:129./255 alpha:1];
    _uislide1.maximumTrackTintColor = grc;
    [_uislide1 setThumbImage:[[UIImage  alloc]  init] forState:UIControlStateNormal];
    [_hud  addSubview:_uislide1];

    _uislide2 = [[UISlider alloc] initWithFrame:CGRectMake(0.0f, 50.0f, 180.0f, 35.0f)];
    _uislide2.minimumValue = 0.0f;
    _uislide2.maximumValue = 100.0f;
    _uislide2.value =40;
    _uislide2.center = CGPointMake(100, 60);
    _uislide2.minimumTrackTintColor = [UIColor colorWithRed:237./255 green:122./255 blue:61./255 alpha:1];
    _uislide2.maximumTrackTintColor = grc;
    [_uislide2 setThumbImage:[[UIImage  alloc]  init] forState:UIControlStateNormal];
    [_hud  addSubview:_uislide2];
    
    _uislide3 = [[UISlider alloc] initWithFrame:CGRectMake(0.0f, 50.0f, 180.0f, 35.0f)];
    _uislide3.minimumValue = 0.0f;
    _uislide3.maximumValue = 100.0f;
    _uislide3.value =40;
    _uislide3.center = CGPointMake(100, 80);
    _uislide3.minimumTrackTintColor = [UIColor colorWithRed:247./255 green:214./255 blue:77./255 alpha:1];
    _uislide3.maximumTrackTintColor = grc;
    [_uislide3 setThumbImage:[[UIImage  alloc]  init] forState:UIControlStateNormal];
    [_hud  addSubview:_uislide3];

    [self  addSubview:_hud];
    [_window  addSubview:self];
    self.userInteractionEnabled = NO;
    return self;
}

+ (VideoCompositeProgress *)sharedInstance
{
    static VideoCompositeProgress *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[VideoCompositeProgress alloc] init];
    });
    return _sharedInstance;
}

- (void)hudShow
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
//    UISlider *_uislide1;
//    UISlider *_uislide2;
//    UISlider *_uislide3;
    _uislide1.value=0;
    _uislide2.value=0;
    _uislide3.value=0;
    
	if (self.alpha == 0)
	{
		self.alpha = 1;
		_hud.alpha = 0;
		_hud.transform = CGAffineTransformScale(_hud.transform, 1.4, 1.4);
		NSUInteger options = UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut;
		[UIView animateWithDuration:0.15 delay:0 options:options animations:^{
			_hud.transform = CGAffineTransformScale(_hud.transform, 1/1.4, 1/1.4);
			_hud.alpha = 1;
		}
                         completion:^(BOOL finished){
                             CABasicAnimation* rotationAnimation;
                             rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
                             rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
                             rotationAnimation.duration = 2;
                             rotationAnimation.cumulative = YES;
                             rotationAnimation.repeatCount = HUGE_VALF;
                             [gear.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
                         }];
	}
}
- (void)dismiss
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	if (self.alpha == 1)
	{
		NSUInteger options = UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseIn;
		[UIView animateWithDuration:0.15 delay:0 options:options animations:^{
			_hud.transform = CGAffineTransformScale(_hud.transform, 0.7, 0.7);
			_hud.alpha = 0;
		}
                         completion:^(BOOL finished)
         {
             self.alpha = 0;
             _hud.transform = CGAffineTransformScale(_hud.transform, 1/0.7, 1/0.7);
             _uislide1.value=0;
             _uislide2.value=0;
             _uislide3.value=0;
         }];
	}
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
@end
