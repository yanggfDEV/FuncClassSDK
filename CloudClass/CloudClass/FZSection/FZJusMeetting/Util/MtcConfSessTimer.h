//
//  MtcConfSessTimer.h
//  BatterHD
//
//  Created by Loc on 13-5-8.
//  Copyright (c) 2013年 juphoon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MtcConfSessTimer : NSObject {
    int _mintues;
    int _seconds;
    id _textView;
    NSTimer *_timer;
    BOOL _pause;
    NSString *_title;
}

@property (nonatomic) int mintues;
@property (nonatomic) int seconds;
@property (nonatomic) NSDate *date;

+ (id)startWithTime:(id)timerTextView mintues:(int)mintues seconds:(int)seconds date:(NSDate *)date;
+ (id)start:(id)timerTextView;
+ (void)stop:(id)timer;

- (void)startWithTime:(id)timerTextView mintues:(int)mintues seconds:(int)seconds date:(NSDate *)date;
- (void)start:(id)timerTextView;
- (void)stop;
- (void)pause;
- (void)resume;
- (void)fired:(NSTimer *)timer;

@end

