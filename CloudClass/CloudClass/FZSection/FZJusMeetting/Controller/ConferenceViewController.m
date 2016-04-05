//
//  CallingViewController.m
//  CCSample
//
//  Created by 杨海佳 on 15/1/8.
//  Copyright (c) 2015年 young. All rights reserved.
//

#import "ConferenceViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVAudioSession.h>
#import "ConfErrorViewController.h"
#import "ConfUIImage+Tint.h"

#import "MtcMeetingRing.h"
#import "MtcConfSessTimer.h"
#import "ConfSettings.h"

#import "grape/zmf.h"
#import "lemon/service/rcs/mtc_call_ext.h"
#import "lemon/service/rcs/mtc_util.h"

#import "ConfUser.h"
#import "ConfUserView.h"
#import "ConfStatView.h"

#define kMainScreenWidth [UIScreen mainScreen].bounds.size.width
#define kMainScreenHeight [UIScreen mainScreen].bounds.size.height

#define kRingWaitingLen 4000

#define kErrorWindowNomalTag 0
#define kErrorWindowShowTag 1

#define kConfViewSpacing 5

#define kUserLanguageKey @"UserLanguage"

#define MtcUtilProductName() [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"]

BOOL MtcUtilSupportTelX()
{
    static BOOL supportTel = NO;
    static BOOL inited = NO;
    if (!inited) {
        inited = YES;
        NSString *model = [[UIDevice currentDevice] model];
        supportTel = [model isEqualToString:@"iPhone"];
    }
    return supportTel;
}

BOOL MtcUtilSystemVersionLessThanX(int version)
{
    NSString *versionString = [[NSString alloc] initWithFormat:@"%d", version];
    return SYSTEM_VERSION_LESS_THAN(versionString);
}

static ConferenceViewController *_confViewController = nil;
extern BOOL isConfFloatWindowShow;
static NSMutableArray *_callWaitingArray = nil;

@interface CallWaiting : NSObject <UIAlertViewDelegate>

@property (nonatomic, retain) NSString *confUri;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, assign) BOOL isVideo;
@property (nonatomic, retain) NSString *userUri;
@property (nonatomic, retain) UIAlertView *alertView;
@property (nonatomic, retain) UIAlertView *answerAlertView;
@property (nonatomic, retain) UILocalNotification *incomingNotification;

+ (void)show:(NSString *)confUri title:(NSString *)title isVideo:(BOOL)isVideo userUri:(NSString *)userUri;
+ (void)dismiss:(NSString *)userUri;
+ (void)dismissConf:(NSString *)confUri;
+ (void)dismissAll;

+ (void)active;
+ (BOOL)allowActive;

- (id)initWithConfUri:(NSString *)confUri title:(NSString *)title isVideo:(BOOL)isVideo userUri:(NSString *)userUri;
- (void)show;
- (void)dismiss;

@end

@implementation CallWaiting
@synthesize
confUri = _confUri,
title = _title,
isVideo = _isVideo,
userUri = _userUri,
alertView = _alertView,
answerAlertView = _answerAlertView,
incomingNotification = _incomingNotification;

+ (void)show:(NSString *)confUri title:(NSString *)title isVideo:(BOOL)isVideo userUri:(NSString *)userUri
{
    CallWaiting *callWaiting = [[CallWaiting alloc] initWithConfUri:confUri title:title isVideo:isVideo userUri:userUri];
    if (!_callWaitingArray) {
        _callWaitingArray = [[NSMutableArray alloc] init];
    }
    [_callWaitingArray addObject:callWaiting];
}

+ (void)dismiss:(NSString *)userUri
{
    if (!_callWaitingArray) {
        return;
    }
    
    NSArray *array = [[NSArray alloc] initWithArray:_callWaitingArray];
    for (CallWaiting *callWaiting in array) {
        if ([callWaiting.userUri caseInsensitiveCompare:userUri] == NSOrderedSame) {
            [callWaiting dismiss];
            [_callWaitingArray removeObject:callWaiting];
            break;
        }
    }
    
    if ([_callWaitingArray count] == 0) {
        _callWaitingArray = nil;
        Mtc_RingStop(EN_MTC_RING_RING);
    }
}

+ (void)dismissConf:(NSString *)confUri
{
    if (!_callWaitingArray) {
        return;
    }
    
    NSArray *array = [[NSArray alloc] initWithArray:_callWaitingArray];
    for (CallWaiting *callWaiting in array) {
        if ([callWaiting.confUri caseInsensitiveCompare:confUri] == NSOrderedSame) {
            [callWaiting dismiss];
            [_callWaitingArray removeObject:callWaiting];
        }
    }
    
    if ([_callWaitingArray count] == 0) {
        _callWaitingArray = nil;
        Mtc_RingStop(EN_MTC_RING_RING);
    }
}

+ (void)dismissAll
{
    if (!_callWaitingArray) {
        return;
    }
    
    NSArray *array = [[NSArray alloc] initWithArray:_callWaitingArray];
    for (CallWaiting *callWaiting in array) {
        [callWaiting dismiss];
    }
    
    [_callWaitingArray removeAllObjects];
    _callWaitingArray = nil;
}

+ (void)termAll
{
    if (!_callWaitingArray) {
        return;
    }
    
    NSArray *array = [[NSArray alloc] initWithArray:_callWaitingArray];
    for (CallWaiting *callWaiting in array) {
        [_confViewController decline:callWaiting.confUri userUri:callWaiting.userUri];
        [callWaiting cancelNotification];
        [callWaiting dismiss];
    }
    
    [_callWaitingArray removeAllObjects];
    _callWaitingArray = nil;
}

+ (void)active
{
    CallWaiting *callWaiting = [_callWaitingArray firstObject];
    [callWaiting dismiss];
    [_callWaitingArray removeObject:callWaiting];
    [_confViewController inviteReceived:callWaiting.confUri title:callWaiting.title isVideo:callWaiting.isVideo userUri:callWaiting.userUri];
}

+ (BOOL)allowActive
{
    return (_callWaitingArray && [_callWaitingArray count]);
}

- (id)initWithConfUri:(NSString *)confUri title:(NSString *)title isVideo:(BOOL)isVideo userUri:(NSString *)userUri
{
    self = [super init];
    if (self) {
        self.confUri = confUri;
        self.title = title;
        self.isVideo = isVideo;
        self.userUri = userUri;
        
        [self show];
        Mtc_RingPlay(EN_MTC_RING_RING, kRingWaitingLen);
    }
    return self;
}

- (void)postNotification:(NSString *)alertBody
{
    if ([UIApplication sharedApplication].applicationState != UIApplicationStateActive) {
        self.incomingNotification = [[UILocalNotification alloc] init];
        self.incomingNotification.alertBody = [NSString stringWithFormat:@"%@ %@", kMeetingStringGroupCall, self.title];
        self.incomingNotification.userInfo = @{ConfIncomingNotificationConfUriKey:self.confUri,
                                               ConfIncomingNotificationIsVideoKey:[NSNumber numberWithBool:self.isVideo],
                                               ConfIncomingNotificationUserUriKey:self.userUri};
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
            self.incomingNotification.category = ConfIncomingNotificationCategory;
        }
        self.incomingNotification.alertBody = alertBody;
        [[UIApplication sharedApplication] presentLocalNotificationNow:self.incomingNotification];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelNotification) name:UIApplicationDidBecomeActiveNotification object:nil];
    }
}

- (void)cancelNotification
{
    if (self.incomingNotification) {
        [[UIApplication sharedApplication] cancelLocalNotification:self.incomingNotification];
        self.incomingNotification = nil;
    }
}

- (void)show
{
    NSString *message = [NSString stringWithFormat:@"%@ %@", kMeetingStringGroupCall, self.title];
    self.alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:kMeetingStringIgnore otherButtonTitles:kMeetingStringEndAndAnswer, kMeetingStringDecline, nil];
    [self.alertView show];
    
    [self postNotification:message];
}

- (void)dismiss
{
    if (self.alertView) {
        [self.alertView dismissWithClickedButtonIndex:self.alertView.cancelButtonIndex animated:YES];
        self.alertView = nil;
    }
    
    if (self.answerAlertView) {
        [self.answerAlertView dismissWithClickedButtonIndex:self.answerAlertView.cancelButtonIndex animated:YES];
        self.answerAlertView = nil;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView isEqual:self.answerAlertView]) {
        self.answerAlertView = nil;
        [self show];
        return;
    }
    
    [self cancelNotification];
    Mtc_RingStop(EN_MTC_RING_RING);
    
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:kMeetingStringIgnore]) {
        
    } else if ([buttonTitle isEqualToString:kMeetingStringDecline]) {
        [_confViewController decline:self.confUri userUri:self.userUri];
    } else {
        if ([MtcMeetingManager isCSCalling]) {
            self.answerAlertView = [[UIAlertView alloc] initWithTitle:nil message:[[NSString alloc] initWithFormat:kMeetingStringPleaseHangUpTheRegularCallBeforeYouAnswer, MtcUtilProductName()] delegate:self cancelButtonTitle:kMeetingStringOk otherButtonTitles:nil];
            [self.answerAlertView show];
            return;
        }
        [_confViewController answer:self.confUri title:self.title userUri:self.userUri isVideo:self.isVideo];
    }
    
    [_callWaitingArray removeObject:self];
}

@end

enum {
    CallVideoCurrent = -1,
    CallVideoFrontCamera,
    CallVideoRearCamera,
    CallVideoCameraOff,
    CallVideoVoiceOnly
};

enum {
    CallAudioRouteDefault = -1,
    CallAudioRouteHeadset,
    CallAudioRouteBluetooth,
    CallAudioRouteSpeaker,
    CallAudioRouteReceiver,
    CallAudioRouteOther
};

#define ConfIsVideo (_confVideo<CallVideoVoiceOnly)

static NSString * const SpeakerButtonImage[5] = {@"JusMeeting.bundle/call-voiceheadset", @"JusMeeting.bundle/call-voicebluetooth", @"JusMeeting.bundle/call-voicespeaker", @"JusMeeting.bundle/call-voicereceiver", @"JusMeeting.bundle/call-voiceothers"};

static int _bluetooth = 0;
static int _otherRoute = 0;

static void audioRouteChangeListenerCallback(void                      *inUserData,
                                             AudioSessionPropertyID    inPropertyID,
                                             UInt32                    inPropertyValueS,
                                             const void                *inPropertyValue
                                             )
{
    ConferenceViewController *viewController = (__bridge ConferenceViewController *)inUserData;
    [viewController audioRouteChange:inPropertyValue];
}

@interface ConferenceViewController () <UIActionSheetDelegate, UIAlertViewDelegate, ConfFloatWindowDelegate, ConfUserViewDelegate>
{
    //  session state
    JMeetingId _sessId;
    int _sessState;
    int _video;
    BOOL _rtpConnected;
    MtcConfSessTimer *_sessTimer;
    MtcConfSessTimer *_returnTimer;
    
    BOOL _reconnecting;
    BOOL _paused;
    BOOL _pausedByCS;
    BOOL _audioInterrupted;
    ZUINT _videoReceiveStatusX;
    BOOL _isVideo;
    
    int _audioErrorTimes;
    BOOL _audioStarted;
    BOOL _audioStarting;
    BOOL _speakerStarted;
    BOOL _speakerStarting;
    BOOL _speakerSwitching;
    int _audioRoute;
    MPVolumeView *_volumeView;
    
    UIAlertView *_errorAlertView;
    
    NSString *_termedRingPath;
    int _termedRingTimes;
    
    UIAlertView *_answerAlertView;
    
    UIView *_backgroundView;
    
    BOOL _disconnectedTiming;
    
    UIWindow *_errorWindow;
    ConfErrorViewController *_confErrorViewController;
    
    BOOL _isFrontCamera;
    
    UIDeviceOrientation _orientation;
    
    NSString *_tempPhone;
    NSString *_tempDisplayName;
    BOOL _tempIsVideo;
    
    //conference state
    JMeetingId _confId;
    NSString *_confUri;
    NSString *_confTitle;
    int _confVideo;
    NSString *_targetUserUri;

    ConfUser *_currentUser;
    NSMutableArray *_confUserArray;
    NSMutableArray *_confUserViewArray;
    NSMutableArray *_confInviteArray;
    NSMutableArray *_confInviteFailedAlertViewArray;

    NSString *_username;
    NSString *_userUri;
    NSString *_dispName;
    UIAlertView *_didLeaveAlertView;
    UIActionSheet *_kickActionSheet;
    NSString *_kickUserUri;
    ConfStatView *_confStatisticsView;
    
    UIButton *_previewCameraOffView;
    
    UIView *_shareScreenView;
    NSString *_shareScreenUri;
    
    CGSize _confViewCellSize;
    CGSize _largeViewSize;
    CGFloat _largeViewToTop;
}

@end

@implementation ConferenceViewController

ZUINT _videoReceiveStatusX;

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


# pragma batter code

- (UIView *)preview
{
    if (!_preview) {
        CGFloat screenWidth = kMainScreenWidth;
        _largeViewSize = CGSizeMake(screenWidth, screenWidth);
        _preview = [[ZmfView alloc] initWithFrame:self.view.bounds];
        _preview.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _preview.layer.masksToBounds = YES;
        _preview.layer.borderWidth = 1.0f;
        _preview.layer.borderColor = [[UIColor clearColor] CGColor];
        _preview.alpha = 0;
        _preview.backgroundColor = [UIColor clearColor];
        [self.view insertSubview:_preview belowSubview:self.callView];
        CGFloat cellWidth = (screenWidth - 25) / 4;
        _confViewCellSize = CGSizeMake(cellWidth, cellWidth + 20);
        _largeViewToTop = kMainScreenHeight;
        _largeViewToTop = (_largeViewToTop - _confViewCellSize.height - _largeViewSize.height) / 2;
        Zmf_VideoRenderStart((__bridge void *)(_preview), ZmfRenderViewFx);
    }
    
//    BOOL allCanKick = ([MtcMeetingManager getPorperty:MtcMeetingPropertyKeyAllCanKick]).boolValue;
//    if (allCanKick) {
//    } else {
//    }
    return _preview;
}

