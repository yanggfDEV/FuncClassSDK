//
//  MeterLevelWaveView.h
//  Test_aacRecord
//
//  Created by DING FENG on 12/10/14.
//  Copyright (c) 2014 DING FENG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeterLevelWaveView : UIView
@property  (nonatomic)   float    lineMeterLevel;
@property  (nonatomic,strong)   UIImageView  *backImageView;
@property  (nonatomic,strong)   UIImageView  *tempImageView;




-(void)updateRecordMeterLevel:(float )meterLevel;


@end
