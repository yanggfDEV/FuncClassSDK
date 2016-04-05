//
//  MeterLevelWaveView.m
//  Test_aacRecord
//
//  Created by DING FENG on 12/10/14.
//  Copyright (c) 2014 DING FENG. All rights reserved.
//

#import "MeterLevelWaveView.h"
@interface MeterLevelWaveView()
{
    int64_t   curentStep;
}

@end


@implementation MeterLevelWaveView

-(id)initWithFrame:(CGRect)frame{
    
    
    
    self = [super initWithFrame:frame];
    if (self){
        
        
        
        self.backImageView = [[UIImageView  alloc]  initWithFrame:self.bounds];
        self.tempImageView = [[UIImageView  alloc]  initWithFrame:self.bounds];
        

        [self  addSubview:self.backImageView];
        [self  addSubview:self.tempImageView];
        
        
        


    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)updateRecordMeterLevel:(float )meterLevel{

    
    
    
  //  NSLog(@"updateRecordMeterLevel");

    float   width = self.frame.size.width;
    float   height = self.frame.size.height;
    
    float   heightOffSet;
    heightOffSet = height*meterLevel;
    
    //   5  s   *60
    curentStep = curentStep+1;
    if (curentStep>320) {
        curentStep=0;
        self.backImageView.image = nil;
    }
    CGPoint startpoint = CGPointMake(curentStep, height/2.+heightOffSet);
    CGPoint endpoint = CGPointMake(curentStep, height/2.-heightOffSet);
    float red = 255./255.0;
    float green = .0/255.0;
    float blue = .0/255.0;
    UIGraphicsBeginImageContext(self.frame.size);
    [self.tempImageView.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), startpoint.x, startpoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), endpoint.x, endpoint.y);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 1 );
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, 1.0);
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.tempImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    [self.tempImageView setAlpha:1];
    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContext(self.backImageView.frame.size);
    [self.backImageView.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    [self.tempImageView.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) blendMode:kCGBlendModeNormal alpha:1];
    self.backImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    self.tempImageView.image = nil;
    UIGraphicsEndImageContext();

}
@end
