//
//  AudioConvert.h
//  EnglishTalk
//
//  Created by DING FENG on 6/13/14.
//  Copyright (c) 2014 ishowtalk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
// helpers
#include "CAXException.h"


typedef void(^CompleteBlock)(BOOL success);
typedef void(^WillBeginBlock)();

@interface AudioConvert : NSObject
{
    CFURLRef sourceURL;
    CFURLRef destinationURL;
    OSType   outputFormat;
    Float64  sampleRate;
}

@property (nonatomic,strong)  CompleteBlock completeBlock;
@property (nonatomic,strong)  WillBeginBlock willBeginBlock;
@property (nonatomic)float prograss;

+ (AudioConvert *)sharedInstance;
- (void)convertAudioSourcePath:(NSString *)source  outPath:(NSString *)destinationFilePath;

@end
