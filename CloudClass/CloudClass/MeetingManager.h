//
//  MeetingManager.h
//  Meeting
//
//  Created by young on 16/3/1.
//  Copyright © 2016年 young. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MeetingDelegate <NSObject>

@optional
- (void)meetingQueryOk;
- (void)meetingQueryFail;
- (void)meetingJoinOk;
- (void)meetingJoinFail:(int)reason;
- (void)cliLoginFail:(int)reason;

@end

@interface MeetingManager : NSObject



+ (MeetingManager *)sharedManager;

@property (nonatomic, assign) id<MeetingDelegate> delegate;

- (void)registerNotification;
- (void)unregisterNotification;
- (void)queryMeeting:(NSString *)meetingId password:(NSString *)password displayName:(NSString *)displayName retryCount:(NSUInteger)count;
@end
