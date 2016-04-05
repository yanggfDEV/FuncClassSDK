//
//  MeterLevelPrograssBar.h
//  SimpleAVPlayer
//
//  Created by DING FENG on 5/30/14.
//  Copyright (c) 2014 dinfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeterLevelPrograssBar : UIView

@property  (nonatomic)   float  prograss;
@property  (nonatomic)   float  darwPerPoint;
@property  (nonatomic)   float  dbSPl;




@property  (nonatomic,strong)   UIImage *tempBackImag;
@end



//
//CGPoint b_DB = CGPointMake(self.frame.size.width*prograss-darwPerPoint, self.frame.size.height/2);
//CGPoint e_DB = CGPointMake(self.frame.size.width*prograss , self.frame.size.height/2);
//UIBezierPath* pathLines_DB = [UIBezierPath bezierPath];
//[pathLines_DB moveToPoint:b_DB]; // 移动到point1位置
//[pathLines_DB addLineToPoint:e_DB]; // 画一条从point1到point2的线
//pathLines_DB.lineWidth = 44.0*_dbSPl*0.8; // 线宽
//[[UIColor colorWithRed:237./255 green:123./255 blue:61./255 alpha:1]
// set];
//[pathLines_DB stroke]; // 开始描绘
//
//NSLog(@"%f",self.dbSPl);
