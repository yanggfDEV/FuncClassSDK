//
//  AudioRecord.h
//  Test_aacRecord
//
//  Created by DING FENG on 12/9/14.
//  Copyright (c) 2014 DING FENG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RecordIconView.h"

#import <UIKit/UIKit.h>
#define CachesDirectory    [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES) lastObject]

typedef void(^CompleteBlock)(BOOL result,NSURL  *audioFilePath);

typedef enum FZAudioRecordStatus: NSUInteger {
    FZAudioRecordStatusNone = 0,//
    FZAudioRecordStatusRecording,//正在录音
    FZAudioRecordStatusMoveToCancel,//滑动取消
    FZAudioRecordStatusCompleted,//录音完成
} FZAudioRecordStatus;

@interface AudioRecord : NSObject
@property (strong) CompleteBlock  completeBlock;
@property  (nonatomic,strong)   NSURL  *tmpFileUrl;
@property  (nonatomic,strong)   UIView  *recordView;
@property  (nonatomic,strong)   RecordIconView  *recordIconView;
@property (nonatomic,strong)   NSString *mediaLenth;
@property (nonatomic, strong) NSString *audioPath;//临时存储位置

@property (nonatomic, assign) FZAudioRecordStatus recordStatus;




-(AudioRecord *)initFromViewController:(UIViewController  *)fromController;


-(void)recordBegin;
-(void)recordCancel;
-(void)recordComplete;



-(void)removeMicIconAndAddDeleteIcon;
-(void)removeDeleteIconAndAddMicIcon;

-(void)showTooShortSign;


@end
