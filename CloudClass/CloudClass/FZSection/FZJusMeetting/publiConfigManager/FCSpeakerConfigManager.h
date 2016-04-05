//
//  FCSpeakerConfigManager.h
//  Pods
//
//  Created by patty on 15/11/23.
//
// 音频处理

#import <Foundation/Foundation.h>

@interface FCSpeakerConfigManager : NSObject

@property (nonatomic, assign) BOOL headSetPluggedIn;

+ (FCSpeakerConfigManager *)shareInstance;

- (BOOL)isHeadsetPluggedIn;

- (void)resetOutputTarget;

@end
