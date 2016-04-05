//
//  FZSwipeView.m
//  EnglishTalk
//
//  Created by Victor Ji on 15/8/31.
//  Copyright (c) 2015年 Feizhu Tech. All rights reserved.
//

#import "FZSwipeView.h"

static NSTimeInterval const FZSwipeViewAutoscrollMin = 0.1;
static NSTimeInterval const FZSwipeViewAutoscrollDuration = 0.5;

@interface SwipeView (FZSwipeView) <UIScrollViewDelegate>

@end

@interface FZSwipeView () <UIScrollViewDelegate>

@property (strong, nonatomic) NSTimer *pagingAutoscrollTimer;
@property (nonatomic) BOOL displaying;

@end

@implementation FZSwipeView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupForPaging];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupForPaging];
    }
    return self;
}

- (void)setupForPaging {
    self.pagingEnabled = YES;
    self.wrapEnabled = YES;
}

- (void)setPagingAutoscroll:(NSTimeInterval)pagingAutoscroll {
    if (_pagingAutoscroll == pagingAutoscroll) {
        return;
    }
    _pagingAutoscroll = pagingAutoscroll;
    if (pagingAutoscroll >= FZSwipeViewAutoscrollMin) {
        if (self.displaying) {
            [self setupPagingAutoscrollTimer];
        }
    } else {
        [self invalidPagingAutoscrollTimer];
    }
}

- (void)willMoveToWindow:(UIWindow *)newWindow {
    [super willMoveToWindow:newWindow];
    if (newWindow) {
        self.displaying = YES;
        if (self.pagingAutoscroll >= FZSwipeViewAutoscrollMin) {
            [self setupPagingAutoscrollTimer];
        }
    } else {
        self.displaying = NO;
        [self invalidPagingAutoscrollTimer];
    }
}

- (void)setupPagingAutoscrollTimer {
    if (!_pagingAutoscrollTimer) {
        _pagingAutoscrollTimer = [NSTimer scheduledTimerWithTimeInterval:self.pagingAutoscroll target:self selector:@selector(scrollToNextItem) userInfo:nil repeats:YES];
    }
}

- (void)invalidPagingAutoscrollTimer {
    if (_pagingAutoscrollTimer) {
        [_pagingAutoscrollTimer invalidate];
        _pagingAutoscrollTimer = nil;
    }
}

- (void)scrollToNextItem {
    [self scrollByNumberOfItems:1 duration:FZSwipeViewAutoscrollDuration];
    self.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(FZSwipeViewAutoscrollDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.userInteractionEnabled = YES;
        [self.delegate swipeViewDidEndDecelerating:self];
    });
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [super scrollViewWillBeginDragging:scrollView];
    [self invalidPagingAutoscrollTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [super scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    if (self.pagingAutoscroll >= FZSwipeViewAutoscrollMin && self.displaying) {
        [self setupPagingAutoscrollTimer];
    }
}

@end
