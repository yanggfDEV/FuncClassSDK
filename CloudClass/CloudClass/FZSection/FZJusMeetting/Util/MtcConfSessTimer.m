//
//  MtcConfSessTimer.m
//  BatterHD
//
//  Created by Loc on 13-5-8.
//  Copyright (c) 2013年 juphoon. All rights reserved.
//

#import "MtcConfSessTimer.h"

@implementation MtcConfSessTimer

@synthesize
    mintues = _mintues,
    seconds = _seconds,
    date = _date;

+ (id)startWithTime:(id)timerTextView mintues:(int)mintues seconds:(int)seconds date:(NSDate *)date
{
    MtcConfSessTimer *timer = [[MtcConfSessTimer alloc] init];
    [timer startWithTime:timerTextView mintues:mintues seconds:seconds date:date];
    return timer;
}

+ (id)start:(id)timerTextView
{
    MtcConfSessTimer *timer = [[MtcConfSessTimer alloc] init];
    [timer start:timerTextView];
    return timer;
}

+ (void)stop:(id)timer
{
    if (timer) {
        [timer stop];
    }
}

- (void)startWithTime:(id)timerTextView mintues:(int)mintues seconds:(int)seconds date:(NSDate *)date
{
    _date = date;
    _mintues = mintues;
    _seconds = seconds;
    _textView = timerTextView;
    _title = [self title];
    [self setText:[NSString stringWithFormat:@"%02d:%02d", _mintues, _seconds]];
    _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(fired:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)start:(id)timerTextView
{
    _date = [[NSDate alloc] init];
    _mintues = 0;
    _seconds = 0;
    _textView = timerTextView;
    [self setText:@"00:00"];
    _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(fired:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)stop
{
    [_timer invalidate];
    _date = nil;
}

- (void)pause
{
    _pause = YES;
}

- (void)resume
{
    if (!_pause) {
        return;
    }
    
    _pause = NO;
    NSDate *date = [[NSDate alloc] init];
    NSTimeInterval timeInterval = [date timeIntervalSinceDate:_date];
    _mintues = timeInterval / 60;
    _seconds = timeInterval - _mintues * 60;
    NSString *time = [NSString stringWithFormat:@"%02d:%02d", _mintues, _seconds];
    [self setText:time];
}

- (void)fired:(NSTimer *)timer
{
    if (_pause) return;
    
    if (++_seconds == 60) {
        ++_mintues;
        _seconds = 0;
    }
    
    NSString *time = [NSString stringWithFormat:@"%02d:%02d", _mintues, _seconds];
    [self setText:time];
}

- (void)setText:(NSString *)text
{
    if ([_textView isKindOfClass:[UIButton class]]) {
        if (_title.length) {
            text = [NSString stringWithFormat:@"%@ %@", _title, text];
        }
        UIButton *button = (UIButton *)_textView;
        [button setTitle:text forState:UIControlStateNormal];
        _textView = button;
    } else if ([_textView isKindOfClass:[UILabel class]]) {
        UILabel *label = _textView;
        if (_title.length) {
            text = [NSString stringWithFormat:@"%@ %@", _title, text];
        }
        label.text = text;
    }
}

- (NSString *)title
{
    if ([_textView isKindOfClass:[UIButton class]]) {
        return [_textView titleForState:UIControlStateNormal];
    } else if ([_textView isKindOfClass:[UILabel class]]) {
        UILabel *label = _textView;
        return label.text;
    }
    
    return @"";
}

@end