- (ConfFloatWindow *)floatWindow
{
    if (!_floatWindow) {
        _floatWindow = [[ConfFloatWindow alloc] initWithFrame:CGRectMake(200, 80, 80, 120) isVideo:ConfIsVideo time:_sessTimer];
        _floatWindow.floatWindowDelegate = self;
    }
    return _floatWindow;
}

- (void)startPreview
{
    if (MtcUtilSystemVersionLessThanX(7)) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:YES];
    } else {
        [self setNeedsStatusBarAppearanceUpdate];
    }
    
    const char *pcCapture = NULL;
    switch (_confVideo) {
        case CallVideoFrontCamera:
            pcCapture = ZmfVideoCaptureFront;
            break;
        case CallVideoRearCamera:
            pcCapture = ZmfVideoCaptureBack;
            break;
        case CallVideoCameraOff:
            pcCapture = _isFrontCamera ? ZmfVideoCaptureFront : ZmfVideoCaptureBack;
            break;
        default:
            return;
    }
    
    [self videoCaptureStart];
    Zmf_VideoRenderAdd((__bridge void *)self.preview, pcCapture, 0, ZmfRenderFullScreen);
}

- (void)stopVideo:(JMeetingId)dwConfId
{
    if (dwConfId != _confId) {
        return;
    }
    
    if (MtcUtilSystemVersionLessThanX(7)) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:YES];
    } else {
        [self setNeedsStatusBarAppearanceUpdate];
    }
    
    [self showCallView];
    
    Zmf_VideoCaptureStopAll();
    
    if (_preview) {
        Zmf_VideoRenderRemoveAll((__bridge void *)_preview);
        Zmf_VideoRenderStop((__bridge void *)_preview);
        [_preview removeFromSuperview];
        _preview = nil;
    }
    
    if (_sessState != ConfStateNone) {
        [self setErrorText:kMeetingStringSwitchedToVoiceCall needFreeze:NO];
        [self performSelector:@selector(switchedToVoiceCall) withObject:nil afterDelay:2];
        [self configVoiceButton];
    } else {
        [self setErrorText];
    }
    
    for (ConfUser *user in _confUserArray) {
        [user stopRender];
    }
    [self dismissShareScreenView];
}

- (void)netStaChanged:(JMeetingId)dwSessId video:(int)bVideo send:(int)bSend status:(int)iStatus
{
    if (bSend) return;
    
    if (dwSessId != _confId) return;
    
    if (!bVideo) {
        [self setErrorText];
        if (iStatus > EN_MTC_NET_STATUS_DISCONNECTED) {
            [self stopDisconnectedTimer:dwSessId];
        }
    }
}

- (void)didBecomeActive
{
    
}

- (BOOL)isCalling
{
    
    return _sessState > ConfStateNone && _sessState <= ConfStateTalking;
    
}

- (BOOL)isTalking
{
    
    return _sessState >= ConfStateConnecting && _sessState <= ConfStateTalking;
    
}

-(void)switchFloatWindow:(BOOL)enable
{
    if (enable)
        [self shrink:0];
    else
        [self conffloatWindowClick];
}

#pragma mark - Call Function

- (IBAction)end:(id)sender
{
    [self endConf];
}

- (IBAction)answer:(id)sender
{
    [self answerWithVideo:CallVideoCurrent];
}

- (void)answerWithVideo:(int)video
{
    if ([MtcMeetingManager isCSCalling]) {
        _answerAlertView = [[UIAlertView alloc] initWithTitle:nil message:[[NSString alloc] initWithFormat:kMeetingStringPleaseHangUpTheRegularCallBeforeYouAnswer, MtcUtilProductName()] delegate:nil cancelButtonTitle:kMeetingStringOk otherButtonTitles:nil];
        [_answerAlertView show];
        return;
    }
    
    MtcMeetingRingStopRing();
    
    [self answerConfWithVideo:video];
}

- (IBAction)mute:(id)sender
{
    BOOL muted = !self.muteButton.selected;
    [self.muteButton setSelected:muted];
    [self mute];
}

- (void)mute
{
    if (_confId != ZINVALIDID) {
        if (self.muteButton.selected) {
            Mtc_ConfStopSend(_confId, MTC_CONF_MEDIA_AUDIO);
        } else {
            Mtc_ConfStartSend(_confId, MTC_CONF_MEDIA_AUDIO);
        }
    }
}

- (IBAction)cameraSwitch:(id)sender
{
    [self confCameraOn:(_confVideo == CallVideoRearCamera)];
}

- (IBAction)cameraOff:(id)sender
{
    BOOL cameraOn = !self.cameraOffButton.selected;
    [self.cameraOffButton setSelected:cameraOn];
    [self.globalCameraOffButton setSelected:cameraOn];
    if (cameraOn) {
        _isFrontCamera = (_confVideo == CallVideoFrontCamera);
        [self confCameraOff];
    } else {
        [self confCameraOn:_isFrontCamera];
    }
}

- (IBAction)addMember:(id)sender {
    NSDictionary *userInfo = @{@JusMeetingViewKey : self};
    [[NSNotificationCenter defaultCenter] postNotificationName:@JusMeetingInvitingNotification object:nil userInfo:userInfo];
}

- (IBAction)voice:(id)sender
{
//    if (AirPlaySupport() && CallIsVideo) {
//        [self showVolumeView];
//    } else {
        if ((_bluetooth <= 0) && (_otherRoute <= 0)) {
//            BOOL speaker = !self.speakerButton.selected;
//            self.speakerButton.selected = speaker;
            
            if (_speakerSwitching) {
                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(speaker) object:nil];
                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(speakerSwitched) object:nil];
                [self performSelector:@selector(speaker) withObject:nil afterDelay:1];
            } else {
                [self speaker];
            }
            return;
        }
        
        [self showVolumeView];
//    }
}

- (IBAction)shrink:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:NO completion:nil];
    NSString *renderId = _shareScreenView ? _shareScreenUri : _currentUser.renderId;
    [self.floatWindow show:renderId];
}

- (IBAction)kickUser:(id)sender {
    [self kickConfUser:_currentUser];
}

- (void)conffloatWindowClick
{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    UIViewController *viewController = window.rootViewController;
    [viewController presentViewController:self animated:NO completion:nil];
    [self.floatWindow dismiss];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FloatWindowDismissNotification" object:nil userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:_confId] forKey:@"MtcSessionIdKey"]];
}

- (void)showVolumeView
{
    if (!_volumeView) {
        _volumeView = [[MPVolumeView alloc] init];
        _volumeView.hidden = YES;
        [self.callingView insertSubview:_volumeView belowSubview:self.declineView];
    }
    
    for (UIView *view in _volumeView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)view;
            [button sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
    }
}

- (void)speaker
{
//    BOOL selected = self.speakerButton.selected;
    BOOL selected = NO;
    
    if (_bluetooth > 0 || _otherRoute > 0) {
        return;
    }
    if (!_audioStarted) {
        return;
    }
    
    if (selected) {
        UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
        if (!_speakerStarted) {
            _speakerStarting = YES;
            AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(UInt32), &audioRouteOverride);
            audioRouteOverride = kAudioSessionOverrideAudioRoute_None;
            AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(UInt32), &audioRouteOverride);
            audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
            _speakerStarted = YES;
        }
        AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(UInt32), &audioRouteOverride);
    } else {
        UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_None;
        AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(UInt32), &audioRouteOverride);
    }
    _speakerSwitching = YES;
    [self performSelector:@selector(speakerSwitched) withObject:nil afterDelay:1];
}

- (void)speakerSwitched
{
    _speakerSwitching = NO;
}

- (BOOL)setSpeakerIfNeeded
{
    if ((_bluetooth <= 0) && (_otherRoute <= 0)) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self speaker];
        });
        return YES;
    }
    return NO;
}

- (void)audioRouteChange:(const void *)inPropertyValue
{
    if (_sessState == ConfStateNone || _sessState == ConfStateEnding || _sessState == ConfStateIncoming) {
        return;
    }
    
    CFDictionaryRef propertyValue = inPropertyValue;
    CFNumberRef reason = CFDictionaryGetValue(propertyValue, kAudioSession_RouteChangeKey_Reason);
    SInt32 routeChangeReason;
    CFNumberGetValue(reason, kCFNumberSInt32Type, &routeChangeReason);
    
    if (routeChangeReason == kAudioSessionRouteChangeReason_OldDeviceUnavailable) {
        CFDictionaryRef previousRoute = CFDictionaryGetValue(propertyValue, kAudioSession_AudioRouteChangeKey_PreviousRouteDescription);
        CFArrayRef outputs = CFDictionaryGetValue(previousRoute, kAudioSession_AudioRouteKey_Outputs);
        CFDictionaryRef output = CFArrayGetValueAtIndex(outputs, 0);
        CFStringRef outputType = CFDictionaryGetValue(output, kAudioSession_AudioRouteKey_Type);
        if (CFStringCompare(outputType, kAudioSessionOutputRoute_BluetoothHFP, 0) == kCFCompareEqualTo || CFStringCompare(outputType, kAudioSessionOutputRoute_BluetoothA2DP, 0) == kCFCompareEqualTo) {
            if (--_bluetooth < 0) {
                _bluetooth = 0;
            }
        } else {
            if (--_otherRoute < 0) {
                _otherRoute = 0;
            }
        }
    }
    
    CFDictionaryRef route = CFDictionaryGetValue(propertyValue, kAudioSession_AudioRouteChangeKey_CurrentRouteDescription);
    CFArrayRef outputs = CFDictionaryGetValue(route, kAudioSession_AudioRouteKey_Outputs);
    if (CFArrayGetCount(outputs) == 0) {
        return;
    }
    CFDictionaryRef output = CFArrayGetValueAtIndex(outputs, 0);
    CFStringRef outputType = CFDictionaryGetValue(output, kAudioSession_AudioRouteKey_Type);
    
    if (CFStringCompare(outputType, kAudioSessionOutputRoute_Headphones, 0) == kCFCompareEqualTo) {
        _audioRoute = CallAudioRouteHeadset;
    } else if (CFStringCompare(outputType, kAudioSessionOutputRoute_BluetoothHFP, 0) == kCFCompareEqualTo || CFStringCompare(outputType, kAudioSessionOutputRoute_BluetoothA2DP, 0) == kCFCompareEqualTo) {
        _audioRoute = CallAudioRouteBluetooth;
        if (routeChangeReason == kAudioSessionRouteChangeReason_NewDeviceAvailable) {
            ++_bluetooth;
        }
        if (_bluetooth <= 0) {
            _bluetooth = 1;
        }
    } else if (CFStringCompare(outputType, kAudioSessionOutputRoute_BuiltInSpeaker, 0) == kCFCompareEqualTo) {
        _audioRoute = CallAudioRouteSpeaker;
    } else if (CFStringCompare(outputType, kAudioSessionOutputRoute_BuiltInReceiver, 0) == kCFCompareEqualTo) {
        _audioRoute = CallAudioRouteReceiver;
    } else {
        _audioRoute = CallAudioRouteOther;
        if (routeChangeReason == kAudioSessionRouteChangeReason_NewDeviceAvailable) {
            ++_otherRoute;
        }
        if (_otherRoute <= 0) {
            _otherRoute = 1;
        }
    }
    
    if (_audioRoute != CallAudioRouteBluetooth) {
        if (_bluetooth > 0 && !MtcUtilSystemVersionLessThanX(7)) {
            AVAudioSession *audioSession = [AVAudioSession sharedInstance];
            NSArray *inputs = audioSession.availableInputs;
            BOOL bluetoothAvailabel = NO;
            for (AVAudioSessionPortDescription *desc in inputs) {
                NSString *type = desc.portType;
                if ([type isEqualToString:AVAudioSessionPortBluetoothHFP]
                    || [type isEqualToString:AVAudioSessionPortBluetoothA2DP]
                    || [type isEqualToString:AVAudioSessionPortBluetoothLE]) {
                    bluetoothAvailabel = YES;
                    break;
                }
            }
            
            if (!bluetoothAvailabel) {
                _bluetooth = 0;
            }
            
            if (_otherRoute <= 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString *image = SpeakerButtonImage[CallAudioRouteSpeaker];
//                    [self.speakerButton setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
                });
            }
        }
    }
    
    if ((routeChangeReason == kAudioSessionRouteChangeReason_OldDeviceUnavailable)
        && (_audioRoute == CallAudioRouteReceiver)
        && _otherRoute <= 0 && _bluetooth <= 0
        && ConfIsVideo) {
        UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
        AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(UInt32), &audioRouteOverride);
        return;
    }
    
    if (_audioStarted) {
        if (_speakerStarting) {
            if (_audioRoute != CallAudioRouteSpeaker) {
                _speakerStarting = NO;
            }
        }
        
        if ((routeChangeReason == kAudioSessionRouteChangeReason_CategoryChange)
            && _bluetooth <= 0
            && ConfIsVideo) {
            return;
        }
        
        dispatch_block_t block = ^(void){
            [self configVoiceButton];
            
            if (!MtcUtilSupportTelX()) {
                if (_bluetooth > 0 || _otherRoute > 0) {
//                    self.speakerButton.enabled = YES;
                } else {
                    BOOL accessoryConnected = MtcMeetingAudioAccessoryConnected();
                    if (accessoryConnected) {
//                        self.speakerButton.enabled = YES;
                    } else {
                        if (routeChangeReason == kAudioSessionRouteChangeReason_Override) {
//                            self.speakerButton.enabled = YES;
                        } else {
//                            self.speakerButton.enabled = NO;
                        }
                    }
                }
            }
        };
        if ([NSThread isMainThread]) {
            block();
        } else {
            dispatch_async(dispatch_get_main_queue(), block);
        }
    }
}

