//
//  FZSwipeView.h
//  EnglishTalk
//
//  Created by Victor Ji on 15/8/31.
//  Copyright (c) 2015年 Feizhu Tech. All rights reserved.
//

#import <SwipeView/SwipeView.h>

#import "SwipeView.h"

@interface FZSwipeView : SwipeView

/**
 Seconds that scroll to next view.
 */
@property (nonatomic) NSTimeInterval pagingAutoscroll;

@end
