//
//  FZAudioTool.m
//  CloudClass
//
//  Created by Asuna on 16/3/10.
//  Copyright © 2016年 yangguangfu. All rights reserved.
//

#import "FZAudioTool.h"
#import <AVFoundation/AVFoundation.h>

@implementation FZAudioTool

static NSMutableDictionary *_soundIDs;
static NSMutableDictionary *_players;

+ (void)initialize
{
    _soundIDs = [NSMutableDictionary dictionary];
    _players = [NSMutableDictionary dictionary];
}

+ (void)playMusicWithMusicName:(NSString *)musicName
{
    // 1.从字典中取出对应的播放器
    AVAudioPlayer *player = _players[musicName];
    
    // 2.如果取出为nil,创建对应播放器,并且存入字典
    if (player == nil) {
        NSURL *url = [[NSBundle mainBundle] URLForResource:musicName withExtension:nil];
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        
        // 3.将播放器放入字典中
        [_players setObject:player forKey:musicName];
    }
    
    // 3.播放歌曲
    [player play];
}

+ (void)pauseMusicWithMusicName:(NSString *)musicName
{
    // 1.取出播放器
    AVAudioPlayer *player = _players[musicName];
    
    // 2.如果不为nil,则暂停
    if (player) {
        [player pause];
    }
}

+ (void)stopMusicWithMusicName:(NSString *)musicName
{
    // 1.取出播放器
    AVAudioPlayer *player = _players[musicName];
    
    // 2.如果不为nil,则停止
    if (player) {
        [player stop];
        [_players removeObjectForKey:musicName];
        player = nil;
    }
}

+ (void)playSoundWithSoundName:(NSString *)soundName
{
    // 1.从字典中取出对应的音效ID
    SystemSoundID soundID = [_soundIDs[soundName] unsignedIntValue];
    
    // 2.判断是否为0,如果为0创建对应soundID
    if (soundID == 0) {
        CFURLRef url = (__bridge CFURLRef)[[NSBundle mainBundle] URLForResource:soundName withExtension:nil];
        AudioServicesCreateSystemSoundID(url, &soundID);
        
        // 3.将soundID存入字典
        [_soundIDs setObject:@(soundID) forKey:soundName];
    }
    
    // 3.播放音效
    AudioServicesPlaySystemSound(soundID);
}

@end
