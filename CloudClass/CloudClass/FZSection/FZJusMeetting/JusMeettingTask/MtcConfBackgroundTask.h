//
//  MtcConfBackgroundTask.h
//  Batter
//
//  Created by Loc on 13-12-27.
//  Copyright (c) 2013年 juphoon. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MtcConfBackgroundTaskID) {
    MtcConfBackgroundTaskLaunch,
    MtcConfBackgroundTaskCp,
    MtcConfBackgroundTaskLogin,
    MtcConfBackgroundTaskCall,
    MtcConfBackgroundTaskAll
};

void MtcConfBackgroundTaskBegin(MtcConfBackgroundTaskID task);
void MtcConfBackgroundTaskEnd(MtcConfBackgroundTaskID task);
