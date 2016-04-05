//
//  MtcConfBackgroundTask.m
//  Batter
//
//  Created by Loc on 13-12-27.
//  Copyright (c) 2013年 juphoon. All rights reserved.
//

#import "MtcConfBackgroundTask.h"

static UIBackgroundTaskIdentifier _taskId[MtcConfBackgroundTaskAll];

void MtcConfBackgroundTaskBegin(MtcConfBackgroundTaskID task)
{
    static BOOL inited = NO;
    if (!inited) {
        for (int i = 0; i < MtcConfBackgroundTaskAll; ++i) {
            _taskId[i] = UIBackgroundTaskInvalid;
        }
        inited = YES;
    }
    
    UIApplication * application = [UIApplication sharedApplication];
    if (_taskId[task] == UIBackgroundTaskInvalid) {
        _taskId[task] = [application beginBackgroundTaskWithExpirationHandler:^{
            [application endBackgroundTask:_taskId[task]];
            _taskId[task] = UIBackgroundTaskInvalid;
        }];
    }
}

void MtcConfBackgroundTaskEnd(MtcConfBackgroundTaskID task)
{
    UIApplication * application = [UIApplication sharedApplication];
    if (_taskId[task] != UIBackgroundTaskInvalid) {
        [application endBackgroundTask:_taskId[task]];
        _taskId[task] = UIBackgroundTaskInvalid;
    }
}