- (void)configVoiceButton
{
    if (_bluetooth > 0 || _otherRoute > 0) {
        NSString *image = SpeakerButtonImage[_audioRoute];
//        [self.speakerButton setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    }
//    self.speakerButton.selected = (_audioRoute == CallAudioRouteSpeaker);
}

- (void)initSpeaker
{
    if (_bluetooth > 0 || _otherRoute > 0) {
        NSString *image = SpeakerButtonImage[CallAudioRouteBluetooth];
//        [self.speakerButton setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
        if (!MtcUtilSupportTelX()) {
//            self.speakerButton.enabled = YES;
        }
    } else {
        BOOL defaultRoute = (_audioRoute == CallAudioRouteDefault);
        if (ConfIsVideo || !MtcUtilSupportTelX()) {
            BOOL select = defaultRoute ? !MtcMeetingAudioAccessoryConnected() : (_audioRoute == CallAudioRouteSpeaker);
//            self.speakerButton.selected = select;
        } else {
            BOOL select = defaultRoute ? NO : (_audioRoute == CallAudioRouteSpeaker);
//            self.speakerButton.selected = select;
        }
        if (!MtcUtilSupportTelX()) {
//            self.speakerButton.enabled = MtcMeetingAudioAccessoryConnected();
        }
    }
}

- (void)showCallView:(UITapGestureRecognizer *)gestureRecognizer
{
    if (_errorWindow) {
        CGPoint point = [gestureRecognizer locationInView:_confErrorViewController.errorButton];
        if (CGRectContainsPoint(_confErrorViewController.cancelButton.frame, point)) {
            _errorWindow.hidden = YES;
            return;
        }
        if (CGRectContainsPoint(_confErrorViewController.errorButton.frame, point)) {
            return;
        }
    }
    
    if (!_confUserViewArray || [_confUserViewArray count] == 0) {
        return;
    }
    
    CGPoint point = [gestureRecognizer locationInView:self.view];
    CGRect contentFrame = CGRectMake(0, 0, self.confScrollView.contentSize.width, self.confScrollView.contentSize.height);
    if (CGRectContainsPoint(contentFrame, point)) {
        return;
    }
    
    if (self.callView.hidden) {
        [self showCallView];
    } else {
        [self hideCallView];
    }
}

- (void)hideCallView
{
    [self hideCallView:YES];
}

- (void)hideCallView:(BOOL)animation
{
    self.callView.hidden = YES;
    if (MtcUtilSystemVersionLessThanX(7)) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    } else {
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

- (void)showCallView
{
    self.callView.hidden = NO;
    if (MtcUtilSystemVersionLessThanX(7)) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    } else {
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

- (IBAction)statistics:(id)sender
{
    [self showConfStatisticsView:_currentUser.userUri];
}

- (void)netChanged:(NSNotification *)notification
{
    if (_sessState < ConfStateTalking) {
        return;
    }
    
    //    if (MtcDelegateNet() != MTC_ANET_UNAVAILABLE) {
    //        _reconnecting = YES;
    //    }
    [self setErrorText];
}

- (void)callDisconnected
{
    Mtc_ConfLeave(_confId);
    NSDictionary * userInfo = @{@"MtcConfIdKey" : JIdToNumber(_confId)};
    //[NSDictionary dictionaryWithObjectsAndKeys:_confId, @"MtcConfIdKey", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@JusMeetingDidLeaveNotification object:nil userInfo:userInfo];
    _sessState = ConfStateDisconnected;
    [self termedConf:_confId statCode:EN_CONF_DELEGATE_FAIL_CALL_DISC reason:nil];
}

#pragma mark - View Controller

- (id)init
{
    self = [super initWithNibName:@"ConferenceViewController" bundle:meetingResourcesBundle];
    if (self) {
        _isFrontCamera = YES;
        _audioRoute = CallAudioRouteDefault;
        _orientation = UIDeviceOrientationPortrait;
        self.wantsFullScreenLayout = YES;
        self.view.bounds = [UIApplication sharedApplication].delegate.window.bounds;
        
        _confId = ZINVALIDID;
        _confUri = nil;
        _confUserArray = nil;
        _confInviteArray = nil;
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        _username = [userDefaults stringForKey:@"username"];
        
        // configration for customers who don't want time and name shown.
        self.nameLabel.hidden = YES;
        self.timeLabel.hidden = YES;
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    AudioSessionRemovePropertyListenerWithUserData(kAudioSessionProperty_AudioRouteChange, audioRouteChangeListenerCallback, (__bridge void *)(self));
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.callView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];
    [self.declineView setText:kMeetingStringDecline];
    [self.answerView setText:kMeetingStringAnswer];
    
    CGSize size = self.answerView.button.frame.size;
    self.answerView.button.layer.cornerRadius = size.height / 2;
    [self.answerView.button setBackgroundImage:[UIImage confColoredImage:[ConfSettings callAnswerColor] size:size] forState:UIControlStateNormal];
    size = self.declineView.button.frame.size;
    self.declineView.button.layer.cornerRadius = size.height / 2;
    [self.declineView.button setBackgroundImage:[UIImage confColoredImage:[ConfSettings callEndColor] size:size] forState:UIControlStateNormal];
    
    self.shrinkButton.hidden = YES;
    self.globalMenuView.hidden = YES;
    self.addMemberButton.hidden = YES;
    
    self.selfMenuView.hidden = YES;
    self.otherMenuView.hidden = YES;
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter addObserver:self selector:@selector(audioStarted) name:ZmfAudioOutputDidStart object:nil];
    [notificationCenter addObserver:self selector:@selector(audioInterrupted) name:ZmfAudioInterrupted object:nil];
    [notificationCenter addObserver:self selector:@selector(audioResume) name:ZmfAudioDidResume object:nil];
    [notificationCenter addObserver:self selector:@selector(audioError) name:ZmfAudioErrorOccurred object:nil];
    AudioSessionAddPropertyListener(kAudioSessionProperty_AudioRouteChange, audioRouteChangeListenerCallback, (__bridge void *)(self));
    
    [notificationCenter addObserver:self selector:@selector(videoRenderStarted:) name:ZmfVideoRenderDidStart object:nil];
    [notificationCenter addObserver:self selector:@selector(deviceOrientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
    [notificationCenter addObserver:self selector:@selector(didEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [notificationCenter addObserver:self selector:@selector(willEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    [notificationCenter addObserver:self selector:@selector(videoReceiveStatusChanged:) name:@MtcCallVideoReceiveStatusChangedNotification object:nil];
    
    [notificationCenter addObserver:self selector:@selector(ringPlayDidFinish:) name:@MtcRingPlayDidFinishNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewWillLayoutSubviews
{
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (BOOL)prefersStatusBarHidden
{
    if ([self isTalking] && ConfIsVideo && !UIDeviceOrientationIsPortrait(_orientation)) {
        return YES;
    }
    
    return (ConfIsVideo && self.callView.hidden);
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (UIViewController *)childViewControllerForStatusBarStyle
{
    return nil;
}

#pragma mark - UI Setting

- (void)show:(BOOL)isVideo animated:(BOOL)animated completion:(void (^)(void))completion
{
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    if (_errorAlertView) {
        [_errorAlertView dismissWithClickedButtonIndex:_errorAlertView.cancelButtonIndex animated:NO];
        _errorAlertView = nil;
    }
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showCallView:)];
    tapGR.cancelsTouchesInView = !MtcUtilSystemVersionLessThanX(6);
    [self.view addGestureRecognizer:tapGR];
    
    if (self.isViewLoaded && self.view.window) {
        if (completion) {
            dispatch_async(dispatch_get_main_queue(), completion);
        }
        return;
    }
    
    _confViewController = self;
    
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    UIViewController *viewController = window.rootViewController;
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [viewController presentViewController:self animated:animated completion:^{
        if (completion) {
            completion();
        }
    }];
    
}

- (void)dismiss
{
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    
    [CallWaiting dismissAll];
    
    if (_errorAlertView) {
        [_errorAlertView dismissWithClickedButtonIndex:_errorAlertView.cancelButtonIndex animated:NO];
        _errorAlertView = nil;
    }
    
    Mtc_RingStopX();
    
    if(!self.isViewLoaded || !self.view.window) {
        @synchronized (self) {
            [self audioStop];
        }
        _confViewController = nil;
        return;
    }
    
    [self dismissViewControllerAnimated:NO completion:^{
        if (_confId != ZINVALIDID || _sessState != ConfStateNone) {
            _confViewController = nil;
            [self audioStop];
            return;
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            @synchronized (self) {
                if (_confId != ZINVALIDID || _sessState != ConfStateNone) {
                    _confViewController = nil;
                    return;
                }
                [self audioStop];
            }
        });
        
        if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
            Mtc_CliWakeup(ZFALSE);
        }
        
        _confViewController = nil;
    }];
}

- (void)termedAnimation
{
    if (_sessState != ConfStateNone) return;
    
    self.muteButton.alpha = 1;
//    self.speakerButton.alpha = 1;
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.muteButton.alpha = 0;
//                         self.speakerButton.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         if (_sessState != ConfStateNone) return;
                         
                         self.muteButton.hidden = YES;
//                         self.speakerButton.hidden = YES;
                         self.muteButton.alpha = 1;
//                         self.speakerButton.alpha = 1;
                         
                         self.declineView.alpha = 1;
                         [UIView animateWithDuration:0.3
                                               delay:0
                                             options:UIViewAnimationOptionCurveEaseOut
                                          animations:^{
                                              CGRect declineFrame = self.declineView.frame;
                                              declineFrame.origin.x = 0;
                                              self.declineView.frame = declineFrame;
                                              self.declineView.alpha = 0;
                                          }
                                          completion:^(BOOL finished) {
                                              if (_sessState != ConfStateNone) return;
                                              
                                              self.declineView.hidden = YES;
                                              self.declineView.alpha = 1;
//                                              [UIView animateWithDuration:0.3
//                                                                    delay:0
//                                                                  options:UIViewAnimationOptionCurveEaseOut
//                                                               animations:^{
//                                                                   self.callTermedView.alpha = 1;
//                                                                   if (!self.redialView.hidden) {
//                                                                       self.redialView.alpha = 1;
//                                                                   }
//                                                               }
//                                                               completion:^(BOOL finished) {
//                                                                   if (_sessState != ConfStateNone) return;
//                                                                   
//                                                                   self.callingView.hidden = YES;
//                                                               }
//                                               ];
                                          }
                          ];
                     }
     ];
}

- (void)setEnabled:(BOOL)enabled
{
    self.view.userInteractionEnabled = enabled;
    [self.declineView setEnabled:enabled];
    [self.answerView setEnabled:enabled];
    self.muteButton.enabled = enabled;
    self.cameraSwitchButton.enabled = enabled;
    self.cameraOffButton.enabled = enabled;
    self.leaveButton.enabled = enabled;
}

- (void)setStateIncoming:(BOOL)isVideo
{
    [self shrinkLargeView:NO];
    
    self.callBackgroundView.hidden = NO;
    self.timeLabel.hidden = YES;
    CGRect declineFrame = self.declineView.frame;
    declineFrame.origin.x = self.callingView.frame.size.width - self.answerView.frame.origin.x - self.answerView.frame.size.width;
    self.declineView.frame = declineFrame;
    self.declineView.hidden = NO;
    self.declineView.label.hidden = NO;
    NSString *image = isVideo ? @"JusMeeting.bundle/call-videoanswer" : @"JusMeeting.bundle/call-voiceanswer";
    [self.answerView setImage:image];
    self.answerView.hidden = NO;
    self.callingView.hidden = NO;
    self.selfMenuView.hidden = YES;
    self.otherMenuView.hidden = YES;
}

- (void)setStateCalling:(BOOL)isVideo
{
    [self shrinkLargeView:NO];
    self.callBackgroundView.hidden = NO;
    self.timeLabel.hidden = YES;
    CGRect declineFrame = self.declineView.frame;
    declineFrame.origin.x = (self.callingView.frame.size.width - declineFrame.size.width) / 2;
    self.declineView.frame = declineFrame;
    self.declineView.hidden = NO;
    self.declineView.label.hidden = YES;
    self.answerView.hidden = YES;
    self.callingView.hidden = NO;
    [self.muteButton setSelected:NO];
    [self.cameraOffButton setSelected:NO];
    self.selfMenuView.hidden = YES;
    self.otherMenuView.hidden = YES;
}

- (void)setStateTalking:(BOOL)isVideo
{
    [self shrinkLargeView:YES];
    self.shrinkButton.hidden = YES;
    self.globalMenuView.hidden = NO;
    self.timeLabel.hidden = YES;
    
    if (isVideo) {
        UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
        BOOL isLandscape = UIDeviceOrientationIsLandscape(orientation);
        if (isLandscape) {
            [self rotateWithOrientation:orientation];
        }
    }
    if (_confScrollView) {
        self.confScrollView.hidden = NO;
    }
    
    [self showMainMenu];
}

- (void)setStateAnswering:(BOOL)isVideo
{
    [self shrinkLargeView:NO];
    //    self.timeLabel.hidden = NO;
    // configration for customers who don't want time shown.
    self.timeLabel.hidden = YES;
    CGRect declineFrame = self.declineView.frame;
    declineFrame.origin.x = (self.callingView.frame.size.width - declineFrame.size.width) / 2;
    self.muteButton.hidden = NO;
    [self.muteButton setSelected:NO];
    self.muteButton.alpha = 0;
//    self.speakerButton.hidden = NO;
//    self.speakerButton.alpha = 0;
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.declineView.frame = declineFrame;
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.3
                                               delay:0
                                             options:UIViewAnimationOptionCurveEaseOut
                                          animations:^{
                                              self.muteButton.alpha = 1;
//                                              self.speakerButton.alpha = 1;
                                          }
                                          completion:^(BOOL finished) {
                                          }
                          ];
                     }
     ];
    self.declineView.hidden = NO;
    self.declineView.label.hidden = YES;
    self.answerView.hidden = YES;
    self.callingView.hidden = NO;
}

- (void)setStateNone:(BOOL)isVideo
{
    self.shrinkButton.hidden = YES;
    self.globalMenuView.hidden = NO;
    
    if (isVideo) {
        UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
        if (orientation != UIDeviceOrientationPortrait) {
            [self rotateWithOrientation:UIDeviceOrientationPortrait];
        }
    }
}

- (void)setStateText:(NSString *)text animated:(BOOL)animated
{
    if (text.length == 0) {
        if (_sessTimer) {
            [_sessTimer resume];
            
            return;
        }
    } else {
        if (_sessTimer) {
            [_sessTimer pause];
        }
    }
    
    self.timeLabel.text = animated ? [text stringByAppendingString:@"..."] : text;
}

- (void)setErrorText
{
    if (_sessState < ConfStateTalking) {
        [self setErrorText:nil needFreeze:NO];
        return;
    }
    
    if (Mtc_GetAccessNetType() == MTC_ANET_UNAVAILABLE) {
        if ([self setErrorText:kMeetingStringCheckNetwork needFreeze:YES]) {
            Mtc_RingPlayNoLoop(EN_MTC_RING_RING);
        }
        [self startDisconnectedTimer];
        return;
    }
    
    if (_reconnecting) {
        if ([self setErrorText:kMeetingStringCallReconnecting needFreeze:YES]) {
            Mtc_RingPlayNoLoop(EN_MTC_RING_RING);
        }
        return;
    }
    
    if (_pausedByCS) {
        if ([self setErrorText:kMeetingStringCallInterrupted needFreeze:YES]) {
            Mtc_RingPlayNoLoop(EN_MTC_RING_RING);
        }
        return;
    }
    
    if (_paused) {
        if ([self setErrorText:kMeetingStringCallPaused needFreeze:NO]) {
            Mtc_RingPlayNoLoop(EN_MTC_RING_RING);
        }
        return;
    }
    
    if (_audioInterrupted) {
        [self setErrorText:kMeetingStringAudioDeviceOccupied needFreeze:NO];
        return;
    }
    
//    ZINT audioNetSta = Mtc_CallGetAudioNetSta(_sessId);
//    if (audioNetSta <= EN_MTC_NET_STATUS_DISCONNECTED) {
//        [self startDisconnectedTimer];
//    }
    
    if (ConfIsVideo) {
        switch (_videoReceiveStatusX) {
            case EN_MTC_CALL_TRANSMISSION_CAMOFF:
                [self setErrorText:kMeetingStringVideoCameraOff needFreeze:YES];
                return;
            case EN_MTC_CALL_TRANSMISSION_PAUSE:
                [self setErrorText:kMeetingStringVideoPaused needFreeze:YES];
                return;
            default:
                break;
        }
    } else {
//        if (audioNetSta <= EN_MTC_NET_STATUS_DISCONNECTED) {
//            [self setErrorText:kMeetingStringPoorConnection needFreeze:YES];
//            return;
//        }
    }
    
    [self setErrorText:nil needFreeze:NO];
}

- (BOOL)setErrorText:(NSString *)text needFreeze:(BOOL)freeze
{
    if (text) {
        if (!_errorWindow) {
            _errorWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            _errorWindow.hidden = NO;
            _errorWindow.tag = kErrorWindowNomalTag;
            _errorWindow.userInteractionEnabled = NO;
            _errorWindow.windowLevel = UIWindowLevelStatusBar;
            _errorWindow.backgroundColor = [UIColor clearColor];
            _confErrorViewController = [[ConfErrorViewController alloc] initWithAutorotate:ConfIsVideo];
            [_confErrorViewController setErrorText:text];
            _errorWindow.rootViewController = _confErrorViewController;
            [UIViewController attemptRotationToDeviceOrientation];
        } else {
            NSString *title = [_confErrorViewController.errorButton titleForState:UIControlStateNormal];
            if ([text isEqualToString:title]) {
                return NO;
            }
            
            _errorWindow.hidden = NO;
            _errorWindow.tag = kErrorWindowNomalTag;
            [_confErrorViewController setErrorText:text];
        }
    } else {
        [self dismissErrorWindow];
    }
    
    return YES;
}

- (void)shrinkLargeView:(BOOL)shrink {
    if (!_preview) return;
    _callingView.hidden = shrink;
    CGRect rect = shrink ? CGRectMake(0, _largeViewToTop, _largeViewSize.width, _largeViewSize.height) : self.view.bounds;
    _preview.frame = rect;
    if (shrink) {
        CGFloat menuLeft = (_callView.frame.size.width - _selfMenuView.frame.size.width) / 2;
        CGRect menuViewFrame = _selfMenuView.frame;
        menuViewFrame.origin.x = menuLeft;
        menuViewFrame.origin.y = rect.origin.y + _largeViewSize.height;
        _selfMenuView.frame = menuViewFrame;
        menuLeft = (_callView.frame.size.width - _otherMenuView.frame.size.width) / 2;
        menuViewFrame = _otherMenuView.frame;
        menuViewFrame.origin.x = menuLeft;
        menuViewFrame.origin.y = _selfMenuView.frame.origin.y;
        _otherMenuView.frame = menuViewFrame;
    }
}

- (void)showMainMenu {
    if (!_currentUser) return;
//    BOOL isShow = [_currentUser.username caseInsensitiveCompare:_username] == NSOrderedSame;
//    self.selfMenuView.hidden = !isShow;
//    self.otherMenuView.hidden = isShow;
}

- (void)dismissErrorWindow
{
    if (_errorWindow) {
        _confErrorViewController = nil;
        _errorWindow = nil;
    }
    
    [self performSelector:@selector(resetStatusBarOrientation) withObject:nil afterDelay:[UIApplication sharedApplication].statusBarOrientationAnimationDuration];
}

- (void)resetStatusBarOrientation
{
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
}

- (void)startDisconnectedTimer
{
    if (!_disconnectedTiming) {
        _disconnectedTiming = YES;
        [self performSelector:@selector(callDisconnected) withObject:nil afterDelay:30];
    }
}

- (void)stopDisconnectedTimer:(JMeetingId)sessId
{
    if (_disconnectedTiming) {
        _disconnectedTiming = NO;
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(callDisconnected) object:nil];
    }
}

- (void)switchedToVoiceCall
{
    [self setConfVideo:CallVideoCameraOff];
    [self setErrorText];
}

- (void)showError:(NSString *)error
{
    if (_errorAlertView) {
        [_errorAlertView dismissWithClickedButtonIndex:_errorAlertView.cancelButtonIndex animated:NO];
    }
    _errorAlertView = [[UIAlertView alloc] initWithTitle:nil message:error delegate:nil cancelButtonTitle:kMeetingStringEnd otherButtonTitles:nil];
    [_errorAlertView show];
}

#pragma mark - ZMF Audio

- (int)audioStart
{
    if (_audioStarting) return 0;
    _audioStarting = YES;
//    if (AirPlaySupport() && CallIsVideo) {
//        Zmf_AudioSessionSetMode(ZmfSessionVideoChat);
//    } else {
        Zmf_AudioSessionSetMode(ZmfSessionAutoMode);
//    }
    if (_audioStarted) return 0;
    ZBOOL bAec = Mtc_MdmGetOsAec();
    const char *pcId = bAec ? ZmfAudioDeviceVoice : ZmfAudioDeviceRemote;
    ZBOOL bAgc = Mtc_MdmGetOsAgc();
    int ret = Zmf_AudioInputStart(pcId, 0, 0, bAec ? ZmfAecOn : ZmfAecOff, bAgc ? ZmfAgcOn : ZmfAgcOff);
    if (ret == 0) {
        ret = Zmf_AudioOutputStart(pcId, 0, 0);
    }
    [self setSpeakerIfNeeded];
    return ret;
}

- (void)audioStop
{
    _audioStarted = NO;
    _audioStarting = NO;
    _audioInterrupted = NO;
    _speakerStarted = NO;
    Zmf_AudioInputStopAll();
    Zmf_AudioOutputStopAll();
    MtcMeetingRingResetCategory();
}

- (void)audioStarted
{
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(audioStarted) withObject:nil waitUntilDone:NO];
        return;
    }
    
    if (_sessState == ConfStateNone || _sessState == ConfStateEnding) {
        return;
    }
    _audioStarted = YES;
    _audioStarting = NO;
    _audioInterrupted = NO;
    _speakerStarted = NO;
    if (![self setSpeakerIfNeeded])
        [self configVoiceButton];
}

