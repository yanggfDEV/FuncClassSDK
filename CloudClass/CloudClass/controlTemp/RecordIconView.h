//
//  RecordIconView.h
//  Test_aacRecord
//
//  Created by DING FENG on 12/9/14.
//  Copyright (c) 2014 DING FENG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordIconView : UIView
@property  (nonatomic)   float    lineMeterLevel;
@property  (nonatomic,strong)   UIImageView  *iconImageView;
@property  (nonatomic,strong)   UILabel  *countNumLabel;


-(void)updateRecordMeterLevel:(float )meterLevel;

@end
