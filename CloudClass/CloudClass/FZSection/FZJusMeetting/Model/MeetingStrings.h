//
//  MeetingStrings.h
//  Batter
//
//  Created by cathy on 12-10-22.
//  Copyright (c) 2011Âπ?__MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kMagnifierEnabled @"MagnView"
#define kAutoAnswerEnabled @"AutoAnswerEnabled"
#define kAutoAnswerWithVideo @"AutoAnswerWithVideo"

#define meetingResourceBundlePath [[NSBundle mainBundle] pathForResource:@"JusMeeting" ofType:@"bundle"]
#define meetingResourcesBundle [NSBundle bundleWithPath:meetingResourceBundlePath]

#define MeetingLocalizedString(key) [meetingResourcesBundle localizedStringForKey:(key) value:@"" table:nil]

#define kMeetingStringOk MeetingLocalizedString(@"OK")

#define kMeetingStringUnverifiedNumber MeetingLocalizedString(@"Unverified number")

#define kMeetingStringCancel MeetingLocalizedString(@"Cancel")

//keypad
#define kMeetingStringCalleeHasNotInstalled MeetingLocalizedString(@"\"%@\" Hasn't Installed %@")

#define kMeetingStringTemporarilyUnavailableTitle MeetingLocalizedString(@"Temporarily Unavailable")
#define kMeetingStringOfflineTitle MeetingLocalizedString(@"Offline")
#define kMeetingStringOfflineMessage MeetingLocalizedString(@"\"%@\" is offline.")

//call
//call-button
#define kMeetingStringEnd MeetingLocalizedString(@"End")
#define kMeetingStringAnswer MeetingLocalizedString(@"Answer")
#define kMeetingStringDecline MeetingLocalizedString(@"Decline")
#define kMeetingStringText MeetingLocalizedString(@"Text")
#define kMeetingStringAddVideo MeetingLocalizedString(@"add video")
#define kMeetingStringAddCall MeetingLocalizedString(@"add call")
#define kMeetingStringContacts MeetingLocalizedString(@"contacts")
#define kMeetingStringRedial MeetingLocalizedString(@"Redial")
#define kMeetingStringNotifyTitle MeetingLocalizedString(@"Notify")
#define kMeetingStringNotify MeetingLocalizedString(@"notify")
#define kMeetingStringCallShare MeetingLocalizedString(@"call share")
#define kMeetingStringMute MeetingLocalizedString(@"mute")
#define kMeetingStringSwitch MeetingLocalizedString(@"switch")
#define KMeetingStringAddMember MeetingLocalizedString(@"add member")
#define kMeetingStringSpeaker MeetingLocalizedString(@"speaker")
#define kMeetingStringRegularCall MeetingLocalizedString(@"Regular Call")
#define kMeetingStringAudio MeetingLocalizedString(@"audio")
#define kMeetingStringCameraOff MeetingLocalizedString(@"camera off")
#define kMeetingStringCameraOffTitle MeetingLocalizedString(@"Camera Off")
#define kMeetingStringCameraOn MeetingLocalizedString(@"camera on")
#define kMeetingStringIgnore MeetingLocalizedString(@"Ignore")
#define kMeetingStringEndAndAnswer MeetingLocalizedString(@"End & Answer")
#define kMeetingStringEndAndVoiceAnswer MeetingLocalizedString(@"End & Voice Answer")
#define kMeetingStringEndAndVideoAnswer MeetingLocalizedString(@"End & Video Answer")
#define kMeetingStringAddToCall MeetingLocalizedString(@"Add to Call")

//call-status
#define kMeetingStringAnswering MeetingLocalizedString(@"answering")
#define kMeetingStringJoining MeetingLocalizedString(@"joining")
#define kMeetingStringCalling MeetingLocalizedString(@"calling")
#define kMeetingStringRinging MeetingLocalizedString(@"ringing")
#define kMeetingStringConnecting MeetingLocalizedString(@"connecting")
#define kMeetingStringCallEnding MeetingLocalizedString(@"call ending")
#define kMeetingStringCallEnded MeetingLocalizedString(@"call ended")