- (void)audioInterrupted
{
    _audioStarted = NO;
    _speakerStarted = NO;
    
    if (_sessState >= ConfStateCalling && _sessState < ConfStateTalking) {
        [self end:NULL];
    } else if (_sessState == ConfStateTalking) {
        _audioInterrupted = YES;
        [self setErrorText];
//        Mtc_CallInfo(_sessId, [MtcCallManager IsCSCalling] ? kCallInterrupt : kCallPause);
    }
}

- (void)audioResume
{
    if (_audioInterrupted) {
        _audioInterrupted = NO;
        if (_sessState == ConfStateTalking) {
            [self setErrorText];
//            Mtc_CallInfo(_sessId, kCallResume);
        }
    }
    
    _audioStarted = YES;
    _speakerStarted = NO;
    if(![self setSpeakerIfNeeded])
        [self configVoiceButton];
}

- (void)audioError
{
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(audioError) withObject:nil waitUntilDone:NO];
        return;
    }
    
    if (![self isCalling]) return;
    
    if ([MtcMeetingManager isCSCalling]) {
        return;
    }
    
    if (_audioErrorTimes == 0) {
        ++_audioErrorTimes;
        @synchronized (self) {
            [self audioStop];
        }
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            @synchronized (self) {
                if (![self isCalling]) return;
                [self audioStart];
            }
        });
        return;
    }
    
    [self showError:kMeetingStringAudioDeviceError];
    
    [self endConf];
}

#pragma mark - ZMF Video

- (void)videoCaptureStart
{
    [self confVideoCaptureStart:YES];
}

- (void)videoRenderStarted:(NSNotification *)notification
{
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(videoRenderStarted:) withObject:notification waitUntilDone:NO];
        return;
    }
    
    void *pWnd = (void *)[[notification.userInfo valueForKey:ZmfWindow] integerValue];
    
    // null ?
    if (pWnd == (__bridge void *)_preview) {
        if (_preview && _preview.alpha == 0) {
            [UIView animateWithDuration:0.3 animations:^{
                _preview.alpha = 1;
            }];
        }
    }
}

- (void)rotateWithOrientation:(UIDeviceOrientation)orientation
{
    if (orientation == UIDeviceOrientationFaceUp
        || orientation == UIDeviceOrientationFaceDown
        || orientation == UIDeviceOrientationUnknown) {
        return;
    }
    
    _orientation = orientation;
    
    BOOL isLandscape = UIDeviceOrientationIsLandscape(orientation);
    // configration for customer who don't want time shown.
    self.timeLabel.hidden = YES;
//    self.timeLabel.hidden = isLandscape;
    if (!_errorWindow || _errorWindow.hidden) {
        if (MtcUtilSystemVersionLessThanX(7)) {
            [[UIApplication sharedApplication] setStatusBarHidden:isLandscape withAnimation:UIStatusBarAnimationFade];
        } else {
            [self setNeedsStatusBarAppearanceUpdate];
        }
    }
    
    CGFloat angle;
    switch(orientation) {
        case UIDeviceOrientationPortrait:
            angle = 0;
            break;
        case UIDeviceOrientationLandscapeLeft:
            angle = M_PI/2;
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            angle = 0;
            break;
        case UIDeviceOrientationLandscapeRight:
            angle = -M_PI/2;
            break;
        default:
            return;
    }
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.declineView.button.transform = CGAffineTransformMakeRotation(angle);
                         self.muteButton.transform = CGAffineTransformMakeRotation(angle);
//                         self.speakerButton.transform = CGAffineTransformMakeRotation(angle);
                     }];
}

- (void)deviceOrientationChanged:(NSNotification *)notification
{
    if ([self isTalking] && ConfIsVideo) {
        UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
        [self rotateWithOrientation:orientation];
    }
    
    if (_shareScreenView) {
        UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
        ZmfRotationAngle enAngle;
        switch (orientation) {
            case UIDeviceOrientationPortrait:
                enAngle = ZmfRotationAngle0;
                break;
            case UIDeviceOrientationLandscapeLeft:
                enAngle = ZmfRotationAngle90;
                break;
            case UIDeviceOrientationPortraitUpsideDown:
                enAngle = ZmfRotationAngle180;
                break;
            case UIDeviceOrientationLandscapeRight:
                enAngle = ZmfRotationAngle270;
                break;
            default:
                return;
        }
        Zmf_VideoRenderRotate((__bridge void *)_shareScreenView, enAngle);
    }
}

- (void)didEnterBackground:(NSNotification *)notification
{
    if ([self isTalking] && ConfIsVideo) {
        [self sendVideoPause];
    }
}

- (void)willEnterForeground:(NSNotification *)notification
{
    if ([self isTalking] && ConfIsVideo) {
        [self sendVideoResume];
    }
}

#pragma mark - Video Pause/Resume

- (void)videoReceiveStatusChanged:(NSNotification *)notification
{
//    JMeetingId dwSessId = JMeetingIdFromNumber([notification.userInfo objectForKey:@MtcCallIdKey]);
//    if (dwSessId != _sessId) return;
//    
//    ZUINT status = [[notification.userInfo objectForKey:@MtcCallVideoStatusKey] unsignedIntValue];
//    if (_videoReceiveStatus != status) {
//        _videoReceiveStatus = status;
//        [self setErrorText];
//    }
}

