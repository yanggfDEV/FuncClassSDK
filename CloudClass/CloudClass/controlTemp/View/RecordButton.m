//
//  RecordButton.m
//  SimpleAVPlayer
//
//  Created by DING FENG on 5/29/14.
//  Copyright (c) 2014 dinfeng. All rights reserved.
//

#import "RecordButton.h"

@implementation RecordButton
@synthesize stadus = _stadus;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _stadus= Ready;

    }
    return self;
}



//- (void)drawRect:(CGRect)rect
//{
//    
//    
//    
//    
//    
//}



-(void)setStadus:(RecordStadus)stadus
{

    
    _stadus = stadus;
    switch (stadus) {
        case Ready:
        {
//            self.layer.backgroundColor = [UIColor colorWithRed:0./255 green:93./255 blue:171./255 alpha:1].CGColor; // 给图层添加背景色
            //layer.contents = (id)[UIImage imageNamed:@"view_BG.png"].CGImage; // 给图层添加背景图片
            self.layer.cornerRadius = self.frame.size.width/2.;  // 将图层的边框设置为圆脚
            self.layer.masksToBounds = YES; // 隐藏边界
            self.layer.borderWidth = 0;  // 给图层添加一个有色边框
            self.layer.borderColor = [UIColor colorWithRed:94./255 green:131./255 blue:83./255 alpha:0].CGColor;
            self.layer.shadowOffset = CGSizeMake(0, 3);  // 设置阴影的偏移量
            self.layer.shadowRadius = 1.0;  // 设置阴影的半径
            self.layer.shadowColor = [UIColor blackColor].CGColor; // 设置阴影的颜色为黑色
//            self.layer.shadowOpacity = 0.1; // 设置阴影的不透明度
        }
            break;
        case Recording:
        {
            self.layer.cornerRadius = self.frame.size.width/2.;  // 将图层的边框设置为圆脚
            self.layer.masksToBounds = YES; // 隐藏边界
            self.layer.borderWidth = 0;  // 给图层添加一个有色边框
            self.layer.borderColor = [UIColor colorWithRed:94./255 green:131./255 blue:83./255 alpha:1].CGColor;
            self.layer.shadowOffset = CGSizeMake(0, 3);  // 设置阴影的偏移量
            self.layer.shadowRadius = 1.0;  // 设置阴影的半径
            self.layer.shadowColor = [UIColor blackColor].CGColor; // 设置阴影的颜色为黑色
//            self.layer.shadowOpacity = 0.1; // 设置阴影的不透明度
        }
            break;
        default:
            break;
    }
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.layer.cornerRadius =self.bounds.size.width/2.;  // 将图层的边框设置为圆脚
    self.layer.masksToBounds = YES; // 隐藏边界
    UIColor  *oldColor = self.backgroundColor;
    [UIView animateWithDuration:0.03 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.backgroundColor = [UIColor colorWithRed:82./255 green:168./255 blue:92./255 alpha:0.3];
    } completion:^(BOOL finished)
     {
         self.backgroundColor = oldColor;
         self.layer.cornerRadius =0;  // 将图层的边框设置为圆脚
         self.layer.masksToBounds = NO; // 隐藏边界
     }];
    [super touchesBegan:touches withEvent:event];
}

@end
