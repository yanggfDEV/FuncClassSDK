//
//  MtcMeetingRing.h
//  BatterHD
//
//  Created by Loc on 13-5-8.
//  Copyright (c) 2013年 juphoon. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef __cplusplus
extern "C" {
#endif
    
void MtcMeetingRingInit(NSURL *fileURL);
void MtcMeetingRingReset(NSURL *fileURL);

void MtcMeetingRingStartRing();
void MtcMeetingRingStopRing();

BOOL MtcMeetingRingIsPlaying();
void MtcMeetingRingStartPlay();
void MtcMeetingRingStopPlay();

void MtcMeetingRingResetCategory();

BOOL MtcMeetingAudioAccessoryConnected();

#ifdef __cplusplus
}
#endif