//- (void)videoSendAdviceChanged:(NSNotification *)notification
//{
//    JMeetingId dwSessId = JMeetingIdFromNumber([notification.userInfo objectForKey:@MtcCallIdKey]);
//    if (dwSessId != _sessId) return;
//
//    if ([[notification.userInfo objectForKey:@MtcCallSendAdviceKey] boolValue]) {
//        [self sendVideoResumeForQoS];
//    } else {
//        [self sendVideoPauseForQoS];
//    }
//}

- (void)sendVideoPause
{
//    if (_video != CallVideoFrontCamera && _video != CallVideoRearCamera) {
//        return;
//    }
//    Mtc_CallVideoSetSend(_sessId, EN_MTC_CALL_TRANSMISSION_PAUSE);
    //    Mtc_CallInfo(_sessId, kVideoPause);
}

- (void)sendVideoResume
{
//    if (_video != CallVideoFrontCamera && _video != CallVideoRearCamera) {
//        return;
//    }
    //    if (Mtc_CallVideoGetSendAdvice(_sessId)) {
//    Mtc_CallVideoSetSend(_sessId, EN_MTC_CALL_TRANSMISSION_NORMAL);
    //        Mtc_CallInfo(_sessId, kVideoResume);
    //    } else {
    //        Mtc_CallVideoSetSend(_sessId, EN_MTC_CALL_TRANSMISSION_PAUSE4QOS);
    //    }
}

- (void)sendVideoPauseForCameraOff
{
//    Mtc_CallVideoSetSend(_sessId, EN_MTC_CALL_TRANSMISSION_CAMOFF);
    //    Mtc_CallInfo(_sessId, kVideoOff);
}

- (void)sendVideoResumeForCameraOn
{
    //    if (Mtc_CallVideoGetSendAdvice(_sessId)) {
//    Mtc_CallVideoSetSend(_sessId, EN_MTC_CALL_TRANSMISSION_NORMAL);
    //        Mtc_CallInfo(_sessId, kVideoOn);
    //    } else {
    //        Mtc_CallVideoSetSend(_sessId, EN_MTC_CALL_TRANSMISSION_PAUSE4QOS);
    //    }
}

#pragma mark - Term Ring

- (void)ringPlayDidFinish:(NSNotification *)notification
{
    ZUINT iType = [[notification.userInfo objectForKey:@MtcRingTypeKey] unsignedIntValue];
    if (iType != ZMAXUINT) {
        return;
    }
    if (_confId != ZINVALIDID || _sessState != ConfStateNone) {
        return;
    }
    if (_termedRingTimes <= 0) {
    } else {
        --_termedRingTimes;
        Mtc_RingPlayXNoLoop([_termedRingPath UTF8String]);
    }
}

- (void)termedRingStart:(NSString *)resource
{
    _termedRingTimes = 1;
    _termedRingPath = LanguageGetRingPath(resource);
    Mtc_RingPlayXNoLoop([_termedRingPath UTF8String]);
}

static NSString * LanguageGetUserLanguage()
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *language = [userDefaults stringForKey:kUserLanguageKey];
    
    return language;
}

static NSBundle * LanguageGetBundle()
{
    NSString *userLanguage = LanguageGetUserLanguage();
    if (userLanguage.length == 0) {
        return meetingResourcesBundle;
    } else {
        NSString *path = [meetingResourcesBundle pathForResource:userLanguage ofType:@"lproj"];
        NSBundle *bundle = [NSBundle bundleWithPath:path];
        return bundle;
    }
}

static NSString * LanguageGetRingPath(NSString *resource)
{
    NSString *ringPath = [LanguageGetBundle() pathForResource:resource ofType:@"amr"];
    if (!ringPath) {
        NSString *path = [meetingResourcesBundle pathForResource:@"en" ofType:@"lproj"];
        NSBundle *bundle = [NSBundle bundleWithPath:path];
        ringPath = [bundle pathForResource:resource ofType:@"amr"];
    }
    
    return ringPath;
}

#pragma mark - MtcConfDelegate

- (void)conf:(NSArray *)userUriArray title:(NSString *)title isVideo:(BOOL)isVideo
{
    Mtc_RingStopX();
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismiss) object:nil];
    
    if (_sessState != ConfStateNone) {
        NSMutableArray *tempUserUriArray = [[NSMutableArray alloc] initWithArray:userUriArray];
        for (NSString *userUri in userUriArray) {
            for (ConfUser *confUser in _confUserArray) {
                if ([confUser.userUri caseInsensitiveCompare:userUri] == NSOrderedSame) {
                    [tempUserUriArray removeObject:userUri];
                }
            }
        }
        userUriArray = tempUserUriArray;
        if ([userUriArray count]) {
            for (NSString *userUri in userUriArray) {
                ZINT ret = Mtc_ConfInviteUser(_confId, [userUri UTF8String]);
                if (ret != ZOK) {
                    [self inviteDidFail:_confId userUri:userUri reason:-1];
                }
            }
        }
        if (isConfFloatWindowShow) {
            [self conffloatWindowClick];
        }
        [self show:ConfIsVideo animated:YES completion:nil];
        return;
    }
    
    _confTitle = (title && title.length) ? title : kMeetingStringGroupCall;
    _confInviteArray = [[NSMutableArray alloc] initWithArray:userUriArray];

    _sessState = ConfStateCalling;
    self.nameLabel.text = _confTitle;
    [self setStateText:kMeetingStringCalling animated:YES];

    [self setConfVideo:isVideo ? CallVideoFrontCamera : CallVideoVoiceOnly];
    [self setEnabled:YES];
    [self setStateCalling:isVideo];
    
    [self initSpeaker];

    [self confStartPreview];
    
    [self show:isVideo animated:YES completion:^(void) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            @synchronized (self) {
                int audioStartRet = [self audioStart];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (audioStartRet != 0) {
                        [self showError:kMeetingStringAudioDeviceInitializationFailed];
                        [self termedConf:_confId statCode:EN_CONF_DELEGATE_FAIL_CALL_AUDIO_INIT reason:nil];
                        return;
                    }
                    
                    NSDictionary *dict = @{@MtcConfCapacity      : [[NSNumber alloc] initWithInt:16],
                                           @MtcConfViewMode      : [[NSNumber alloc] initWithInt:MTC_CONF_MODE_VIEW_FREEDOM],
                                           @MtcConfQualityGrade  : [[NSNumber alloc] initWithInt:MTC_CONF_QUALITY_GRADE_JUNIOR]};
                    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
                    NSString *info = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

                    int ret = Mtc_ConfCreateEx(0, [_confTitle UTF8String], isVideo, [info UTF8String]);
                    if (ret != ZOK) {
                        [self termedConf:ZINVALIDID statCode:EN_CONF_DELEGATE_FAIL_CREATE reason:nil];
                    }
                });
            }
        });
    }];
}

- (void)createOk:(NSString *)confUri
{
    Mtc_RingPlay(EN_MTC_RING_RING_BACK, MTC_RING_FOREVER);
    _dispName = [MtcMeetingManager getDisplayName];
    ZCONST ZCHAR *pcDispName;
    if (_dispName && _dispName.length) {
        pcDispName = [_dispName UTF8String];
    }else{
        pcDispName = "";
    }
    _confId = Mtc_ConfJoinEx([confUri UTF8String], 0, pcDispName, MTC_CONF_ROLE_OWNER);
    if (_confId == ZINVALIDID) {
        [self termedConf:_confId statCode:EN_CONF_DELEGATE_FAIL_JOIN reason:nil];
    }
}

- (void)createDidFail
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Create confernece fail" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [self termedConf:_confId statCode:EN_CONF_DELEGATE_FAIL_CREATE reason:nil];
}

- (void)joinOk:(NSArray *)userArray screenUser:(NSString *)screenUser
{
    [self confAudioStart];
    [self confVideoCaptureStart:YES];
    if (_confVideo == CallVideoCameraOff) {
        Mtc_ConfStartSend(_confId, MTC_CONF_MEDIA_AUDIO);
    } else {
        Mtc_ConfStartSend(_confId, MTC_CONF_MEDIA_ALL);
    }
    NSString *ownerUri;
    for (ConfUser *user in userArray) {
        if ([user.username caseInsensitiveCompare:_username] != NSOrderedSame) {
            NSDictionary *dic = @{@MtcConfUserUriKey        : user.userUri,
                                  @MtcConfPictureSizeKey    : [NSNumber numberWithInt:user.picSize],
                                  @MtcConfFrameRateKey      : [NSNumber numberWithInt:user.frameRate]};
            NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
            NSString *videoJson = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            int ret = Mtc_ConfCommand(_confId, MtcConfCmdRequestVideo, [videoJson UTF8String]);
            if (ret != ZOK) {
                [self termedConf:_confId statCode:EN_CONF_DELEGATE_FAIL_JOIN reason:nil];
                return;
            }
            user.renderId = user.userUri;
            if (user.confRole & MTC_CONF_ROLE_OWNER) {
                ownerUri = user.userUri;
            }
        } else {
            user.renderId = [NSString stringWithUTF8String:ZmfVideoCaptureFront];
            if (_confVideo == CallVideoCameraOff) {
                user.confState = MTC_CONF_STATE_FWD_VIDEO | MTC_CONF_STATE_FWD_AUDIO | MTC_CONF_STATE_AUDIO;
            } else {
                user.confState = MTC_CONF_STATE_FWD_VIDEO | MTC_CONF_STATE_FWD_AUDIO | MTC_CONF_STATE_AUDIO | MTC_CONF_STATE_VIDEO;
            }
            user.displayName = _dispName;
            user.username = _username;
            _currentUser = user;
            _userUri = user.userUri;
            // user not forward video at start.
//            NSDictionary *dic = @{@MtcConfUserUriKey        : user.userUri,
//                                   @MtcConfMediaOptionKey    : [NSNumber numberWithInt:MTC_CONF_MEDIA_ALL]};
//            NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
//            NSString *videoJson = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//            int ret = Mtc_ConfCommand(_confId, MtcConfCmdStartForward, [videoJson UTF8String]);
//            if (ret != ZOK) {
//                [self termedConf:_confId statCode:EN_CONF_DELEGATE_FAIL_JOIN reason:nil];
//                return;
//            }
        }
    }
    
    BOOL needToHideCallView = ((_sessState == ConfStateAnswering) && ([userArray count] == 2));
    if (needToHideCallView) {
        [self hideCallView];
    }
    _confUserArray = [[NSMutableArray alloc] initWithArray:userArray];
    [self.view addSubview:self.confScrollView];
//    if (needToHideCallView) {
//        [self currentConfUserViewDidToSwitch:[_confUserViewArray firstObject]];
//    }
    [self currentConfUserViewDidToSwitch:[_confUserViewArray firstObject]];
    
    [self propertyChanged:screenUser];

    if (_sessState == ConfStateAnswering) {
        self.nameLabel.text = [[NSString alloc] initWithFormat:@"%@(%d)", _confTitle, (int)[userArray count]];
        if (_sessTimer) {
            [MtcConfSessTimer stop:_sessTimer];
            _sessTimer = nil;
        }
        _sessTimer = [MtcConfSessTimer start:self.timeLabel];
        _sessState = ConfStateTalking;
        [self setStateTalking:ConfIsVideo];
    } else if (_sessState == ConfStateCalling) {
        _sessState = ConfStateOutgoing;
        if (_confScrollView) {
            self.confScrollView.hidden = YES;
        }
    }
    
    for (NSString *userUri in _confInviteArray) {
        ZINT ret = Mtc_ConfInviteUser(_confId, [userUri UTF8String]);
        if (ret != ZOK) {
            [self inviteDidFail:_confId userUri:userUri reason:-1];
        }
    }
}

- (void)joinDidFail
{
    [self termedConf:_confId statCode:EN_CONF_DELEGATE_FAIL_JOIN reason:nil];
}

- (void)queryOk:(NSString *)confUri title:(NSString *)title isVideo:(BOOL)isVideo
{
    Mtc_RingStopX();
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismiss) object:nil];
    
    if (_sessState != ConfStateNone) {
        [CallWaiting show:confUri title:title isVideo:isVideo userUri:nil];
        return;
    }
    
    _confUri = confUri;
    _confTitle = (title && title.length) ? title : kMeetingStringGroupCall;
    
    _sessState = ConfStateAnswering;
    self.nameLabel.text = _confTitle;
    [self setStateText:kMeetingStringJoining animated:YES];
    
    [self setConfVideo:isVideo ? CallVideoFrontCamera : CallVideoVoiceOnly];
    [self setEnabled:YES];
    [self setStateAnswering:isVideo];
    
    [self initSpeaker];
    
    [self confStartPreview];
    
    [MtcMeetingManager setPorperty:MtcMeetingPropertyKeyAllCanKick value:[[NSString alloc] initWithFormat:@"%d",NO]];
    
    [self show:isVideo animated:YES completion:^(void) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            @synchronized (self) {
                int audioStartRet = [self audioStart];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (audioStartRet != 0) {
                        [self showError:kMeetingStringAudioDeviceInitializationFailed];
                        [self termedConf:_confId statCode:EN_CONF_DELEGATE_FAIL_ANSWER_AUDIO_INIT reason:nil];
                        return;
                    }
                    
                    _dispName = [MtcMeetingManager getDisplayName];
                    ZCONST ZCHAR *pcDispName;
                    if (_dispName && _dispName.length) {
                        pcDispName = [_dispName UTF8String];
                    }else{
                        pcDispName = "";
                    }
                    
                    _confId = Mtc_ConfJoinEx([_confUri UTF8String], 0, pcDispName, MTC_CONF_ROLE_PARTP);
                    NSLog(@"confUri:%@", _confUri);
                    if (_confId == ZINVALIDID) {
                        [self termedConf:_confId statCode:EN_CONF_DELEGATE_FAIL_JOIN reason:nil];
                    }
                });
            }
        });    
    }];
}

