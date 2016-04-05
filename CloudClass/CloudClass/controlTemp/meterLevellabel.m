//
//  meterLevellabel.m
//  Test_aacRecord
//
//  Created by DING FENG on 12/9/14.
//  Copyright (c) 2014 DING FENG. All rights reserved.
//

#import "meterLevellabel.h"

@implementation meterLevellabel

- (void)drawRect:(CGRect)rect
{
    UIBezierPath* pathLines = [UIBezierPath bezierPath];
    [pathLines moveToPoint:CGPointMake(0, 22)]; // 移动到point1位置
    [pathLines addLineToPoint:CGPointMake(320*self.lineMeterLevel, 22)]; // 画一条从point1到point2的线
    float   totleLength =320*self.lineMeterLevel;
    int   segLengthNum =(int)(totleLength /10.)+1;
    pathLines.lineWidth = 44.0; // 线宽
    [[UIColor blueColor]  set];
    [pathLines stroke]; // 开始描绘
}

@end
