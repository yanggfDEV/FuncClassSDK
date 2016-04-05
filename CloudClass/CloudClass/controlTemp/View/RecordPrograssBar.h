//
//  RecordPrograssBar.h
//  SimpleAVPlayer
//
//  Created by DING FENG on 5/30/14.
//  Copyright (c) 2014 dinfeng. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^AudioRecordCompleteBlock)();

@interface RecordPrograssBar : UIView

@property (nonatomic)  float recordDuration;
@property (nonatomic)  float beginTime;
@property (nonatomic)  float endTime;

@property (nonatomic)  float dbSPl;
@property (nonatomic)  BOOL recordAudioFull;

@property (nonatomic,strong)   AudioRecordCompleteBlock   audioRecordCompleteBlock;






@end
