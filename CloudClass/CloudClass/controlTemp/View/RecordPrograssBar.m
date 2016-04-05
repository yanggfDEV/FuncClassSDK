//
//  RecordPrograssBar.m
//  SimpleAVPlayer
//
//  Created by DING FENG on 5/30/14.
//  Copyright (c) 2014 dinfeng. All rights reserved.
//

#import "RecordPrograssBar.h"
#import "MeterLevelPrograssBar.h"
@interface RecordPrograssBar ()
{
    UIImage  *_tempBackImage;
    MeterLevelPrograssBar *meterLevelPrograssBar;
}
@end


@implementation RecordPrograssBar
@synthesize recordDuration =_recordDuration;
@synthesize beginTime =_beginTime;
@synthesize endTime =_endTime;
@synthesize dbSPl = _dbSPl;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _recordAudioFull = NO;
        
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{

    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        NSLog(@"  222initWithFrame ");
        meterLevelPrograssBar  =[[MeterLevelPrograssBar  alloc]  initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        meterLevelPrograssBar.backgroundColor = [ UIColor   clearColor  ];
        // [self  addSubview:meterLevelPrograssBar];//废弃        meterlevel  测量
    }
    return self;
}
///*
//// Only override drawRect: if you perform custom drawing.
//// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    float  prograss;
    if ((_endTime-_beginTime)!=0  &&_recordDuration>=0)
    {
        prograss =_recordDuration/(_endTime-_beginTime);
    }else
    {
        
        NSLog(@" else %f",_endTime-_beginTime);

        return;
    }
    if (prograss<0 ) {
        prograss = 0;
        _recordAudioFull = NO;
    }
    if (prograss>=1) {
        prograss = 1;
        _recordAudioFull = YES;
        if (self.audioRecordCompleteBlock)
        {
            NSLog(@" audioRecordCompleteBlock %f",_endTime-_beginTime);
            self.audioRecordCompleteBlock();
        }
    }
    
    int  drawCount =((_endTime-_beginTime)*60);
    float  darwPerPoint = self.frame.size.width/drawCount;
    CGPoint b = CGPointMake(self.frame.size.width*0, self.frame.size.height/2);
    CGPoint e = CGPointMake(self.frame.size.width*prograss , self.frame.size.height/2);
    //        NSLog(@"beginTime  %f",[[d  objectForKey:@"beginTime"]  floatValue]);
    //        NSLog(@"endTime    %f",[[d  objectForKey:@"endTime"]  floatValue]);
    //        NSLog(@"_totalTime    %f",_totalTime);
    UIBezierPath* pathLines = [UIBezierPath bezierPath];
    [pathLines moveToPoint:b]; // 移动到point1位置
    [pathLines addLineToPoint:e]; // 画一条从point1到point2的线
    pathLines.lineWidth = 44.0; // 线宽
    [[FZStyleSheet currentStyleSheet].colorOfMainTint set];
    [pathLines stroke]; // 开始描绘
    
    meterLevelPrograssBar.prograss =prograss;
    meterLevelPrograssBar.darwPerPoint =darwPerPoint;
    meterLevelPrograssBar.dbSPl =_dbSPl;
    [meterLevelPrograssBar  setNeedsDisplay];

}

@end
