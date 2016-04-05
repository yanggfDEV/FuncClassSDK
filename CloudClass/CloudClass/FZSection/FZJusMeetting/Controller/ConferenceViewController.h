//
//  CallingViewController.h
//  CCSample
//
//  Created by 杨海佳 on 15/1/9.
//  Copyright (c) 2015年 young. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfActionView.h"
#import "MtcConfSessTimer.h"
#import "ConfFloatWindow.h"

#import <lemon/service/rcs/mtc_doodle.h>

@interface ConferenceViewController : UIViewController <MtcMeetingDelegate>

@property (nonatomic, retain) UIView *preview;

@property (nonatomic, strong) ConfFloatWindow *floatWindow;

@property (nonatomic, retain) IBOutlet UIImageView *callBackgroundView;
@property (nonatomic, retain) IBOutlet UIView *callView;

@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel *timeLabel;

@property (nonatomic, retain) IBOutlet UIView *selfMenuView;
@property (nonatomic, retain) IBOutlet UIButton *leaveButton;
@property (nonatomic, retain) IBOutlet UIButton *cameraSwitchButton;
@property (nonatomic, retain) IBOutlet UIButton *cameraOffButton;
@property (nonatomic, retain) IBOutlet UIButton *muteButton;

@property (nonatomic, retain) IBOutlet UIView *otherMenuView;
@property (nonatomic, retain) IBOutlet UIButton *kickButton;

@property (nonatomic, retain) IBOutlet UIView *callingView;
@property (nonatomic, retain) IBOutlet ConfActionView *declineView;
@property (nonatomic, retain) IBOutlet ConfActionView *answerView;

@property (weak, nonatomic) IBOutlet UIButton *shrinkButton;

@property (weak, nonatomic) IBOutlet UIView *globalMenuView;
@property (weak, nonatomic) IBOutlet UIButton *addMemberButton;
@property (weak, nonatomic) IBOutlet UIButton *globalCameraOffButton;
@property (weak, nonatomic) IBOutlet UIButton *globalLeaveButton;

@property (nonatomic, retain) UIScrollView *confScrollView;

- (IBAction)end:(id)sender;
- (IBAction)answer:(id)sender;
- (IBAction)mute:(id)sender;
- (IBAction)cameraSwitch:(id)sender;
- (IBAction)cameraOff:(id)sender;
- (IBAction)addMember:(id)sender;
- (IBAction)voice:(id)sender;
- (IBAction)shrink:(id)sender;
- (IBAction)kickUser:(id)sender;

- (IBAction)statistics:(id)sender;

- (void)decline:(NSString *)confUri userUri:(NSString *)userUri;
- (void)answer:(NSString *)confUri title:(NSString *)title userUri:(NSString *)userUri isVideo:(BOOL)isVideo;

- (void)audioRouteChange:(const void *)inPropertyValue;

@end
