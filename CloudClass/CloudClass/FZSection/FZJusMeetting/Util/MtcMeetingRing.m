//
//  MtcMeetingRing.m
//  BatterHD
//
//  Created by Loc on 13-5-8.
//  Copyright (c) 2013年 juphoon. All rights reserved.
//

#import "MtcMeetingRing.h"
#import <AVFoundation/AVFoundation.h>

@interface MtcMeetingRing : NSObject

@end

@implementation MtcMeetingRing

- (id)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioSessionInterruption:) name:AVAudioSessionInterruptionNotification object:nil];
    }
    return self;
}

- (void)audioSessionInterruption:(NSNotification *)notification
{
    NSUInteger type = [[notification.userInfo valueForKey:AVAudioSessionInterruptionTypeKey] unsignedIntegerValue];
    if (type == AVAudioSessionInterruptionTypeEnded) {
        AudioSessionSetActive(true);
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

static AVAudioPlayer *_audioPlayer;
static BOOL _startRing = NO;
static NSURL *_fileURL;
static MtcMeetingRing *_mtcConfRing = nil;

static void MtcMeetingRingVolumeListenerCallback(void                      *inClientData,
                                          AudioSessionPropertyID    inID,
                                          UInt32                    inDataSize,
                                          const void                *inData)
{
    MtcMeetingRingStopRing();
}

static void MtcMeetingRingAudioServicesSystemSoundCompletionProc(SystemSoundID ssID, void *clientData)
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void) {
        if (!_audioPlayer || !_startRing) {
            return;
        }
        
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    });
}

void MtcMeetingRingInit(NSURL *fileURL)
{
    if ([fileURL isEqual:_fileURL]) {
        return;
    }
    
    if (!SYSTEM_VERSION_LESS_THAN(@"6.0")) {
        if (!_mtcConfRing) {
            _mtcConfRing = [[MtcMeetingRing alloc] init];
        }
    }
    
    UInt32 sessionCategory = kAudioSessionCategory_AmbientSound;
    AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(UInt32), &sessionCategory);

    _fileURL = fileURL;
    NSURL *url = _fileURL;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:_fileURL error:NULL];
        audioPlayer.numberOfLoops = -1;
        [audioPlayer prepareToPlay];
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (![url isEqual:_fileURL]) {
                return;
            }
            
            _audioPlayer = audioPlayer;
            if (_startRing) {
                MtcMeetingRingStartRing();
            }
        });
    });
}

void MtcMeetingRingReset(NSURL *fileURL)
{
    if ([fileURL isEqual:_fileURL]) {
        return;
    }
    
    _fileURL = fileURL;
    NSURL *url = _fileURL;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:_fileURL error:NULL];
        [audioPlayer prepareToPlay];
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (![url isEqual:_fileURL]) {
                return;
            }
            
            _audioPlayer = audioPlayer;
            MtcMeetingRingStartPlay();
        });
    });
}

void MtcMeetingRingStartRing()
{
    _startRing = YES;
    
    if (!_audioPlayer) {
        return;
    }

    AudioSessionSetActive(false);
    UInt32 sessionCategory = kAudioSessionCategory_SoloAmbientSound;
    AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(UInt32), &sessionCategory);
    AudioSessionAddPropertyListener(kAudioSessionProperty_CurrentHardwareOutputVolume, MtcMeetingRingVolumeListenerCallback, NULL);
    AudioSessionSetActive(true);
    
    AudioServicesAddSystemSoundCompletion(kSystemSoundID_Vibrate, NULL, NULL, MtcMeetingRingAudioServicesSystemSoundCompletionProc, NULL);
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    _audioPlayer.numberOfLoops = -1;
    _audioPlayer.currentTime = 0;
    [_audioPlayer play];
}

void MtcMeetingRingStopRing()
{
    if (!_startRing) {
        return;
    }
    
    _startRing = NO;
    
    AudioSessionRemovePropertyListenerWithUserData(kAudioSessionProperty_CurrentHardwareOutputVolume, MtcMeetingRingVolumeListenerCallback, NULL);
    
    AudioServicesRemoveSystemSoundCompletion(kSystemSoundID_Vibrate);

    if (_audioPlayer) {
        [_audioPlayer stop];
    }
}

BOOL MtcMeetingRingIsPlaying()
{
    return [_audioPlayer isPlaying];
}

void MtcMeetingRingStartPlay()
{
    if (_audioPlayer) {
        _audioPlayer.numberOfLoops = 0;
        _audioPlayer.currentTime = 0;
        [_audioPlayer play];
    }
}

void MtcMeetingRingStopPlay()
{
    if (_audioPlayer) {
        [_audioPlayer stop];
    }
}

void MtcMeetingRingResetCategory()
{
    AudioSessionSetActiveWithFlags(false, kAudioSessionSetActiveFlag_NotifyOthersOnDeactivation);
    UInt32 sessionCategory = kAudioSessionCategory_AmbientSound;
    AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(UInt32), &sessionCategory);
    AudioSessionSetActive(true);
}

BOOL MtcMeetingAudioAccessoryConnected()
{
    CFDictionaryRef route = nil;
    UInt32 size = sizeof(route);
    AudioSessionGetProperty(kAudioSessionProperty_AudioRouteDescription, &size, &route);
    if (!route) {
        return NO;
    }
    
    CFArrayRef outputs = CFDictionaryGetValue(route, kAudioSession_AudioRouteKey_Outputs);
    if (!outputs) {
        return NO;
    }
    
    int count = (int)CFArrayGetCount(outputs);
    for (int i = 0; i < count; ++i) {
        CFDictionaryRef output = CFArrayGetValueAtIndex(outputs, i);
        CFStringRef outputType = CFDictionaryGetValue(output, kAudioSession_AudioRouteKey_Type);
        if ((CFStringCompare(outputType, kAudioSessionOutputRoute_BuiltInReceiver, 0) != kCFCompareEqualTo)
            &&
            (CFStringCompare(outputType, kAudioSessionOutputRoute_BuiltInSpeaker, 0) != kCFCompareEqualTo)) {
            return YES;
        }
    }
    
    return NO;
}
