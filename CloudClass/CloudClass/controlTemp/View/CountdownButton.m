//
//  CountdownButton.m
//  EnglishTalk
//
//  Created by DING FENG on 8/16/14.
//  Copyright (c) 2014 ishowtalk. All rights reserved.
//

#import "CountdownButton.h"
@interface CountdownButton()

{

    int  timecount;
    
}
@end

@implementation CountdownButton
@synthesize timelabel=_timelabel;



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _timelabel = [[UILabel  alloc ] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _timelabel.textColor = [UIColor  whiteColor];
        _timelabel.font = [UIFont  boldSystemFontOfSize:18];
        _timelabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_timelabel];
        
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:(1.0)
                     
                                                    target:self
                                                  selector:@selector(updateLabel)
                                                  userInfo:nil
                                                   repeats:YES];
        [self.timer setFireDate:[NSDate distantFuture]];
        timecount = 60; // 更改为了 60秒，原120秒

        
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    timecount = 60; // 更改为了 60秒，原120秒
    [self.timer setFireDate:[NSDate date]];
    [super touchesBegan:touches withEvent:event];
}
-(void)updateLabel
{
    timecount = timecount-1;
    if(timecount>0)
    {
        _timelabel.text = [NSString  stringWithFormat:@"(%d)重新获取",timecount];
        [self  setTitle:@"" forState:UIControlStateNormal];
        self.enabled =NO;
    }else if
        (timecount ==0)
    {
        
        [self  resetTheState];
    }
}

-(void)resetTheState
{
    
    timecount = 60; // 更改为了 60秒，原120秒
    [self.timer setFireDate:[NSDate distantFuture]];
    self.enabled =YES;
    _timelabel.text = [NSString  stringWithFormat:@"获取验证码"];

}

@end