- (void)queryDidFail
{
//    [self termedConf:_confId statCode:EN_CONF_DELEGATE_FAIL_QUERY reason:nil];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:kMeetingStringQueryFailed message:nil delegate:self cancelButtonTitle:kMeetingStringOk otherButtonTitles: nil];
    [alertView show];
}

- (void)inviteReceived:(NSString *)confUri title:(NSString *)title isVideo:(BOOL)isVideo userUri:(NSString *)userUri
{
    if (_sessState != ConfStateNone) {
        [CallWaiting show:confUri title:title isVideo:isVideo userUri:userUri];
        return;
    }

    Mtc_RingStopX();
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismiss) object:nil];
    
    _confUri = confUri;
    _confTitle = (title && title.length) ? title : kMeetingStringGroupCall;
    _targetUserUri = userUri;
    
    _sessState = ConfStateIncoming;
    self.nameLabel.text = [NSString stringWithUTF8String:Mtc_UserGetId([userUri UTF8String])];
    
    [self setConfVideo:isVideo ? CallVideoFrontCamera : CallVideoVoiceOnly];
    [self setEnabled:YES];
    [self setStateIncoming:isVideo];

    [self confStartPreview];
    
    [self show:isVideo animated:YES completion:^(void) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            @synchronized (self) {
                [self audioStop];
                dispatch_async(dispatch_get_main_queue(), ^{
                    MtcMeetingRingStartRing();
                });
            }
        });
    }];
}

- (void)cancelReceived:(NSString *)confUri title:(NSString *)title isVideo:(BOOL)isVideo userUri:(NSString *)userUri
{
    [CallWaiting dismissConf:confUri];
    
    if ([_confUri caseInsensitiveCompare:confUri] != NSOrderedSame) {
        return;
    }
    
    self.shrinkButton.hidden = YES;
    self.globalMenuView.hidden = YES;
    if (isConfFloatWindowShow) {
        [self conffloatWindowClick];
        _floatWindow = nil;
    }
    
    Mtc_RingStop(ZMAXUINT);
    [self termConf];
    [self setStateNone:ConfIsVideo];
    
    if ([CallWaiting allowActive]) {
        [CallWaiting active];
    } else {
        [self dismiss];
    }
}

- (void)inviteOk:(JMeetingId)dwConfId userUri:(NSString *)userUri
{
    NSLog(@"confInviteOk");
    if (_sessState == ConfStateOutgoing) {
        _sessState = ConfStateAlertedRing;
        [self setStateText:kMeetingStringRinging animated:YES];
    }
}

- (void)inviteDidFail:(JMeetingId)dwConfId userUri:(NSString *)userUri reason:(NSInteger)reason
{
    NSLog(@"confInviteFail");
    
    if (_confInviteArray) {
        NSArray *inviteArray = [[NSArray alloc] initWithArray:_confInviteArray];
        for (NSString *tempUserUri in inviteArray) {
            if ([tempUserUri caseInsensitiveCompare:userUri] == NSOrderedSame) {
                [_confInviteArray removeObject:tempUserUri];
                break;
            }
        }
    }
    
    ZCONST ZCHAR *userId = Mtc_UserGetId([userUri UTF8String]);
    NSString *username = [NSString stringWithUTF8String:userId];
    
    NSString *message = nil;
    if (reason == EN_MTC_CONF_REASON_DECLINE) {
        message = kMeetingStringCalleeBusy;
    } else if (reason == EN_MTC_CONF_REASON_ACCOUNT_NOT_EXIST) {
        message = kMeetingStringHasNotBeenInstalled;
    } else if (reason == EN_MTC_CONF_REASON_NETWORK){
        message = kMeetingStringCheckNetwork;
    } else {
        message = [[NSString alloc] initWithFormat:@"reason: %d", (int)reason];
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[[NSString alloc] initWithFormat:@"%@ %@", kMeetingStringInviteFailed, username] message:message delegate:self cancelButtonTitle:kMeetingStringOk otherButtonTitles: nil];
    [alertView show];
    
    if (!_confInviteFailedAlertViewArray) {
        _confInviteFailedAlertViewArray = [[NSMutableArray alloc] initWithCapacity:1];
    }
    [_confInviteFailedAlertViewArray addObject:alertView];    
}

- (void)joined:(JMeetingId)dwConfId userUri:(NSString *)userUri displayName:(NSString *)displayName state:(NSInteger)state
{
    if (_confId != dwConfId) {
        return;
    }
    
    if (_sessState == ConfStateAlertedRing) {
        NSArray *inviteArray = [[NSArray alloc] initWithArray:_confInviteArray];
        for (NSString *tempUserUri in inviteArray) {
            if ([tempUserUri caseInsensitiveCompare:userUri] == NSOrderedSame) {
                [_confInviteArray removeObject:tempUserUri];
                break;
            }
        }
        Mtc_RingStop(ZMAXUINT);
        if (_sessTimer) {
            [MtcConfSessTimer stop:_sessTimer];
            _sessTimer = nil;
        }
        _sessTimer = [MtcConfSessTimer start:self.timeLabel];
        _sessState = ConfStateTalking;
        [self setStateTalking:ConfIsVideo];
    }
    
    ConfUser *user = [[ConfUser alloc] init];
    user.userUri = userUri;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userUri == %@", user.userUri];
    NSArray *filteredArray = [_confUserArray filteredArrayUsingPredicate:predicate];
    if (filteredArray.count == 0) {
        user.displayName = displayName;
        user.username = [NSString stringWithUTF8String:Mtc_UserGetId([user.userUri UTF8String])];
        user.confState = state;
        user.picSize = MTC_CONF_PS_MIN;
        user.frameRate = 15;
        user.sended = YES;
        user.volume = 30;
        if (ConfIsVideo) {
            if (!_shareScreenView) {
                NSDictionary *dic = @{@MtcConfUserUriKey        : user.userUri,
                                      @MtcConfPictureSizeKey    : [NSNumber numberWithInt:user.picSize],
                                      @MtcConfFrameRateKey      : [NSNumber numberWithInt:user.frameRate]};
                NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
                NSString *videoJson = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                Mtc_ConfCommand(_confId, MtcConfCmdRequestVideo, [videoJson UTF8String]);
            }
            user.renderId = user.userUri;
        }
        
        [_confUserArray addObject:user];
        BOOL needToHideCallView = ([_confUserViewArray count] == 0);
        if (needToHideCallView) {
            [self hideCallView:NO];
        }
        [self confScrollViewAddUser:user];
        if (needToHideCallView) {
            [self currentConfUserViewDidToSwitch:[_confUserViewArray firstObject]];
        }
    }
    
    self.nameLabel.text = [[NSString alloc] initWithFormat:@"%@(%d)", _confTitle, (int)[_confUserArray count]];
}

- (void)didLeave:(JMeetingId)dwConfId reason:(NSInteger)reason
{
    NSString *message = nil;
    if (reason == EN_MTC_CONF_REASON_LEAVED) {
        return;
    } else if (reason == EN_MTC_CONF_REASON_KICKED) {
        message = @"You've been kicked out of conference!";
    }else if (reason == EN_MTC_CONF_REASON_OFFLINE){
        message = @"You are offline!";
    }
    
    _didLeaveAlertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:kMeetingStringOk otherButtonTitles: nil];
    [_didLeaveAlertView show];
}

- (void)leaved:(JMeetingId)dwConfId userUri:(NSString *)userUri
{
    if (_confId != dwConfId) {
        return;
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userUri == %@", userUri];
    NSArray *filteredArray = [_confUserArray filteredArrayUsingPredicate:predicate];
    if (filteredArray.count > 0) {
        ConfUser *user = [filteredArray firstObject];
        [_confUserArray removeObject:user];
        if ([_currentUser.userUri caseInsensitiveCompare:userUri] == NSOrderedSame) {
            [self currentConfUserViewDidToSwitch:[_confUserViewArray firstObject]];
        }
        [user stopRender];
        [self confScrollViewDelUser:user];
//        self.nameLabel.text = [[NSString alloc] initWithFormat:@"%@(%d)", _confTitle, (int)[_confUserArray count]];
    } else {
        [CallWaiting dismiss:userUri];
    }
    
    if ((!_confInviteArray || [_confInviteArray count] == 0) && ([_confUserArray count] == 1)) {
        self.nameLabel.text = _confTitle;
        ConfUser *user = [_confUserArray firstObject];
        if ([user.username caseInsensitiveCompare:_username] == NSOrderedSame) {
            [self endConf];
        }
    }
}

- (void)kickOk:(JMeetingId)dwConfId userUri:(NSString *)userUri
{
    if (_confId != dwConfId) {
        return;
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userUri == %@", userUri];
    NSArray *filteredArray = [_confUserArray filteredArrayUsingPredicate:predicate];
    if (filteredArray.count <= 0) return;
    
    ConfUser *user = [filteredArray firstObject];
    [_confUserArray removeObject:user];
    if ([_currentUser.userUri caseInsensitiveCompare:userUri] == NSOrderedSame) {
        [self currentConfUserViewDidToSwitch:[_confUserViewArray firstObject]];
    }
    [user stopRender];
    [self confScrollViewDelUser:user];
    
//    self.nameLabel.text = [[NSString alloc] initWithFormat:@"%@(%d)", _confTitle, (int)[_confUserArray count]];
    if ((!_confInviteArray || [_confInviteArray count] == 0) && ([_confUserArray count] == 1)) {
        self.nameLabel.text = _confTitle;
        ConfUser *user = [_confUserArray firstObject];
        if ([user.username caseInsensitiveCompare:_username] == NSOrderedSame) {
            [self endConf];
        }
    }
}

- (void)kickDidFail
{
    NSLog(@"kickDidFail");
}

- (void)volumeChanged:(NSArray *)partpVolArray
{
    NSMutableArray *indexArray = [[NSMutableArray alloc] init];
    for (NSDictionary *volumeDict in partpVolArray) {
        NSString *volumeUserUri = [volumeDict objectForKey:@MtcConfUserUriKey];
        int vol = [[volumeDict objectForKey:@MtcConfVolumeKey] intValue];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userUri == %@",volumeUserUri];
        NSArray *filterArray = [_confUserArray filteredArrayUsingPredicate:predicate];
        if (filterArray.count > 0) {
            ConfUser *model = [filterArray firstObject];
            model.volume = vol;
            [indexArray addObject:[NSNumber numberWithInteger:[_confUserArray indexOfObject:model]]];
        }
    }
    [self confScrollViewReloadUsersAtIndexs:indexArray];
}

- (void)partpChanged:(JMeetingId)dwConfId userUri:(NSString *)userUri state:(NSInteger)state
{
    if (_confId != dwConfId) {
        return;
    }
    NSLog(@"partpChanged userUri:%s state:%d", [userUri UTF8String], (int)state);

    ZCONST ZCHAR *userId = Mtc_UserGetId([userUri UTF8String]);
    NSString *username = [NSString stringWithUTF8String:userId];
    
    if ([_currentUser.username caseInsensitiveCompare:username] == NSOrderedSame) {
        if (_currentUser.confState != state) {
            _currentUser.confState = state;
            [self previewCameraOff:!(state & MTC_CONF_STATE_VIDEO)];
        }
    } else {
        for (ConfUserView *view in _confUserViewArray) {
            if ([view.user.username caseInsensitiveCompare:username] == NSOrderedSame) {
                view.user.confState = state;
                [view cameraOff:!(state & MTC_CONF_STATE_VIDEO)];
                break;
            }
        }
    }
}

- (void)errorConf:(JMeetingId)dwConfId event:(NSInteger)event reason:(NSInteger)reason
{
    if (_confId != dwConfId) {
        return;
    }
    
    NSLog(@"event:%d reason:%d", (int)event, (int)reason);
}

- (void)propertyChanged:(NSString *)screenUser
{
    if (screenUser && screenUser.length) {
        _confScrollView.hidden = YES;
        [self dismissShareScreenView];
        
        _shareScreenView = [[UIView alloc] initWithFrame:self.view.bounds];
        _shareScreenView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _shareScreenView.backgroundColor = [UIColor blackColor];
        [self.view insertSubview:_shareScreenView aboveSubview:_preview];
        
        Zmf_VideoRenderStart((__bridge void *)(_shareScreenView), ZmfRenderViewFx);
        ZCONST ZCHAR *pcUri = Mtc_ConfGetScreenUri(_confId);
        Zmf_VideoRenderAdd((__bridge void *)(_shareScreenView), pcUri, 0, ZmfRenderFullAuto);
        
        _shareScreenUri = [[NSString alloc] initWithUTF8String:pcUri];
        NSDictionary *dic = @{@MtcConfUserUriKey        : _shareScreenUri,
                              @MtcConfPictureSizeKey    : [NSNumber numberWithInt:MTC_CONF_PS_LARGE],
                              @MtcConfFrameRateKey      : [NSNumber numberWithInt:15]};
        NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
        NSString *videoJson = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        Mtc_ConfCommand(_confId, MtcConfCmdRequestVideo, [videoJson UTF8String]);
        [self requestVideo:NO];
    } else {
        [self requestVideo:YES];
        _confScrollView.hidden = NO;
        [self dismissShareScreenView];
    }
}

- (void)requestVideo:(BOOL)start
{
    for (ConfUser *user in _confUserArray) {
        if ([user.username caseInsensitiveCompare:_username] != NSOrderedSame) {
            int pictureSize = start ? user.picSize : MTC_CONF_PS_OFF;
            NSDictionary *dic = @{@MtcConfUserUriKey        : user.userUri,
                                  @MtcConfPictureSizeKey    : [NSNumber numberWithInt:pictureSize],
                                  @MtcConfFrameRateKey      : [NSNumber numberWithInt:user.frameRate]};
            NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
            NSString *videoJson = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            Mtc_ConfCommand(_confId, MtcConfCmdRequestVideo, [videoJson UTF8String]);
        }
    }
}

- (void)dismissShareScreenView
{
    if (_shareScreenView) {
        Zmf_VideoRenderRemoveAll((__bridge void *)(_shareScreenView));
        Zmf_VideoRenderStop((__bridge void *)(_shareScreenView));
        [_shareScreenView removeFromSuperview];
        _shareScreenView = nil;
        _shareScreenUri = nil;
    }
}

- (BOOL)isConfing
{
    return _sessState > ConfStateNone && _sessState <= ConfStateTalking;
}

-(JMeetingId)getConfId
{
    return _confId;
}

#pragma mark - Conference Function

- (void)decline:(NSString *)confUri userUri:(NSString *)userUri
{
    Mtc_ConfDeclineInvite([confUri UTF8String], [userUri UTF8String]);
    NSDictionary *userInfo = @{@MtcConfIdKey : JIdToNumber(_confId)};
    [[NSNotificationCenter defaultCenter] postNotificationName:@JusMeetingDidRejectNotification object:nil userInfo:userInfo];
}

- (void)answer:(NSString *)confUri title:(NSString *)title userUri:(NSString *)userUri isVideo:(BOOL)isVideo
{
    Mtc_RingStop(ZMAXUINT);
    if (_sessState == ConfStateIncoming) {
        [self decline:_confUri userUri:_targetUserUri];
    } else {
        Mtc_ConfLeave(_confId);
    }
    [self termConf];
    
    _confUri = confUri;
    _confTitle = (title && title.length) ? title : kMeetingStringGroupCall;
    _targetUserUri = userUri;
    
    [self setConfVideo:isVideo ? CallVideoFrontCamera : CallVideoVoiceOnly];
    if (isVideo) {
        [self confStartPreview];
    }
    [self answerConfWithVideo:CallVideoCurrent];
    [self show:isVideo animated:YES completion:nil];
}

- (void)answerConfWithVideo:(int)video
{
    [MtcMeetingManager setPorperty:MtcMeetingPropertyKeyAllCanKick value:[[NSString alloc] initWithFormat:@"%d", NO]];

    _sessState = ConfStateAnswering;
    [self setEnabled:YES];
    [self setConfVideo:video];
    [self setStateText:kMeetingStringAnswering animated:YES];
    
    BOOL isVideo = ConfIsVideo;
    [self setStateAnswering:isVideo];
    
    [self initSpeaker];
    
    if (video == CallVideoRearCamera) {
        [self confCameraOn:NO];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @synchronized (self) {
            int audioStartRet = [self audioStart];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (audioStartRet != 0) {
                    [self showError:kMeetingStringAudioDeviceInitializationFailed];
                    [self termedConf:_confId statCode:EN_CONF_DELEGATE_FAIL_ANSWER_AUDIO_INIT reason:nil];
                    return;
                }
                _dispName = [MtcMeetingManager getDisplayName];
                ZCONST ZCHAR *pcDispName;
                if (_dispName && _dispName.length) {
                    pcDispName = [_dispName UTF8String];
                }else{
                    pcDispName = "";
                }

                _confId = Mtc_ConfJoinEx([_confUri UTF8String], 0, pcDispName, MTC_CONF_ROLE_PARTP);

                NSLog(@"confUri:%@", _confUri);
                if (_confId == ZINVALIDID) {
                    [self termedConf:_confId statCode:EN_CONF_DELEGATE_FAIL_JOIN reason:nil];
                }
            });
        }
    });
}