//call-error status
#define kMeetingStringCallReconnecting MeetingLocalizedString(@"reconnecting")
#define kMeetingStringCallDisconnected MeetingLocalizedString(@"call disconnected")
#define kMeetingStringCallPaused MeetingLocalizedString(@"call paused")
#define kMeetingStringCallInterrupted MeetingLocalizedString(@"call interrupted")
#define kMeetingStringVideoPaused MeetingLocalizedString(@"video paused")
#define kMeetingStringVideoCameraOff MeetingLocalizedString(@"video camera off")
#define kMeetingStringVideoPausedForQoS MeetingLocalizedString(@"video paused for QoS")
#define kMeetingStringSwitchedToVoiceCall MeetingLocalizedString(@"switched to voice call")
#define kMeetingStringPoorConnection MeetingLocalizedString(@"poor connection")
#define kMeetingStringCheckNetwork MeetingLocalizedString(@"check the network connection")

//call-term
#define kMeetingStringHasNotBeenInstalled MeetingLocalizedString(@"%@ hasn't been installed")
#define kMeetingStringCalleeOffline MeetingLocalizedString(@"callee is offline")
#define kMeetingStringOffline MeetingLocalizedString(@"offline")
#define kMeetingStringCalleeBusy MeetingLocalizedString(@"callee is busy")
#define kMeetingStringNoAnswer MeetingLocalizedString(@"no answer")
#define kMeetingStringTemporarilyUnavailable MeetingLocalizedString(@"temporarily unavailable")
#define kMeetingStringNoInternetConnection MeetingLocalizedString(@"no Internet connection")

//call-notification
#define kMeetingStringVoiceCallFrom MeetingLocalizedString(@"Voice call from")
#define kMeetingStringVideoCallFrom MeetingLocalizedString(@"Video call from")
#define kMeetingStringMissedVoiceCallFrom MeetingLocalizedString(@"Missed voice call from")
#define kMeetingStringMissedVideoCallFrom MeetingLocalizedString(@"Missed video call from")

#define kMeetingStringTouchToReturnToCall MeetingLocalizedString(@"Touch to return to call")

#define kMeetingStringPleaseHangUpTheRegularCallBeforeYouAnswer MeetingLocalizedString(@"Please hang up the regular call before you answer %@.")

#define kMeetingStringCall MeetingLocalizedString(@"Call")
#define kMeetingStringClose MeetingLocalizedString(@"Close")

//call-error
#define kMeetingStringAudioDeviceInitializationFailed MeetingLocalizedString(@"Audio device initialization failed.")
#define kMeetingStringAudioDeviceError MeetingLocalizedString(@"Audio device error.")
#define kMeetingStringAudioDeviceOccupied MeetingLocalizedString(@"audio device occupied")

//call-statistics
#define kMeetingStringStatistics MeetingLocalizedString(@"Statistics")
#define kMeetingStringVoiceTitle MeetingLocalizedString(@"Voice")
#define kMeetingStringVideoTitle MeetingLocalizedString(@"Video")
#define kMeetingStringNotRunning MeetingLocalizedString(@"Not running")

//call-check
#define kMeetingStringCannotCallYourself MeetingLocalizedString(@"Can't call yourself")

//format
#define kMeetingStringFormatStringString MeetingLocalizedString(@"%@ %@")

#define kMeetingStringGroupCall MeetingLocalizedString(@"Group Call")
#define kMeetingStringKick MeetingLocalizedString(@"Kick")
#define kMeetingStringInviteFailed MeetingLocalizedString(@"Invite Failed")
#define kMeetingStringQueryFailed MeetingLocalizedString(@"Invalid Meeting")
