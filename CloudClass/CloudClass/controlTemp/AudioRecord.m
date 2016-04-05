//
//  AudioRecord.m
//  Test_aacRecord
//
//  Created by DING FENG on 12/9/14.
//  Copyright (c) 2014 DING FENG. All rights reserved.
//

#import "AudioRecord.h"
#import <AVFoundation/AVFoundation.h>
#import "NSFileManager+plus.h"
#import "meterLevellabel.h"
#import "MeterLevelWaveView.h"

@interface AudioRecord()
{
    UIView  *_recordView;
    meterLevellabel  *_metelevelLabel;
    MeterLevelWaveView *_meterLevelWaveView;
    AVAudioRecorder *recorder;
    NSURL *_tmpFileUrl;
    CADisplayLink  *_displayLink;
    RecordIconView  *_recordIconView;
    UIView   *_deleteIconView;
    NSTimer   *showTimer;
    
    int   secendsCount;
    BOOL  timeOut_60s;
    
}
@property  (nonatomic,weak)  UIViewController  *fromController;
@end

@implementation AudioRecord
@synthesize recordView=_recordView;
@synthesize tmpFileUrl=_tmpFileUrl;
@synthesize recordIconView=_recordIconView;
- (id)init
{
    self = [super init];
    if (self)
    {
        _recordView = [[UIView  alloc]  init];
        _recordView.frame = CGRectMake(0, 0, [UIScreen  mainScreen].bounds.size.width, [UIScreen  mainScreen].bounds.size.height-50);
//        _recordView.center = CGPointMake([UIScreen  mainScreen].bounds.size.width/2., [UIScreen  mainScreen].bounds.size.height/2.-58);
        _recordView.backgroundColor = [UIColor colorWithRed:20./255 green:20./255 blue:20./255 alpha:0.7];
        _metelevelLabel =[[meterLevellabel  alloc]  initWithFrame:CGRectMake(0, 0, 320, 44)];
        _metelevelLabel.text = @"meterlevel";
        _metelevelLabel.backgroundColor  = [UIColor   grayColor];
        //[_recordView  addSubview:_metelevelLabel];
        NSString *docsDir = CachesDirectory;
        self.audioPath = [docsDir stringByAppendingPathComponent:@"tmpAudioRecordFileUrl.aac"];
        _tmpFileUrl = [NSURL fileURLWithPath:self.audioPath];
        
        [self removeDeleteIconAndAddMicIcon];
    }
    return self;
}

-(AudioRecord *)initFromViewController:(UIViewController  *)fromController{
    AudioRecord *arv = [[AudioRecord  alloc ]  init];
    arv.fromController=fromController;
    return arv;
}
-(void)recordBegin{
    
    
    timeOut_60s = NO;
    [showTimer  invalidate];
    showTimer = nil;
    secendsCount = 0;
    
    
    
    NSTimeInterval timeInterval =1.0 ;
    //定时器
    showTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval
                                                 target:self
                                               selector:@selector(handleTimer:)
                                               userInfo:nil
                                                repeats:YES];
    
    [showTimer setFireDate:[NSDate distantFuture]];
    NSLog(@"recordBegin");
    NSString  *path = [_tmpFileUrl   path];
    NSError *error;
    if ([[NSFileManager defaultManager] isDeletableFileAtPath:path]) {
        BOOL success = [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
        if (!success) {
            NSLog(@"Error removing file at path: %@", error.localizedDescription);
        }
    }
    
    _meterLevelWaveView = [[MeterLevelWaveView  alloc]  initWithFrame:CGRectMake(0, 320-44, 320, 44)];
    _meterLevelWaveView.backgroundColor  = [UIColor   greenColor];
//     [_recordView  addSubview:_meterLevelWaveView];
    
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkRefresh)];
    _displayLink.frameInterval = (NSInteger)(ceil(60.0/60));
    [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
    [[UIApplication  sharedApplication].keyWindow  addSubview:_recordView];
//    [self.fromController.view  addSubview:_recordView];

    _recordView.alpha = 1;
//    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
//        _recordView.alpha =1;
//    } completion:^(BOOL finished)
//     {
    
         NSDictionary *recordSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                         [NSNumber numberWithInt: kAudioFormatMPEG4AAC], AVFormatIDKey,
                                         [NSNumber numberWithFloat:8000.0], AVSampleRateKey,
                                         [NSNumber numberWithInt: 2], AVNumberOfChannelsKey,
                                         nil];
         
//         NSError *error = nil;
         recorder = [[AVAudioRecorder alloc] initWithURL:_tmpFileUrl settings:recordSettings error:&error];
         [recorder prepareToRecord];
         AVAudioSession *session = [AVAudioSession sharedInstance];
         [session setCategory:AVAudioSessionCategoryRecord error:nil];
         [session setActive:YES error:nil];
         [recorder setMeteringEnabled:YES];
         [recorder record];
         [showTimer setFireDate:[NSDate date]];
         
         [self removeDeleteIconAndAddMicIcon];
         
