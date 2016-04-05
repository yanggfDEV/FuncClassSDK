//
//  FZPagingSwipeView.m
//
//
//  Created by liuyong on 15/06/30.
//  Copyright (c) 2015年 Feizhu Tech. All rights reserved.
//

#import "FZPagingSwipeView.h"

static NSTimeInterval const FZPagingSwipeViewAutoscrollMin = 0.1;
static NSTimeInterval const FZPagingSwipeViewAutoscrollDuration = 0.5;

@interface SwipeView (NIEPagingSwipeView) <UIScrollViewDelegate>

@end

@interface FZPagingSwipeView () <UIScrollViewDelegate>

@property (strong, nonatomic) NSTimer *pagingAutoscrollTimer;
@property (nonatomic) BOOL displaying;

@end

@implementation FZPagingSwipeView


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

- (void)setPagingAutoscrollDuration:(NSTimeInterval)pagingAutoscroll {
    _pagingAutoscrollDuration = pagingAutoscroll;
    if (pagingAutoscroll >= FZPagingSwipeViewAutoscrollMin) {
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
        if (self.pagingAutoscrollDuration >= FZPagingSwipeViewAutoscrollMin) {
            [self setupPagingAutoscrollTimer];
        }
    } else {
        self.displaying = NO;
        [self invalidPagingAutoscrollTimer];
    }
}

- (void)setupPagingAutoscrollTimer {
    if (!_pagingAutoscrollTimer) {
        _pagingAutoscrollTimer = [NSTimer scheduledTimerWithTimeInterval:self.pagingAutoscrollDuration target:self selector:@selector(scrollToNextItem) userInfo:nil repeats:YES];
    }
}

- (void)invalidPagingAutoscrollTimer {
    if (_pagingAutoscrollTimer) {
        [_pagingAutoscrollTimer invalidate];
        _pagingAutoscrollTimer = nil;
    }
}

- (void)scrollToNextItem {
    [self scrollByNumberOfItems:1 duration:FZPagingSwipeViewAutoscrollDuration];
    self.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(FZPagingSwipeViewAutoscrollDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
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
    if (self.pagingAutoscrollDuration >= FZPagingSwipeViewAutoscrollMin && self.displaying) {
        [self setupPagingAutoscrollTimer];
    }
}

@end
