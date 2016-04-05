//
//  MeterLevelPrograssBar.m
//  SimpleAVPlayer
//
//  Created by DING FENG on 5/30/14.
//  Copyright (c) 2014 dinfeng. All rights reserved.
//

#import "MeterLevelPrograssBar.h"

@implementation MeterLevelPrograssBar

@synthesize tempBackImag = _tempBackImag;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{

//    [super  drawRect:rect];
//    
//
//    CGPoint b_DB = CGPointMake(self.frame.size.width*self.prograss-self.darwPerPoint, self.frame.size.height/2);
//    CGPoint e_DB = CGPointMake(self.frame.size.width*self.prograss , self.frame.size.height/2);
//    
//    UIGraphicsBeginImageContext(self.frame.size);
//    [self.tempBackImag drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
//    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), b_DB.x, b_DB.y);
//    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), e_DB.x, e_DB.y);
//    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapSquare);
//    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 44.0*self.dbSPl*0.5 );
//    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 237./255, 123./255 , 61./255, 1.0);
//    CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
//    CGContextStrokePath(UIGraphicsGetCurrentContext());
//    self.tempBackImag = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    self.backgroundColor = [UIColor  colorWithPatternImage:self.tempBackImag];
////
////    UIBezierPath* pathLines_DB = [UIBezierPath bezierPath];
////    [pathLines_DB moveToPoint:b_DB]; // 移动到point1位置
////    [pathLines_DB addLineToPoint:e_DB]; // 画一条从point1到point2的线
////    pathLines_DB.lineWidth = 44.0*self.dbSPl*0.8; // 线宽
////    [[UIColor colorWithRed:237./255 green:123./255 blue:61./255 alpha:1]
////     set];
////    [pathLines_DB stroke]; // 开始描绘
//    NSLog(@"   MeterLevelPrograssBar     %f",self.dbSPl);
}

@end
