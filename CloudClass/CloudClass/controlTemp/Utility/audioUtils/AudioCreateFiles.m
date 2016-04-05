//
//  AudioCreateFiles.m
//  Test_createAudioFiles
//
//  Created by DING FENG on 3/11/15.
//  Copyright (c) 2015 DING FENG. All rights reserved.
//
#define BUFFER_SIZE 1024
#import "AudioCreateFiles.h"
int bufferCount;

static
inline
void fix_buffers(int16_t *mixbuffer,
                 int mixbufferNumSamples)
{
    for (int i = 0 ; i < mixbufferNumSamples; i++) {
        int32_t s1 =0;
        int32_t s2 =0;
        int32_t mixed = s1+s2;
        if (mixed < -32768)
            mixed = -32768;
        else if (mixed > 32767)
            mixed = 32767;
        mixbuffer[i] = (int16_t) mixed;
    }
}


static
inline
void fix_buffers_hz(int16_t *mixbuffer,
                 int mixbufferNumSamples,
                 int hz)
{
    int  T =2*44100/hz;
    for (int i = 0 ; i < mixbufferNumSamples; i++) {
        bufferCount ++;
        int32_t s1 =0;
        float a =(bufferCount%T)/(float)T;
        s1=30000*sin(2*M_PI*a);
        int32_t s2 =0;
        int32_t mixed = s1+s2;
        if (mixed < -32768)
            mixed = -32768;
        else if (mixed > 32767)
            mixed = 32767;
        mixbuffer[i] = (int16_t) mixed;
    }
}


@implementation AudioCreateFiles
+(OSStatus)createBlankAudioFileAudioDuration:(int)duration  toPath:(NSString *)toPath{

    OSStatus  stadus;
    NSURL *toUrl = [NSURL  URLWithString:toPath];
    AudioFileID resultAudioFile;
    #define BUFFER_SIZE 1024
    char *buffer = NULL;
    AudioStreamBasicDescription inputDataFormat;
    [self _setDefaultAudioFormatFlags:&inputDataFormat numChannels:2];
    stadus = AudioFileCreateWithURL((__bridge CFURLRef)toUrl, kAudioFileCAFType, &inputDataFormat,
                                    kAudioFileFlags_EraseFile, &resultAudioFile);
    if (stadus)
    {
        goto reterr;
    }
    buffer = malloc(BUFFER_SIZE);
    assert(buffer);
    UInt32 packetsHadWritten = 0;

    while (TRUE) {
    
    
        int numSamples = BUFFER_SIZE / sizeof(int16_t);
        fix_buffers((int16_t *) buffer, numSamples);
        
        UInt32 packetsWritten = BUFFER_SIZE / inputDataFormat.mBytesPerPacket;
        stadus = AudioFileWritePackets(resultAudioFile,
                                       FALSE,
                                       BUFFER_SIZE,
                                       NULL,
                                       packetsHadWritten,
                                       &packetsWritten,
                                       buffer);
        packetsHadWritten = packetsHadWritten+packetsWritten;
        if (stadus) {
            goto reterr;
        }
        
        if (packetsHadWritten>44100*duration) {
            stadus = 0;
            goto reterr;
        }
    }

reterr:
    return stadus;
}

+(OSStatus)createBlankAudioFileAudioDuration:(int)duration  toPath:(NSString *)toPath frequency:(int)hz{

    OSStatus  stadus;
    NSURL *toUrl = [NSURL  URLWithString:toPath];
    AudioFileID resultAudioFile;
    char *buffer = NULL;
    AudioStreamBasicDescription inputDataFormat;
    [self _setDefaultAudioFormatFlags:&inputDataFormat numChannels:2];
    stadus = AudioFileCreateWithURL((__bridge CFURLRef)toUrl, kAudioFileCAFType, &inputDataFormat,
                                    kAudioFileFlags_EraseFile, &resultAudioFile);
    if (stadus)
    {
        goto reterr;
    }
    buffer = malloc(BUFFER_SIZE);
    assert(buffer);
    UInt32 packetsHadWritten = 0;
    
    while (TRUE) {
        int numSamples = BUFFER_SIZE / sizeof(int16_t);
        fix_buffers_hz((int16_t *) buffer, numSamples,hz);
        
        UInt32 packetsWritten = BUFFER_SIZE / inputDataFormat.mBytesPerPacket;
        stadus = AudioFileWritePackets(resultAudioFile,
                                       FALSE,
                                       BUFFER_SIZE,
                                       NULL,
                                       packetsHadWritten,
                                       &packetsWritten,
                                       buffer);
        packetsHadWritten = packetsHadWritten+packetsWritten;
        if (stadus) {
            goto reterr;
        }
        
        if (packetsHadWritten>44100*duration) {
            stadus = 0;
            goto reterr;
        }
    }
    
reterr:
    return stadus;
}


+ (void) _setDefaultAudioFormatFlags:(AudioStreamBasicDescription*)audioFormatPtr
                         numChannels:(NSUInteger)numChannels
{
    bzero(audioFormatPtr, sizeof(AudioStreamBasicDescription));
    audioFormatPtr->mFormatID = kAudioFormatLinearPCM;
    audioFormatPtr->mSampleRate = 44100.0;
    audioFormatPtr->mChannelsPerFrame = numChannels;
    audioFormatPtr->mBytesPerPacket = 2 * numChannels;
    audioFormatPtr->mFramesPerPacket = 1;
    audioFormatPtr->mBytesPerFrame = 2 * numChannels;
    audioFormatPtr->mBitsPerChannel = 16;
    audioFormatPtr->mFormatFlags = kAudioFormatFlagsNativeEndian |
    kAudioFormatFlagIsPacked | kAudioFormatFlagIsSignedInteger;
}

@end
