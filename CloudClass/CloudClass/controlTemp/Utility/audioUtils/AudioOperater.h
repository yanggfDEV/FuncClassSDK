//
//  AudioOperater.h
//  iShowVideoTalk
//
//  Created by DING FENG on 5/22/14.
//  Copyright (c) 2014 dinfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioFile.h>


// Returned as the value of the OSStatus argument to mix when the sound samples
// values would clip when mixed together. If a mix would clip then the output
// file is not generated.

#define OSSTATUS_MIX_WOULD_CLIP 8888
@interface AudioOperater : NSObject

typedef void(^MixSubprogressBlock)(float rate);

typedef void(^ProgressRateBlock)(float rate);



/*------fileType:  caf      ----------*/

+ (OSStatus) mix:(NSString*)file1 file2:(NSString*)file2 offset:(int)offset mixfile:(NSString*)mixfile  subProgress:(MixSubprogressBlock)mixSubprogressBlock;
+ (OSStatus) mixFiles:(NSArray*)files atTimes:(NSArray*)times toMixfile:(NSString*)mixfile block:(ProgressRateBlock)progressRateBlock;

+ (OSStatus) trimFile:(NSString *)filePath timeFrom:(float)timeFrom  to:(float) endTime;
+ (OSStatus) VolumeDown:(NSString *)inPath downPercent: (float )percent;


@end
