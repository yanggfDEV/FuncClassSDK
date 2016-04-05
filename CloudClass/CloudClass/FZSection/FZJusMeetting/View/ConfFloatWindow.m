//
//  ConfFloatWindow.m
//  JusMeeting
//
//  Created by young on 15/10/9.
//  Copyright © 2015年 Fiona. All rights reserved.
//

#import "ConfFloatWindow.h"

BOOL isConfFloatWindowShow = NO;
#define kMainScreenWidth [UIScreen mainScreen].bounds.size.width
#define kMainScreenHeight [UIScreen mainScreen].bounds.size.height

@implementation ConfFloatWindow
{
    UIView *_remote;
    BOOL _isRender;
}
- (instancetype)initWithFrame:(CGRect)frame isVideo:(BOOL)isVideo time:(MtcConfSessTimer *)timer
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.windowLevel = UIWindowLevelAlert;
        self.hidden = YES;
        _isRender = NO;
        [self makeKeyAndVisible];
        
        if (isVideo) {
            _remote = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
            [self addSubview:_remote];
        } else {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
            view.backgroundColor = [UIColor grayColor];
            view.alpha = 0.9;
            view.layer.cornerRadius = 35;
            view.layer.masksToBounds = YES;
            [self addSubview:view];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 40, 40)];
            imageView.image = [UIImage imageNamed:@"JusMeeting.bundle/call-float-voice-answer"];
            [view addSubview:imageView];
            UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 55, 40, 10)];
            timeLabel.font = [UIFont systemFontOfSize:11];
            timeLabel.textColor = [UIColor whiteColor];
            timeLabel.textAlignment = NSTextAlignmentCenter;
            [MtcConfSessTimer startWithTime:timeLabel mintues:timer.mintues seconds:timer.seconds date:timer.date];
            [view addSubview:timeLabel];
        }
        
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click:)];
        [self addGestureRecognizer:tap];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(locationChange:)];
        pan.delaysTouchesBegan = YES;
        [self addGestureRecognizer:pan];
    }
    return self;
}

- (void)show:(NSString *)renderId
{
    self.hidden = NO;
    Zmf_VideoRenderStart((__bridge void *)(_remote), ZmfRenderViewFx);
    Zmf_VideoRenderAdd((__bridge void *)(_remote), [renderId UTF8String], 0, ZmfRenderFullScreen);
    _isRender = YES;
    isConfFloatWindowShow = YES;
}

- (void)dismiss
{
    if (_isRender == YES)
    {
        Zmf_VideoRenderRemoveAll((__bridge void *)(_remote));
        Zmf_VideoRenderStop((__bridge void *)(_remote));
        _isRender = NO;
    }
    self.hidden = YES;
    isConfFloatWindowShow = NO;
}

-(void)click:(UITapGestureRecognizer*)t
{
    if(self.floatWindowDelegate && [self.floatWindowDelegate respondsToSelector:@selector(conffloatWindowClick)])
    {
        [self.floatWindowDelegate conffloatWindowClick];
    }
}

-(void)locationChange:(UIPanGestureRecognizer*)p
{
    CGPoint translation = [p translationInView:self];
    CGPoint center = self.center;
    CGFloat offsetX = center.x + translation.x;
    CGFloat offsetY = center.y + translation.y;
    CGFloat w = self.frame.size.width / 2;
    CGFloat h = self.frame.size.height / 2;
    if (offsetX < w) {
        offsetX = w;
    } else if (offsetX > kMainScreenWidth - w) {
        offsetX = kMainScreenWidth - w;
    }
    
    if (offsetY < h) {
        offsetY = h;
    } else if (offsetY > kMainScreenHeight - h) {
        offsetY = kMainScreenHeight - h;
    }
    CGPoint movedCenter = CGPointMake(offsetX, offsetY);
    
    if (p.state == UIGestureRecognizerStateChanged) {
        self.center = movedCenter;
        [p setTranslation:CGPointZero inView:self];
    } else if (p.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.2 animations:^{
            self.center = movedCenter;
        } completion:^(BOOL finished) {
            [p setTranslation:CGPointZero inView:self];
        }];
    }
}

@end