//     }];
    
}
-(void)recordCancel{
    [showTimer  invalidate];
    showTimer = nil;
    secendsCount = 0;
    
    
    
    //invalidate and free the display link
    [_displayLink invalidate];
    _displayLink = nil;
    NSLog(@"recordCancel");
    [_recordView  removeFromSuperview];
    [recorder stop];
    AVAudioSession *session = [AVAudioSession sharedInstance];
    int flags = AVAudioSessionSetActiveFlags_NotifyOthersOnDeactivation;
    [session setActive:NO withFlags:flags error:nil];
    
    
}
-(void)recordComplete{
    
    
    
    if (timeOut_60s) {
        return;
    }
    
    //invalidate and free the display link
    [_displayLink invalidate];
    _displayLink = nil;
    NSLog(@"recordComplete");
    [_recordView  removeFromSuperview];
    [recorder stop];
    
    
    [showTimer  invalidate];
    showTimer = nil;
    secendsCount = 0;
    
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    int flags = AVAudioSessionSetActiveFlags_NotifyOthersOnDeactivation;
    [session setActive:NO withFlags:flags error:nil];
    
    
    
    AVURLAsset* audioAsset = [AVURLAsset URLAssetWithURL:_tmpFileUrl options:nil];
    CMTime audioDuration = audioAsset.duration;
    float audioDurationSeconds = CMTimeGetSeconds(audioDuration);
    
    if (audioDurationSeconds>=59) {
        audioDurationSeconds=60;
    }
    
    NSLog(@"audioDurationSeconds  %f",audioDurationSeconds);
    
    
    BOOL   result;
    result = NO;
    if (audioDurationSeconds>0.6) {
        result = YES;
    }
    
    self.mediaLenth = [NSString  stringWithFormat:@"%.1f",audioDurationSeconds];
    
    if (self.completeBlock) {
        self.completeBlock(result,_tmpFileUrl);
    }
}


-(void)displayLinkRefresh{
    
    [recorder updateMeters];
    double peakPowerForChannel =[recorder peakPowerForChannel:0];
    
    //听觉线性和分贝之间需要转换
    /*
     The range is from -160 dB to 0 dB. You probably want to display it in a meter that goes from -90 dB to 0 dB. Displaying it as decibels is actually more useful than as a linear audio level, because the decibels are a logarithmic scale, which means that it more closely approximates how loud we perceive a sound.
     That said, you can use this to convert from decibels to linear:
     linear = pow (10, decibels / 20);
     and the reverse:
     decibels = log10 (linear) * 20;
     The range for the above decibels is negative infinity to zero, and for linear is 0.0 to 1.0. When the linear value is 0.0, that is -inf dB; linear at 1.0 is 0 dB.
     */
    float linear = pow (10, peakPowerForChannel / 20);
    _metelevelLabel.lineMeterLevel =linear;
    [_metelevelLabel  setNeedsDisplay];
    recorder.meteringEnabled = YES;//fix the long decay time   ( thx to http://mattlogandev.blogspot.jp/2013/06/easy-fix-for-slow-level-decay-time-with.html
    //    NSLog(@"%f",linear);
    [_meterLevelWaveView   updateRecordMeterLevel:linear];
    [_recordIconView  updateRecordMeterLevel:linear];
}



-(void)removeMicIconAndAddDeleteIcon{
    
    self.recordStatus = FZAudioRecordStatusMoveToCancel;
 
    [_deleteIconView  removeFromSuperview];
    [_recordIconView  removeFromSuperview];
    
    _deleteIconView = [[UIView  alloc]  initWithFrame:CGRectMake(0, 0, 328/2., 328/2.)];
    _deleteIconView.backgroundColor = [UIColor   clearColor];
    _deleteIconView.center  = CGPointMake(_deleteIconView.frame.size.width/2.,_deleteIconView.frame.size.width/2.);
    UIImageView  *deleteIcon = [[UIImageView  alloc]   initWithFrame:CGRectMake(0, 0, 170/2., 170/2.)];
    deleteIcon.image = [UIImage  imageNamed:@"删除灰@2x.png"];
    deleteIcon.center = CGPointMake(_recordView.frame.size.width/2., _recordView.frame.size.width/2.);
    UIImageView  *textHint = [[UIImageView  alloc]  initWithFrame:CGRectMake(164/2., 164/2., 130, 25)];
    textHint.image = [UIImage  imageNamed:@"上滑取消发送-删除@2x.png"];
    textHint.center = CGPointMake(_recordView.frame.size.width/2., _recordView.frame.size.width/2.+80);
    [_deleteIconView  addSubview:textHint];
    [_deleteIconView  addSubview:deleteIcon];
    [_recordView  addSubview:_deleteIconView];
    _deleteIconView.alpha = 0;
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        _deleteIconView.alpha = 1;
    } completion:^(BOOL finished)
     {
     }];
    
}

