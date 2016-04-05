//
//  AudioCreateFiles.h
//  Test_createAudioFiles
//
//  Created by DING FENG on 3/11/15.
//  Copyright (c) 2015 DING FENG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioFile.h>

@interface AudioCreateFiles : NSObject
+(OSStatus)createBlankAudioFileAudioDuration:(int)duration  toPath:(NSString *)toPath;  //blankAudio
+(OSStatus)createBlankAudioFileAudioDuration:(int)duration  toPath:(NSString *)toPath frequency:(int)hz ;  //blankAudio
@end
