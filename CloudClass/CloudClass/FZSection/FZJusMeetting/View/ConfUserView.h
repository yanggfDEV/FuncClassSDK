//
//  ConfUserView.h
//  CloudSample
//
//  Created by Young on 15/6/26.
//  Copyright (c) 2015年 young. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfUser.h"

@class ConfUserView;

@protocol ConfUserViewDelegate

@optional

- (void)currentConfUserViewDidToSwitch:(ConfUserView *)confUserView;
- (void)confUserViewDidToKick:(ConfUserView *)confUserView;

@end

@interface ConfUserView : UIView

@property (nonatomic, retain) UILabel *usernameLabel;
@property (nonatomic, retain) UILabel *volumeLabel;
@property (nonatomic, retain) UIView *contentView;
@property (nonatomic, retain) ConfUser *user;

@property (nonatomic, assign) id<ConfUserViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame user:(ConfUser *)user isVideo:(BOOL)isVideo;
- (void)refreshVolume:(int)volume;
- (void)hideNameLabel:(BOOL)hidden;
- (void)cameraOff:(BOOL)off;

@end