- (void)endConf
{
    [self.presentedViewController dismissViewControllerAnimated:NO completion:nil];
    if (_sessState == ConfStateIncoming) {
        [self decline:_confUri userUri:_targetUserUri];
        [self termConf];
        [self dismiss];
        return;
    }

    if (_sessState == ConfStateNone) {
        [self dismiss];
        return;
    }
    
    Mtc_ConfLeave(_confId);
    _sessState = ConfStateEnding;
    [self termedConf:_confId statCode:EN_MTC_CALL_TERM_STATUS_NORMAL reason:nil];
}

- (void)termConf
{
    MtcMeetingRingStopRing();
    [UIDevice currentDevice].proximityMonitoringEnabled = NO;
    
    _isFrontCamera = YES;
    _orientation = UIDeviceOrientationPortrait;
    
    _sessState = ConfStateNone;
    [self stopVideo:_confId];
    
    _confId = ZINVALIDID;
    _confUri = nil;
    _targetUserUri = nil;
    [_confUserArray removeAllObjects];
    _confUserArray = nil;
    
    for (ConfUserView *userView in _confUserViewArray) {
        [userView removeFromSuperview];
    }
    [_confUserViewArray removeAllObjects];
    _confUserViewArray = nil;
    
    if (_confScrollView) {
        [_confScrollView removeFromSuperview];
        _confScrollView = nil;
    }
    
    if (_didLeaveAlertView) {
        [_didLeaveAlertView dismissWithClickedButtonIndex:_didLeaveAlertView.cancelButtonIndex animated:NO];
        _didLeaveAlertView = nil;
    }
    
    if (_kickActionSheet) {
        [_kickActionSheet dismissWithClickedButtonIndex:_kickActionSheet.cancelButtonIndex animated:NO];
        _kickActionSheet = nil;
    }
    
    for (UIAlertView *alertView in _confInviteFailedAlertViewArray) {
        [alertView dismissWithClickedButtonIndex:_didLeaveAlertView.cancelButtonIndex animated:NO];
    }
    [_confInviteFailedAlertViewArray removeAllObjects];
    _confInviteFailedAlertViewArray = nil;
    
    [self stopDisconnectedTimer:_confId];
    for (UIGestureRecognizer *gestureRecognizer in self.view.gestureRecognizers) {
        [self.view removeGestureRecognizer:gestureRecognizer];
    }
    
    [self setErrorText];
    
    if (_confStatisticsView) {
        [_confStatisticsView removeFromSuperview];
        _confStatisticsView = nil;
    }
    
    if (_answerAlertView) {
        [_answerAlertView dismissWithClickedButtonIndex:_answerAlertView.cancelButtonIndex animated:NO];
        _answerAlertView = nil;
    }
}

- (void)termedConf:(JMeetingId)dwConfId statCode:(JMeetingStatusCode)dwStatCode reason:(const char *)pcReason
{
    if (_confId != dwConfId) {
        return;
    }
    
    self.shrinkButton.hidden = YES;
    self.globalMenuView.hidden = YES;
    if (isConfFloatWindowShow) {
        [self conffloatWindowClick];
        _floatWindow = nil;
    }
    
    int state = _sessState;
    Mtc_RingStop(ZMAXUINT);
    [self termConf];
    [self setStateNone:ConfIsVideo];

    if ([CallWaiting allowActive]) {
        [CallWaiting active];
        return;
    }
    
    if (Mtc_GetAccessNetType() == MTC_ANET_UNAVAILABLE) {
        if (_confInviteArray && [_confInviteArray count]) {
            [self termedAnimation];
            [self setStateText:kMeetingStringCheckNetwork animated:NO];
            Mtc_RingPlay(EN_MTC_RING_TERM, MTC_RING_TERM_LEN);
            return;
        }
    }
    
    if (state == ConfStateIncoming) {
        [self dismiss];
    } else if (state == ConfStateEnding) {
        [self setStateText:kMeetingStringCallEnding animated:NO];
        [self setEnabled:NO];
        self.selfMenuView.hidden = YES;
        self.otherMenuView.hidden = YES;
        self.globalMenuView.hidden = YES;
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:1];
    } else {
        [self setStateText:kMeetingStringCallEnded animated:NO];
        [self setEnabled:NO];
        Mtc_RingPlay(EN_MTC_RING_TERM, MTC_RING_TERM_LEN);
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:3];
    }
}

- (void)confStatisticsViewShow:(UIGestureRecognizer *)gestureRecognizer
{
    if (_confStatisticsView) {
        return;
    }
    
    CGPoint point = [gestureRecognizer locationInView:self.confScrollView];
    for (NSInteger index = 0; index < [_confUserViewArray count]; index++) {
        ConfUserView *view = [_confUserViewArray objectAtIndex:index];
        if (CGRectContainsPoint(view.frame, point)) {
            [self showConfStatisticsView:view.user.userUri];
            
            break;
        }
    }    
}

- (void)showConfStatisticsView:(NSString *)uri
{
    if (_confStatisticsView) {
        return;
    }
    
    CGRect callViewframe = self.view.frame;
    callViewframe.origin.y = callViewframe.size.height;
    _confStatisticsView = [[ConfStatView alloc] initWithFrame:callViewframe confId:_confId parameter:[uri UTF8String]];
    [self.view addSubview:_confStatisticsView];
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    tapGR.cancelsTouchesInView = NO;
    [_confStatisticsView.textView addGestureRecognizer:tapGR];
    
    CGRect frame = _confStatisticsView.frame;
    frame.origin.y = 0;
    [UIView animateWithDuration:0.3
                     animations:^{
                         _confStatisticsView.frame = frame;
                     }];
}

- (void)tap:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint point = [gestureRecognizer locationInView:_confStatisticsView];
    if (CGRectContainsPoint(_confStatisticsView.segmentedControl.frame, point)) {
        return;
    }
    
    [self confStatisticsViewDismiss];
}

- (void)confStatisticsViewDismiss
{
    [[NSNotificationCenter defaultCenter] postNotificationName:ConfStatViewDismissNotification object:nil];
    [_confStatisticsView removeFromSuperview];
    _confStatisticsView = nil;
}

- (void)setConfVideo:(int)video
{
    if (video == CallVideoCurrent) {
        return;
    }
    
    _confVideo = video;
}

- (UIView *)findViewWithUserName
{
    UIView *userView;
    if ([_currentUser.username caseInsensitiveCompare:_username] == NSOrderedSame) {
        userView = _preview;
    } else {
        for (ConfUserView *view in _confUserViewArray) {
            if ([view.user.username caseInsensitiveCompare:_username] == NSOrderedSame) {
                userView = view;
                break;
            }
        }
    }
    
    return userView;
}

- (BOOL)isPreviewUserView {
    return [_currentUser.username caseInsensitiveCompare:_username] == NSOrderedSame;
}

- (UIView *)findViewWithUserNameFromScroll:(NSString *)username {
    UIView *userView;
    if (!username) {
        username = _username;
    }
    for (ConfUserView *view in _confUserViewArray) {
        if ([view.user.username caseInsensitiveCompare:username] == NSOrderedSame) {
            userView = view;
            break;
        }
    }
    return userView;
}

- (void)confVideoStopForward {
    if (_confVideo < CallVideoVoiceOnly) {
        UIView *userView = [self findViewWithUserNameFromScroll:nil];
        NSString *userUri;
        if (userView) {
            ConfUserView *view = (ConfUserView *)userView;
            [view cameraOff:YES];
        }
        if ([self isPreviewUserView]) {
            [self previewCameraOff:YES];
            userUri = _currentUser.userUri;
        }
        [self confForwardVideo:NO];
    }
    [self setConfVideo:CallVideoCameraOff];
}

- (void)confVideoStartForward {
    [self confForwardVideo:YES];
}

- (void)confForwardVideo:(BOOL)forward {
    NSDictionary *dic = @{@MtcConfUserUriKey        : _userUri,
                          @MtcConfMediaOptionKey    : [NSNumber numberWithInt:MTC_CONF_MEDIA_ALL]};
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
    NSString *videoJson = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    int ret = Mtc_ConfCommand(_confId, forward ? MtcConfCmdStartForward : MtcConfCmdStopForward, [videoJson UTF8String]);
    if (ret != ZOK) {
        [self termedConf:_confId statCode:EN_CONF_DELEGATE_FAIL_JOIN reason:nil];
        return;
    }
}

- (void)confCameraOff
{
    if (_confVideo >= CallVideoVoiceOnly)
        return;
    if ([self isPreviewUserView]) {
        [self previewCameraOff:YES];
    }
    UIView *userView = [self findViewWithUserNameFromScroll:nil];
    if (userView) {
        ConfUserView *view = (ConfUserView *)userView;
        [view cameraOff:YES];
    }
    Mtc_ConfStopSend(_confId, MTC_CONF_MEDIA_VIDEO);
    [self setConfVideo:CallVideoCameraOff];
}

- (void)confCameraOn:(BOOL)front
{
    UIView *userView = [self findViewWithUserName];
    if (!userView) return;
    
    int video = front ? CallVideoFrontCamera : CallVideoRearCamera;
    const char *pcCapture = front ? ZmfVideoCaptureFront : ZmfVideoCaptureBack;
    const char *pcCaptureCurrent = ZmfVideoCaptureFront;
    switch (_confVideo) {
        case CallVideoVoiceOnly: {
            return;
        }
        case CallVideoCameraOff: {
            [self setConfVideo:video];
            
            if ([userView isKindOfClass:[ConfUserView class]]) {
                ConfUserView *view = (ConfUserView *)userView;
                [view cameraOff:NO];
            } else {
                if (!_preview) {
                    Zmf_VideoRenderAdd((__bridge void *)self.preview, pcCapture, 0, ZmfRenderFullScreen);
                    [self videoCaptureStart];
                }
                [self previewCameraOff:NO];
                UIView *view = [self findViewWithUserNameFromScroll:nil];
                if (view) {
                    ConfUserView *confView = (ConfUserView *)view;
                    [confView cameraOff:NO];
                }
            }
            
            Mtc_ConfStartSend(_confId, MTC_CONF_MEDIA_VIDEO);
            [self sendVideoResumeForCameraOn];
            break;
        }
        case CallVideoRearCamera:
            pcCaptureCurrent = ZmfVideoCaptureBack;
        default: {
            if (_confVideo == video) {
                return;
            }
            [self setConfVideo:video];
            
            if ([userView isKindOfClass:[ConfUserView class]]) {
                ConfUserView *view = (ConfUserView *)userView;
                [view.user cameraSwitch:pcCapture];
            } else {
                Zmf_VideoRenderReplace((__bridge void *)self.preview, pcCaptureCurrent, pcCapture);
                _currentUser.renderId = [NSString stringWithUTF8String:pcCapture];
            }
            Zmf_VideoCaptureStopAll();
            [self confVideoCaptureStart:front];
        }
    }
}

