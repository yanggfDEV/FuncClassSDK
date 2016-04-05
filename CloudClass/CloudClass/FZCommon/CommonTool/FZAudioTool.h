//
//  FZAudioTool.h
//  CloudClass
//
//  Created by Asuna on 16/3/10.
//  Copyright © 2016年 yangguangfu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FZAudioTool : NSObject

+ (void)playMusicWithMusicName:(NSString *)musicName;

+ (void)pauseMusicWithMusicName:(NSString *)musicName;

+ (void)stopMusicWithMusicName:(NSString *)musicName;

+ (void)playSoundWithSoundName:(NSString *)soundName;


@end
