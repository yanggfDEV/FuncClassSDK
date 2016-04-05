//
//  ConfFloatWindow.h
//  JusMeeting
//
//  Created by young on 15/10/9.
//  Copyright © 2015年 Fiona. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MtcConfSessTimer.h"
#import "JusMeeting/JusMeeting.h"

@protocol ConfFloatWindowDelegate <NSObject>
@optional
- (void)conffloatWindowClick;

@end

@interface ConfFloatWindow : UIWindow

@property (nonatomic, weak) id<ConfFloatWindowDelegate> floatWindowDelegate;
- (instancetype)initWithFrame:(CGRect)frame isVideo:(BOOL)isVideo time:(MtcConfSessTimer *)timer;
- (void)show:(NSString *)renderId;
- (void)dismiss;
@end
