//
//  MeetingManager.m
//  Meeting
//
//  Created by young on 16/3/1.
//  Copyright © 2016年 young. All rights reserved.
//

#import "MeetingManager.h"

@interface MeetingManager ()
{
    NSString *_meetingId;
    NSString *_password;
    NSString *_displayName;
    NSUInteger _retryCount;
    NSUInteger _queryFailCount;
}
@end

@implementation MeetingManager

+ (MeetingManager *)sharedManager
{
    static MeetingManager *manager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        manager = [[MeetingManager alloc] init];
    });
    return manager;
}

- (void)registerNotification
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(cliLoginOk) name:@MtcLoginOkNotification object:nil];
    [notificationCenter addObserver:self selector:@selector(cliLoginFail:) name:@MtcLoginDidFailNotification object:nil];
    
    [notificationCenter addObserver:self selector:@selector(queryMeetingOk) name:@MtcConfQueryOkNotification object:nil];
    [notificationCenter addObserver:self selector:@selector(queryMeetingFail) name:@MtcConfQueryDidFailNotification object:nil];
    [notificationCenter addObserver:self selector:@selector(joinMeetingOk) name:@MtcConfJoinOkNotification object:nil];
    [notificationCenter addObserver:self selector:@selector(joinMeetingFail:) name:@MtcConfJoinDidFailNotification object:nil];
}

- (void)unregisterNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)queryMeeting:(NSString *)meetingId password:(NSString *)password displayName:(NSString *)displayName retryCount:(NSUInteger)count
{
    _meetingId = meetingId;
    _password = password;
    _displayName = displayName;
    _retryCount = count;
    _queryFailCount = 0;
    [self queryMeeting];
}

- (void)cliLogin
{
    Mtc_CliStop();
    
    NSString *url = kAPITestMode ?  @"sudp:172.16.3.201:9851" : @"sudp:ae.justalkcloud.com:9851";
    
    Mtc_Login(Mtc_CliGetDevId(), @{@MtcPasswordKey : @"123", @MtcServerAddressKey : url});
}

- (void)queryMeeting
{
    if (Mtc_CliGetState() == 2) {
        [MtcMeetingManager queryMeeting:_meetingId displayName:_displayName password:_password];
    } else {
        [self cliLogin];
    }
}

- (void)cliLoginOk
{
    [MtcMeetingManager queryMeeting:_meetingId displayName:_displayName password:_password];
}

- (void)cliLoginFail:(NSNotification *)notification
{
    ZUINT dwStatusCode = [[notification.userInfo objectForKey:@MtcCliStatusCodeKey] unsignedIntValue];
    
    if ([_delegate respondsToSelector:@selector(cliLoginFail:)]) {
        [_delegate cliLoginFail:dwStatusCode];
    }
}

- (void)queryMeetingOk
{
    if ([_delegate respondsToSelector:@selector(meetingQueryOk)]) {
        [_delegate meetingQueryOk];
    }
}

- (void)queryMeetingFail
{
    if (_queryFailCount < _retryCount) {
        
        [self performSelector:@selector(queryMeeting) withObject:nil afterDelay:5];
    } else {
        if ([_delegate respondsToSelector:@selector(meetingQueryFail)]) {
            [_delegate meetingQueryFail];
        }
    }
    
    _queryFailCount++;
}

- (void)joinMeetingOk
{
    if ([_delegate respondsToSelector:@selector(meetingJoinOk)]) {
        [_delegate meetingJoinOk];
    }
}

- (void)joinMeetingFail:(NSNotification *)notification
{
    int reason = [[notification.userInfo objectForKey:@MtcConfReasonKey] intValue];
    
    if ([_delegate respondsToSelector:@selector(meetingJoinFail:)]) {
        [_delegate meetingJoinFail:reason];
    }
}

@end
