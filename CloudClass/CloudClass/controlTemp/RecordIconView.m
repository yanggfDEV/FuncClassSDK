//
//  RecordIconView.m
//  Test_aacRecord
//
//  Created by DING FENG on 12/9/14.
//  Copyright (c) 2014 DING FENG. All rights reserved.
//

#import "RecordIconView.h"

@implementation RecordIconView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/   //137  202  48
- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.lineMeterLevel = [self  lineDataToCurve:self.lineMeterLevel];
    int  levelPhase  =  (int)(self.lineMeterLevel*10);
    if (levelPhase==0) {
        levelPhase=1;
    }
    
    for (int i =0;i<=levelPhase;i++) {
        float   MaxRadius = 328/2./2.-5;
        
        float  alpha = 0.6 -i/10.;
        if (alpha<0.1) {
            alpha =0.05;
        }
        float  RadiusDelta =(MaxRadius -170/4.)/10.;
        CGPoint   center = CGPointMake(self.bounds.size.width/2., self.bounds.size.width/2);
        UIBezierPath* pathLines = [UIBezierPath bezierPath];
        [pathLines addArcWithCenter:center radius:170/4+RadiusDelta*i+RadiusDelta/2. startAngle:0 endAngle:2 * M_PI clockwise:YES];
        pathLines.lineWidth = RadiusDelta; // 线宽
        [[UIColor colorWithRed:137./255 green:202./255 blue:48./255 alpha:alpha]  set];
        [pathLines stroke]; // 开始描绘
    }
}

-(void)updateRecordMeterLevel:(float )meterLevel{
    self.lineMeterLevel =meterLevel;
    [self  setNeedsDisplay];
}

-(float)lineDataToCurve:(float)lineValue{
    float  index_x = lineValue;
    float  index_Y2 = 1-(1-index_x)*(1-index_x);
    float  curveValue = sqrtf(index_Y2);
    return fabsf(curveValue);
}



@end