-(void)removeDeleteIconAndAddMicIcon{
    
    self.recordStatus = FZAudioRecordStatusRecording;
    [_deleteIconView  removeFromSuperview];
    [_recordIconView  removeFromSuperview];
    _recordIconView = [[RecordIconView  alloc]  initWithFrame:CGRectMake(0, 0, 328/2., 328/2.)];
    _recordIconView.backgroundColor = [UIColor   clearColor];
    _recordIconView.center  = CGPointMake(_recordView.frame.size.width/2.,_recordView.frame.size.width/2.);
    
    UIImageView  *micIcon = [[UIImageView  alloc]   initWithFrame:CGRectMake(0, 0, 170/2., 170/2.)];
    micIcon.image = [UIImage  imageNamed:@"麦克风@2x.png"];
    micIcon.center = CGPointMake(_recordIconView.frame.size.width/2., _recordIconView.frame.size.width/2.);
    UIImageView  *textHint = [[UIImageView  alloc]  initWithFrame:CGRectMake(164/2., 164/2., 130, 25)];
    textHint.image = [UIImage  imageNamed:@"上滑取消发送@2x.png"];
    textHint.center = CGPointMake(_recordIconView.frame.size.width/2., _recordIconView.frame.size.width/2.+80);
    [_recordIconView  addSubview:textHint];
    [_recordIconView  addSubview:micIcon];
    _recordIconView.iconImageView =micIcon;
    _recordIconView.countNumLabel.alpha = 0;
    
    
    [_recordView  addSubview:_recordIconView];
    
    _recordIconView.alpha = 0;
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        _recordIconView.alpha = 1;
    } completion:^(BOOL finished)
     {
     }];
    
}

-(void)showTooShortSign{
    
    [_deleteIconView  removeFromSuperview];
    [_recordIconView  removeFromSuperview];
    
    UIView  *shortSignView = [[UIView  alloc]  initWithFrame:CGRectMake(0, 0, 328/2., 328/2.)];
    shortSignView.backgroundColor = [UIColor   clearColor];
    shortSignView.center  = CGPointMake(shortSignView.frame.size.width/2.,shortSignView.frame.size.width/2.);
    UIImageView  *deleteIcon = [[UIImageView  alloc]   initWithFrame:CGRectMake(0, 0, 170/2., 170/2.)];
    deleteIcon.image = [UIImage  imageNamed:@"时间太短@2x.png"];
    deleteIcon.center = CGPointMake(_recordView.frame.size.width/2., _recordView.frame.size.width/2.);
    
    UIImageView  *textHint = [[UIImageView  alloc]  initWithFrame:CGRectMake(164/2., 164/2., 130, 25)];
    textHint.image = [UIImage  imageNamed:@"时间太短提醒@2x.png"];
    textHint.center = CGPointMake(_recordView.frame.size.width/2., _recordView.frame.size.width/2.+80);
    
    
    [shortSignView  addSubview:textHint];
    [shortSignView  addSubview:deleteIcon];
    [self.fromController.view   addSubview:shortSignView];
    
    shortSignView.alpha = 0;
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        shortSignView.alpha = 1;
    } completion:^(BOOL finished)
     {
         [shortSignView  removeFromSuperview];
     }];
    
}
-(void)handleTimer:(id)sender{
    if (secendsCount>=51 &&secendsCount<=60){
        [_recordIconView.iconImageView   setImage: [UIImage  imageNamed:@"倒计时底板@2x.png"]];
        [_recordIconView.countNumLabel  removeFromSuperview];
        _recordIconView.countNumLabel.alpha = 1;
        _recordIconView.countNumLabel =[[UILabel  alloc]  init];
        _recordIconView.countNumLabel.frame = _recordIconView.iconImageView.bounds;
        [_recordIconView.iconImageView  addSubview:_recordIconView.countNumLabel];
        _recordIconView.countNumLabel.backgroundColor =[UIColor  clearColor];
        _recordIconView.countNumLabel.text  = [NSString  stringWithFormat:@"%d",60-secendsCount];
        _recordIconView.countNumLabel.font = [UIFont  boldSystemFontOfSize:50];
        _recordIconView.countNumLabel.textColor = [UIColor   whiteColor];
        _recordIconView.countNumLabel.textAlignment =NSTextAlignmentCenter;
    }
    if (secendsCount>=60) {
        [self  recordComplete];
        timeOut_60s = YES;
        [_recordIconView.iconImageView   setImage: [UIImage  imageNamed:@"麦克风@2x.png"]];
        _recordIconView.countNumLabel.alpha = 0;
    }
}
-(void)dealloc{
    NSLog(@"dealloc   dealloc");
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
}
@end