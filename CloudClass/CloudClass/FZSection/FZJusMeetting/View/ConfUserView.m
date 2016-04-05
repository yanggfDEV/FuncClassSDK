//
//  ConfUserView.m
//  CloudSample
//
//  Created by Young on 15/6/26.
//  Copyright (c) 2015年 young. All rights reserved.
//

#import "ConfUserView.h"
#import "ConfSettings.h"

#define kUserNameLabelHeight 20

@interface ConfUserView () {
    BOOL _isVideo;
    UITapGestureRecognizer *_switchGR;
    UILongPressGestureRecognizer *_kickGR;
    
    UIButton *_cameraOffView;
}

@end

@implementation ConfUserView
@synthesize
    usernameLabel = _usernameLabel,
    volumeLabel = _volumeLabel,
    contentView = _contentView,
    user = _user,
    delegate = _delegate;

- (UILabel *)usernameLabel
{
    if (!_usernameLabel) {
        _usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, kUserNameLabelHeight)];
        _usernameLabel.backgroundColor = [UIColor clearColor];
        _usernameLabel.textColor = [UIColor whiteColor];
        _usernameLabel.textAlignment = UITextAlignmentLeft;
        _usernameLabel.font = [UIFont systemFontOfSize:14];
        _usernameLabel.minimumFontSize = 9;
        _usernameLabel.contentMode = UIViewContentModeCenter;
        [self addSubview:_usernameLabel];
    }
    return _usernameLabel;
}

- (UILabel *)volumeLabel
{
    if (!_volumeLabel) {
        _volumeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height - kUserNameLabelHeight, self.frame.size.width, kUserNameLabelHeight)];
        _volumeLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_volumeLabel];
    }
    return _volumeLabel;
}

- (UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.usernameLabel.frame.size.height, self.bounds.size.width, self.bounds.size.height - self.usernameLabel.frame.size.height)];
        _contentView.backgroundColor = [UIColor blackColor];
        _contentView.layer.masksToBounds = YES;
        _contentView.layer.borderWidth = 1.0f;
        _contentView.layer.borderColor = [[UIColor whiteColor] CGColor];
        [self addSubview:_contentView];
    }
    return _contentView;
}

- (id)initWithFrame:(CGRect)frame user:(ConfUser *)user isVideo:(BOOL)isVideo
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configWithUser:user isVideo:isVideo];
    }
    return self;
}

- (void)configWithUser:(ConfUser *)user isVideo:(BOOL)isVideo
{
    _isVideo = isVideo;
    self.user = user;
    if (isVideo) {
        [user setSuperView:self.contentView];
        
        if (!_switchGR) {
            _switchGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(switchVideoView:)];
            _switchGR.cancelsTouchesInView = !SYSTEM_VERSION_LESS_THAN(@"6.0");
            [self addGestureRecognizer:_switchGR];
        }
        
        BOOL allCanKick = ([MtcMeetingManager getPorperty:MtcMeetingPropertyKeyAllCanKick]).boolValue;
        if (allCanKick) {
            if (!_kickGR) {
                _kickGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(kickConfUser:)];
                _kickGR.cancelsTouchesInView = !SYSTEM_VERSION_LESS_THAN(@"6.0");
                _kickGR.minimumPressDuration = 1;
                [self addGestureRecognizer:_kickGR];
            }
        } else {
            if (_kickGR) {
                [self removeGestureRecognizer:_kickGR];
                _kickGR = nil;
            }
        }
    } else {
        if (_contentView) {
            [_contentView removeFromSuperview];
            _contentView = nil;
        }
        if (_switchGR) {
            [self removeGestureRecognizer:_switchGR];
            _switchGR = nil;
        }
        if (_kickGR) {
            [self removeGestureRecognizer:_kickGR];
            _kickGR = nil;
        }
        self.backgroundColor = [UIColor blackColor];
    }
    if (user.displayName && user.displayName.length) {
        self.usernameLabel.text = user.displayName;
    }else{
        self.usernameLabel.text = user.username;
    }
    self.volumeLabel.text = [NSString stringWithFormat:@"vol:%d",user.volume];
    self.volumeLabel.hidden = YES;
    [self cameraOff:!(user.confState & MTC_CONF_STATE_VIDEO)];
}

- (void)refreshVolume:(int)volume
{
    self.volumeLabel.text = [NSString stringWithFormat:@"vol:%d", volume];
}

- (void)switchVideoView:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.delegate) {
        [self.delegate currentConfUserViewDidToSwitch:self];
    }
}

- (void)kickConfUser:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.delegate) {
        [self.delegate confUserViewDidToKick:self];
    }
}

- (void)hideNameLabel:(BOOL)hidden
{
    self.usernameLabel.hidden = hidden;
}

- (void)cameraOff:(BOOL)off
{
    if (off) {
        if (!_cameraOffView) {
            _cameraOffView = [[UIButton alloc] initWithFrame:self.contentView.bounds];
            _cameraOffView.userInteractionEnabled = NO;
            _cameraOffView.backgroundColor = [ConfSettings cameraOffBackgroundLightColor];
            [_cameraOffView setImage:[UIImage imageNamed:@"JusMeeting.bundle/call-cameraoff"] forState:UIControlStateNormal];
            [self.contentView addSubview:_cameraOffView];
        }
    } else {
        if (_cameraOffView) {
            [_cameraOffView removeFromSuperview];
            _cameraOffView = nil;
        }
    }
}

@end
