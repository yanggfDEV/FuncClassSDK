//
//  LeafProgressView.m
//  LeafProgress
//
//  Created by kim on 14/12/18.
//  Copyright (c) 2014年 com.v2next. All rights reserved.
//

#import "LeafProgressView.h"
#import "BGMovingComponent.h"

@interface LeafProgressView ()
{
    
    UIImage     *bg1Img, *bg2Img;
    UIImageView *bg1ImgView, *bg2ImgView;
    UIImage     *rotImg;
    UIImageView *rotImgView;
    
    double      angle;
    
    UILabel *_uilabel; //新建一个label用来显示滑动的位置
    
    int  oldIntProgress;
    NSTimer *triggerTimer;
    
}
@property (nonatomic, assign) NSInteger borderWidth;
@property (nonatomic, strong) UIView *oneView;
@property (nonatomic,assign) NSInteger cornerRadius;

@end

@implementation LeafProgressView
@synthesize progress = _progress;

#pragma mark - ProgressViewInit

- (id)init
{
    self = [super init];
    if (self) {
        
        self.frame = CGRectMake(0, 10, 320, 44);               //UIView大小
        self.backgroundColor = [UIColor clearColor];
        
        bg1Img = [UIImage imageNamed:@"进度底板1"];
        bg2Img = [UIImage imageNamed:@"进度底板2"];
        
        


        
        
        
        
        
        NSLog(@"bg1Img.scale  %f",bg1Img.scale);   // 2014-12-24 12:16:47.233 EnglishTalk[891:60b] bg1Img.scale  1.000000
        NSLog(@"bg2Img  %f",bg2Img.scale);
        
        bg1ImgView = [[UIImageView alloc] initWithFrame:CGRectMake(20.0, 200.0 - 125, bg1Img.size.width, bg1Img.size.height)];
        bg1ImgView.image = bg1Img;
        bg2ImgView = [[UIImageView alloc] initWithFrame:CGRectMake(25.0, 205.0 - 125, bg2Img.size.width, bg2Img.size.height)];
        bg2ImgView.image = bg2Img;
        [self addSubview:bg1ImgView];
        [self addSubview:bg2ImgView];
        
        rotImg = [UIImage imageNamed:@"风扇"];

        rotImgView = [[UIImageView alloc] initWithFrame:CGRectMake(240.0 + 5.0, 205.0 - 125, rotImg.size.width, rotImg.size.height)];
        rotImgView.image = rotImg;
        [self addSubview:rotImgView];
        
        CGAffineTransform transform= CGAffineTransformMakeRotation(M_PI*0.38);
        rotImgView.transform = transform;
        triggerTimer = [NSTimer scheduledTimerWithTimeInterval: 0.01 target: self selector:@selector(transformAction) userInfo: nil repeats: YES];
        self.oneView = [[UIView alloc] init];
        self.oneView.clipsToBounds = YES;
        
        self.oneView.frame = CGRectMake(25-10-10-5, 0, 180 + 60, 40);
        self.oneView = [self roundCornersOnView:self.oneView onTopLeft:YES topRight:NO bottomLeft:YES bottomRight:NO radius:20];
        [bg2ImgView addSubview:self.oneView];
        
        
        _uilabel = [[UILabel alloc] initWithFrame:CGRectMake(3+7, 10, 70, 20)];
        [_uilabel setTextColor:[UIColor colorWithWhite:0.486 alpha:1.000]];
        _uilabel.text =@"16%";
        
        [bg2ImgView addSubview:_uilabel];
        
        
    }
    return self;
}

#pragma mark - UIImageView圆角直角变形
-(UIView *)roundCornersOnView:(UIView *)view onTopLeft:(BOOL)tl topRight:(BOOL)tr bottomLeft:(BOOL)bl bottomRight:(BOOL)br radius:(float)radius {
    
    if (tl || tr || bl || br) {
        UIRectCorner corner = 0; //holds the corner
        //Determine which corner(s) should be changed
        if (tl) {
            corner = corner | UIRectCornerTopLeft;
        }
        if (tr) {
            corner = corner | UIRectCornerTopRight;
        }
        if (bl) {
            corner = corner | UIRectCornerBottomLeft;
        }
        if (br) {
            corner = corner | UIRectCornerBottomRight;
        }
        
        UIView *roundedView = view;
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:roundedView.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(radius, radius)];
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = roundedView.bounds;
        maskLayer.path = maskPath.CGPath;
        roundedView.layer.mask = maskLayer;
        return roundedView;
    } else {
        return view;
    }
}





- (void)transformAction
{
    angle = angle + 0.07;
    if (angle > 6.28) {
        angle = 0;
    }
    CGAffineTransform transform = CGAffineTransformMakeRotation(angle);
    rotImgView.transform = transform;
    
}


- (void)setProgress:(float)progress
{
    _progress = progress;
    
    _uilabel.text =[NSString  stringWithFormat:@"%d%@ ",(int)(progress*100),@"%"];

    self.oneView.backgroundColor = [UIColor colorWithRed:171./255 green:232./255 blue:70./255 alpha:1];     // 进度条颜
    //    self.oneView.frame = CGRectMake(25-10-10-5, 0, 180 * _progress, 40);
    self.oneView.frame = CGRectMake(25-10-10-5, 0, self.frame.size.width * progress/1.3, 40);
    NSLog(@"setProgress  %f",progress);
    
    
    float  p =_progress;
    int leafAnimationFirStep = 4;
    int  progress100 = (int)(p*100);
    if (progress100-oldIntProgress>leafAnimationFirStep) {
        
        BGMovingComponent *leafImg = [[BGMovingComponent alloc] initWithFrame:CGRectMake(-10, 35, 100, 40)];
        [bg2ImgView insertSubview:leafImg belowSubview:self.oneView];
        
        
        oldIntProgress = oldIntProgress +leafAnimationFirStep;
    }
}

// 进度百分比
- (void)stopanimate
{
    [UIView animateWithDuration:0.5
                     animations:^{
                         [_uilabel setAlpha:1.f]; // 0.f Label渐变消失
                     }
                     completion:^(BOOL finished){
                         // 动画结束时的处理
                     }];
}



-(void)dealloc{
    NSLog(@"LeafProgressView   dealloc");
    
}
- (void)removeFromSuperview
{
    [triggerTimer  invalidate];
    triggerTimer = nil;
    [super  removeFromSuperview];
}

@end



