//
//  FCSpeakerConfigManager.m
//  Pods
//
//  Created by patty on 15/11/23.
//
//

#import "FCSpeakerConfigManager.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVAudioSession.h>

@implementation FCSpeakerConfigManager
{
    BOOL _headSetPluggedIn;
}

+ (FCSpeakerConfigManager *)shareInstance
{
    static FCSpeakerConfigManager *configManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        configManager = [[FCSpeakerConfigManager alloc] init];
    });
    return configManager;
}

// 返回YES代表在耳机状态
-(BOOL)isHeadsetPluggedIn {
    _headSetPluggedIn = NO;
    AVAudioSessionRouteDescription* route = [[AVAudioSession sharedInstance] currentRoute];
    for (AVAudioSessionPortDescription* desc in [route outputs]) {
        if ([[desc portType] isEqualToString:AVAudioSessionPortHeadphones])
            _headSetPluggedIn = YES;
    }
    return _headSetPluggedIn;
}

- (void)resetOutputTarget {
    if(_headSetPluggedIn){
        UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_None;
        AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(audioRouteOverride), &audioRouteOverride);
    }else{
        UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
        AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(audioRouteOverride), &audioRouteOverride);
    }
}


@end