- (void)previewCameraOff:(BOOL)off
{
    if (off) {
        if (!_previewCameraOffView) {
            _previewCameraOffView = [[UIButton alloc] initWithFrame:self.preview.bounds];
            _previewCameraOffView.backgroundColor = [ConfSettings cameraOffBackgroundDarkColor];
            _previewCameraOffView.userInteractionEnabled = NO;
            [_previewCameraOffView setImage:[UIImage imageNamed:@"JusMeeting.bundle/call-cameraoff"] forState:UIControlStateNormal];
            [_previewCameraOffView setTitle:[[NSString alloc] initWithFormat:kMeetingStringFormatStringString, _currentUser.displayName, kMeetingStringCameraOff] forState:UIControlStateNormal];
            _previewCameraOffView.imageEdgeInsets = UIEdgeInsetsMake(0, -4 * kConfViewSpacing, 0, 0);
            [self.preview addSubview:_previewCameraOffView];
        }
    } else {
        if (_previewCameraOffView) {
            [_previewCameraOffView removeFromSuperview];
            _previewCameraOffView = nil;
        }
    }
}

- (void)kickConfUser:(ConfUser *)confUser
{
    if ([confUser.username caseInsensitiveCompare:_username] != NSOrderedSame) {
        if (!_kickActionSheet) {
            _kickUserUri = confUser.userUri;
            _kickActionSheet = [[UIActionSheet alloc] initWithTitle:confUser.displayName delegate:self cancelButtonTitle:kMeetingStringCancel destructiveButtonTitle:nil otherButtonTitles:kMeetingStringKick, nil];
            [_kickActionSheet showInView:self.confScrollView];
        }
    }
}

- (void)kickCurrentUser:(UIGestureRecognizer *)gestureRecognizer
{
    [self kickConfUser:_currentUser];
}

- (void)updateMeetingId:(NSString *)meetingId {
    
}

#pragma mark - ZMF Audio

- (void)confAudioStart
{
    ZBOOL bAec = Mtc_MdmGetOsAec();
    const char *pcId = bAec ? ZmfAudioDeviceVoice : ZmfAudioDeviceRemote;
    ZBOOL bAgc = Mtc_MdmGetOsAgc();
    int ret = Zmf_AudioInputStart(pcId, 0, 0, bAec ? ZmfAecOn : ZmfAecOff, bAgc ? ZmfAgcOn : ZmfAgcOff);
    if (ret == 0) {
        ret = Zmf_AudioOutputStart(pcId, 0, 0);
    }
}

- (void)confVideoCaptureStart:(BOOL)isFront
{
    const char *pcCapture = isFront ? ZmfVideoCaptureFront : ZmfVideoCaptureBack;
    unsigned int iVideoCaptureWidth;
    unsigned int iVideoCaptureHeight;
    unsigned int iVideoCaptureFrameRate;
    Mtc_MdmGetCaptureParms(&iVideoCaptureWidth, &iVideoCaptureHeight, &iVideoCaptureFrameRate);
    Zmf_VideoCaptureStart(pcCapture, iVideoCaptureWidth, iVideoCaptureHeight, iVideoCaptureFrameRate);
    Mtc_ConfSetVideoCapture(_confId, pcCapture);
}

- (void)confStartPreview
{
    if (MtcUtilSystemVersionLessThanX(7)) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:YES];
    } else {
        [self setNeedsStatusBarAppearanceUpdate];
    }
    
    const char *pcCapture = ZmfVideoCaptureFront;
    unsigned int iVideoCaptureWidth;
    unsigned int iVideoCaptureHeight;
    unsigned int iVideoCaptureFrameRate;
    Mtc_MdmGetCaptureParms(&iVideoCaptureWidth, &iVideoCaptureHeight, &iVideoCaptureFrameRate);
    Zmf_VideoCaptureStart(pcCapture, iVideoCaptureWidth, iVideoCaptureHeight, iVideoCaptureFrameRate);
    Zmf_VideoRenderAdd((__bridge void *)self.preview, pcCapture, 0, ZmfRenderFullScreen);
}

#pragma mark - Conference UI

- (UIScrollView *)confScrollView
{
    if (!_confScrollView) {
        CGFloat totalHeight = self.callView.frame.size.height;
        _confScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, totalHeight - _confViewCellSize.height - 3 * kConfViewSpacing, kMainScreenWidth, _confViewCellSize.height)];
        _confScrollView.backgroundColor = [UIColor clearColor];
        _confScrollView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        _confScrollView.showsHorizontalScrollIndicator = NO;
        _confScrollView.alwaysBounceHorizontal = YES;
        _confScrollView.panGestureRecognizer.delaysTouchesBegan = YES;
        NSInteger count = [_confUserArray count];
        if (count > 1) {
            _confScrollView.contentSize = CGSizeMake((count - 1) * (kConfViewSpacing + _confViewCellSize.width) + kConfViewSpacing, _confViewCellSize.height);
        } else {
            _confScrollView.contentSize = CGSizeMake(0, _confViewCellSize.height);
        }
        [self.view insertSubview:_confScrollView belowSubview:self.callView];
        
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(confStatisticsViewShow:)];
        tapGR.cancelsTouchesInView = !MtcUtilSystemVersionLessThanX(6);
        tapGR.numberOfTouchesRequired = 2;
        [_confScrollView addGestureRecognizer:tapGR];
        
        _confUserViewArray = [[NSMutableArray alloc] initWithCapacity:1];
        for (NSInteger index = 0; index < count; index++) {
            ConfUser *user = [_confUserArray objectAtIndex:index];
            NSInteger count = [_confUserViewArray count];
            CGFloat originX = (count + 1) * kConfViewSpacing + count * _confViewCellSize.width;
            ConfUserView *view = [[ConfUserView alloc] initWithFrame:CGRectMake(originX, 0, _confViewCellSize.width, _confViewCellSize.height) user:user isVideo:ConfIsVideo];
            view.delegate = self;
            view.alpha = 0;
            if (user.confRole & MTC_CONF_ROLE_OWNER) {
                [_confUserViewArray insertObject:view atIndex:0];
                [_confScrollView insertSubview:view atIndex:0];
            } else {
                [_confUserViewArray addObject:view];
                [_confScrollView addSubview:view];
            }
            [UIView animateWithDuration:0.3 animations:^{view.alpha = 1;}];
        }
    }
    return _confScrollView;
}

- (void)confScrollViewAddUser:(ConfUser *)user
{
    CGSize size = self.confScrollView.contentSize;
    
    NSInteger count = [_confUserViewArray count];
    CGFloat originX = (count + 1) * kConfViewSpacing + count * _confViewCellSize.width;
    ConfUserView *view = [[ConfUserView alloc] initWithFrame:CGRectMake(originX, 0, _confViewCellSize.width, _confViewCellSize.height) user:user isVideo:ConfIsVideo];
    view.delegate = self;
    [_confUserViewArray addObject:view];
    view.alpha = 0;
    if (user.confRole & MTC_CONF_ROLE_OWNER) {
        [self.confScrollView insertSubview:view atIndex:0];
    } else if ([user.username caseInsensitiveCompare:_username] == NSOrderedSame) {
        if (_confUserViewArray.count > 1) {
            [self.confScrollView insertSubview:view atIndex:1];
        }
    } else {
        [self.confScrollView addSubview:view];
    }
    [UIView animateWithDuration:0.3 animations:^{view.alpha = 1;}];
    
    size.width = originX + (kConfViewSpacing + _confViewCellSize.width);
    self.confScrollView.contentSize = size;
}

- (void)confScrollViewDelUser:(ConfUser *)user
{
    NSInteger index = -1;
    ConfUserView *delView = nil;
    for (NSInteger i = 0; i < [_confUserViewArray count]; i++) {
        ConfUserView *view = [_confUserViewArray objectAtIndex:i];
        if ([view.user.userUri caseInsensitiveCompare:user.userUri] == NSOrderedSame) {
            index = i;
            delView = view;
            break;
        }
    }
    
    if (index >= 0) {
        [UIView animateWithDuration:0.3
                         animations:^{
                             delView.alpha = 0;
                         }
                         completion:^(BOOL finished) {
                             [delView removeFromSuperview];
                             [_confUserViewArray removeObject:delView];
                         }];
        
        for (NSInteger j = index; j < [_confUserViewArray count]; j++) {
            ConfUserView *view = [_confUserViewArray objectAtIndex:j];
            CGRect frame = view.frame;
            frame.origin.x -= (kConfViewSpacing + _confViewCellSize.width);
            [UIView animateWithDuration:0.3
                             animations:^{
                                 view.frame = frame;
                             }];
        }
        
        CGSize size = self.confScrollView.contentSize;
        size.width -= (kConfViewSpacing + _confViewCellSize.width);
        self.confScrollView.contentSize = size;
    }
}

- (void)confScrollViewReloadUsersAtIndexs:(NSArray *)indexArray
{
    //todo
}

#pragma mark - ConfUserView delegate

- (void)currentConfUserViewDidToSwitch:(ConfUserView *)confUserView
{
    if (!confUserView) return;
    Zmf_VideoRenderReplace((__bridge void *)self.preview, [_currentUser.renderId UTF8String], [confUserView.user.renderId UTF8String]);
    
    ConfUser *tempUser = _currentUser;
    _currentUser = confUserView.user;
    [self previewCameraOff:!(confUserView.user.confState & MTC_CONF_STATE_VIDEO)];
//
//    ConfUserView *newConfUserView = [[ConfUserView alloc] initWithFrame:confUserView.frame user:tempUser isVideo:YES];
//    newConfUserView.delegate = self;
//    [_confUserViewArray replaceObjectAtIndex:[_confUserViewArray indexOfObject:confUserView] withObject:newConfUserView];
//    [confUserView removeFromSuperview];
//    [_confScrollView addSubview:newConfUserView];

    if ([_currentUser.username caseInsensitiveCompare:_username] != NSOrderedSame) {
        _currentUser.picSize = MTC_CONF_PS_LARGE;
        NSDictionary *dic = @{@MtcConfUserUriKey        : _currentUser.userUri,
                              @MtcConfPictureSizeKey    : [NSNumber numberWithInt:_currentUser.picSize],
                              @MtcConfFrameRateKey      : [NSNumber numberWithInt:_currentUser.frameRate]};
        NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
        NSString *videoJson = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        Mtc_ConfCommand(_confId, MtcConfCmdRequestVideo, [videoJson UTF8String]);
    }
    
    if ([tempUser.username caseInsensitiveCompare:_username] != NSOrderedSame) {
        tempUser.picSize = MTC_CONF_PS_MIN;
        NSDictionary *dic = @{@MtcConfUserUriKey        : tempUser.userUri,
                              @MtcConfPictureSizeKey    : [NSNumber numberWithInt:tempUser.picSize],
                              @MtcConfFrameRateKey      : [NSNumber numberWithInt:tempUser.frameRate]};
        NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
        NSString *videoJson = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        Mtc_ConfCommand(_confId, MtcConfCmdRequestVideo, [videoJson UTF8String]);
    }
    self.nameLabel.text = _currentUser.displayName.length == 0 ? _currentUser.username : _currentUser.displayName;
    [self showMainMenu];
}

- (void)confUserViewDidToKick:(ConfUserView *)confUserView
{
    [self kickConfUser:confUserView.user];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView isEqual:_didLeaveAlertView]) {
        _didLeaveAlertView = nil;
        if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:kMeetingStringOk]) {
            _sessState = ConfStateEnding;
            [self termedConf:_confId statCode:EN_MTC_CALL_TERM_STATUS_NORMAL reason:nil];
        }
    } else {
        if ([alertView.title hasPrefix:kMeetingStringInviteFailed]) {
            if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:kMeetingStringOk]) {
                if ((!_confInviteArray || [_confInviteArray count] == 0) && ([_confUserArray count] == 1)) {
                    ConfUser *user = [_confUserArray firstObject];
                    if ([user.username caseInsensitiveCompare:_username] == NSOrderedSame) {
                        [self endConf];
                    }
                }
            }
            
            [_confInviteFailedAlertViewArray removeObject:alertView];
        }
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([actionSheet isEqual:_kickActionSheet]) {
        _kickActionSheet = nil;
        if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:kMeetingStringKick]) {
            Mtc_ConfKickUser(_confId, [_kickUserUri UTF8String]);
        }
    }
}

@end

Class MtcMeetingDelegateClass()
{
    return [ConferenceViewController class];
}

UILocalNotification * MtcMeetingDelegateIncomingNotification(NSString *confUri, NSString *title, BOOL isVideo, NSString *userUri)
{
    UILocalNotification *incomingNotification = [[UILocalNotification alloc] init];
    incomingNotification.alertBody = [NSString stringWithFormat:@"%@ %@", kMeetingStringGroupCall, title];
    incomingNotification.soundName = @"JusMeeting.bundle/A_Journey.m4r";
    incomingNotification.userInfo = @{ConfIncomingNotificationConfUriKey:confUri,
                                      ConfIncomingNotificationIsVideoKey:[NSNumber numberWithBool:isVideo],
                                      ConfIncomingNotificationUserUriKey:userUri};
    if (!MtcUtilSystemVersionLessThanX(8)) {
        incomingNotification.category = ConfIncomingNotificationCategory;
    }
    
    return incomingNotification;
}
