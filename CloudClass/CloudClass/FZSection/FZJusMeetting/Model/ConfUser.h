//
//  ConfUser.h
//  JusMeeting
//
//  Created by Cathy on 15/11/12.
//  Copyright © 2015年 juphoon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConfUser : NSObject

@property (nonatomic, retain) NSString *userUri;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *displayName;
@property (nonatomic, retain) NSString *renderId;
@property (nonatomic, assign) NSInteger confState;
@property (nonatomic, assign) NSInteger confRole;
@property (nonatomic, assign) int picSize;
@property (nonatomic, assign) int frameRate;
@property (nonatomic, assign) int volume;
@property (nonatomic, getter=isSended) BOOL sended;

- (void)setSuperView:(UIView*)view;
- (void)stopRender;
- (void)cameraSwitch:(ZCONST ZCHAR *)newRenderId;

@end
